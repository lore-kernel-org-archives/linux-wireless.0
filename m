Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41861 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496AbaIPAN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:26 -0400
Received: by mail-wi0-f182.google.com with SMTP id e4so5274590wiv.9
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:25 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 09/10] ath9k: enable dynack using set_coverage_class codepath
Date: Tue, 16 Sep 2014 02:13:15 +0200
Message-Id: <1410826396-15544-10-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021334_898994_A7ECA941)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable ACK timeout estimation algorithm if set_coverage_class routine has been
called with negative coverage_class parameter. Dynack is automatically disabled
setting valid value for coverage class

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6083359..6969aba 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1876,6 +1876,20 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
+static void ath9k_enable_dynack(struct ath_softc *sc)
+{
+#ifdef CONFIG_ATH9K_DYNACK
+	u32 rfilt;
+	struct ath_hw *ah = sc->sc_ah;
+
+	ath_dynack_reset(ah);
+
+	ah->dynack.enabled = true;
+	rfilt = ath_calcrxfilter(sc);
+	ath9k_hw_setrxfilter(ah, rfilt);
+#endif
+}
+
 static void ath9k_set_coverage_class(struct ieee80211_hw *hw,
 				     s16 coverage_class)
 {
@@ -1886,11 +1900,22 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw,
 		return;
 
 	mutex_lock(&sc->mutex);
-	ah->coverage_class = coverage_class;
 
-	ath9k_ps_wakeup(sc);
-	ath9k_hw_init_global_settings(ah);
-	ath9k_ps_restore(sc);
+	if (coverage_class >= 0) {
+		ah->coverage_class = coverage_class;
+		if (ah->dynack.enabled) {
+			u32 rfilt;
+
+			ah->dynack.enabled = false;
+			rfilt = ath_calcrxfilter(sc);
+			ath9k_hw_setrxfilter(ah, rfilt);
+		}
+		ath9k_ps_wakeup(sc);
+		ath9k_hw_init_global_settings(ah);
+		ath9k_ps_restore(sc);
+	} else if (!ah->dynack.enabled) {
+		ath9k_enable_dynack(sc);
+	}
 
 	mutex_unlock(&sc->mutex);
 }
-- 
1.9.1

