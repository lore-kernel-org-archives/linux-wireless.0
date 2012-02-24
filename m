Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37751 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2BXGHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 01:07:30 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 1/3] ath9k: completely zero intialize valid_phy_rate_idx
Date: Fri, 24 Feb 2012 11:37:19 +0530
Message-ID: <1330063641-4524-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120224_070734_164798_E167FF83)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

its better to zero initialize the 'valid_phy_rate_idx' array completely

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 drivers/net/wireless/ath/ath9k/rc.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a427a16..424864b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1228,7 +1228,7 @@ static void ath_rc_init(struct ath_softc *sc,
 	ath_rc_init_valid_rate_idx(ath_rc_priv);
 
 	for (i = 0; i < WLAN_RC_PHY_MAX; i++) {
-		for (j = 0; j < MAX_TX_RATE_PHY; j++)
+		for (j = 0; j < RATE_TABLE_SIZE; j++)
 			ath_rc_priv->valid_phy_rateidx[i][j] = 0;
 		ath_rc_priv->valid_phy_ratecnt[i] = 0;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index b7a4bcd..75f8e9b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -25,8 +25,6 @@ struct ath_softc;
 
 #define ATH_RATE_MAX     30
 #define RATE_TABLE_SIZE  72
-#define MAX_TX_RATE_PHY  48
-
 
 #define RC_INVALID	0x0000
 #define RC_LEGACY	0x0001
-- 
1.7.0.4

