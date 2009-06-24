Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21389 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbZFXN1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 09:27:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 06:27:17 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 5/7] ath9k: stop ani when the STA gets disconnected.
Date: Wed, 24 Jun 2009 18:56:40 +0530
Message-ID: <1245850002-26351-6-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1245850002-26351-5-git-send-email-senthilkumar@atheros.com>
References: <1245850002-26351-1-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-2-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-3-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-4-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-5-git-send-email-senthilkumar@atheros.com>
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
index a977f80..81de792 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -950,6 +950,8 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		sc->curaid = 0;
+		/* Stop ANI */
+		del_timer_sync(&sc->ani.timer);
 	}
 }
 
@@ -2197,7 +2199,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
-	if (conf->type == NL80211_IFTYPE_AP)
+	if (conf->type == NL80211_IFTYPE_AP    ||
+	    conf->type == NL80211_IFTYPE_ADHOC ||
+	    conf->type == NL80211_IFTYPE_MONITOR)
 		ath_start_ani(sc);
 
 out:
-- 
1.6.0.4

