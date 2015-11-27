Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34301 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbbK0Ih2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:28 -0500
Received: by lffu14 with SMTP id u14so121540494lff.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:26 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 04/13] ath9k: P2P_CLIENT, send frames after 1ms AP/GO will aprear
Date: Fri, 27 Nov 2015 09:37:09 +0100
Message-Id: <1448613438-5173-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093734_921581_8E83D818)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
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

