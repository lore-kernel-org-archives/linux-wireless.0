Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18587 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbZA1USh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:18:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 12:18:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/3] ath9k: move check for radar freqs into a helper
Date: Wed, 28 Jan 2009 12:17:48 -0800
Message-ID: <1233173869-16512-3-git-send-email-lrodriguez@atheros.com> (sfid-20090128_211845_940348_9E43D6DD)
In-Reply-To: <1233173869-16512-2-git-send-email-lrodriguez@atheros.com>
References: <1233173869-16512-1-git-send-email-lrodriguez@atheros.com>
 <1233173869-16512-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used later.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index b84fbe3..cccec40 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -154,6 +154,12 @@ const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hal *ah)
 	}
 }
 
+/* Frequency is one where radar detection is required */
+static bool ath9k_is_radar_freq(u16 center_freq)
+{
+	return (center_freq >= 5260 && center_freq <= 5700);
+}
+
 /* Enable adhoc on 5 GHz if allowed by 11d */
 static void ath9k_reg_apply_5ghz_adhoc_flags(struct wiphy *wiphy,
 					     enum reg_set_by setby)
@@ -247,9 +253,7 @@ void ath9k_reg_apply_radar_flags(struct wiphy *wiphy)
 
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
-		if (ch->center_freq < 5260)
-			continue;
-		if (ch->center_freq > 5700)
+		if (!ath9k_is_radar_freq(ch->center_freq))
 			continue;
 		/* We always enable radar detection/DFS on this
 		 * frequency range. Additionally we also apply on
-- 
1.6.1.rc3.51.g5832d

