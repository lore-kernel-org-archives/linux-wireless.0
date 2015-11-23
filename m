Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54784 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbbKWS14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:56 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 4/8] cfg80211: reg: Properly handle rules for 5 and 10 MHz channels
Date: Mon, 23 Nov 2015 19:27:17 +0100
Message-Id: <1448303241-27747-5-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192801_651522_A290ADE4)
In-Reply-To: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regulatory rules are applied to channels as if the channel is at least
20 MHz wide. This is a problem when dealing with 5 and 10 MHz channels
because side channels of a regulatory rule get disabled even when they
fall into rule's frequency range.

This problem was already fixed in commit
4edd56981c8fbb349b1529a2feaf772636eb1c83, but only for custom regulatory
domains provided by drivers. Here we fix it also for all other (e.g.
user-supplied) regulatory domains.

Before that, similar commit was
reverted (e33e2241e272eddc38339692500bd1c7d8753a77) due to it allowing
running AP on channel 12 in the US regulatory domain. I have checked
that this is not possible with this change:

  # iw reg set US
  # iw dev wlan0 interface add wlan0_ap  type __ap
  # iw dev wlan0_ap set channel 12
  command failed: Invalid argument (-22)

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 net/wireless/reg.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0a4f548..35eaeeb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1201,11 +1201,6 @@ static uint32_t reg_rule_to_chan_bw_flags(const struct ieee80211_regdomain *regd
 	return bw_flags;
 }
 
-/*
- * Note that right now we assume the desired channel bandwidth
- * is always 20 MHz for each individual channel (HT40 uses 20 MHz
- * per channel, the primary and the extension channel).
- */
 static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
 			   struct ieee80211_channel *chan)
@@ -1221,7 +1216,8 @@ static void handle_channel(struct wiphy *wiphy,
 
 	flags = chan->orig_flags;
 
-	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
+	reg_rule = __freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
+				   MHZ_TO_KHZ(5));
 	if (IS_ERR(reg_rule)) {
 		/*
 		 * We will disable all channels that do not match our
-- 
2.5.3

