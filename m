Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3H3It0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 04:49:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Subject: [PATCH 1/3] mac80211: fix some snprintf misuses
Date: Fri, 30 Aug 2013 10:49:19 +0200
Message-Id: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net> (sfid-20130830_104931_636456_970396D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In some debugfs related functions snprintf was used
while scnprintf should have been used instead.

(blindly adding the return value of snprintf and supplying
it to the next snprintf might result in buffer overflow when
the input is too big)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c             | 55 ++++++++++++++++++++------------------
 net/mac80211/rc80211_pid_debugfs.c | 26 +++++++++---------
 net/wireless/debugfs.c             | 24 +++++++++--------
 3 files changed, 55 insertions(+), 50 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b0e32d6..5c090e4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -103,54 +103,57 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 	if (!buf)
 		return 0;
 
-	sf += snprintf(buf, mxln - sf, "0x%x\n", local->hw.flags);
+	sf += scnprintf(buf, mxln - sf, "0x%x\n", local->hw.flags);
 	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
-		sf += snprintf(buf + sf, mxln - sf, "HAS_RATE_CONTROL\n");
+		sf += scnprintf(buf + sf, mxln - sf, "HAS_RATE_CONTROL\n");
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
-		sf += snprintf(buf + sf, mxln - sf, "RX_INCLUDES_FCS\n");
+		sf += scnprintf(buf + sf, mxln - sf, "RX_INCLUDES_FCS\n");
 	if (local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)
-		sf += snprintf(buf + sf, mxln - sf,
-			       "HOST_BCAST_PS_BUFFERING\n");
+		sf += scnprintf(buf + sf, mxln - sf,
+				"HOST_BCAST_PS_BUFFERING\n");
 	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE)
-		sf += snprintf(buf + sf, mxln - sf,
-			       "2GHZ_SHORT_SLOT_INCAPABLE\n");
+		sf += scnprintf(buf + sf, mxln - sf,
+				"2GHZ_SHORT_SLOT_INCAPABLE\n");
 	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE)
-		sf += snprintf(buf + sf, mxln - sf,
-			       "2GHZ_SHORT_PREAMBLE_INCAPABLE\n");
+		sf += scnprintf(buf + sf, mxln - sf,
+				"2GHZ_SHORT_PREAMBLE_INCAPABLE\n");
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
-		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_DBM\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SIGNAL_DBM\n");
 	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC)
-		sf += snprintf(buf + sf, mxln - sf, "NEED_DTIM_BEFORE_ASSOC\n");
+		sf += scnprintf(buf + sf, mxln - sf,
+				"NEED_DTIM_BEFORE_ASSOC\n");
 	if (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT)
-		sf += snprintf(buf + sf, mxln - sf, "SPECTRUM_MGMT\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SPECTRUM_MGMT\n");
 	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
-		sf += snprintf(buf + sf, mxln - sf, "AMPDU_AGGREGATION\n");
+		sf += scnprintf(buf + sf, mxln - sf, "AMPDU_AGGREGATION\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_PS\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_PS\n");
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-		sf += snprintf(buf + sf, mxln - sf, "PS_NULLFUNC_STACK\n");
+		sf += scnprintf(buf + sf, mxln - sf, "PS_NULLFUNC_STACK\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_PS\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_PS\n");
 	if (local->hw.flags & IEEE80211_HW_MFP_CAPABLE)
-		sf += snprintf(buf + sf, mxln - sf, "MFP_CAPABLE\n");
+		sf += scnprintf(buf + sf, mxln - sf, "MFP_CAPABLE\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_STATIC_SMPS\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_STATIC_SMPS\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_SMPS\n");
+		sf += scnprintf(buf + sf, mxln - sf,
+				"SUPPORTS_DYNAMIC_SMPS\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_UAPSD\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_UAPSD\n");
 	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		sf += snprintf(buf + sf, mxln - sf, "REPORTS_TX_ACK_STATUS\n");
