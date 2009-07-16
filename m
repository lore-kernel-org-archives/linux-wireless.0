Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38303 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbZGPRRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 13:17:37 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 10:17:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bennyam Malavazi <bennyam.malavazi@atheros.com>,
	Jouni Malinen <jouni.malinen@Atheros.com>
Subject: [PATCH v2] ath9k: Tune ANI function processing on AP mode during ANI reset
Date: Thu, 16 Jul 2009 10:17:35 -0700
Message-ID: <1247764655-23304-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For AP mode we must tune ANI specially for 2 GHz and
for 5 GHz. We mask in only the flags we want to toggle
on ath9k_hw_ani_control() through the ah->ani_function
bitmask, this will take care of ignoring changes during
ANI reset which we were disabling before.

Testedy-by: Steven Luo <steven@steven676.net>
Cc: Bennyam Malavazi <bennyam.malavazi@atheros.com>
Cc: Jouni Malinen <jouni.malinen@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I had messed up an e-mail address on the commit log, here its fixed.
The actual patch is the same. Seems that shiny new ergonomic keyboard
helps with the hands but won't actually type for you.

 drivers/net/wireless/ath/ath9k/ani.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 1aeafb5..aad259b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -478,6 +478,18 @@ void ath9k_ani_reset(struct ath_hw *ah)
 			"Reset ANI state opmode %u\n", ah->opmode);
 		ah->stats.ast_ani_reset++;
 
+		if (ah->opmode == NL80211_IFTYPE_AP) {
+			/*
+			 * ath9k_hw_ani_control() will only process items set on
+			 * ah->ani_function
+			 */
+			if (IS_CHAN_2GHZ(chan))
+				ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
+						    ATH9K_ANI_FIRSTEP_LEVEL);
+			else
+				ah->ani_function = 0;
+		}
+
 		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, 0);
-- 
1.6.3.3

