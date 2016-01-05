Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34864 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbcAEKf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:35:58 -0500
Received: by mail-lb0-f180.google.com with SMTP id bc4so172036476lbc.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 02:35:57 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/2] ath9k: use min rate when MCC and nullfunc
Date: Tue,  5 Jan 2016 11:35:34 +0100
Message-Id: <1451990134-15183-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160105_113607_793565_95B546E4)
In-Reply-To: <1451990134-15183-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1451990134-15183-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of nullfunc and MCC case use lowest
possible rates.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index b81f65c..988c859 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1155,6 +1155,7 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 
 		skb->priority = 7;
 		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, &sta)) {
 			dev_kfree_skb_any(skb);
 			return false;
-- 
1.9.1