+		sf += scnprintf(buf + sf, mxln - sf,
+				"REPORTS_TX_ACK_STATUS\n");
 	if (local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-		sf += snprintf(buf + sf, mxln - sf, "CONNECTION_MONITOR\n");
+		sf += scnprintf(buf + sf, mxln - sf, "CONNECTION_MONITOR\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_PER_STA_GTK\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_PER_STA_GTK\n");
 	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
-		sf += snprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
+		sf += scnprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
 	if (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)
-		sf += snprintf(buf + sf, mxln - sf, "TX_AMPDU_SETUP_IN_HW\n");
+		sf += scnprintf(buf + sf, mxln - sf, "TX_AMPDU_SETUP_IN_HW\n");
 
 	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 	kfree(buf);
diff --git a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
index c97a065..6ff1346 100644
--- a/net/mac80211/rc80211_pid_debugfs.c
+++ b/net/mac80211/rc80211_pid_debugfs.c
@@ -167,29 +167,29 @@ static ssize_t rate_control_pid_events_read(struct file *file, char __user *buf,
 	 * provide large enough buffers. */
 	length = length < RC_PID_PRINT_BUF_SIZE ?
 		 length : RC_PID_PRINT_BUF_SIZE;
-	p = snprintf(pb, length, "%u %lu ", ev->id, ev->timestamp);
+	p = scnprintf(pb, length, "%u %lu ", ev->id, ev->timestamp);
 	switch (ev->type) {
 	case RC_PID_EVENT_TYPE_TX_STATUS:
-		p += snprintf(pb + p, length - p, "tx_status %u %u",
-			      !(ev->data.flags & IEEE80211_TX_STAT_ACK),
-			      ev->data.tx_status.status.rates[0].idx);
+		p += scnprintf(pb + p, length - p, "tx_status %u %u",
+			       !(ev->data.flags & IEEE80211_TX_STAT_ACK),
+			       ev->data.tx_status.status.rates[0].idx);
 		break;
 	case RC_PID_EVENT_TYPE_RATE_CHANGE:
-		p += snprintf(pb + p, length - p, "rate_change %d %d",
-			      ev->data.index, ev->data.rate);
+		p += scnprintf(pb + p, length - p, "rate_change %d %d",
+			       ev->data.index, ev->data.rate);
 		break;
 	case RC_PID_EVENT_TYPE_TX_RATE:
-		p += snprintf(pb + p, length - p, "tx_rate %d %d",
-			      ev->data.index, ev->data.rate);
+		p += scnprintf(pb + p, length - p, "tx_rate %d %d",
+			       ev->data.index, ev->data.rate);
 		break;
 	case RC_PID_EVENT_TYPE_PF_SAMPLE:
-		p += snprintf(pb + p, length - p,
-			      "pf_sample %d %d %d %d",
-			      ev->data.pf_sample, ev->data.prop_err,
-			      ev->data.int_err, ev->data.der_err);
+		p += scnprintf(pb + p, length - p,
+			       "pf_sample %d %d %d %d",
+			       ev->data.pf_sample, ev->data.prop_err,
+			       ev->data.int_err, ev->data.der_err);
 		break;
 	}
-	p += snprintf(pb + p, length - p, "\n");
+	p += scnprintf(pb + p, length - p, "\n");
 
 	spin_unlock_irqrestore(&events->lock, status);
 
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 90d0500..4541577 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -47,17 +47,19 @@ static int ht_print_chan(struct ieee80211_channel *chan,
 		return 0;
 
 	if (chan->flags & IEEE80211_CHAN_DISABLED)
-		return snprintf(buf + offset,
-				buf_size - offset,
-				"%d Disabled\n",
-				chan->center_freq);
-
-	return snprintf(buf + offset,
-			buf_size - offset,
-			"%d HT40 %c%c\n",
-			chan->center_freq,
-			(chan->flags & IEEE80211_CHAN_NO_HT40MINUS) ? ' ' : '-',
-			(chan->flags & IEEE80211_CHAN_NO_HT40PLUS)  ? ' ' : '+');
+		return scnprintf(buf + offset,
+				 buf_size - offset,
+				 "%d Disabled\n",
+				 chan->center_freq);
+
+	return scnprintf(buf + offset,
+			 buf_size - offset,
+			 "%d HT40 %c%c\n",
+			 chan->center_freq,
+			 (chan->flags & IEEE80211_CHAN_NO_HT40MINUS) ?
+				' ' : '-',
+			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS) ?
+				' ' : '+');
 }
 
 static ssize_t ht40allow_map_read(struct file *file,
-- 
1.8.4.rc3

