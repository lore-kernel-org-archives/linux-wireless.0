Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48417 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1I1HRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 03:17:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC v4] mac80211: Send nullfunc frames at lower rate during connection monitor
Date: Wed, 28 Sep 2011 12:48:33 +0530
Message-ID: <1317194313-10292-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110928_091757_234231_6FF03015)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently mac80211 was changed to use nullfunc instead of probe
request for connection monitoring for tx ack status reporting
hardwares. Frequent disconnection was observed when the STA is
moving so frequesntly and it is on idle state without any transmission.
So the rate control is not learned completely in order to send data
frame at proper rate. So sending the nullfunc at higher rate in
in congested network is failed offenly.

This patch sends the nullfunc frame at minimum rate only if it is used
for monitoring purpose.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/mlme.c    |    5 +++++
 net/mac80211/rate.c    |    8 +++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1e83afa..35038ca 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -366,6 +366,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_NO_CCK_RATE: This frame will be sent at non CCK rate.
  *	This flag is actually used for management frame especially for P2P
  *	frames not being sent at CCK rate in 2GHz band.
+ * @IEEE80211_TX_CTL_USE_MINRATE: This frame will be sent at lowest rate.
+ *	This flag is used to send nullfunc frame at minimum rate where this
+ *	this nullfunc is used for connection monitoring.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -397,6 +400,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
 	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(27),
+	IEEE80211_TX_CTL_USE_MINRATE		= BIT(28),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cd37a4e..d87a88e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -348,6 +348,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr_3addr *nullfunc;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
 	if (!skb)
@@ -358,6 +359,10 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 		nullfunc->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+			    IEEE80211_STA_CONNECTION_POLL))
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
+
 	ieee80211_tx_skb(sdata, skb);
 }
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index f61244c..ff5c3aa 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -199,7 +199,7 @@ static void rate_control_release(struct kref *kref)
 	kfree(ctrl_ref);
 }
 
-static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
+static bool rc_no_data_or_no_ack_use_min(struct ieee80211_tx_rate_control *txrc)
 {
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -208,7 +208,9 @@ static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
 
 	fc = hdr->frame_control;
 
-	return (info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc);
+	return (info->flags & (IEEE80211_TX_CTL_NO_ACK |
+			       IEEE80211_TX_CTL_USE_MINRATE)) ||
+		!ieee80211_is_data(fc);
 }
 
 static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
@@ -262,7 +264,7 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 	struct ieee80211_supported_band *sband = txrc->sband;
 	int mcast_rate;
 
-	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
+	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
 		if ((sband->band != IEEE80211_BAND_2GHZ) ||
 		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
 			info->control.rates[0].idx =
-- 
1.7.6.4

