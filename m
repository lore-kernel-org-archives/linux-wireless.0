Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:58209 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0Vnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2014 17:43:39 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so6600429wes.4
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 14:43:38 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCHv3 6/6] ath9k: extend ath9k_set_coverage_class signature
Date: Sun, 27 Jul 2014 23:43:35 +0200
Message-Id: <1406497415-25983-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140727_234341_885922_8E79DC0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Synchronize set_coverage_class routine signature with mac80211 function
pointer. Function pointer prototype has been changed to activate ath9k ACK
timeout estimation algorithm (dynack).

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6ac8d2..97c028e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1959,7 +1959,8 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
-static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
+static void ath9k_set_coverage_class(struct ieee80211_hw *hw,
+				     s16 coverage_class)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
-- 
1.9.1

