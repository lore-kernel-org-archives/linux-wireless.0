Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47631 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab1JaKYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 06:24:52 -0400
Received: by wyg36 with SMTP id 36so5684549wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 03:24:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: add vifs_state debugfs key
Date: Mon, 31 Oct 2011 12:24:49 +0200
Message-Id: <1320056689-19953-1-git-send-email-eliad@wizery.com> (sfid-20111031_112456_105205_8AEDB2D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add debugfs key to dump information regarding the
active vifs (similar to the driver_state debugfs key)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |  110 +++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index a9e0b73..2e14b43 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -385,6 +385,115 @@ static const struct file_operations driver_state_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	struct wl12xx_vif *wlvif;
+	int ret, res = 0;
+	const int buf_size = 4096;
+	char *buf;
+	char tmp_buf[64];
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&wl->mutex);
+
+#define VIF_STATE_PRINT(x, fmt)				\
+	(res += scnprintf(buf + res, buf_size - res,	\
+			  #x " = " fmt "\n", wlvif->x))
+
+#define VIF_STATE_PRINT_LONG(x)  VIF_STATE_PRINT(x, "%ld")
+#define VIF_STATE_PRINT_INT(x)   VIF_STATE_PRINT(x, "%d")
+#define VIF_STATE_PRINT_STR(x)   VIF_STATE_PRINT(x, "%s")
+#define VIF_STATE_PRINT_LHEX(x)  VIF_STATE_PRINT(x, "0x%lx")
+#define VIF_STATE_PRINT_LLHEX(x) VIF_STATE_PRINT(x, "0x%llx")
+#define VIF_STATE_PRINT_HEX(x)   VIF_STATE_PRINT(x, "0x%x")
+
+#define VIF_STATE_PRINT_NSTR(x, len)				\
+	do {							\
+		memset(tmp_buf, 0, sizeof(tmp_buf));		\
+		memcpy(tmp_buf, wlvif->x,			\
+		       min_t(u8, len, sizeof(tmp_buf) - 1));	\
+		res += scnprintf(buf + res, buf_size - res,	\
+				 #x " = %s\n", tmp_buf);	\
+	} while (0)
+
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		VIF_STATE_PRINT_INT(role_id);
+		VIF_STATE_PRINT_INT(bss_type);
+		VIF_STATE_PRINT_LHEX(flags);
+		VIF_STATE_PRINT_INT(p2p);
+		VIF_STATE_PRINT_INT(dev_role_id);
+		VIF_STATE_PRINT_INT(dev_hlid);
+
+		if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
+		    wlvif->bss_type == BSS_TYPE_IBSS) {
+			VIF_STATE_PRINT_INT(sta.hlid);
+			VIF_STATE_PRINT_INT(sta.ba_rx_bitmap);
+			VIF_STATE_PRINT_INT(sta.basic_rate_idx);
+			VIF_STATE_PRINT_INT(sta.ap_rate_idx);
+			VIF_STATE_PRINT_INT(sta.p2p_rate_idx);
+		} else {
+			VIF_STATE_PRINT_INT(ap.global_hlid);
+			VIF_STATE_PRINT_INT(ap.bcast_hlid);
+			VIF_STATE_PRINT_LHEX(ap.sta_hlid_map[0]);
+			VIF_STATE_PRINT_INT(ap.mgmt_rate_idx);
+			VIF_STATE_PRINT_INT(ap.bcast_rate_idx);
+			VIF_STATE_PRINT_INT(ap.ucast_rate_idx[0]);
+			VIF_STATE_PRINT_INT(ap.ucast_rate_idx[1]);
+			VIF_STATE_PRINT_INT(ap.ucast_rate_idx[2]);
+			VIF_STATE_PRINT_INT(ap.ucast_rate_idx[3]);
+		}
+		VIF_STATE_PRINT_INT(last_tx_hlid);
+		VIF_STATE_PRINT_LHEX(links_map[0]);
+		VIF_STATE_PRINT_NSTR(ssid, wlvif->ssid_len);
+		VIF_STATE_PRINT_INT(band);
+		VIF_STATE_PRINT_INT(channel);
+		VIF_STATE_PRINT_HEX(bitrate_masks[0]);
+		VIF_STATE_PRINT_HEX(bitrate_masks[1]);
+		VIF_STATE_PRINT_HEX(basic_rate_set);
+		VIF_STATE_PRINT_HEX(basic_rate);
+		VIF_STATE_PRINT_HEX(rate_set);
+		VIF_STATE_PRINT_INT(beacon_int);
+		VIF_STATE_PRINT_INT(default_key);
+		VIF_STATE_PRINT_INT(aid);
+		VIF_STATE_PRINT_INT(session_counter);
+		VIF_STATE_PRINT_INT(ps_poll_failures);
+		VIF_STATE_PRINT_INT(psm_entry_retry);
+		VIF_STATE_PRINT_INT(power_level);
+		VIF_STATE_PRINT_INT(rssi_thold);
+		VIF_STATE_PRINT_INT(last_rssi_event);
+		VIF_STATE_PRINT_INT(ba_support);
+		VIF_STATE_PRINT_INT(ba_allowed);
+		VIF_STATE_PRINT_LLHEX(tx_security_seq);
+		VIF_STATE_PRINT_INT(tx_security_last_seq_lsb);
+	}
+
+#undef VIF_STATE_PRINT_INT
+#undef VIF_STATE_PRINT_LONG
+#undef VIF_STATE_PRINT_HEX
+#undef VIF_STATE_PRINT_LHEX
+#undef VIF_STATE_PRINT_LLHEX
+#undef VIF_STATE_PRINT_STR
+#undef VIF_STATE_PRINT_NSTR
+#undef VIF_STATE_PRINT
+
+	mutex_unlock(&wl->mutex);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations vifs_state_ops = {
+	.read = vifs_state_read,
+	.open = wl1271_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static ssize_t dtim_interval_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
 {
@@ -765,6 +874,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(gpio_power, rootdir);
 	DEBUGFS_ADD(start_recovery, rootdir);
 	DEBUGFS_ADD(driver_state, rootdir);
+	DEBUGFS_ADD(vifs_state, rootdir);
 	DEBUGFS_ADD(dtim_interval, rootdir);
 	DEBUGFS_ADD(beacon_interval, rootdir);
 	DEBUGFS_ADD(beacon_filtering, rootdir);
-- 
1.7.6.401.g6a319

