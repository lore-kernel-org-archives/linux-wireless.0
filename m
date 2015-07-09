Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34842 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbGILuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:50:19 -0400
Received: by lblf12 with SMTP id f12so4005433lbl.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 04:50:16 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] ath9k: setup rxfilter when offchannel
Date: Thu,  9 Jul 2015 13:49:57 +0200
Message-Id: <1436442597-6147-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150709_135034_149431_F4A7A966)
In-Reply-To: <1436442597-6147-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1436442597-6147-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup rxfiler correctly for offchannel ctx.

This fix problem we didn't configure rxfilter, next
didn't receive probe requests and next failed
p2p_find. This was seen when ath9k loaded with
use_chanctx=1

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3de829f..b45084d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1468,6 +1468,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	spin_lock_bh(&sc->chan_lock);
 	ath_for_each_chanctx(sc, ctx)
 		ctx->rxfilter = *total_flags;
+	sc->offchannel.chan.rxfilter = *total_flags;
 	spin_unlock_bh(&sc->chan_lock);
 
 	ath9k_ps_wakeup(sc);
-- 
1.9.1

