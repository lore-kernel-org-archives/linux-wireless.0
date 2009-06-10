Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43280 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbZFJQ0C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 12:26:02 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 09:26:05 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <luis.rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 4/7] ath9k: stop ani when the STA gets disconnected.
Date: Wed, 10 Jun 2009 21:55:29 +0530
Message-ID: <1244651133-6537-5-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1244651133-6537-4-git-send-email-senthilkumar@atheros.com>
References: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-2-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-3-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-4-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI is not required when the STA is disconnected. So stop it and enable
ANI for adhoc and monitor mode.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 84fa69d..10dc7d1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -934,6 +934,8 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		sc->curaid = 0;
+		/* Stop ANI */
+		del_timer_sync(&sc->ani.timer);
 	}
 }
 
@@ -2243,7 +2245,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
-	if (conf->type == NL80211_IFTYPE_AP)
+	if (conf->type == NL80211_IFTYPE_AP    ||
+	    conf->type == NL80211_IFTYPE_ADHOC ||
+	    conf->type == NL80211_IFTYPE_MONITOR)
 		ath_start_ani(sc);
 
 out:
-- 
1.6.0.4

