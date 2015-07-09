Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:33973 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbbGILuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:50:16 -0400
Received: by lagx9 with SMTP id x9so244487153lag.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 04:50:15 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] ath9k: setup rxfilter for all chanctx
Date: Thu,  9 Jul 2015 13:49:56 +0200
Message-Id: <1436442597-6147-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150709_135040_289847_5A16C176)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While mac80211 setup this per HW, set same
rxfilter configuration for all chanctx.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b7b77e0..3de829f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1459,13 +1459,15 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 				   u64 multicast)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_chanctx *ctx;
 	u32 rfilt;
 
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
 	spin_lock_bh(&sc->chan_lock);
-	sc->cur_chan->rxfilter = *total_flags;
+	ath_for_each_chanctx(sc, ctx)
+		ctx->rxfilter = *total_flags;
 	spin_unlock_bh(&sc->chan_lock);
 
 	ath9k_ps_wakeup(sc);
-- 
1.9.1

