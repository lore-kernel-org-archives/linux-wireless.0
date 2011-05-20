Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59054 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935738Ab1ETMWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:22:51 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:22:20 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH 5/6] ath9k: set 40 Mhz rate only if hw is configured in ht40
Date: Fri, 20 May 2011 17:52:14 +0530
Message-ID: <1305894135-14036-5-git-send-email-rmanoharan@atheros.com> (sfid-20110520_142255_268500_00AC1EB2)
In-Reply-To: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever there is a channel width change from 40 Mhz to 20 Mhz,
the hardware is reconfigured to ht20. Meantime before doing
the rate control updation, the packets are being transmitted are
selected rate with IEEE80211_TX_RC_40_MHZ_WIDTH.

While transmitting ht40 rate packets in ht20 mode is causing
baseband panic with AR9003 based chips.

==== BB update: BB status=0x02001109 ====
ath: ** BB state: wd=1 det=1 rdar=0 rOFDM=1 rCCK=1 tOFDM=0 tCCK=0 agc=2
src=0 **
ath: ** BB WD cntl: cntl1=0xffff0085 cntl2=0x00000004 **
ath: ** BB mode: BB_gen_controls=0x000033c0 **
ath: ** BB busy times: rx_clear=99%, rx_frame=0%, tx_frame=0% **
ath: ==== BB update: done ====

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1754221..ba7f36a 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -689,7 +689,8 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table,
 
 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
-		if (WLAN_RC_PHY_40(rate_table->info[rix].phy))
+		if (WLAN_RC_PHY_40(rate_table->info[rix].phy) &&
+		    conf_is_ht40(&txrc->hw->conf))
 			rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 		if (WLAN_RC_PHY_SGI(rate_table->info[rix].phy))
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
-- 
1.7.5.1

