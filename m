Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55552 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab3CXArq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:47:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 00/15] brcmsmac: add AP mode
Date: Sun, 24 Mar 2013 01:45:48 +0100
Message-Id: <1364085963-25940-1-git-send-email-hauke@hauke-m.de> (sfid-20130324_014759_616419_82F7E4F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains some cleanup patches for brcmsmac and then 
adds beacon and probe response template upload.
With these features AP and Ad hoc mode support is added in the last patch.
Probe response sending by ucode is deactivated for now.

Currently AP and Ad hoc mode do not work in the 5GHz band. I do not 
know what is wrong there, I have tested this with the firmware from 
linux-firmware and with one extracted from a proprietary Broadcom 
driver.

Power saving stations could cause some problems as Johannes said, to 
make this properly work some more functions have to be implemented, but 
I would like to do this later.

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
I got some positive responses for other people testing this on their
Access Points with OpenWrt and no problem report.

The structure of brcmsmac is pretty complicated, because it copies many 
addresses into its own structs and does not use mac80211 structs in 
main.c.

This is based on the current version of wireless-testing/master.

Changes since RFC:
 * add ad hoc mode support
 * deactivate ucode probe response sending by ucode

Hauke Mehrtens (15):
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
  brcmsmac: deactivate ucode sending probe responses
  brcmsmac: activate AP support
  brcmsmac: add support for adhoc mode

 drivers/net/wireless/brcm80211/brcmsmac/d11.h      |    1 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   85 ++++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  362 +++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   25 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   17 +-
 5 files changed, 376 insertions(+), 114 deletions(-)

-- 
1.7.10.4

