Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4075 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbGFHkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 03:40:25 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 03/13] wil6210: debugfs for channel survey
Date: Mon,  6 Jul 2015 10:39:39 +0300
Message-Id: <1436168389-3676-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150706_094036_456438_27275C4F)
In-Reply-To: <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print channel survey results on the debugfs. New entry
named "survey"

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 60 ++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 75219a1..42bc6e6 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1414,6 +1414,65 @@ static const struct file_operations fops_sta = {
 	.llseek		= seq_lseek,
 };
 
+/*---------Survey results------------*/
+static int wil_survey_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	int i, n_ch;
+	u16 filled;
+
+	if (!wil->survey_ready) {
+		seq_puts(s, "Survey not ready\n");
+		return 0;
+	}
+	seq_printf(s, "dwell_time : %d\n",
+		   le32_to_cpu(wil->survey_reply.evt.dwell_time));
+	filled = le16_to_cpu(wil->survey_reply.evt.filled);
+	n_ch = min_t(int, wil->survey_reply.evt.num_scanned_channels,
+		     ARRAY_SIZE(wil->survey_reply.ch_info));
+
+#define ACS_FILLED(x) (filled & WMI_ACS_INFO_BITMASK_ ## x) ? \
+	" " __stringify(x) : ""
+	seq_printf(s, "Filled : 0x%04x%s%s%s%s%s\n", filled,
+		   ACS_FILLED(BEACON_FOUND),
+		   ACS_FILLED(BUSY_TIME),
+		   ACS_FILLED(TX_TIME),
+		   ACS_FILLED(RX_TIME),
+		   ACS_FILLED(NOISE)
+		  );
+#undef ACS_FILLED
+	seq_printf(s, "Channels [%d] {\n", n_ch);
+	for (i = 0; i < n_ch; i++) {
+		struct scan_channel_info *ch = &wil->survey_reply.ch_info[i];
+
+		seq_printf(s, "  [%d]", ch->channel);
+#define ACS_PRINT(x, str, field) do { if (filled & WMI_ACS_INFO_BITMASK_ ## x) \
+		seq_printf(s, " %s : %d", str, field); \
+	} while (0)
+		ACS_PRINT(BEACON_FOUND, "bcon", ch->beacon_found);
+		ACS_PRINT(BUSY_TIME, "busy", le16_to_cpu(ch->busy_time));
+		ACS_PRINT(TX_TIME, "tx", le16_to_cpu(ch->tx_time));
+		ACS_PRINT(RX_TIME, "rx", le16_to_cpu(ch->rx_time));
+		ACS_PRINT(NOISE, "noise", ch->noise);
+#undef ACS_PRINT
+		seq_puts(s, "\n");
+	}
+	seq_puts(s, "}\n");
+	return 0;
+}
+
+static int wil_survey_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_survey_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_survey = {
+	.open		= wil_survey_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*----------------*/
 static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 				       struct dentry *dbg)
@@ -1460,6 +1519,7 @@ static const struct {
 	{"link",	S_IRUGO,		&fops_link},
 	{"info",	S_IRUGO,		&fops_info},
 	{"recovery",	S_IRUGO | S_IWUSR,	&fops_recovery},
+	{"survey",	S_IRUGO,		&fops_survey},
 };
 
 static void wil6210_debugfs_init_files(struct wil6210_priv *wil,
-- 
2.1.4

