Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1LGNz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 08:55:28 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/4] ath9k: Restore EEPROM regulatory upon STA disconnect
Date: Wed, 7 Dec 2011 19:23:20 +0530
Message-ID: <1323266001-12912-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111207_145531_720885_A1D5BE4B)
In-Reply-To: <1323266001-12912-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1323266001-12912-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current regulatory for world roaming mode cards might be
overriden by country IE from the assiciated AP. But these
regulatory values are failed to be restored on disconnection.
This patch ensures to resotre regulatry values at driver side.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 424289f..a4dbb7b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2046,6 +2046,14 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 		sc->sc_flags &= ~SC_OP_ANI_RUN;
 		del_timer_sync(&common->ani.timer);
 		memset(&sc->caldata, 0, sizeof(sc->caldata));
+		/*
+		 * Restore regulatory values that might be updated
+		 * by country IEs.
+		 */
+		if (!ath_is_world_regd(&common->regulatory) &&
+		    ath_is_world_regd(&common->reg_world_copy))
+			memcpy(&common->regulatory, &common->reg_world_copy,
+			       sizeof(struct ath_regulatory));
 	}
 }
 
-- 
1.7.8

