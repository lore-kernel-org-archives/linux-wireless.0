Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47991 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0VmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2014 17:42:07 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so6360470wgh.10
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 14:42:05 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCHv3 4/6] ath5k: extend ath5k_set_coverage_class signature
Date: Sun, 27 Jul 2014 23:42:00 +0200
Message-Id: <1406497320-25796-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140727_234210_313038_61439D34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Synchronize set_coverage_class routine signature with mac80211 function
pointer. Function pointer prototype has been changed to activate ath9k ACK
timeout estimation algorithm (dynack).

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index b65c38f..ab2709a 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -704,7 +704,7 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
  * reset.
  */
 static void
-ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
+ath5k_set_coverage_class(struct ieee80211_hw *hw, s16 coverage_class)
 {
 	struct ath5k_hw *ah = hw->priv;
 
-- 
1.9.1

