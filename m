Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-04.prod.phx3.secureserver.net ([173.201.192.105]:59899
	"EHLO p3plsmtpa06-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbaAUXYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 18:24:04 -0500
Date: Tue, 21 Jan 2014 16:23:59 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Thierry Escande <thierry.escande@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: [PATCH v2 2/3] NFC: iso15693 - Add Digital Layer support for
 ISO/IEC 15693
Message-ID: <20140121232359.GA32300@animalcreek.com> (sfid-20140122_002409_138377_B3FD3CC8)
References: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com>
 <1389747131-2577-3-git-send-email-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389747131-2577-3-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for ISO/IEC 15693 to the digital layer.  The code
currently uses single-slot anticollision only since the digital
layer infrastructure only supports one tag per adapter (making
it pointless to do 16-slot anticollision).

The code uses two new framing types:
'NFC_DIGITAL_FRAMING_ISO15693_INVENTORY' and
'NFC_DIGITAL_FRAMING_ISO15693_TVT'.  The former is used to
tell the driver to prepare for an Inventory command and the
ensuing anticollision sequence.  The latter is used to tell
the driver that the anticollision sequence is over and to
prepare for non-inventory commands.

Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---

Changes since v1:
 - rewrote kzalloc line to use sizeof(*target) instead of target's type
 - initialized the mask_len part of the 15693 inventory request

 net/nfc/digital.h            |   1 +
 net/nfc/digital_core.c       |  14 ++++++
 net/nfc/digital_technology.c | 109 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+)

diff --git a/net/nfc/digital.h b/net/nfc/digital.h
index 08b29b5..3c757dc 100644
--- a/net/nfc/digital.h
+++ b/net/nfc/digital.h
@@ -72,6 +72,7 @@ void digital_poll_next_tech(struct nfc_digital_dev *ddev);
 
 int digital_in_send_sens_req(struct nfc_digital_dev *ddev, u8 rf_tech);
 int digital_in_send_sensf_req(struct nfc_digital_dev *ddev, u8 rf_tech);
+int digital_in_send_iso15693_inv_req(struct nfc_digital_dev *ddev, u8 rf_tech);
 
 int digital_target_found(struct nfc_digital_dev *ddev,
 			 struct nfc_target *target, u8 protocol);
diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index c129d15..48906ca 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -25,6 +25,8 @@
 #define DIGITAL_PROTO_NFCF_RF_TECH \
 	(NFC_PROTO_FELICA_MASK | NFC_PROTO_NFC_DEP_MASK)
 
+#define DIGITAL_PROTO_ISO15693_RF_TECH	NFC_PROTO_ISO15693_MASK
+
 struct digital_cmd {
 	struct list_head queue;
 
@@ -331,6 +333,12 @@ int digital_target_found(struct nfc_digital_dev *ddev,
 		}
 		break;
 
+	case NFC_PROTO_ISO15693:
+		framing = NFC_DIGITAL_FRAMING_ISO15693_TVT;
+		check_crc = digital_skb_check_crc_b;
+		add_crc = digital_skb_add_crc_b;
+		break;
+
 	default:
 		pr_err("Invalid protocol %d\n", protocol);
 		return -EINVAL;
@@ -469,6 +477,10 @@ static int digital_start_poll(struct nfc_dev *nfc_dev, __u32 im_protocols,
 				      digital_in_send_sensf_req);
 	}
 
