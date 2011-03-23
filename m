Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50067 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab1CWTUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:20:13 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wifi:  Add hwflags to debugfs.
Date: Wed, 23 Mar 2011 12:20:08 -0700
Message-Id: <1300908008-17676-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Aids debugging wifi behaviour.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 51f0d78... dd0632a... M	net/mac80211/debugfs.c
 net/mac80211/debugfs.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 51f0d78..dd0632a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -291,12 +291,84 @@ static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 }
 
+static ssize_t hwflags_read(struct file *file, char __user *user_buf,
+			    size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int mxln = 500;
+	ssize_t rv;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
+	int sf = 0; /* how many written so far */
+
+	sf += snprintf(buf, mxln - sf, "0x%x", local->hw.flags);
+	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
+		sf += snprintf(buf + sf, mxln - sf, " HAS_RATE_CONTROL");
+	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
+		sf += snprintf(buf + sf, mxln - sf, " RX_INCLUDES_FCS");
+	if (local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)
+		sf += snprintf(buf + sf, mxln - sf, " HOST_BCAST_PS_BUFFERING");
+	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE)
+		sf += snprintf(buf + sf, mxln - sf,
+			       " 2GHZ_SHORT_SLOT_INCAPABLE");
+	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE)
+		sf += snprintf(buf + sf, mxln - sf,
+			       " 2GHZ_SHORT_PREAMBLE_INCAPABLE");
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
+		sf += snprintf(buf + sf, mxln - sf, " SIGNAL_UNSPEC");
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		sf += snprintf(buf + sf, mxln - sf, " SIGNAL_DBM");
+	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
+		sf += snprintf(buf + sf, mxln - sf, " NEED_DTIM_PERIOD");
+	if (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT)
+		sf += snprintf(buf + sf, mxln - sf, " SPECTRUM_MGMT");
+	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
+		sf += snprintf(buf + sf, mxln - sf, " AMPDU_AGGREGATION");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS)
+		sf += snprintf(buf + sf, mxln - sf, " SUPPORTS_PS");
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		sf += snprintf(buf + sf, mxln - sf, " PS_NULLFUNC_STACK");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
+		sf += snprintf(buf + sf, mxln - sf, " SUPPORTS_DYNAMIC_PS");
+	if (local->hw.flags & IEEE80211_HW_MFP_CAPABLE)
+		sf += snprintf(buf + sf, mxln - sf, " MFP_CAPABLE");
+	if (local->hw.flags & IEEE80211_HW_BEACON_FILTER)
+		sf += snprintf(buf + sf, mxln - sf, " BEACON_FILTER");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS)
+		sf += snprintf(buf + sf, mxln - sf, " SUPPORTS_STATIC_SMPS");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
+		sf += snprintf(buf + sf, mxln - sf, " SUPPORTS_DYNAMIC_SMPS");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
+		sf += snprintf(buf + sf, mxln - sf, " SUPPORTS_UAPSD");
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sf += snprintf(buf + sf, mxln - sf, " REPORTS_TX_ACK_STATUS");
+	if (local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		sf += snprintf(buf + sf, mxln - sf, " CONNECTION_MONITOR");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)
+		sf += snprintf(buf + sf, mxln - sf, " SUPPORTS_CQM_RSSI");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK)
+		sf += snprintf(buf + sf, mxln - sf, " SUPPORTS_PER_STA_GTK");
+	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
+		sf += snprintf(buf + sf, mxln - sf, " AP_LINK_PS");
+
+	sf += snprintf(buf + sf, mxln - sf, "\n");
+
+	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+	kfree(buf);
+	return rv;
+}
+
 static const struct file_operations channel_type_ops = {
 	.read = channel_type_read,
 	.open = mac80211_open_file_generic,
 	.llseek = default_llseek,
 };
 
+static const struct file_operations hwflags_ops = {
+	.read = hwflags_read,
+	.open = mac80211_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static ssize_t queues_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -395,6 +467,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(uapsd_queues);
 	DEBUGFS_ADD(uapsd_max_sp_len);
 	DEBUGFS_ADD(channel_type);
+	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
 
-- 
1.7.3.4

