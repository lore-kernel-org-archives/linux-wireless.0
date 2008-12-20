Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11999 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYLTFz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:58 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 12/16] ath9k: remove mode specific default noise floor values
Date: Fri, 19 Dec 2008 21:55:18 -0800
Message-ID: <1229752522-1917-13-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065610_939887_450755A9)
In-Reply-To: <1229752522-1917-12-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-7-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-9-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-10-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-11-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-12-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NOISE_FLOOR array we have is mode specific, and the only
possible indexed values are A, B and G. The mode routine only
can return G or A, so this is band specific. Then since the
values for A and G (5ghz or 2ghz) are the same (-96) we simply
remove the array and use a static value.

If we later determine we want to use special values for
HT configurations we can use the new mac80211 conf_is_ht*()
helpers.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 74369c1..f82554b 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -19,8 +19,6 @@
 #include "reg.h"
 #include "phy.h"
 
-static const int16_t NOISE_FLOOR[] = { -96, -93, -98, -96, -93, -96 };
-
 /* We can tune this as we go by monitoring really low values */
 #define ATH9K_NF_TOO_LOW	-60
 
@@ -752,10 +750,9 @@ s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
 			chan->channel, chan->channelFlags);
 		return ATH_DEFAULT_NOISE_FLOOR;
 	}
-	if (ichan->rawNoiseFloor == 0) {
-		enum wireless_mode mode = ath9k_hw_chan2wmode(ah, chan);
-		nf = NOISE_FLOOR[mode];
-	} else
+	if (ichan->rawNoiseFloor == 0)
+		nf = -96;
+	else
 		nf = ichan->rawNoiseFloor;
 
 	if (!ath9k_hw_nf_in_range(ah, nf))
-- 
1.5.6.rc2.15.g457bb.dirty

