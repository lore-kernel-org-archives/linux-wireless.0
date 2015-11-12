Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34393 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbbKLNQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:16 -0500
Received: by lbbcs9 with SMTP id cs9so34648999lbb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:14 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 04/12] ath9k: P2P_CLIENT, send frames after 1ms AP/GO will aprear
Date: Thu, 12 Nov 2015 14:15:41 +0100
Message-Id: <1447334149-15507-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_141632_147508_1DB4BDD6)
In-Reply-To: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP/GO will aprear after NOA, wait 1ms to be sure AP
could receive/answer this frames.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index dddaaea..5640e88 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1417,6 +1417,8 @@ static void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 	target_tsf = avp->noa.next_tsf;
 	if (!avp->noa.absent)
 		target_tsf -= ATH_P2P_PS_STOP_TIME;
+	else
+		target_tsf += ATH_P2P_PS_STOP_TIME;
 
 	if (target_tsf - tsf < ATH_P2P_PS_STOP_TIME)
 		target_tsf = tsf + ATH_P2P_PS_STOP_TIME;
@@ -1543,6 +1545,8 @@ void ath9k_p2p_ps_timer(void *priv)
 	tsf = ath9k_hw_gettsf32(sc->sc_ah);
 	if (!avp->noa.absent)
 		tsf += ATH_P2P_PS_STOP_TIME;
+	else
+		tsf -= ATH_P2P_PS_STOP_TIME;
 
 	if (!avp->noa.has_next_tsf ||
 	    avp->noa.next_tsf - tsf > BIT(31))
-- 
1.9.1

