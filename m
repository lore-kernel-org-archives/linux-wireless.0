Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56088 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2ECFKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:10:19 -0400
Message-ID: <4FA21339.8060407@gtri.gatech.edu> (sfid-20120503_071024_045381_B1BFEA7A)
Date: Thu, 3 May 2012 01:10:17 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/9] rtlwifi: avoid race registering with mac80211
References: <4FA212D9.5020602@gtri.gatech.edu>
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
Content-Type: multipart/mixed;
	boundary="------------000405020607050809080207"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------000405020607050809080207
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit



--------------000405020607050809080207
Content-Type: text/x-patch;
	name="0001-rtlwifi-avoid-race-registering-with-mac80211.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-rtlwifi-avoid-race-registering-with-mac80211.patch"

>From 3511cdf6c7d4388a21a4d36da423258e73a963b6 Mon Sep 17 00:00:00 2001
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Date: Wed, 2 May 2012 23:48:21 -0400
Subject: [PATCH 1/9] rtlwifi: avoid race registering with mac80211

Move the ieee80211_register_hw call out of the firmware callback.  If the
firmware is cached in memory, the callback could be called before
rtl_init_core which configures the mac80211 bits.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/base.c         |    9 +++++++++
 drivers/net/wireless/rtlwifi/core.c         |    9 ---------
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |    9 ---------
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index e54488d..a08b408 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -421,11 +421,20 @@ int rtl_init_core(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
+	int err;
 
 	/* <1> init mac80211 */
 	_rtl_init_mac80211(hw);
 	rtlmac->hw = hw;
 
+	err = ieee80211_register_hw(hw);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			"Can't register mac80211 hw\n");
+		return 1;
+	}
+	rtlpriv->mac80211.mac80211_registered = 1;
+
 	/* <2> rate control register */
 	hw->rate_control_algorithm = "rtl_rc";
 
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 278e9f9..5f62b9d 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -40,7 +40,6 @@ void rtl_fw_cb(const struct firmware *firmware, void *context)
 {
 	struct ieee80211_hw *hw = context;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	int err;
 
 	RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
 			 "Firmware callback routine entered!\n");
@@ -60,14 +59,6 @@ void rtl_fw_cb(const struct firmware *firmware, void *context)
 	rtlpriv->rtlhal.fwsize = firmware->size;
 	release_firmware(firmware);
 
-	err = ieee80211_register_hw(hw);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't register mac80211 hw\n");
-		return;
-	} else {
-		rtlpriv->mac80211.mac80211_registered = 1;
-	}
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 
 	/*init rfkill */
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index f1b3600..9739e24 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -95,7 +95,6 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(pcipriv);
 	struct rt_firmware *pfirmware = NULL;
-	int err;
 
 	RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
 			 "Firmware callback routine entered!\n");
@@ -117,14 +116,6 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
 	pfirmware->sz_fw_tmpbufferlen = firmware->size;
 	release_firmware(firmware);
 
-	err = ieee80211_register_hw(hw);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't register mac80211 hw\n");
-		return;
-	} else {
-		rtlpriv->mac80211.mac80211_registered = 1;
-	}
 	rtlpci->irq_alloc = 1;
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 
-- 
1.7.7.6


--------------000405020607050809080207--
