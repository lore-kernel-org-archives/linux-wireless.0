Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63985 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1EPAur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 20:50:47 -0400
Received: by iwn34 with SMTP id 34so3531253iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 17:50:46 -0700 (PDT)
Message-ID: <4DD074E3.3090502@lwfinger.net> (sfid-20110516_025056_145561_30091E5A)
Date: Sun, 15 May 2011 19:50:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rob Browning <rlb@defaultvalue.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>
In-Reply-To: <87pqnl5i81.fsf@raven.defaultvalue.org>
Content-Type: multipart/mixed;
 boundary="------------020001010603010601070200"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020001010603010601070200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/14/2011 12:01 PM, Rob Browning wrote:
>
> I'm seeing very slow receive rates (~63kb/s) with an EW-7811Un USB
> adapter which appears to load the rtl8192cu driver.  Is that a known
> problem?
>
> I'm currently running the Debian 2.6.39-rc7-amd64 kernel from unstable;
> I believe rc7 may be the first Debian kernel to work with this adapter.
>
> I also needed to patch Debian's firmware-realtek package to include the
> relevant firmware as detailed here:
>
>    http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625614.
>
> With respect to the connection quality I see:
>
>    Channel:1
>    Frequency:2.412 GHz (Channel 1)
>    Quality=65/70  Signal level=-45 dBm
>
> And during transfers "iw event -t" shows nothing other than the
> occasional scan started/finished pair.

You are using the correct firmware.

Could you please try the attached patch to see if it improves your throughput?

In addition, please file a Bugzilla report for this problem at 
http:bugzilla.kernel.org.

Thanks,

Larry

--------------020001010603010601070200
Content-Type: text/plain;
 name="rtl8192cu_fixes_low_rate"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_fixes_low_rate"

Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
@@ -34,6 +34,27 @@
 #include "phy.h"
 #include "dm.h"
 
+static void _rtl92c_dm_restore_power_index(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 index;
+	u32 power_index_reg[6] = {0xc90, 0xc91, 0xc92, 0xc98, 0xc99, 0xc9a};
+
+	for(index = 0; index< 6; index++)
+		rtl_write_byte(rtlpriv, power_index_reg[index],
+			       rtlpriv->dm.power_index_backup[index]);
+}
+
+static void _rtl92c_dm_write_power_index(struct ieee80211_hw *hw,u8 value)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 index;
+	u32 power_index_reg[6] = {0xc90, 0xc91, 0xc92, 0xc98, 0xc99, 0xc9a};
+
+	for(index = 0; index< 6; index++)
+		rtl_write_byte(rtlpriv, power_index_reg[index], value);
+}
+
 void rtl92cu_dm_dynamic_txpower(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -107,6 +128,17 @@ void rtl92cu_dm_dynamic_txpower(struct i
 			 ("PHY_SetTxPowerLevel8192S() Channel = %d\n",
 			  rtlphy->current_channel));
 		rtl92c_phy_set_txpower_level(hw, rtlphy->current_channel);
+
+		if(rtlpriv->dm.dynamic_txhighpower_lvl == TXHIGHPWRLEVEL_NORMAL)
+			/* HP1 -> Normal  or HP2 -> Normal */
+			 _rtl92c_dm_restore_power_index(hw);
+		else if(rtlpriv->dm.dynamic_txhighpower_lvl ==
+			TXHIGHPWRLEVEL_LEVEL1)
+			_rtl92c_dm_write_power_index(hw,0x14);
+		else if(rtlpriv->dm.dynamic_txhighpower_lvl ==
+			TXHIGHPWRLEVEL_LEVEL2)
+			_rtl92c_dm_write_power_index(hw,0x10);
+
 	}
 
 	rtlpriv->dm.last_dtp_lvl = rtlpriv->dm.dynamic_txhighpower_lvl;
Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -503,11 +503,33 @@ static void rtl92c_dm_dig(struct ieee802
 
 }
 
+static void _rtl92c_dm_save_power_index(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 index;
+	u32 power_index_reg[6] = {0xc90, 0xc91, 0xc92, 0xc98, 0xc99, 0xc9a};
+
+	for(index = 0; index< 6; index++)
+		rtlpriv->dm.power_index_backup[index] =
+				 rtl_read_byte(rtlpriv, power_index_reg[index]);
+}
+
 static void rtl92c_dm_init_dynamic_txpower(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtlpriv);
 
-	rtlpriv->dm.dynamic_txpower_enable = false;
+	if (rtlhal->interface == INTF_PCI) {
+		rtlpriv->dm.dynamic_txpower_enable = false;
+	} else {
+		if (rtlefuse->external_pa) {
+			_rtl92c_dm_save_power_index(hw);
+			rtlpriv->dm.dynamic_txpower_enable = true;
+		} else {
+			rtlpriv->dm.dynamic_txpower_enable = false;
+		}
+	}
 
 	rtlpriv->dm.last_dtp_lvl = TXHIGHPWRLEVEL_NORMAL;
 	rtlpriv->dm.dynamic_txhighpower_lvl = TXHIGHPWRLEVEL_NORMAL;
@@ -541,8 +563,6 @@ static void rtl92c_dm_pwdb_monitor(struc
 
 	u8 h2c_parameter[3] = { 0 };
 
-	return;
-
 	if (tmpentry_max_pwdb != 0) {
 		rtlpriv->dm.entry_max_undecoratedsmoothed_pwdb =
 		    tmpentry_max_pwdb;
Index: linux-2.6/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ linux-2.6/drivers/net/wireless/rtlwifi/wifi.h
@@ -1105,6 +1105,7 @@ struct rtl_dm {
 	bool disable_tx_int;
 	char ofdm_index[2];
 	char cck_index;
+	u8 power_index_backup[6];
 };
 
 #define	EFUSE_MAX_LOGICAL_SIZE			256

--------------020001010603010601070200--
