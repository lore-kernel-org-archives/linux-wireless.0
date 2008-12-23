Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22685 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYLWX7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:59:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 15:59:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 12/16] ath9k: remove mode specific default noise floor values
Date: Tue, 23 Dec 2008 15:58:47 -0800
Message-ID: <1230076731-22946-13-git-send-email-lrodriguez@atheros.com> (sfid-20081224_010846_475492_94A60EAC)
In-Reply-To: <1230076731-22946-12-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-4-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-6-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-7-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-8-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-9-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-10-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-11-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-12-git-send-email-lrodriguez@atheros.com>
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
index 7072896..8e073d6 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -19,8 +19,6 @@
 #include "reg.h"
 #include "phy.h"
 
-static const int16_t NOISE_FLOOR[] = { -96, -93, -98, -96, -93, -96 };
-
 /* We can tune this as we go by monitoring really low values */
 #define ATH9K_NF_TOO_LOW	-60
 
@@ -740,10 +738,9 @@ s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
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
1.6.1.rc3.51.g5832d

