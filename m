Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35512 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbbLQJUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 04:20:52 -0500
Received: by mail-wm0-f42.google.com with SMTP id l126so11973576wml.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 01:20:51 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC/RFT 2/2] ath9k: request aligned skb
Date: Thu, 17 Dec 2015 10:20:29 +0100
Message-Id: <1450344029-5296-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151217_102102_728501_229CA2C1)
In-Reply-To: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set NEEDS_ALIGNED4_SKB hw flag.
This allow driver to save CPU and remove two memmove
from tx path.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/init.c |  1 +
 drivers/net/wireless/ath/ath9k/xmit.c | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6abace6..d578a00 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -831,6 +831,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(hw, NEEDS_ALIGNED4_SKBS);
 
 	if (ath9k_ps_enable)
 		ieee80211_hw_set(hw, SUPPORTS_PS);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 82fc76f..c3bd1b1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2267,11 +2267,15 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len > padpos) {
-		if (skb_headroom(skb) < padsize)
-			return -ENOMEM;
+		if (ieee80211_hw_check(hw, NEEDS_ALIGNED4_SKBS)) {
+			frmlen -= padsize;
+		} else {
+			if (skb_headroom(skb) < padsize)
+				return -ENOMEM;
 
-		skb_push(skb, padsize);
-		memmove(skb->data, skb->data + padsize, padpos);
+			skb_push(skb, padsize);
+			memmove(skb->data, skb->data + padsize, padpos);
+		}
 	}
 
 	setup_frame_info(hw, sta, skb, frmlen);
@@ -2494,7 +2498,8 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
-	if (padsize && skb->len>padpos+padsize) {
+	if (padsize && skb->len > padpos + padsize &&
+	    !ieee80211_hw_check(sc->hw, NEEDS_ALIGNED4_SKBS)) {
 		/*
 		 * Remove MAC header padding before giving the frame back to
 		 * mac80211.
-- 
1.9.1

