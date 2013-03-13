Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20118 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab3CMMNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:36 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/14] wil6210: temperature measurement
Date: Wed, 13 Mar 2013 14:12:51 +0200
Message-ID: <1363176771-10082-15-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131347_927198_246787E1)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware got support for temperature measurement.
There are 2 temperature sensors: MAC and radio

"not available" temperature - reported by FW as 0 or ~0

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Conflicts:
	drivers/net/wireless/ath/wil6210/wil6210.h
---
 drivers/net/wireless/ath/wil6210/debugfs.c |   44 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h |    1 +
 drivers/net/wireless/ath/wil6210/wmi.c     |   25 ++++++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 1e709bf..4be07f5 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -521,6 +521,49 @@ static const struct file_operations fops_ssid = {
 	.open  = simple_open,
 };
 
+/*---------temp------------*/
+static void print_temp(struct seq_file *s, const char *prefix, u32 t)
+{
+	switch (t) {
+	case 0:
+	case ~(u32)0:
+		seq_printf(s, "%s N/A\n", prefix);
+	break;
+	default:
+		seq_printf(s, "%s %d.%03d\n", prefix, t / 1000, t % 1000);
+		break;
+	}
+}
+
+static int wil_temp_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	u32 t_m, t_r;
+
+	int rc = wmi_get_temperature(wil, &t_m, &t_r);
+	if (rc) {
+		seq_printf(s, "Failed\n");
+		return 0;
+	}
+
+	print_temp(s, "MAC temperature   :", t_m);
+	print_temp(s, "Radio temperature :", t_r);
+
+	return 0;
+}
+
+static int wil_temp_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_temp_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_temp = {
+	.open		= wil_temp_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*----------------*/
 int wil6210_debugfs_init(struct wil6210_priv *wil)
 {
@@ -555,6 +598,7 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	debugfs_create_file("mem_val", S_IRUGO, dbg, wil, &fops_memread);
 
 	debugfs_create_file("reset", S_IWUSR, dbg, wil, &fops_reset);
+	debugfs_create_file("temp", S_IRUGO, dbg, wil, &fops_temp);
 
 	wil->rgf_blob.data = (void * __force)wil->csr + 0;
 	wil->rgf_blob.size = 0xa000;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 3bbd86d..8f76ecd 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -329,6 +329,7 @@ int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
 int wmi_p2p_cfg(struct wil6210_priv *wil, int channel);
+int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 706ee9d..45b04e3 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -962,6 +962,31 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 	return rc;
 }
 
+int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r)
+{
+	int rc;
+	struct wmi_temp_sense_cmd cmd = {
+		.measure_marlon_m_en = cpu_to_le32(!!t_m),
+		.measure_marlon_r_en = cpu_to_le32(!!t_r),
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_temp_sense_done_event evt;
+	} __packed reply;
+
+	rc = wmi_call(wil, WMI_TEMP_SENSE_CMDID, &cmd, sizeof(cmd),
+		      WMI_TEMP_SENSE_DONE_EVENTID, &reply, sizeof(reply), 100);
+	if (rc)
+		return rc;
+
+	if (t_m)
+		*t_m = le32_to_cpu(reply.evt.marlon_m_t1000);
+	if (t_r)
+		*t_r = le32_to_cpu(reply.evt.marlon_r_t1000);
+
+	return 0;
+}
+
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
-- 
1.7.10.4

