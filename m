Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from connotech.com ([76.10.176.241]:51137 "EHLO mail.connotech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaCJN0C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 09:26:02 -0400
Received: from [192.168.1.204] (DODECA1ER.CONNOTECH-INTERNAL.COM [192.168.1.204])
	by mail.connotech.com (Postfix) with ESMTPA id 86B8931A22
	for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2014 09:23:14 -0400 (EDT)
Message-ID: <531DBD98.2030906@connotech.com> (sfid-20140310_142702_761304_6D4EC331)
Date: Mon, 10 Mar 2014 13:26:48 +0000
From: Thierry Moreau <thierry.moreau@connotech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Scan completes with wext, not with nl80211 (wpa_supplicant, rtlwifi,
 3.14.0-rc5)
Content-Type: multipart/mixed;
 boundary="------------040809090301070101070307"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040809090301070101070307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

This is not a show stopper for me, but some of you may want to deprecate 
the wireless extension kernel option.

I have a configuration where scanning and association attempt work fine 
from wpa_supplicant when the wpa_priv utility is started with wext:wlan1 
but not with nl80211:wlan1.

If I try the not-performing variant (nl80211), I need to remove and 
install the wifi module (rtl8192ce) for the other one to perform OK. 
 From a fresh boot, this performing wext variant works fine the first time.

I have traces from wpa_priv, wpa_supplicant, and wpa_cli from either 
options. Same configuration files for build time and run time.

Tried with various kernel options. A portion of the most recent kernel 
config is attached.

If I can be of assistance for improving the Linux Wi-Fi support, let me 
know.

- Thierry Moreau

--------------040809090301070101070307
Content-Type: text/plain; charset=us-ascii;
 name="scan_only_with_wext.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scan_only_with_wext.log"

grep '\(WIFI\|WIRELESS\|RTL8\|80211\)' .config -C 4 -n
928-# CONFIG_IRDA is not set
929-# CONFIG_BT is not set
930-# CONFIG_AF_RXRPC is not set
931-CONFIG_FIB_RULES=y
932:CONFIG_WIRELESS=y
933:CONFIG_WIRELESS_EXT=y
934-CONFIG_WEXT_CORE=y
935-CONFIG_WEXT_PROC=y
936-CONFIG_WEXT_SPY=y
937-CONFIG_WEXT_PRIV=y
938:CONFIG_CFG80211=y
939:# CONFIG_NL80211_TESTMODE is not set
940:# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
941:# CONFIG_CFG80211_REG_DEBUG is not set
942:CONFIG_CFG80211_DEFAULT_PS=y
943:# CONFIG_CFG80211_DEBUGFS is not set
944:# CONFIG_CFG80211_INTERNAL_REGDB is not set
945:# CONFIG_CFG80211_WEXT is not set
946:CONFIG_LIB80211=y
947:CONFIG_LIB80211_CRYPT_WEP=y
948:CONFIG_LIB80211_CRYPT_CCMP=y
949:CONFIG_LIB80211_CRYPT_TKIP=y
950:# CONFIG_LIB80211_DEBUG is not set
951:CONFIG_MAC80211=y
952:CONFIG_MAC80211_HAS_RC=y
953:CONFIG_MAC80211_RC_MINSTREL=y
954:CONFIG_MAC80211_RC_MINSTREL_HT=y
955:CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
956:CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
957:CONFIG_MAC80211_MESH=y
958:CONFIG_MAC80211_LEDS=y
959:# CONFIG_MAC80211_DEBUGFS is not set
960:# CONFIG_MAC80211_MESSAGE_TRACING is not set
961:# CONFIG_MAC80211_DEBUG_MENU is not set
962-# CONFIG_WIMAX is not set
963-CONFIG_RFKILL=y
964-CONFIG_RFKILL_LEDS=y
965-CONFIG_RFKILL_INPUT=y
--
1482-#
1483-# CONFIG_USB_CATC is not set
1484-# CONFIG_USB_KAWETH is not set
1485-# CONFIG_USB_PEGASUS is not set
1486:# CONFIG_USB_RTL8150 is not set
1487:# CONFIG_USB_RTL8152 is not set
1488-# CONFIG_USB_USBNET is not set
1489-# CONFIG_USB_HSO is not set
1490-# CONFIG_USB_IPHETH is not set
1491-CONFIG_WLAN=y
--
1498-# CONFIG_PCMCIA_WL3501 is not set
1499-# CONFIG_PRISM54 is not set
1500-# CONFIG_USB_ZD1201 is not set
1501-# CONFIG_USB_NET_RNDIS_WLAN is not set
1502:# CONFIG_RTL8180 is not set
1503:# CONFIG_RTL8187 is not set
1504-# CONFIG_ADM8211 is not set
1505:# CONFIG_MAC80211_HWSIM is not set
1506-# CONFIG_MWL8K is not set
1507-# CONFIG_ATH_CARDS is not set
1508-# CONFIG_B43 is not set
1509-# CONFIG_B43LEGACY is not set
--
1514-# CONFIG_HOSTAP_PLX is not set
1515-# CONFIG_HOSTAP_PCI is not set
1516-# CONFIG_HOSTAP_CS is not set
1517-# CONFIG_IPW2100 is not set
1518:# CONFIG_IWLWIFI is not set
1519-# CONFIG_IWL4965 is not set
1520-# CONFIG_IWL3945 is not set
1521-# CONFIG_LIBERTAS is not set
1522-# CONFIG_P54_COMMON is not set
1523-# CONFIG_RT2X00 is not set
1524-CONFIG_RTL_CARDS=y
1525:CONFIG_RTL8192CE=m
1526:# CONFIG_RTL8192SE is not set
1527:# CONFIG_RTL8192DE is not set
1528:# CONFIG_RTL8723AE is not set
1529:# CONFIG_RTL8188EE is not set
1530:# CONFIG_RTL8192CU is not set
1531:CONFIG_RTLWIFI=m
1532:CONFIG_RTLWIFI_PCI=m
1533:CONFIG_RTLWIFI_DEBUG=y
1534:CONFIG_RTL8192C_COMMON=m
1535-# CONFIG_WL_TI is not set
1536-# CONFIG_ZD1211RW is not set
1537:# CONFIG_MWIFIEX is not set
1538-# CONFIG_CW1200 is not set
1539-
1540-#
1541-# Enable WiMAX (Networking options) to see the WiMAX drivers
--
1782-#
1783-# CONFIG_SYNCLINK_CS is not set
1784-# CONFIG_CARDMAN_4000 is not set
1785-# CONFIG_CARDMAN_4040 is not set
1786:# CONFIG_IPWIRELESS is not set
1787-# CONFIG_MWAVE is not set
1788-# CONFIG_RAW_DRIVER is not set
1789-CONFIG_HPET=y
1790-# CONFIG_HPET_MMAP is not set
--
2826-# CONFIG_FUJITSU_LAPTOP is not set
2827-# CONFIG_FUJITSU_TABLET is not set
2828-# CONFIG_AMILO_RFKILL is not set
2829-# CONFIG_HP_ACCEL is not set
2830:# CONFIG_HP_WIRELESS is not set
2831-# CONFIG_MSI_LAPTOP is not set
2832-# CONFIG_PANASONIC_LAPTOP is not set
2833-# CONFIG_COMPAL_LAPTOP is not set
2834-# CONFIG_SONY_LAPTOP is not set

--------------040809090301070101070307--
