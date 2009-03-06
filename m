Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:35166 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCFKR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 05:17:59 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: always compile ath_radio_{en,dis}able
Date: Fri,  6 Mar 2009 11:17:55 +0100
Message-Id: <1236334675-21918-1-git-send-email-juhosg@openwrt.org> (sfid-20090306_111802_515551_27F64154)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_radio_{en,dis}able is only compiled if RFKILL is enabled, but it is
required by the 'ath9k_wiphy_select' function.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath9k/main.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index f473fee..9f65a94 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1084,12 +1084,6 @@ fail:
 	ath_deinit_leds(sc);
 }
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-
-/*******************/
-/*	Rfkill	   */
-/*******************/
-
 void ath_radio_enable(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1166,6 +1160,12 @@ void ath_radio_disable(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 }
 
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
+
+/*******************/
+/*	Rfkill	   */
+/*******************/
+
 static bool ath_is_rfkill_set(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-- 
1.5.3.2

