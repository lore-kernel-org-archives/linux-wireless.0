Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1326 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0FDMVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 08:21:25 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	weedy2887@gmail.com, sidhayn@gmail.com,
	Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH] ath5k: retain promiscuous setting
Date: Fri,  4 Jun 2010 08:14:14 -0400
Message-Id: <1275653654-5499-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 56d1de0a21db28e41741cfa0a66e18bc8d920554, "ath5k: clean up
filter flags setting" introduced a regression in monitor mode such
that the promisc filter flag would get lost.

Although we set the promisc flag when it changed, we did not
preserve it across subsequent calls to configure_filter.  This patch
restores the original functionality.

Cc: stable@kernel.org
Bisected-by: weedy2887@gmail.com
Tested-by: weedy2887@gmail.com
Tested-by: Rick Farina <sidhayn@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9c27623..9e023b8 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3153,13 +3153,15 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 
 	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
 		if (*new_flags & FIF_PROMISC_IN_BSS) {
-			rfilt |= AR5K_RX_FILTER_PROM;
 			__set_bit(ATH_STAT_PROMISC, sc->status);
 		} else {
 			__clear_bit(ATH_STAT_PROMISC, sc->status);
 		}
 	}
 
+	if (test_bit(ATH_STAT_PROMISC, sc->status))
+		rfilt |= AR5K_RX_FILTER_PROM;
+
 	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
 	if (*new_flags & FIF_ALLMULTI) {
 		mfilt[0] =  ~0;
-- 
1.6.3.3


