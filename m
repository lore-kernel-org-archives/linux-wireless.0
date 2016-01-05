Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35909 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcAEJAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:00:32 -0500
Received: by mail-lb0-f169.google.com with SMTP id oh2so171446269lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 01:00:31 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] mac80211: add use_minrate param to ieee80211_tx_prepare_skb()
Date: Tue,  5 Jan 2016 10:00:19 +0100
Message-Id: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160105_100035_907131_981B03DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add use_minrate param to ieee80211_tx_prepare_skb() function.
This is useful in case we would like to send frames
with lowest rates, eg. nullfunc, probe_resp.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 5 +++--
 include/net/mac80211.h                   | 4 +++-
 net/mac80211/tx.c                        | 6 +++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index b81f65c..ccb2d76 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1040,7 +1040,7 @@ static void ath_scan_send_probe(struct ath_softc *sc,
 
 	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 
-	if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, NULL))
+	if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, NULL, true))
 		goto error;
 
 	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
@@ -1155,7 +1155,8 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 
 		skb->priority = 7;
 		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
-		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, &sta)) {
+		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb,
+					      band, &sta, true)) {
 			dev_kfree_skb_any(skb);
 			return false;
 		}
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ea9b51..7269fca 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5412,12 +5412,14 @@ void ieee80211_report_wowlan_wakeup(struct ieee80211_vif *vif,
  * @skb: frame to be sent from within the driver
  * @band: the band to transmit on
  * @sta: optional pointer to get the station to send the frame to
+ * @use_minrate: use lowest rate
  *
  * Note: must be called under RCU lock
  */
 bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
-			      int band, struct ieee80211_sta **sta);
+			      int band, struct ieee80211_sta **sta,
+			      bool use_minrate);
 
 /**
  * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a512c4b..ebe8268 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1526,7 +1526,8 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 
 bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
-			      int band, struct ieee80211_sta **sta)
+			      int band, struct ieee80211_sta **sta,
+			      bool use_minrate)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1540,6 +1541,9 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 	info->control.vif = vif;
 	info->hw_queue = vif->hw_queue[skb_get_queue_mapping(skb)];
 
+	if (use_minrate)
+		info->flags |= IEEE80211_TX_CTL_USE_MINRATE;
+
 	if (invoke_tx_handlers(&tx))
 		return false;
 
-- 
1.9.1

