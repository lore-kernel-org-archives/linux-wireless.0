Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44149 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030224Ab2EQWcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 18:32:10 -0400
Message-ID: <4FB57C61.3090302@hauke-m.de> (sfid-20120518_003216_241431_236F528A)
Date: Fri, 18 May 2012 00:32:01 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: brcmsmac and BCM47186 (BCM5357) + brcmfmac and BCM43236 V2
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I got a new device, a Linksys E3200 with a BCM47186 (id: 0x5357) and a
BCM43236 v2 for 5GHz wifi.

The BCM47186 has a wifi core rev 28, a N-PHY rev 9 and a 2057 radio rev
5 and it does not work with brcmsmac or b43. :-(

Are there plans to add support for such new N-PHY revs to brcmsmac and
the firmware?

Here are some parts of my log with brcmsamc with firmware from
linux-firmware.

bcma: Found chip with id 0x5357, rev 0x02 and package 0x0A
....
bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x1C, class 0x0)
....
[   14.776000] b43-phy0: Broadcom 5357 WLAN found (core revision 28)
[   14.780000] b43-phy0 debug: Found PHY: Analog 9, Type 4, Revision 9
[   14.780000] b43-phy0 ERROR: FOUND UNSUPPORTED RADIO (Manuf 0x17F,
Version 0x2057, Revision 5)
[   14.792000] b43: probe of bcma0:5 failed with error -122
[   14.796000] Broadcom 43xx driver loaded [ Features: PNL ]
[   14.824000] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
...
[   15.048000] brcmsmac bcma0:5: mfg 4bf core 812 rev 28 class 0 irq 3
[   15.144000] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
...
[   16.212000] brcmf_usb_fw_download: unsupported chip 43236 rev 2
[   16.212000] brcmf_usb_attach: failed!
[   16.212000] brcmf_usb_probe: failed with errno -19
...
[   32.508000] ieee80211 phy1: wl0: wlc_coreinit: ucode did not
self-suspend!
[   32.516000] ieee80211 phy1: wlc_coreinit: txfifo mismatch: ucode size
127 driver size 29535 index 5
[   32.636000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[   32.644000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000000, psm_brc 0x0000
... (~6 times the same two messages)
[   33.372000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[   33.380000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000000, psm_brc 0x0000
[   33.388000] ieee80211 phy1: brcms_ops_bss_info_changed: qos enabled:
false (implement)
[   33.396000] ieee80211 phy1: brcms_ops_config: change monitor mode: false
[   33.396000] ieee80211 phy1: brcms_ops_config: change power-save mode:
false (implement)
[   33.492000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[   33.500000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000000, psm_brc 0x0000
... (~10 times the same two messages)
[   43.144000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[   43.152000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000001, psm_brc 0x0000
[   51.096000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   51.236000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[   51.244000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000001, psm_brc 0x0000
... (~10 times the same two messages)
[   53.652000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[   53.660000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000000, psm_brc 0x0000
[   53.796000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   53.956000] ------------[ cut here ]------------
[   53.960000] WARNING: at
/home/hauke/kamikaze/git/build_dir/linux-brcm47xx/compat-wireless-2012-04-17/drivers/net/wireless/brcm80211/brcmsmac/main.c:7975
brcms_c_wait_for_
tx_completion+0xc4/0xe0 [brcmsmac]()
[   53.976000] Modules linked in: usb_storage brcmfmac(O) uhci_hcd
ohci_hcd nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp
ipt_MASQUERADE iptable_nat nf_nat xt_conn
track xt_CT xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack ehci_hcd sd_mod pppoe pppox ipt_REJECT
xt_TCPMSS ipt_LOG xt_comment xt_multiport xt
_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables
msdos brcmsmac(O) ppp_async ppp_generic slhc vfat fat ext4 jbd2 mbcache
brcmutil(O) b43legacy(O) b43
(O) nls_utf8 nls_koi8_r nls_iso8859_2 nls_iso8859_15 nls_iso8859_13
nls_iso8859_1 nls_cp866 nls_cp852 nls_cp850 nls_cp775 nls_cp437
nls_cp1251 nls_cp1250 mac80211(O) usbcore
 usb_common switch_core(O) scsi_mod nls_base crc8 crc16 crc_ccitt cordic
cfg80211(O) compat(O) ssb_hcd bcma_hcd arc4 aes_generic crypto_algapi
tg3 diag(O) [last unloaded: switch_core]
[   54.056000] Call Trace:
[   54.060000] [<8024ea44>] dump_stack+0x8/0x34
[   54.064000] [<80017f80>] warn_slowpath_common+0x78/0xa4
[   54.068000] [<80017fc4>] warn_slowpath_null+0x18/0x24
[   54.072000] [<82e8dd1c>] brcms_c_wait_for_tx_completion+0xc4/0xe0
[brcmsmac]
[   54.080000] [<82e80194>] 0x82e80194
[   54.084000]
[   54.084000] ---[ end trace 374ee2ec89e7f317 ]---
[   63.292000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[   63.300000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000001, psm_brc 0x0000
... (~10 times the same two messages)
[  193.292000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.
[  193.300000] ieee80211 phy1: wl0: psmdebug 0x00ff8cd4, phydebug
0x00000001, psm_brc 0x0000
[  203.292000] ieee80211 phy1: wl0: wlc_suspend_mac_and_wait: waited
83000 uS and MI_MACSSPNDD is still not on.


When using the firmware from b43 (666.2, extracted from wl 5.100.138) I
get the following messages, but iw wlan0 scan does not find any networks
either.

[   30.088000] ieee80211 phy1: wlc_coreinit: txfifo mismatch: ucode size
127 driver size 29535 index 5
[   30.164000] ieee80211 phy1: brcms_ops_bss_info_changed: qos enabled:
false (implement)
[   30.172000] ieee80211 phy1: brcms_ops_config: change monitor mode: false
[   30.172000] ieee80211 phy1: brcms_ops_config: change power-save mode:
false (implement)
[   43.976000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   44.844000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   48.088000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   48.956000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   53.448000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   54.316000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   76.816000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC
[   77.684000] ieee80211 phy1: FIF_BCN_PRBRESP_PROMISC

Did you talk to the firmware guys, is there a limitation to core rev 23
devices in the N-PHY firmware other than in the firmware used by wl?

There is also a BCM43236 V2 (usb chip) on the board. I tried brcmfmac
and the firmware from linux-firmware, but it did not work. This is a rev
2 device and brcmfmac just seams to support rev 3. Are there any plans
to add support for rev 2 or is this an other problem and a rev 2 device
should also work with brcmfmac?

Hauke
