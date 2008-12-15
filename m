Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:58772 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbYLOUlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 15:41:16 -0500
To: linux-wireless@vger.kernel.org
Subject: ath5k + AP mode?
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 15 Dec 2008 21:41:14 +0100
Message-ID: <m3skopuq6t.fsf@maximus.localdomain> (sfid-20081215_214135_416745_A827D1E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is AP mode with ath5k supposed to work?

My hw:
- IPX425 CPU (ARM architecture - in big- or little-endian mode)
- Wistron NeWeb Corp. CM9 a/b/g MiniPCI (AR5001X+, PCI IDs 168c:0013 +
  sub 185f:1012).
- hostapd from git (f4f2774a96d91753811e921380856bc859888153)
- linux from git (basically wireless-testing = master-2008-12-12)

Added:
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -505,6 +505,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 
        hw->wiphy->interface_modes =
                BIT(NL80211_IFTYPE_STATION) |
+               BIT(NL80211_IFTYPE_AP) |
                BIT(NL80211_IFTYPE_ADHOC) |
                BIT(NL80211_IFTYPE_MESH_POINT);

Now:

# ifconfig wlan0 up
# iwlist wlan0 scan
wlan0     Scan completed :
          Cell XX (shows many cells)

# ifconfig wlan0 down (is it needed?)
# hostapd -dd /etc/hostapd.conf 
Configuration file: /etc/hostapd.conf
ctrl_interface_group=0
Failed to set interface wlan0 to master mode.
nl80211 driver initialization failed.
wlan0: Unable to setup interface.
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=5 eloop_data=0x57bd8 user_data=(nil) handler=0x32b10

Relevant .config:
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG=y

CONFIG_WLAN_80211=y
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y

Related dmesg:
PCI: enabling device 0000:00:0d.0 (0140 -> 0142)
ath5k 0000:00:0d.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF5112B multiband radio found (0x36)
-- 
Krzysztof Halasa
