Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39473 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:20:15 -0500
Received: by yib18 with SMTP id 18so2360641yib.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:20:14 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52177.65660.815952@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:50:01 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 18/23] ath9k_htc: Fix TBTT calculation for IBSS mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The target beacon transmission time has to be synced with the HW
TSF when configuring beacon timers in Adhoc mode. Failing to do this
would cause erroneous beacon transmission, for example, on completion
of a scan run to check for IBSS merges.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index e897a56..007b99f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -188,20 +188,31 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	enum ath9k_int imask = 0;
-	u32 nexttbtt, intval;
+	u32 nexttbtt, intval, tsftu;
 	__be32 htc_imask = 0;
 	int ret;
 	u8 cmd_rsp;
+	u64 tsf;
 
 	intval = bss_conf->beacon_interval & ATH9K_BEACON_PERIOD;
 	nexttbtt = intval;
+
+	/*
+	 * Pull nexttbtt forward to reflect the current TSF.
+	 */
+	tsf = ath9k_hw_gettsf64(priv->ah);
+	tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
+	do {
+		nexttbtt += intval;
+	} while (nexttbtt < tsftu);
+
 	intval |= ATH9K_BEACON_ENA;
 	if (priv->op_flags & OP_ENABLE_BEACON)
 		imask |= ATH9K_INT_SWBA;
 
-	ath_dbg(common, ATH_DBG_BEACON,
-		"IBSS Beacon config, intval: %d, imask: 0x%x\n",
-		bss_conf->beacon_interval, imask);
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"IBSS Beacon config, intval: %d, nexttbtt: %u, imask: 0x%x\n",
+		bss_conf->beacon_interval, nexttbtt, imask);
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
-- 
1.7.4.1

