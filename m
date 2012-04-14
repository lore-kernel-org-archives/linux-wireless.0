Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46354 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2DNPtV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 11:49:21 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: [RFC 2/2] ath9k: fix tx power settings for AR9287
Date: Sat, 14 Apr 2012 17:32:19 +0200
Message-Id: <1334417539-6498-2-git-send-email-juhosg@openwrt.org> (sfid-20120414_174946_183121_0D02F992)
In-Reply-To: <1334417539-6498-1-git-send-email-juhosg@openwrt.org>
References: <1334417539-6498-1-git-send-email-juhosg@openwrt.org>
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
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
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

