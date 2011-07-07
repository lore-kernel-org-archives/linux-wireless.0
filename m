Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20808 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1GGSDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 14:03:40 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_htc: do not configure filter before driver is started
Date: Thu, 7 Jul 2011 23:33:38 +0530
Message-ID: <1310061819-7260-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110707_200344_161665_7C169738)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 7b77968..7212acb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1294,11 +1294,16 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	u32 rfilt;
 
 	mutex_lock(&priv->mutex);
-	ath9k_htc_ps_wakeup(priv);
-
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
+	if (priv->op_flags & OP_INVALID) {
+		ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_ANY,
+			"Unable to configure filter on invalid state\n");
+		return;
+	}
+	ath9k_htc_ps_wakeup(priv);
+
 	priv->rxfilter = *total_flags;
 	rfilt = ath9k_htc_calcrxfilter(priv);
 	ath9k_hw_setrxfilter(priv->ah, rfilt);
-- 
1.7.6

