Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7959 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab2HGBPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:15:40 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27627.335105.160676@gargle.gargle.HOWL> (sfid-20120807_031542_910299_776235EC)
Date: Tue, 7 Aug 2012 06:44:19 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 09/14] ath9k: Do not set IEEE80211_TX_RC_USE_SHORT_PREAMBLE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 does it for us.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ed48d3d..78192c1 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -682,8 +682,6 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table,
 	rate->count = tries;
 	rate->idx = rate_table->info[rix].ratecode;
 
-	if (txrc->short_preamble)
-		rate->flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
 	if (txrc->rts || rtsctsenable)
 		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
 
-- 
1.7.11.4

