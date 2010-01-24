Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41797 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab0AXC0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 21:26:17 -0500
Message-ID: <4B5BAFC3.7000807@openwrt.org>
Date: Sun, 24 Jan 2010 03:26:11 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: improve max rate retry handling
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k currently forces hw->max_rate_tries to 4 to work around rate
control inefficiencies. This has some negative side effects, such as
rate_control_send_low also using a maximum of 4 tries, which could
negatively affect reliability of unicast management frames.
This patch pushes the retry limit to the rate control instead, and
allows it to use more tries on the last stage to prevent unnecessary
packet loss.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -645,8 +645,7 @@ void ath9k_set_hw_capab(struct ath_softc
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
 	hw->max_listen_interval = 10;
-	/* Hardware supports 10 but we use 4 */
-	hw->max_rate_tries = 4;
+	hw->max_rate_tries = 10;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);
 
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -678,13 +678,13 @@ static void ath_get_rate(void *priv, str
 	 * For Multi Rate Retry we use a different number of
 	 * retry attempt counts. This ends up looking like this:
 	 *
-	 * MRR[0] = 2
-	 * MRR[1] = 2
-	 * MRR[2] = 2
-	 * MRR[3] = 4
+	 * MRR[0] = 4
+	 * MRR[1] = 4
+	 * MRR[2] = 4
+	 * MRR[3] = 8
 	 *
 	 */
-	try_per_rate = sc->hw->max_rate_tries;
+	try_per_rate = 4;
 
 	rate_table = sc->cur_rate_table;
 	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe);
@@ -714,7 +714,7 @@ static void ath_get_rate(void *priv, str
 	for ( ; i < 4; i++) {
 		/* Use twice the number of tries for the last MRR segment. */
 		if (i + 1 == 4)
-			try_per_rate = 4;
+			try_per_rate = 8;
 
 		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &nrix);
 		/* All other rates in the series have RTS enabled */
