Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:58548 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaLUK1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 05:27:17 -0500
Message-ID: <5496A083.5060400@msgid.tls.msk.ru> (sfid-20141221_112758_288663_D6EC7A83)
Date: Sun, 21 Dec 2014 13:27:15 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <53FDACD1.8090805@msgid.tls.msk.ru> <54363ED0.605@broadcom.com> <CACna6rw3XgdJz0uKkAuas8RTzozTdFp2mgF5g1uo7LHJVSMt4g@mail.gmail.com> <3543341.FmUQFH9nrl@eisbaer> <546C5D1F.108@msgid.tls.msk.ru> <546CD94D.9060509@broadcom.com> <546CF66A.3000207@msgid.tls.msk.ru> <546D04EE.1030200@msgid.tls.msk.ru> <5471AC29.6040009@broadcom.com> <5475A2DC.80502@msgid.tls.msk.ru> <547B07CF.90501@broadcom.com> <547E31BD.8090302@msgid.tls.msk.ru> <547F0575.7010104@broadcom.com> <549062FE.2000808@broadcom.com> <549699D9.2060106@msgid.tls.msk.ru> <54969D18.3060000@broadcom.com>
In-Reply-To: <54969D18.3060000@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Trimming Cc list a bit]

21.12.2014 13:12, Arend van Spriel wrote:
> On 12/21/14 10:58, Michael Tokarev wrote:
>> 16.12.2014 19:51, Arend van Spriel wrote:
>>
>>> Hmm. The function brcms_btc_ecicoex_enab() is calling itself. Please remove that call as it causes endless recursion and eventually reboot.
>>
>> Ok, that was easy.  Now it loads, but wifi link still
>> does not work, stalling as before.  What we're looking
>> at now?
> 
> The patch is just to provide me with extra bt-coex related information in the kernel log. So if you can provide that to me I have to info needed to look in the proprietary code base to determine what is missing.

I don't really see any additional info, but it might be just me.

Here's the dmesg contents of loading brcmsmac module with debug=1,
adding an IP address to the wlan0 interface and running a simple
download (which stalls after about 4..6Kb transferred):

