Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CAWMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 17:12:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add VHT capabilities station debugfs file
Date: Fri,  1 Mar 2013 23:12:15 +0100
Message-Id: <1362175935-11828-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_231229_956773_D9D04F05)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add a new debugfs file to view a station's VHT capabilities.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index c7591f7..942df95 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -325,6 +325,36 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(ht_capa);
 
+static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	char buf[512], *p = buf;
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_sta_vht_cap *vhtc = &sta->sta.vht_cap;
+
+	p += scnprintf(p, sizeof(buf) + buf - p, "VHT %ssupported\n",
+			vhtc->vht_supported ? "" : "not ");
+	if (vhtc->vht_supported) {
+		p += scnprintf(p, sizeof(buf)+buf-p, "cap: %#.8x\n", vhtc->cap);
+
+		p += scnprintf(p, sizeof(buf)+buf-p, "RX MCS: %.4x\n",
+			       le16_to_cpu(vhtc->vht_mcs.rx_mcs_map));
+		if (vhtc->vht_mcs.rx_highest)
+			p += scnprintf(p, sizeof(buf)+buf-p,
+				       "MCS RX highest: %d Mbps\n",
+				       le16_to_cpu(vhtc->vht_mcs.rx_highest));
+		p += scnprintf(p, sizeof(buf)+buf-p, "TX MCS: %.4x\n",
+			       le16_to_cpu(vhtc->vht_mcs.tx_mcs_map));
+		if (vhtc->vht_mcs.tx_highest)
+			p += scnprintf(p, sizeof(buf)+buf-p,
+				       "MCS TX highest: %d Mbps\n",
+				       le16_to_cpu(vhtc->vht_mcs.tx_highest));
+	}
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+STA_OPS(vht_capa);
+
 static ssize_t sta_current_tx_rate_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -405,6 +435,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(dev);
 	DEBUGFS_ADD(last_signal);
 	DEBUGFS_ADD(ht_capa);
+	DEBUGFS_ADD(vht_capa);
 	DEBUGFS_ADD(last_ack_signal);
 	DEBUGFS_ADD(current_tx_rate);
 	DEBUGFS_ADD(last_rx_rate);
-- 
1.8.0

