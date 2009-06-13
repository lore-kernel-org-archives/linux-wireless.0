Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45035 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZFMJ0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 05:26:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2009 02:26:47 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/3] ath9k: Make sure we have current channel in ah_curchan before rf disable/enable
Date: Sat, 13 Jun 2009 14:50:25 +0530
Message-ID: <1244884826-3009-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1244884826-3009-2-git-send-email-vasanth@atheros.com>
References: <1244884826-3009-1-git-send-email-vasanth@atheros.com>
 <1244884826-3009-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5fd17a4..48b117d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1125,6 +1125,9 @@ void ath_radio_enable(struct ath_softc *sc)
 	ath9k_ps_wakeup(sc);
 	ath9k_hw_configpcipowersave(ah, 0);
 
+	if (!ah->curchan)
+		ah->curchan = ath_get_curchannel(sc, sc->hw);
+
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
@@ -1177,6 +1180,9 @@ void ath_radio_disable(struct ath_softc *sc)
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
 
+	if (!ah->curchan)
+		ah->curchan = ath_get_curchannel(sc, sc->hw);
+
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
-- 
1.5.5.1

