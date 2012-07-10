Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59521 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2GJVN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 17:13:56 -0400
Received: by wibhm11 with SMTP id hm11so4996321wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 14:13:55 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: replace snprintf with scnprintf
Date: Wed, 11 Jul 2012 00:13:51 +0300
Message-Id: <1341954831-10313-3-git-send-email-eliad@wizery.com> (sfid-20120710_231400_483513_B34FD19D)
In-Reply-To: <1341954831-10313-1-git-send-email-eliad@wizery.com>
References: <1341954831-10313-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of snprintf was used incorrectly (given
as param to the next snprintf call, without checking
it against max buffer size). use scnprintf instead.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/debugfs.c             |   48 ++++++++++++++++++------------------
 net/mac80211/debugfs_netdev.c      |   10 +++---
 net/mac80211/rc80211_pid_debugfs.c |   26 +++++++++---------
 3 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 778e591..29e1559 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -130,56 +130,56 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
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
+		sf += scnprintf(buf + sf, mxln - sf,
 			       "HOST_BCAST_PS_BUFFERING\n");
 	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE)
-		sf += snprintf(buf + sf, mxln - sf,
+		sf += scnprintf(buf + sf, mxln - sf,
 			       "2GHZ_SHORT_SLOT_INCAPABLE\n");
 	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE)
-		sf += snprintf(buf + sf, mxln - sf,
+		sf += scnprintf(buf + sf, mxln - sf,
 			       "2GHZ_SHORT_PREAMBLE_INCAPABLE\n");
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
-		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_DBM\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SIGNAL_DBM\n");
 	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
-		sf += snprintf(buf + sf, mxln - sf, "NEED_DTIM_PERIOD\n");
+		sf += scnprintf(buf + sf, mxln - sf, "NEED_DTIM_PERIOD\n");
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
+		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_SMPS\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_UAPSD\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_UAPSD\n");
 	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		sf += snprintf(buf + sf, mxln - sf, "REPORTS_TX_ACK_STATUS\n");
+		sf += scnprintf(buf + sf, mxln - sf, "REPORTS_TX_ACK_STATUS\n");
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
 	if (local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)
-		sf += snprintf(buf + sf, mxln - sf, "SCAN_WHILE_IDLE\n");
+		sf += scnprintf(buf + sf, mxln - sf, "SCAN_WHILE_IDLE\n");
 
 	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 	kfree(buf);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6d5aec9..9758cbb 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -215,9 +215,9 @@ static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
-	return snprintf(buf, buflen, "request: %s\nused: %s\n",
-			smps_modes[sdata->u.mgd.req_smps],
-			smps_modes[sdata->u.mgd.ap_smps]);
+	return scnprintf(buf, buflen, "request: %s\nused: %s\n",
+			 smps_modes[sdata->u.mgd.req_smps],
+			 smps_modes[sdata->u.mgd.ap_smps]);
 }
 
 static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
@@ -342,7 +342,7 @@ static ssize_t ieee80211_if_fmt_uapsd_queues(
 {
 	const struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	return snprintf(buf, buflen, "0x%x\n", ifmgd->uapsd_queues);
+	return scnprintf(buf, buflen, "0x%x\n", ifmgd->uapsd_queues);
 }
 
 static ssize_t ieee80211_if_parse_uapsd_queues(
@@ -370,7 +370,7 @@ static ssize_t ieee80211_if_fmt_uapsd_max_sp_len(
 {
 	const struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	return snprintf(buf, buflen, "0x%x\n", ifmgd->uapsd_max_sp_len);
+	return scnprintf(buf, buflen, "0x%x\n", ifmgd->uapsd_max_sp_len);
 }
 
 static ssize_t ieee80211_if_parse_uapsd_max_sp_len(
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
 
-- 
1.7.6.401.g6a319

