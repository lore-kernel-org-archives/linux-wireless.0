Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34400 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbbKLNQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:17 -0500
Received: by lbbcs9 with SMTP id cs9so34649343lbb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:15 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 05/12] ath9k: use u32 when calculate tsf
Date: Thu, 12 Nov 2015 14:15:42 +0100
Message-Id: <1447334149-15507-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_144408_993586_6FD55644)
In-Reply-To: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 5640e88..d86566b 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1405,7 +1405,7 @@ static void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
-	s32 tsf, target_tsf;
+	u32 tsf, target_tsf;
 
 	if (!avp || !avp->noa.has_next_tsf)
 		return;
-- 
1.9.1

