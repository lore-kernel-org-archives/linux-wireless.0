Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:19718 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092AbXJPVbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 17:31:48 -0400
Received: by py-out-1112.google.com with SMTP id u77so3937259pyb
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 14:31:46 -0700 (PDT)
Message-ID: <40f31dec0710161431h188f7d41v7fca16d9ff5fbc46@mail.gmail.com> (sfid-20071016_223152_440656_E40D1D09)
Date: Wed, 17 Oct 2007 00:31:43 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Jiri Slaby" <jirislaby@gmail.com>
Subject: [PATCH 1/4] ath5k: Get rid of unused channel list parameters used in binary HAL
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some parameters left in the code that were used by binary
HAL to generate the channel list. Since we don't use binary HAL and
channel list is handled differently, they are out.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Changes to ath5k.h, hw.c
Changes-licensed-under: ISC

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h
b/drivers/net/wireless/ath5k/ath5k.h
index bcf1041..de4a53a 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -918,7 +918,6 @@ struct ath_hw {

        void                    *ah_sc;
        void __iomem            *ah_sh;
-       enum ath5k_countrycode  ah_country_code;

        enum ath5k_int          ah_imr;

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

-       ah->ah_country_code = countrycode;
-
        /* The order here does not matter */
        modes[0].mode = MODE_IEEE80211G;
        modes[1].mode = MODE_IEEE80211B;
@@ -2214,10 +2202,10 @@ static int ath_attach(struct pci_dev *pdev,
struct ieee80211_hw *hw)
                ath5k_hw_reset_key(ah, i);

        /*
-        * Collect the channel list using the default country
-        * code and including outdoor channels.  The 802.11 layer
-        * is resposible for filtering this list based on settings
-        * like the phy mode.
+        * Collect the channel list.  The 802.11 layer
+        * is resposible for filtering this list based
+        * on settings like the phy mode and regulatory
+        * domain restrictions.
         */
        ret = ath_getchannels(hw);
        if (ret) {
@@ -2585,27 +2573,6 @@ static ctl_table ath_static_sysctls[] = {
        },
 #endif
        {
-         .procname     = "countrycode",
-         .mode         = 0444,
-         .data         = &countrycode,
-         .maxlen       = sizeof(countrycode),
-         .proc_handler = proc_dointvec
-       },
-       {
-         .procname     = "outdoor",
-         .mode         = 0444,
-         .data         = &outdoor,
-         .maxlen       = sizeof(outdoor),
-         .proc_handler = proc_dointvec
-       },
-       {
-         .procname     = "xchanmode",
-         .mode         = 0444,
-         .data         = &xchanmode,
-         .maxlen       = sizeof(xchanmode),
-         .proc_handler = proc_dointvec
-       },
-       {
          .procname     = "calibrate",
          .mode         = 0644,
          .data         = &ath_calinterval,
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 504f642..8b22416 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -214,8 +214,7 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8
mac_version, void *sc,
         * HAL information
         */

-       /* Regulation Stuff */
-       hal->ah_country_code = AR5K_TUNE_CTRY;
+       /* Get reg domain from eeprom */
        ath5k_get_regdomain(hal);

        hal->ah_op_mode = IEEE80211_IF_TYPE_STA;


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
