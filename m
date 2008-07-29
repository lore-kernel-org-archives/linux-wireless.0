Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17140 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbYG2Frf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:35 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:35 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 06/16] ath9k: Fix missing brace in branch on ath_chainmask_sel_logic()
Date: Mon, 28 Jul 2008 22:47:15 -0700
Message-ID: <40a067eab54b9b366002257d5be8e4577b067408.1217309551.git.lrodriguez@atheros.com> (sfid-20080729_074738_571304_E6A71E38)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 47d4891..d9c7561 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -508,9 +508,10 @@ int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
 	 * enabled/disabled setting
 	 */
 	if ((sc->sc_no_tx_3_chains == AH_FALSE) ||
-	    (sc->sc_config.chainmask_sel == AH_FALSE))
+	    (sc->sc_config.chainmask_sel == AH_FALSE)) {
 		cm->cur_tx_mask = sc->sc_tx_chainmask;
 		return cm->cur_tx_mask;
+	}
 
 	if (cm->tx_avgrssi == ATH_RSSI_DUMMY_MARKER)
 		return cm->cur_tx_mask;
-- 
1.5.4.3

