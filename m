Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53930 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413Ab3BXBGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:06:42 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 00/13] brcmsmac: add AP mode
Date: Sun, 24 Feb 2013 02:05:58 +0100
Message-Id: <1361667972-22909-1-git-send-email-hauke@hauke-m.de> (sfid-20130224_020656_642276_577C7758)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains some cleanup patches for brcmsmac and then 
adds beacon and probe response template upload.
With these features AP mode support is added in the last patch.

When running AP mode in 5GHz band on my BCM43224 I get the following 
errors, and I do not see the network with my Intel IWL6300, the 
regulation restrictions in channel.c where changed before:

[  829.608000] brcmsmac bcma1:0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  829.616000] brcmsmac bcma1:0: wl0: psmdebug 0x00ff808d, phydebug 0x0000000d, psm_brc 0x0000
[  829.624000] brcmsmac bcma1:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  829.864000] brcmsmac bcma1:0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  829.876000] brcmsmac bcma1:0: wl0: psmdebug 0x00ff80d8, phydebug 0x0000000d, psm_brc 0x0000
[  829.884000] brcmsmac bcma1:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  830.108000] brcmsmac bcma1:0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  830.120000] brcmsmac bcma1:0: wl0: psmdebug 0x00ff8ae6, phydebug 0x0000000d, psm_brc 0x0000
[  830.128000] brcmsmac bcma1:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[  830.240000] brcmsmac bcma1:0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  830.252000] brcmsmac bcma1:0: wl0: psmdebug 0x00ff800d, phydebug 0x0000000d, psm_brc 0x0000
[  830.292000] brcmsmac bcma1:0: brcms_ops_bss_info_changed: qos enabled: true (implement)


In the 2.4GHz band I get the following phy errors, but the station 
still stays connected:

[  152.196000] brcmsmac bcma0:0: phyerr 0x1, rate 0x37
[  152.200000] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  152.208000] brcmsmac bcma0:0: phyerr 0x1, rate 0x37
[  152.216000] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  152.228000] brcmsmac bcma0:0: phyerr 0x1, rate 0x37
[  152.232000] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x1)
[  346.644000] brcmsmac bcma0:0: phyerr 0x10, rate 0x6e
[  346.652000] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x10)
[  349.504000] brcmsmac bcma0:0: phyerr 0x8, rate 0x14
[  349.508000] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x8)
[  493.524000] brcmsmac bcma0:0: phyerr 0x8, rate 0x37
[  493.528000] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: ampdu tx phy error (0x8)

This was successfully tested on a BCM4716 in 2.4GHz mode, my BCM43224 
does not work in 2.4GHz mode, because the sprom is only configured for 
5GHz.

The probe responses are currently send by the ucode based on the 
template and by mac80211. I was searching for a switch so disable probe 
request forwarding from the ucode to the driver.

The structure of brcmsmac is pretty complicated, because it copies many 
addresses into its own structs and does not use mac80211 structs in 
main.c.

This is based on the current version of wireless-testing/master.


Hauke Mehrtens (13):
  brcmsmac: implement ieee80211_ops get_tsf and set_tsf
  brcmsmac: add interface type to brcms_bss_cfg
  brcmsmac: remove brcms_bss_cfg->BSS
  brcmsmac: remove brcms_bss_cfg->associated
  brcmsmac: remove brcms_bss_cfg->enable
  brcmsmac: remove brcms_bss_cfg->up
  brcmsmac: remove brcms_bss_cfg->cur_etheraddr
  brcmsmac: remove brcms_pub->bcmerr
  brcmsmac: write beacon period to hardware
  brcmsmac: add beacon template support
  brcmsmac: react on changing SSID
  brcmsmac: add support for probe response template
  brcmsmac: activate AP support

 drivers/net/wireless/brcm80211/brcmsmac/d11.h      |    1 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   66 +++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  340 ++++++++++++++------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   25 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   15 +-
 5 files changed, 334 insertions(+), 113 deletions(-)

-- 
1.7.10.4

