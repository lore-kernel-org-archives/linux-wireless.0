Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51188 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab2DORmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 13:42:31 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] ath9k: fix tx power settings for AR9287
Date: Sun, 15 Apr 2012 20:38:06 +0200
Message-Id: <1334515086-16150-2-git-send-email-juhosg@openwrt.org> (sfid-20120415_194305_535947_F1CCF976)
In-Reply-To: <1334515086-16150-1-git-send-email-juhosg@openwrt.org>
References: <1334515086-16150-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'ath9k_hw_update_regulatory_maxpower'
helper function has been introduced by
commit a55f858852e4345d0a31af593c46738ca8614bff
(ath9k_hw: Cleanup TX power calculation for AR9287).

Updating of the max_power_level value has been moved
into the helper function in that change, however the
removed code from 'ath9k_hw_ar9287_set_txpower' has
not been replaced with a call of the new helper
function.

Due to that missing call, retrieving tx power for 2x2
and 3x3 chainmask is not handled properly. During the
calculation of the tx power for 2x2 and 3x3 chainmasks
the values are reduced. Those reductions must be
compensated during retrieving.

Fix this by adding the missing call of the helper
function.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index f272236..b34e8b2 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -824,6 +824,8 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 			regulatory->max_power_level = ratesArray[i];
 	}
 
+	ath9k_hw_update_regulatory_maxpower(ah);
+
 	if (test)
 		return;
 
-- 
1.7.2.1

