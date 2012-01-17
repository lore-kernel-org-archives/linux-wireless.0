Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34249 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2AQMJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 07:09:23 -0500
Received: by mail-yw0-f46.google.com with SMTP id o21so33558yho.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 04:09:22 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v3 2/3] NFC: Download TI NFC init script
Date: Tue, 17 Jan 2012 14:11:32 +0200
Message-Id: <1326802293-11539-3-git-send-email-ilane@ti.com> (sfid-20120117_130926_721266_038D1847)
In-Reply-To: <1326802293-11539-1-git-send-email-ilane@ti.com>
References: <1326802293-11539-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Download TI NFC init script during nfcwilink open operation,
after the NFC channel is registered with TI shared transport.
TI NFC init script is written in BTS format.
First, read the chip version via a special vendor specific command.
Second, we request the relevant BTS file from the user space, and
then send the BTS commands to the chip.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 drivers/nfc/nfcwilink.c |  288 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 284 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index ee60d08..90af28d 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/firmware.h>
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
 #include <net/nfc/nci_core.h>
@@ -41,6 +42,17 @@
 #define NFCWILINK_OFFSET_LEN_IN_HDR	1
 #define NFCWILINK_LEN_SIZE		2
 #define NFCWILINK_REGISTER_TIMEOUT	8000	/* 8 sec */
