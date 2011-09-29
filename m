Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27796 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab1I2LXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 07:23:39 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: Choose highest rate of MRR based on IEEE80211_TX_CTL_USE_MINRATE
Date: Thu, 29 Sep 2011 16:54:06 +0530
Message-ID: <1317295446-20749-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110929_132348_183441_C378143A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Select appropriate rate as highest rate of rate series, if the frame
was asked to be sent at minimum rate. For example nullfunc frames
either can be sent at HT rates on normal case or at non-HT rates if
it is used for connection monitoring.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 8448281..3509f14 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -789,8 +789,8 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	try_per_rate = 4;
 
 	rate_table = ath_rc_priv->rate_table;
-	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
-				     &is_probe, false);
+	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table, &is_probe,
+			     !!(tx_info->flags & IEEE80211_TX_CTL_USE_MINRATE));
 	high_rix = rix;
 
 	/*
-- 
1.7.6.4

