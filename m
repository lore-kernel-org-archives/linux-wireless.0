Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34437 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYLLGcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 01:32:24 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 22:32:24 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18754.1203.949873.82961@gargle.gargle.HOWL> (sfid-20081212_073227_206873_C536E549)
Date: Fri, 12 Dec 2008 11:59:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Do not use association state to update rate table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that HT information is made available to the driver through
config() callback, the channel type can be calculated whenever
setting the channel. Update the rate table accordingly with the new
channel type.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c39cfeb..ba04a11 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -61,8 +61,7 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 
 static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 {
-	if (!sc->sc_curaid)
-		sc->cur_rate_table = sc->hw_rate_table[mode];
+	sc->cur_rate_table = sc->hw_rate_table[mode];
 	/*
 	 * All protection frames are transmited at 2Mb/s for
 	 * 11g, otherwise at 1Mb/s.
-- 
1.6.0.3

