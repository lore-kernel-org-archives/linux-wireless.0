Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55151 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0GWCMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 22:12:21 -0400
Message-ID: <4C48FA83.7080405@openwrt.org>
Date: Fri, 23 Jul 2010 04:12:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k_hw: fix a small typo in the noisefloor calibration
 debug code
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the noisefloor array, the extension channel values start at index 3

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -278,7 +278,7 @@ static void ath9k_hw_nf_sanitize(struct 
 
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "NF calibrated [%s] [chain %d] is %d\n",
-			  (i > 3 ? "ext" : "ctl"), i % 3, nf[i]);
+			  (i >= 3 ? "ext" : "ctl"), i % 3, nf[i]);
 
 		if (nf[i] > limit->max) {
 			ath_print(common, ATH_DBG_CALIBRATE,
