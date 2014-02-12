Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:38065 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbaBLTFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:10 -0500
Received: by mail-we0-f179.google.com with SMTP id q58so6343179wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:09 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 9/9] wcn36xx: Update dtim period before starting BSS
Date: Wed, 12 Feb 2014 19:04:48 +0000
Message-Id: <1392231888-2191-9-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200556_513139_0E464A37)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

The dtim period sent to FW was 0 because the dtim period
was never set. This caused an incorrect dtim count to be sent in
beacons.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index dca21ee..4ab5370 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -708,6 +708,7 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 			    bss_conf->enable_beacon);
 
 		if (bss_conf->enable_beacon) {
+			vif_priv->dtim_period = bss_conf->dtim_period;
 			vif_priv->bss_index = 0xff;
 			wcn36xx_smd_config_bss(wcn, vif, NULL,
 					       vif->addr, false);
-- 
1.8.3.2

