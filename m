Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaLWHsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:33 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 14/22] wil6210: rework debugfs for BACK
Date: Tue, 23 Dec 2014 09:47:16 +0200
Message-Id: <1419320844-23989-15-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_596446_656942C4)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable more flexible control over block ack:
- allow addba for any Tx vring
- allow to specify block ack timeout
- allow to delba for Tx or Rx side of any agreement; with reason

Renamed "addba" entry to "back"; it prints short help when read;
write:
 - "add <ringid> <agg_size> <timeout>" to trigger ADDBA
If missing, <timeout> defaults to 0
 - "del_tx <ringid> <reason>" to trigger DELBA for Tx side
 - "del_rx <CID> <TID> <reason>" to trigger DELBA for Rx side
If missing, <reason> set to "STA_LEAVING" (36)

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 71 +++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 338a811..a36a753 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -564,17 +564,19 @@ static const struct file_operations fops_rxon = {
 	.open  = simple_open,
 };
 
-/* block ack for vring 0
- * write 0 to it to trigger DELBA
- * write positive agg_wsize to trigger ADDBA
+/* block ack control, write:
+ * - "add <ringid> <agg_size> <timeout>" to trigger ADDBA
+ * - "del_tx <ringid> <reason>" to trigger DELBA for Tx side
+ * - "del_rx <CID> <TID> <reason>" to trigger DELBA for Rx side
  */
-static ssize_t wil_write_addba(struct file *file, const char __user *buf,
-			       size_t len, loff_t *ppos)
+static ssize_t wil_write_back(struct file *file, const char __user *buf,
+			      size_t len, loff_t *ppos)
 {
 	struct wil6210_priv *wil = file->private_data;
 	int rc;
-	uint agg_wsize;
 	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
+	char cmd[8];
+	int p1, p2, p3;
 
 	if (!kbuf)
 		return -ENOMEM;
@@ -586,25 +588,60 @@ static ssize_t wil_write_addba(struct file *file, const char __user *buf,
 	}
 
 	kbuf[len] = '\0';
-	rc = kstrtouint(kbuf, 0, &agg_wsize);
+	rc = sscanf(kbuf, "%8s %d %d %d", cmd, &p1, &p2, &p3);
 	kfree(kbuf);
 
-	if (rc)
+	if (rc < 0)
 		return rc;
-
-	if (!wil->vring_tx[0].va)
+	if (rc < 2)
 		return -EINVAL;
 
-	if (agg_wsize > 0)
-		wmi_addba(wil, 0, agg_wsize, 0);
-	else
-		wmi_delba_tx(wil, 0, 0);
+	if (0 == strcmp(cmd, "add")) {
+		if (rc < 3) {
+			wil_err(wil, "BACK: add require at least 2 params\n");
+			return -EINVAL;
+		}
+		if (rc < 4)
+			p3 = 0;
+		wmi_addba(wil, p1, p2, p3);
+	} else if (0 == strcmp(cmd, "del_tx")) {
+		if (rc < 3)
+			p2 = WLAN_REASON_QSTA_LEAVE_QBSS;
+		wmi_delba_tx(wil, p1, p2);
+	} else if (0 == strcmp(cmd, "del_rx")) {
+		if (rc < 3) {
+			wil_err(wil,
+				"BACK: del_rx require at least 2 params\n");
+			return -EINVAL;
+		}
+		if (rc < 4)
+			p3 = WLAN_REASON_QSTA_LEAVE_QBSS;
+		wmi_delba_rx(wil, mk_cidxtid(p1, p2), p3);
+	} else {
+		wil_err(wil, "BACK: Unrecognized command \"%s\"\n", cmd);
+		return -EINVAL;
+	}
 
 	return len;
 }
 
-static const struct file_operations fops_addba = {
-	.write = wil_write_addba,
+static ssize_t wil_read_back(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	static const char text[] = "block ack control, write:\n"
+	" - \"add <ringid> <agg_size> <timeout>\" to trigger ADDBA\n"
+	"If missing, <timeout> defaults to 0\n"
+	" - \"del_tx <ringid> <reason>\" to trigger DELBA for Tx side\n"
+	" - \"del_rx <CID> <TID> <reason>\" to trigger DELBA for Rx side\n"
+	"If missing, <reason> set to \"STA_LEAVING\" (36)\n";
+
+	return simple_read_from_buffer(user_buf, count, ppos, text,
+				       sizeof(text));
+}
+
+static const struct file_operations fops_back = {
+	.read = wil_read_back,
+	.write = wil_write_back,
 	.open  = simple_open,
 };
 
@@ -1268,7 +1305,7 @@ static const struct {
 	{"rxon",		  S_IWUSR,	&fops_rxon},
 	{"tx_mgmt",		  S_IWUSR,	&fops_txmgmt},
 	{"wmi_send",		  S_IWUSR,	&fops_wmi},
-	{"addba",		  S_IWUSR,	&fops_addba},
+	{"back",	S_IRUGO | S_IWUSR,	&fops_back},
 	{"temp",	S_IRUGO,		&fops_temp},
 	{"freq",	S_IRUGO,		&fops_freq},
 	{"link",	S_IRUGO,		&fops_link},
-- 
2.1.0

