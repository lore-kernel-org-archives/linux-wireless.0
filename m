Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33577 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbbGUJMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 05:12:39 -0400
Received: by lbbyj8 with SMTP id yj8so111544300lbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 02:12:38 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 4/4] ath9k: setup rxfilter when offchannel
Date: Tue, 21 Jul 2015 11:11:43 +0200
Message-Id: <1437469903-32362-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150721_111244_289681_C70BB971)
In-Reply-To: <1437469903-32362-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1437469903-32362-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup rxfiler correctly for offchannel ctx.

This fix problem we didn't configure rxfilter, next
didn't receive probe requests and next failed
p2p_find. This was seen when ath9k loaded with
use_chanctx=1

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3de829f..c27143b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1468,6 +1468,9 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	spin_lock_bh(&sc->chan_lock);
 	ath_for_each_chanctx(sc, ctx)
 		ctx->rxfilter = *total_flags;
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+	sc->offchannel.chan.rxfilter = *total_flags;
+#endif
 	spin_unlock_bh(&sc->chan_lock);
 
 	ath9k_ps_wakeup(sc);
-- 
1.9.1