+	if (matching_im_protocols & DIGITAL_PROTO_ISO15693_RF_TECH)
+		digital_add_poll_tech(ddev, NFC_DIGITAL_RF_TECH_ISO15693,
+				      digital_in_send_iso15693_inv_req);
+
 	if (tm_protocols & NFC_PROTO_NFC_DEP_MASK) {
 		if (ddev->ops->tg_listen_mdaa) {
 			digital_add_poll_tech(ddev, 0,
@@ -700,6 +712,8 @@ struct nfc_digital_dev *nfc_digital_allocate_device(struct nfc_digital_ops *ops,
 		ddev->protocols |= NFC_PROTO_FELICA_MASK;
 	if (supported_protocols & NFC_PROTO_NFC_DEP_MASK)
 		ddev->protocols |= NFC_PROTO_NFC_DEP_MASK;
+	if (supported_protocols & NFC_PROTO_ISO15693_MASK)
+		ddev->protocols |= NFC_PROTO_ISO15693_MASK;
 
 	ddev->tx_headroom = tx_headroom + DIGITAL_MAX_HEADER_LEN;
 	ddev->tx_tailroom = tx_tailroom + DIGITAL_CRC_LEN;
diff --git a/net/nfc/digital_technology.c b/net/nfc/digital_technology.c
index 251c8c7..97d3f60 100644
--- a/net/nfc/digital_technology.c
+++ b/net/nfc/digital_technology.c
@@ -51,6 +51,15 @@
 #define DIGITAL_SENSF_REQ_RC_SC   1
 #define DIGITAL_SENSF_REQ_RC_AP   2
 
+#define DIGITAL_CMD_ISO15693_INVENTORY_REQ	0x01
+
+#define DIGITAL_ISO15693_REQ_FLAG_DATA_RATE	BIT(1)
+#define DIGITAL_ISO15693_REQ_FLAG_INVENTORY	BIT(2)
+#define DIGITAL_ISO15693_REQ_FLAG_NB_SLOTS	BIT(5)
+#define DIGITAL_ISO15693_RES_FLAG_ERROR		BIT(0)
+#define DIGITAL_ISO15693_RES_IS_VALID(flags) \
+	(!((flags) & DIGITAL_ISO15693_RES_FLAG_ERROR))
+
 struct digital_sdd_res {
 	u8 nfcid1[4];
 	u8 bcc;
@@ -82,6 +91,19 @@ struct digital_sensf_res {
 	u8 rd[2];
 } __packed;
 
+struct digital_iso15693_inv_req {
+	u8 flags;
+	u8 cmd;
+	u8 mask_len;
+	u64 mask;
+} __packed;
+
+struct digital_iso15693_inv_res {
+	u8 flags;
+	u8 dsfid;
+	u64 uid;
+} __packed;
+
 static int digital_in_send_sdd_req(struct nfc_digital_dev *ddev,
 				   struct nfc_target *target);
 
@@ -473,6 +495,93 @@ int digital_in_send_sensf_req(struct nfc_digital_dev *ddev, u8 rf_tech)
 	return rc;
 }
 
+static void digital_in_recv_iso15693_inv_res(struct nfc_digital_dev *ddev,
+		void *arg, struct sk_buff *resp)
+{
+	struct digital_iso15693_inv_res *res;
+	struct nfc_target *target = NULL;
+	int rc;
+
+	if (IS_ERR(resp)) {
+		rc = PTR_ERR(resp);
+		resp = NULL;
+		goto out_free_skb;
+	}
+
+	if (resp->len != sizeof(*res)) {
+		rc = -EIO;
+		goto out_free_skb;
+	}
+
+	res = (struct digital_iso15693_inv_res *)resp->data;
+
+	if (!DIGITAL_ISO15693_RES_IS_VALID(res->flags)) {
+		PROTOCOL_ERR("ISO15693 - 10.3.1");
+		rc = -EINVAL;
+		goto out_free_skb;
+	}
+
+	target = kzalloc(sizeof(*target), GFP_KERNEL);
+	if (!target) {
+		rc = -ENOMEM;
+		goto out_free_skb;
+	}
+
+	target->is_iso15693 = 1;
+	target->iso15693_dsfid = res->dsfid;
+	memcpy(target->iso15693_uid, &res->uid, sizeof(target->iso15693_uid));
+
+	rc = digital_target_found(ddev, target, NFC_PROTO_ISO15693);
+
+	kfree(target);
+
+out_free_skb:
+	dev_kfree_skb(resp);
+
+	if (rc)
+		digital_poll_next_tech(ddev);
+}
+
+int digital_in_send_iso15693_inv_req(struct nfc_digital_dev *ddev, u8 rf_tech)
+{
+	struct digital_iso15693_inv_req *req;
+	struct sk_buff *skb;
+	int rc;
+
+	rc = digital_in_configure_hw(ddev, NFC_DIGITAL_CONFIG_RF_TECH,
+				     NFC_DIGITAL_RF_TECH_ISO15693);
+	if (rc)
+		return rc;
+
+	rc = digital_in_configure_hw(ddev, NFC_DIGITAL_CONFIG_FRAMING,
+				     NFC_DIGITAL_FRAMING_ISO15693_INVENTORY);
+	if (rc)
+		return rc;
+
+	skb = digital_skb_alloc(ddev, sizeof(*req));
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put(skb, sizeof(*req) - sizeof(req->mask)); /* No mask */
+	req = (struct digital_iso15693_inv_req *)skb->data;
+
+	/* Single sub-carrier, high data rate, no AFI, single slot
+	 * Inventory command
+	 */
+	req->flags = DIGITAL_ISO15693_REQ_FLAG_DATA_RATE |
+		     DIGITAL_ISO15693_REQ_FLAG_INVENTORY |
+		     DIGITAL_ISO15693_REQ_FLAG_NB_SLOTS;
+	req->cmd = DIGITAL_CMD_ISO15693_INVENTORY_REQ;
+	req->mask_len = 0;
+
+	rc = digital_in_send_cmd(ddev, skb, 30,
+				 digital_in_recv_iso15693_inv_res, NULL);
+	if (rc)
+		kfree_skb(skb);
+
+	return rc;
+}
+
 static int digital_tg_send_sel_res(struct nfc_digital_dev *ddev)
 {
 	struct sk_buff *skb;
-- 
1.8.3.4

