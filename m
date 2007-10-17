Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.ics.forth.gr ([139.91.1.2]:38138 "EHLO
	mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbXJQWVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 18:21:15 -0400
Message-ID: <61445.77.49.14.172.1192655606.squirrel@webmail.ics.forth.gr> (sfid-20071017_232117_498204_A2E1E41F)
Date: Thu, 18 Oct 2007 00:13:26 +0300 (EEST)
Subject: RE: [PATCH 1/4] ath5k: Get rid of unused channel list parameters
     used in binary HAL
From: mick@ics.forth.gr
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hope it's O.K. now...

---

diff --git a/drivers/net/wireless/ath5k/ath5k.h
b/drivers/net/wireless/ath5k/ath5k.h
index bcf1041..de4a53a 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -918,7 +918,6 @@ struct ath_hw {

 	void			*ah_sc;
 	void __iomem		*ah_sh;
-	enum ath5k_countrycode	ah_country_code;

 	enum ath5k_int		ah_imr;

diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index 5ca6af1..6f55011 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -98,16 +98,6 @@ enum {

 static int ath_calinterval = ATH_SHORT_CALIB;

-static int countrycode = CTRY_DEFAULT;
-static int outdoor = true;
-static int xchanmode = true;
-module_param(countrycode, int, 0);
-MODULE_PARM_DESC(countrycode, "Override default country code");
-module_param(outdoor, int, 0);
-MODULE_PARM_DESC(outdoor, "Enable/disable outdoor use");
-module_param(xchanmode, int, 0);
-MODULE_PARM_DESC(xchanmode, "Enable/disable extended channel mode");
-
 #if AR_DEBUG
 static unsigned int ath_debug;
 module_param_named(debug, ath_debug, uint, 0);
@@ -1981,8 +1971,6 @@ static int ath_getchannels(struct ieee80211_hw *hw)

 	BUILD_BUG_ON(ARRAY_SIZE(sc->modes) < 3);

-	ah->ah_country_code = countrycode;
-
 	/* The order here does not matter */
 	modes[0].mode = MODE_IEEE80211G;
 	modes[1].mode = MODE_IEEE80211B;
@@ -2214,10 +2202,10 @@ static int ath_attach(struct pci_dev *pdev, struct
ieee80211_hw *hw)
 		ath5k_hw_reset_key(ah, i);

 	/*
-	 * Collect the channel list using the default country
-	 * code and including outdoor channels.  The 802.11 layer
-	 * is resposible for filtering this list based on settings
-	 * like the phy mode.
+	 * Collect the channel list.  The 802.11 layer
+	 * is resposible for filtering this list based
+	 * on settings like the phy mode and regulatory
+	 * domain restrictions.
 	 */
 	ret = ath_getchannels(hw);
 	if (ret) {
@@ -2585,27 +2573,6 @@ static ctl_table ath_static_sysctls[] = {
 	},
 #endif
 	{
-	  .procname	= "countrycode",
-	  .mode		= 0444,
-	  .data		= &countrycode,
-	  .maxlen	= sizeof(countrycode),
-	  .proc_handler	= proc_dointvec
-	},
-	{
-	  .procname	= "outdoor",
-	  .mode		= 0444,
-	  .data		= &outdoor,
-	  .maxlen	= sizeof(outdoor),
-	  .proc_handler	= proc_dointvec
-	},
-	{
-	  .procname	= "xchanmode",
-	  .mode		= 0444,
-	  .data		= &xchanmode,
-	  .maxlen	= sizeof(xchanmode),
-	  .proc_handler	= proc_dointvec
-	},
-	{
 	  .procname	= "calibrate",
 	  .mode		= 0644,
 	  .data		= &ath_calinterval,
diff --git a/drivers/net/wireless/ath5k/hw.c
b/drivers/net/wireless/ath5k/hw.c
index 504f642..8b22416 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -214,8 +214,7 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8
mac_version, void *sc,
 	 * HAL information
 	 */

-	/* Regulation Stuff */
-	hal->ah_country_code = AR5K_TUNE_CTRY;
+	/* Get reg domain from eeprom */
 	ath5k_get_regdomain(hal);

 	hal->ah_op_mode = IEEE80211_IF_TYPE_STA;



