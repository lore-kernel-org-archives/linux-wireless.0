Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60201 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab1BDMZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 07:25:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 04:25:11 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: Fix a race on enabling power save.
Date: Fri, 4 Feb 2011 17:55:26 +0530
Message-ID: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race on sending a data frame before the tx completion
of nullfunc frame for enabling power save. As the data quickly
follows the nullfunc frame, the AP thinks that the station is out
of power save and continues to send the frames. Whereas in the
station, the nullfunc ack will be processed after the tx completion
of data frame and mac80211 goes to powersave. Thus the power
save state mismatch between the station and the AP causes some
data loss and some applications fail because of that. This patch
fixes this issue.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    8 ++++++--
 net/mac80211/tx.c          |    8 ++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 533fd32..6ad97f6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -346,6 +346,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_PS_PENDING	= BIT(10),
 };
 
 struct ieee80211_if_managed {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e059b3a..45f736e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -727,13 +727,17 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		return;
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
+	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
+		ifmgd->flags |= IEEE80211_STA_PS_PENDING;
 		ieee80211_send_nullfunc(local, sdata, 1);
+	}
 
 	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
 	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
-	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
+	    ((ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED) &&
+	      ifmgd->flags & IEEE80211_STA_PS_PENDING))  {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+		ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8fbbc7a..e1c2256 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -185,6 +185,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_hdr *hdr;
 
 	/* driver doesn't support power save */
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
@@ -233,6 +234,13 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	    && skb_get_queue_mapping(tx->skb) == 0)
 		return TX_CONTINUE;
 
+	hdr = (struct ieee80211_hdr *)tx->skb->data;
+
+	if (!(ieee80211_is_nullfunc(hdr->frame_control) &&
+	     ieee80211_has_pm(hdr->frame_control)) &&
+	    (ifmgd->flags & IEEE80211_STA_PS_PENDING))
+		ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
 						IEEE80211_QUEUE_STOP_REASON_PS);
-- 
1.6.3.3

