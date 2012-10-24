Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62165 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab2JXUAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 16:00:01 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so600642pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 13:00:00 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linville@tuxdriver.com
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net
Subject: [PATCH 2/2] ath9k_htc: Honor FIF_OTHER_BSS
Date: Wed, 24 Oct 2012 12:59:34 -0700
Message-Id: <1351108774-7450-3-git-send-email-javier@cozybit.com> (sfid-20121024_220007_624690_322AE919)
In-Reply-To: <1351108774-7450-1-git-send-email-javier@cozybit.com>
References: <1351108774-7450-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 06cdcb7..fc87fb9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -887,7 +887,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	if (priv->rxfilter & FIF_PSPOLL)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
-	if (priv->nvifs > 1)
+	if (priv->nvifs > 1 || priv->rxfilter & FIF_OTHER_BSS)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 
 	return rfilt;
-- 
1.7.5.4

