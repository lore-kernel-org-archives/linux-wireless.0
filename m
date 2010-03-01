Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:20096 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751298Ab0CAL72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 06:59:28 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0294944767
	for <linux-wireless@vger.kernel.org>; Mon,  1 Mar 2010 20:59:27 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 5/5] ath5k: fix TSF reset
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 01 Mar 2010 20:59:26 +0900
Message-ID: <20100301115926.13996.42566.stgit@void>
In-Reply-To: <20100301115903.13996.95024.stgit@void>
References: <20100301115903.13996.95024.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to reset the TSF, AR5K_BEACON_RESET_TSF has to be 1, not 0. also we have a
function for that so use it.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/ath/ath5k/reset.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index a35a7db..c780b55 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1379,11 +1379,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		ath5k_hw_set_sleep_clock(ah, true);
 
 	/*
-	 * Disable beacons and reset the register
+	 * Disable beacons and reset the TSF
 	 */
-	AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE |
-			AR5K_BEACON_RESET_TSF);
-
+	AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
+	ath5k_hw_reset_tsf(ah);
 	return 0;
 }
 

