Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3361 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYJ2MbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 08:31:15 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: honor FIF_BCN_PRBRESP_PROMISC in STA mode
Date: Wed, 29 Oct 2008 08:30:56 -0400
Message-Id: <1225283457-24417-4-git-send-email-me@bobcopeland.com> (sfid-20081029_133122_397022_A95EC067)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were setting RX_FILTER_BEACON even after entering STA mode,
which leads to a lot of unnecessary wakeups.  This should fix the
bug "Ath5k driver has too many interrupts per second at idle" at
http://bugzilla.kernel.org/show_bug.cgi?id=11749.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c7ffcbb..5ef8cc4 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2952,10 +2952,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		sc->opmode != NL80211_IFTYPE_MESH_POINT &&
 		test_bit(ATH_STAT_PROMISC, sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
-	if (sc->opmode == NL80211_IFTYPE_STATION ||
-		sc->opmode == NL80211_IFTYPE_ADHOC) {
+	if (sc->opmode == NL80211_IFTYPE_ADHOC)
 		rfilt |= AR5K_RX_FILTER_BEACON;
-	}
 	if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
 		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
 			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
-- 
1.5.4.2.182.gb3092


