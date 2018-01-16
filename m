Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:16360 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbeAPODd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:33 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/13] staging: wilc1000: rename pstrCfgParamVal varaible in set_wiphy_params()
Date: Tue, 16 Jan 2018 19:32:30 +0530
Message-ID: <1516111351-5353-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150403_274903_23410630)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cleanup patch to fix camelCase issue found by checkpatch.pl
script.
In this patch, renamed pstrCfgParamVal to cfg_param_val to avoid
camelCase for variable name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 81f943d..0570b2d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1234,34 +1234,34 @@ static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	s32 ret = 0;
-	struct cfg_param_attr pstrCfgParamVal;
+	struct cfg_param_attr cfg_param_val;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	pstrCfgParamVal.flag = 0;
+	cfg_param_val.flag = 0;
 
 	if (changed & WIPHY_PARAM_RETRY_SHORT) {
-		pstrCfgParamVal.flag  |= RETRY_SHORT;
-		pstrCfgParamVal.short_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_short;
+		cfg_param_val.flag  |= RETRY_SHORT;
+		cfg_param_val.short_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_short;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG) {
-		pstrCfgParamVal.flag |= RETRY_LONG;
-		pstrCfgParamVal.long_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_long;
+		cfg_param_val.flag |= RETRY_LONG;
+		cfg_param_val.long_retry_limit = priv->dev->ieee80211_ptr->wiphy->retry_long;
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
-		pstrCfgParamVal.flag |= FRAG_THRESHOLD;
-		pstrCfgParamVal.frag_threshold = priv->dev->ieee80211_ptr->wiphy->frag_threshold;
+		cfg_param_val.flag |= FRAG_THRESHOLD;
+		cfg_param_val.frag_threshold = priv->dev->ieee80211_ptr->wiphy->frag_threshold;
 	}
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
-		pstrCfgParamVal.flag |= RTS_THRESHOLD;
-		pstrCfgParamVal.rts_threshold = priv->dev->ieee80211_ptr->wiphy->rts_threshold;
+		cfg_param_val.flag |= RTS_THRESHOLD;
+		cfg_param_val.rts_threshold = priv->dev->ieee80211_ptr->wiphy->rts_threshold;
 	}
 
-	ret = wilc_hif_set_cfg(vif, &pstrCfgParamVal);
+	ret = wilc_hif_set_cfg(vif, &cfg_param_val);
 	if (ret)
 		netdev_err(priv->dev, "Error in setting WIPHY PARAMS\n");
 
-- 
2.7.4
