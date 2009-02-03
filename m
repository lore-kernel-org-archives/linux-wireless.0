Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53922 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZBCEfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 23:35:46 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 20:35:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: fix reg_notifier() flags used upon a country IE
Date: Mon, 2 Feb 2009 20:35:05 -0800
Message-ID: <1233635705-12890-1-git-send-email-lrodriguez@atheros.com> (sfid-20090203_053551_474020_136600E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nl80211 rule flags were being used.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index dfcc3b5..fe08a4f 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -192,11 +192,11 @@ static void ath9k_reg_apply_5ghz_beaconing_flags(struct wiphy *wiphy,
 		 * it by applying our static world regdomain by default during
 		 * probe */
 		if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
-			ch->flags &= ~NL80211_RRF_NO_IBSS;
+			ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
 		if (!ath9k_is_radar_freq(ch->center_freq))
 			continue;
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
-			ch->flags &= ~NL80211_RRF_PASSIVE_SCAN;
+			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
 	}
 }
 
-- 
1.6.1.2.253.ga34a