+#define NFCWILINK_CMD_TIMEOUT		5000	/* 5 sec */
+
+#define BTS_FILE_NAME_MAX_SIZE		40
+#define BTS_FILE_HDR_MAGIC		0x42535442
+#define BTS_FILE_CMD_MAX_LEN		0xff
+#define BTS_FILE_ACTION_TYPE_SEND_CMD	1
+
+#define NCI_VS_NFCC_INFO_CMD_GID	0x2f
+#define NCI_VS_NFCC_INFO_CMD_OID	0x12
+#define NCI_VS_NFCC_INFO_RSP_GID	0x4f
+#define NCI_VS_NFCC_INFO_RSP_OID	0x12
 
 struct nfcwilink_hdr {
 	__u8 chnl;
@@ -48,6 +60,36 @@ struct nfcwilink_hdr {
 	__le16 len;
 } __packed;
 
+struct nci_vs_nfcc_info_cmd {
+	__u8 gid;
+	__u8 oid;
+	__u8 plen;
+} __packed;
+
+struct nci_vs_nfcc_info_rsp {
+	__u8 gid;
+	__u8 oid;
+	__u8 plen;
+	__u8 status;
+	__u8 hw_id;
+	__u8 sw_ver_x;
+	__u8 sw_ver_z;
+	__u8 patch_id;
+} __packed;
+
+struct bts_file_hdr {
+	__le32 magic;
+	__le32 ver;
+	__u8 rfu[24];
+	__u8 actions[0];
+} __packed;
+
+struct bts_file_action {
+	__le16 type;
+	__le16 len;
+	__u8 data[0];
+} __packed;
+
 struct nfcwilink {
 	struct platform_device		*pdev;
 	struct nci_dev			*ndev;
@@ -55,14 +97,241 @@ struct nfcwilink {
 
 	char				st_register_cb_status;
 	long				(*st_write) (struct sk_buff *);
-	struct completion		st_register_completed;
+
+	struct completion		completed;
+
+	struct nci_vs_nfcc_info_rsp	nfcc_info;
 };
 
 /* NFCWILINK driver flags */
 enum {
 	NFCWILINK_RUNNING,
+	NFCWILINK_FW_DOWNLOAD,
 };
 
+static int nfcwilink_send(struct sk_buff *skb);
+
+static inline struct sk_buff *nfcwilink_skb_alloc(unsigned int len, gfp_t how)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(len + NFCWILINK_HDR_LEN, how);
+	if (skb)
+		skb_reserve(skb, NFCWILINK_HDR_LEN);
+
+	return skb;
+}
+
+static void nfcwilink_fw_download_receive(struct nfcwilink *drv,
+						struct sk_buff *skb)
+{
+	struct nci_vs_nfcc_info_rsp *rsp = (void *)skb->data;
+
+	/* Detect NCI_VS_NFCC_INFO_RSP and store the result */
+	if ((skb->len > 3) && (rsp->gid == NCI_VS_NFCC_INFO_RSP_GID) &&
+		(rsp->oid == NCI_VS_NFCC_INFO_RSP_OID)) {
+		memcpy(&drv->nfcc_info, rsp,
+			sizeof(struct nci_vs_nfcc_info_rsp));
+	}
+
+	kfree_skb(skb);
+
+	complete(&drv->completed);
+}
+
+static int nfcwilink_get_bts_file_name(struct nfcwilink *drv, char *file_name)
+{
+	struct nci_vs_nfcc_info_cmd *cmd;
+	struct sk_buff *skb;
+	unsigned long comp_ret;
+	int rc;
+
+	nfc_dev_dbg(&drv->pdev->dev, "get_bts_file_name entry");
+
+	skb = nfcwilink_skb_alloc(sizeof(struct nci_vs_nfcc_info_cmd),
+					GFP_KERNEL);
+	if (!skb) {
+		nfc_dev_err(&drv->pdev->dev,
+				"no memory for nci_vs_nfcc_info_cmd");
+		return -ENOMEM;
+	}
+
+	skb->dev = (void *)drv->ndev;
+
+	cmd = (struct nci_vs_nfcc_info_cmd *)
+			skb_put(skb, sizeof(struct nci_vs_nfcc_info_cmd));
+	cmd->gid = NCI_VS_NFCC_INFO_CMD_GID;
+	cmd->oid = NCI_VS_NFCC_INFO_CMD_OID;
+	cmd->plen = 0;
+
+	drv->nfcc_info.plen = 0;
+
+	rc = nfcwilink_send(skb);
+	if (rc)
+		return rc;
+
+	comp_ret = wait_for_completion_timeout(&drv->completed,
+				msecs_to_jiffies(NFCWILINK_CMD_TIMEOUT));
+	nfc_dev_dbg(&drv->pdev->dev, "wait_for_completion_timeout returned %ld",
+			comp_ret);
+	if (comp_ret == 0) {
+		nfc_dev_err(&drv->pdev->dev,
+				"timeout on wait_for_completion_timeout");
+		return -ETIMEDOUT;
+	}
+
+	nfc_dev_dbg(&drv->pdev->dev, "nci_vs_nfcc_info_rsp: plen %d, status %d",
+			drv->nfcc_info.plen,
+			drv->nfcc_info.status);
+
+	if ((drv->nfcc_info.plen != 5) || (drv->nfcc_info.status != 0)) {
+		nfc_dev_err(&drv->pdev->dev,
+				"invalid nci_vs_nfcc_info_rsp");
+		return -EINVAL;
+	}
+
+	snprintf(file_name, BTS_FILE_NAME_MAX_SIZE,
+			"TINfcInit_%d.%d.%d.%d.bts",
+			drv->nfcc_info.hw_id,
+			drv->nfcc_info.sw_ver_x,
+			drv->nfcc_info.sw_ver_z,
+			drv->nfcc_info.patch_id);
+
+	nfc_dev_info(&drv->pdev->dev, "nfcwilink FW file name: %s", file_name);
+
+	return 0;
+}
+
+static int nfcwilink_send_bts_cmd(struct nfcwilink *drv, __u8 *data, int len)
+{
+	struct nfcwilink_hdr *hdr = (struct nfcwilink_hdr *)data;
+	struct sk_buff *skb;
+	unsigned long comp_ret;
+	int rc;
+
+	nfc_dev_dbg(&drv->pdev->dev, "send_bts_cmd entry");
+
+	/* verify valid cmd for the NFC channel */
+	if ((len <= sizeof(struct nfcwilink_hdr)) ||
+		(len > BTS_FILE_CMD_MAX_LEN) ||
+		(hdr->chnl != NFCWILINK_CHNL) ||
+		(hdr->opcode != NFCWILINK_OPCODE)) {
+		nfc_dev_err(&drv->pdev->dev,
+			"ignoring invalid bts cmd, len %d, chnl %d, opcode %d",
+			len, hdr->chnl, hdr->opcode);
+		return 0;
+	}
+
+	/* remove the ST header */
+	len -= sizeof(struct nfcwilink_hdr);
+	data += sizeof(struct nfcwilink_hdr);
+
+	skb = nfcwilink_skb_alloc(len, GFP_KERNEL);
+	if (!skb) {
+		nfc_dev_err(&drv->pdev->dev, "no memory for bts cmd");
+		return -ENOMEM;
+	}
+
+	skb->dev = (void *)drv->ndev;
+
+	memcpy(skb_put(skb, len), data, len);
+
+	rc = nfcwilink_send(skb);
+	if (rc)
+		return rc;
+
+	comp_ret = wait_for_completion_timeout(&drv->completed,
+				msecs_to_jiffies(NFCWILINK_CMD_TIMEOUT));
+	nfc_dev_dbg(&drv->pdev->dev, "wait_for_completion_timeout returned %ld",
+			comp_ret);
+	if (comp_ret == 0) {
+		nfc_dev_err(&drv->pdev->dev,
+				"timeout on wait_for_completion_timeout");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int nfcwilink_download_fw(struct nfcwilink *drv)
+{
+	unsigned char file_name[BTS_FILE_NAME_MAX_SIZE];
+	const struct firmware *fw;
+	__u16 action_type, action_len;
+	__u8 *ptr;
+	int len, rc;
+
+	nfc_dev_dbg(&drv->pdev->dev, "download_fw entry");
+
+	set_bit(NFCWILINK_FW_DOWNLOAD, &drv->flags);
+
+	rc = nfcwilink_get_bts_file_name(drv, file_name);
+	if (rc)
+		goto exit;
+
+	rc = request_firmware(&fw, file_name, &drv->pdev->dev);
+	if (rc) {
+		nfc_dev_err(&drv->pdev->dev, "request_firmware failed %d", rc);
+
+		/* if the file is not found, don't exit with failure */
+		if (rc == -ENOENT)
+			rc = 0;
+
+		goto exit;
+	}
+
+	len = fw->size;
+	ptr = (__u8 *)fw->data;
+
+	if ((len == 0) || (ptr == NULL)) {
+		nfc_dev_dbg(&drv->pdev->dev,
+				"request_firmware returned size %d", len);
+		goto release_fw;
+	}
+
+	if (__le32_to_cpu(((struct bts_file_hdr *)ptr)->magic) !=
+			BTS_FILE_HDR_MAGIC) {
+		nfc_dev_err(&drv->pdev->dev, "wrong bts magic number");
+		rc = -EINVAL;
+		goto release_fw;
+	}
+
+	/* remove the BTS header */
+	len -= sizeof(struct bts_file_hdr);
+	ptr += sizeof(struct bts_file_hdr);
+
+	while (len > 0) {
+		action_type =
+			__le16_to_cpu(((struct bts_file_action *)ptr)->type);
+		action_len =
+			__le16_to_cpu(((struct bts_file_action *)ptr)->len);
+
+		nfc_dev_dbg(&drv->pdev->dev, "bts_file_action type %d, len %d",
+				action_type, action_len);
+
+		switch (action_type) {
+		case BTS_FILE_ACTION_TYPE_SEND_CMD:
+			rc = nfcwilink_send_bts_cmd(drv,
+					((struct bts_file_action *)ptr)->data,
+					action_len);
+			if (rc)
+				goto release_fw;
+			break;
+		}
+
+		/* advance to the next action */
+		len -= (sizeof(struct bts_file_action) + action_len);
+		ptr += (sizeof(struct bts_file_action) + action_len);
+	}
+
+release_fw:
+	release_firmware(fw);
+
+exit:
+	clear_bit(NFCWILINK_FW_DOWNLOAD, &drv->flags);
+	return rc;
+}
+
 /* Called by ST when registration is complete */
 static void nfcwilink_register_complete(void *priv_data, char data)
 {
@@ -74,7 +343,7 @@ static void nfcwilink_register_complete(void *priv_data, char data)
 	drv->st_register_cb_status = data;
 
 	/* complete the wait in nfc_st_open() */
-	complete(&drv->st_register_completed);
+	complete(&drv->completed);
 }
 
 /* Called by ST when receive data is available */
@@ -97,6 +366,11 @@ static long nfcwilink_receive(void *priv_data, struct sk_buff *skb)
 	(apart for the chnl byte, which is not received in the hdr) */
 	skb_pull(skb, (NFCWILINK_HDR_LEN-1));
 
+	if (test_bit(NFCWILINK_FW_DOWNLOAD, &drv->flags)) {
+		nfcwilink_fw_download_receive(drv, skb);
+		return 0;
+	}
+
 	skb->dev = (void *) drv->ndev;
 
 	/* Forward skb to NCI core layer */
@@ -137,14 +411,14 @@ static int nfcwilink_open(struct nci_dev *ndev)
 
 	nfcwilink_proto.priv_data = drv;
 
-	init_completion(&drv->st_register_completed);
+	init_completion(&drv->completed);
 	drv->st_register_cb_status = -EINPROGRESS;
 
 	rc = st_register(&nfcwilink_proto);
 	if (rc < 0) {
 		if (rc == -EINPROGRESS) {
 			comp_ret = wait_for_completion_timeout(
-			&drv->st_register_completed,
+			&drv->completed,
 			msecs_to_jiffies(NFCWILINK_REGISTER_TIMEOUT));
 
 			nfc_dev_dbg(&drv->pdev->dev,
@@ -172,6 +446,12 @@ static int nfcwilink_open(struct nci_dev *ndev)
 	BUG_ON(nfcwilink_proto.write == NULL);
 	drv->st_write = nfcwilink_proto.write;
 
+	if (nfcwilink_download_fw(drv)) {
+		nfc_dev_err(&drv->pdev->dev, "nfcwilink_download_fw failed %d",
+				rc);
+		/* open should succeed, even if the FW download failed */
+	}
+
 	goto exit;
 
 clear_exit:
-- 
1.7.0.4