[73321.062190] cfg80211: Calling CRDA to update world regulatory domain
[73326.973828] bcma: bus0: Found chip with id 0x4313, rev 0x01 and package 0x08
[73326.979264] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
[73326.984760] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
[73326.990242] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
[73326.995741] bcma: bus0: Found rev 8 PMU (capabilities 0x084C3008)
[73326.995754] bcma: bus0: SPROM offset 0x830
[73326.997645] bcma: bus0: Found SPROM revision 8
[73327.008110] bcma: bus0: GPIO driver not activated
[73327.008117] bcma: bus0: Bus registered
[73327.016533] Support for cores revisions 0x17 and 0x18 disabled by module param allhwsupport=0. Try b43.allhwsupport=1
[73327.021981] b43: probe of bcma0:1 failed with error -524
[73327.027507] Broadcom 43xx driver loaded [ Features: PNL ]
[73327.028594] brcmsmac bcma0:1: mfg 4bf core 812 rev 24 class 0 irq 19
[73327.028620] ieee80211 phy4: brcms_c_protection_upd: idx 2, val -1
[73327.028623] ieee80211 phy4: brcms_c_protection_upd: idx 1, val 0
[73327.028626] ieee80211 phy4: brcms_c_protection_upd: idx 12, val -1
[73327.028629] ieee80211 phy4: brcms_c_protection_upd: idx 11, val 0
[73327.028632] ieee80211 phy4: brcms_c_protection_upd: idx 14, val -1
[73327.028635] ieee80211 phy4: brcms_c_protection_upd: idx 13, val 0
[73327.028638] ieee80211 phy4: brcms_c_protection_upd: idx 15, val -1
[73327.028641] ieee80211 phy4: brcms_c_protection_upd: idx 4, val 2
[73327.028647] brcmsmac bcma0:1: brcms_b_attach wl0: vendor 0x14e4 device 0x4727
[73327.028660] brcmsmac bcma0:1: brcms_b_corereset wl0: core reset
[73327.028667] bcma: bus0: Switched to core: 0x812
[73327.029223] brcmsmac bcma0:1: brcms_b_phy_reset wl0: reset phy
[73327.029227] brcmsmac bcma0:1: brcms_b_core_phypll_ctl wl0
[73327.029259] brcmsmac bcma0:1: brcms_b_corereset wl0: core reset
[73327.029364] brcmsmac bcma0:1: brcms_b_phy_reset wl0: reset phy
[73327.029367] brcmsmac bcma0:1: brcms_b_core_phypll_ctl wl0
[73327.029410] brcmsmac bcma0:1: brcms_b_attach wl0: phy 8/1 radio 2064/1
[73327.029460] brcmsmac bcma0:1: hardware: SECI
[73327.029464] brcmsmac bcma0:1: brcms_c_coredisable wl0: disable core
[73327.029490] brcmsmac bcma0:1: brcms_b_core_phypll_ctl wl0
[73327.029529] ieee80211 phy4: brcms_c_protection_upd: idx 15, val 0
[73327.029534] ieee80211 phy4: brcms_c_protection_upd: idx 3, val 1
[73327.029537] ieee80211 phy4: brcms_c_protection_upd: idx 10, val 1
[73327.029549] ieee80211 phy4: brcms_c_protection_upd: idx 3, val 1
[73327.029820] ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
[73327.121616] brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: false (implement)
[73327.121626] brcmsmac bcma0:1: brcms_ops_config: change power-save mode: false (implement)
[73327.122195] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[73328.179594] wlan0: authenticate with 64:70:02:29:d9:30
[73328.183927] wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[73328.187684] wlan0: send auth to 64:70:02:29:d9:30 (try 1/3)
[73328.193289] wlan0: authenticated
[73328.198793] wlan0: associate with 64:70:02:29:d9:30 (try 1/3)
[73328.207394] wlan0: RX AssocResp from 64:70:02:29:d9:30 (capab=0x411 status=0 aid=2)
[73328.211734] brcmsmac bcma0:1: brcmsmac: brcms_ops_bss_info_changed: associated
[73328.215616] brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
[73328.219433] wlan0: associated
[73328.223264] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[73328.282197] ieee80211 phy4: brcms_c_protection_upd: idx 11, val 0
[73328.285855] ieee80211 phy4: brcms_c_protection_upd: idx 13, val 4
[73328.289431] ieee80211 phy4: brcms_c_protection_upd: idx 16, val 0
[73332.121259] net_ratelimit: 36 callbacks suppressed
[73332.125201] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73333.125295] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73334.129073] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73335.133022] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73336.137011] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73337.141095] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73338.145078] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73339.148965] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73340.152950] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73341.156936] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73342.161074] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73343.165180] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73344.168951] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73345.172948] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73346.176862] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73347.181006] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73348.185025] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73349.188991] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73350.193073] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73351.196894] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73352.200874] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73353.204712] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73354.208701] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73355.212685] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73356.216671] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73357.220657] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73358.224644] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73359.228630] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73360.232616] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73361.236665] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73362.240808] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73363.244823] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73364.248710] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73365.252750] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73366.256533] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73367.260517] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73368.264505] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73369.268541] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73370.272476] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73371.276467] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73372.280717] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73373.284704] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73374.288692] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73375.292669] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73376.296626] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73377.300630] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73378.304613] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73379.308647] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73380.312571] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73381.316529] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73382.320534] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73383.324516] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73384.328514] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73385.332477] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73386.336434] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73387.340438] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73388.344397] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73389.348401] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73390.352382] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73391.356417] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73392.360340] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73393.364394] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73394.368307] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73395.372293] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73396.376270] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73397.380238] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73398.384330] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73399.388338] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73400.392406] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73401.396274] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73402.400268] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73403.404281] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73404.408146] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73405.412177] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73406.416229] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73407.420182] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73408.424230] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73409.428026] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73410.432095] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73411.436110] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73412.439986] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73413.219752] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[73413.444021] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73414.448001] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73415.451912] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73416.455863] brcmsmac bcma0:1: brcms_c_watchdog wl0
[73417.460056] brcmsmac bcma0:1: brcms_c_watchdog wl0


I also noticed the following:

o Watchdog calls itself wl0 while interface name is wlan0.
  Might be a good idea to change it.

o what does "capabilities/regulatory prevented using AP HT/VHT configuration, downgraded"
  mean?

Thanks,

/mjt
