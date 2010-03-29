Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50331 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab0C2KRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 06:17:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 03:17:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19376.33504.681983.192941@gargle.gargle.HOWL>
Date: Mon, 29 Mar 2010 16:07:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] ath9k_htc: Initialize HW opmode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not setting the opmode properly during initialization
results in the firmware sending up a bunch of packets
before add_interface() has been called, for the first
interface.

This patch fixes the issue by setting the initial mode
to 'managed'.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 3206eb0..d8779b9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -421,6 +421,7 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 		memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
 	priv->op_flags |= OP_TXAGGR;
+	priv->ah->opmode = NL80211_IFTYPE_STATION;
 }
 
 static int ath9k_init_priv(struct ath9k_htc_priv *priv, u16 devid)
-- 
1.7.0.3

