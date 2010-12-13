Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2769 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758661Ab0LMSVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 13:21:32 -0500
From: "Brett Rudley" <brudley@broadcom.com>
To: "Sean Paul" <seanpaul@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 13 Dec 2010 10:21:07 -0800
Subject: RE: brcm80211 locking up
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE13856A173D@SJEXCHCCR01.corp.ad.broadcom.com>
References: <AANLkTimqTaTJYinS-AyyjwR2hD+zLYuzjC6W0jDXMyB9@mail.gmail.com>
In-Reply-To: <AANLkTimqTaTJYinS-AyyjwR2hD+zLYuzjC6W0jDXMyB9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the RF disable switch on your laptop (also known as airline switch, wireless disable switch, etc).
It probably got bumped to the 'disabled' position.

Brett

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Sean Paul
> Sent: Monday, December 13, 2010 10:02 AM
> To: linux-wireless@vger.kernel.org
> Subject: brcm80211 locking up
>
> Hello,
> I've recently started encountering issues with the brcm80211 driver
> and my 4313 wireless chipset (with kernel 2.6.35). It was working for
> me a couple of weeks ago, but is now locking up my machine on boot.
>
> I'm using the following kernel config values:
> CONFIG_BRCM80211=m
> CONFIG_BRCM80211_PCI=y
> # CONFIG_BRCMFMAC is not set
>
> I've tracked the issue down to the following line (in
> brcm80211/sys/wlc_bmac.c, function wlc_bmac_radio_read_hwdisabled):
> v = ((R_REG(wlc_hw->osh, &wlc_hw->regs->phydebug) & PDBG_RFD) != 0);
>
> If v equates to true here the driver seems to get stuck in a loop and
> brings everything down with it. If I hardcode v to false, the driver
> works, I can connect to my wireless network and browse the Internet.
>
> I've pasted the dmesg output in this email below, I've added breaks to
> show where the driver goes off the rails. The "ops->tx called while
> down" message followed by the "tx refused but queue active" warning
> repeats until the device becomes unresponsive.
>
> Is this a known issue?
>
> Thanks,
>
> Sean
>
> dmesg output (slightly augmented with my own debug messages):
>
> # modprobe brcm80211
> 2010-12-10T11:44:46.590263-08:00 localhost kernel: [  389.590062]
> brcm80211: module is from the staging directory, the quality is
> unknown, you have been warned.
> 2010-12-10T11:44:46.606997-08:00 localhost kernel: [  389.606782]
> wl_pci_probe: bus 7 slot 0 func 0 irq 11
> 2010-12-10T11:44:46.607045-08:00 localhost kernel: [  389.606828]
> brcm80211 0000:07:00.0: enabling device (0104 -> 0106)
> 2010-12-10T11:44:46.607068-08:00 localhost kernel: [  389.606850]
> brcm80211 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> 2010-12-10T11:44:46.607090-08:00 localhost kernel: [  389.606871]
> brcm80211 0000:07:00.0: setting latency timer to 64
> 2010-12-10T11:44:46.607108-08:00 localhost kernel: [  389.606907] PCI/DMA
> 2010-12-10T11:44:47.016728-08:00 localhost kernel: [  390.015542]
> wlc_protection_upd: idx 2, val -1
> 2010-12-10T11:44:47.016796-08:00 localhost kernel: [  390.015551]
> wlc_protection_upd: idx 1, val 0
> 2010-12-10T11:44:47.016852-08:00 localhost kernel: [  390.015558]
> wlc_protection_upd: idx 12, val -1
> 2010-12-10T11:44:47.016994-08:00 localhost kernel: [  390.015563]
> wlc_protection_upd: idx 11, val 0
> 2010-12-10T11:44:47.017049-08:00 localhost kernel: [  390.015568]
> wlc_protection_upd: idx 14, val -1
> 2010-12-10T11:44:47.017103-08:00 localhost kernel: [  390.015573]
> wlc_protection_upd: idx 13, val 0
> 2010-12-10T11:44:47.017156-08:00 localhost kernel: [  390.015578]
> wlc_protection_upd: idx 15, val -1
> 2010-12-10T11:44:47.017181-08:00 localhost kernel: [  390.015584]
> wlc_protection_upd: idx 4, val 2
> 2010-12-10T11:44:47.017228-08:00 localhost kernel: [  390.015594] wl0:
> wlc_bmac_attach: vendor 0x14e4 device 0x4727
> 2010-12-10T11:44:47.017282-08:00 localhost kernel: [  390.015673]
> Found chip type AI (0x13814313)
> 2010-12-10T11:44:47.022196-08:00 localhost kernel: [  390.021343]
> Changing max_res_mask to 0xffff
> 2010-12-10T11:44:47.022237-08:00 localhost kernel: [  390.021350]
> Changing min_res_mask to 0x200d
> 2010-12-10T11:44:47.028223-08:00 localhost kernel: [  390.027513]
> Applying 4313 WARs
> 2010-12-10T11:44:47.028263-08:00 localhost kernel: [  390.027591] wl0:
> wlc_bmac_corereset
> 2010-12-10T11:44:47.028281-08:00 localhost kernel: [  390.028142] wl0:
> wlc_bmac_phy_reset
> 2010-12-10T11:44:47.028297-08:00 localhost kernel: [  390.028146] wl0:
> wlc_bmac_core_phypll_ctl
> 2010-12-10T11:44:47.028316-08:00 localhost kernel: [  390.028165] wl0:
> validate_chip_access
> 2010-12-10T11:44:47.028342-08:00 localhost kernel: [  390.028240] wl0:
> wlc_setxband: bandunit 0
> 2010-12-10T11:44:47.028371-08:00 localhost kernel: [  390.028295] wl0:
> wlc_bmac_corereset
> 2010-12-10T11:44:47.028421-08:00 localhost kernel: [  390.028427] wl0:
> wlc_bmac_phy_reset
> 2010-12-10T11:44:47.028446-08:00 localhost kernel: [  390.028435] wl0:
> wlc_bmac_core_phypll_ctl
> 2010-12-10T11:44:47.029280-08:00 localhost kernel: [  390.028867] wl0:
> wlc_coredisable
> 2010-12-10T11:44:47.029303-08:00 localhost kernel: [  390.028941] wl0:
> wlc_bmac_core_phypll_ctl
> 2010-12-10T11:44:47.029322-08:00 localhost kernel: [  390.029013] wl0:
> wlc_bmac_xtal: want 0
> 2010-12-10T11:44:47.029342-08:00 localhost kernel: [  390.029033]
> wlc_bmac_attach:: deviceid 0x4727 nbands 1 board 0x510 macaddr:
> 00:26:82:b6:f8:81
> 2010-12-10T11:44:47.029363-08:00 localhost kernel: [  390.029041]
> wlc_protection_upd: idx 15, val 115
> 2010-12-10T11:44:47.029382-08:00 localhost kernel: [  390.029048]
> wlc_bmac_copyfrom_vars, nvram vars totlen=2299
> 2010-12-10T11:44:47.029404-08:00 localhost kernel: [  390.029093] wl0:
> wlc_stf_spatial_policy_set: val 0
> 2010-12-10T11:44:47.029429-08:00 localhost kernel: [  390.029099] wl0:
> wlc_stf_txcore_set: Nsts 1 core_mask 1
> 2010-12-10T11:44:47.029451-08:00 localhost kernel: [  390.029105] wl0:
> wlc_stf_txcore_set: Nsts 2 core_mask 3
> 2010-12-10T11:44:47.029470-08:00 localhost kernel: [  390.029111] wl0:
> wlc_stf_txcore_set: Nsts 3 core_mask 7
> 2010-12-10T11:44:47.029491-08:00 localhost kernel: [  390.029118] wl0:
> wlc_stf_txcore_set: Nsts 4 core_mask f
> 2010-12-10T11:44:47.029509-08:00 localhost kernel: [  390.029127]
> wlc_protection_upd: idx 3, val 1
> 2010-12-10T11:44:47.029528-08:00 localhost kernel: [  390.029132]
> wlc_protection_upd: idx 10, val 1
> 2010-12-10T11:44:47.029549-08:00 localhost kernel: [  390.029157] wl0:
> wlc_channel_mgr_attach
> 2010-12-10T11:44:47.029567-08:00 localhost kernel: [  390.029173]
> wlc_protection_upd: idx 3, val 1
> 2010-12-10T11:44:47.030110-08:00 localhost kernel: [  390.029788] wl0:
> wlc_doiovar
> 2010-12-10T11:44:47.030133-08:00 localhost kernel: [  390.029799] wl0:
> wlc_doiovar: id 1
> 2010-12-10T11:44:47.044182-08:00 localhost flimflamd[1046]: wlan0
> {create} index 6 type 1 <ETHER>
> 2010-12-10T11:44:47.044212-08:00 localhost kernel: [  390.041847]
> phy0: Selected rate control algorithm 'minstrel'
> 2010-12-10T11:44:47.045776-08:00 localhost kernel: [  390.044371]
> wl_set_hint: Sending country code US to MAC80211
> 2010-12-10T11:44:47.045812-08:00 localhost kernel: [  390.044394] wl0:
> Broadcom BCM43xx 802.11 MAC80211 Driver 5.75.11 (1.82.8.0) (Compiled
> in . at 14:11:26 on Dec 10 2010)
> 2010-12-10T11:44:47.045835-08:00 localhost kernel: [  390.044418]
> cfg80211: Calling CRDA for country: US
> 2010-12-10T11:44:47.069896-08:00 localhost udevd[974]: unknown key
> 'HOTPLUG' in /etc/udev/rules.d/99-monitor-hotplug.rules:2
> 2010-12-10T11:44:47.077280-08:00 localhost kernel: [  390.076803] wl0:
> wlc_up:
> 2010-12-10T11:44:47.077327-08:00 localhost kernel: [  390.076824] wl0:
> wlc_up: radio is up
> 2010-12-10T11:44:47.077349-08:00 localhost kernel: [  390.076830] wl0:
> wlc_up: hw not up
> 2010-12-10T11:44:47.077364-08:00 localhost kernel: [  390.076836] wl0:
> wlc_bmac_hw_up:
> 2010-12-10T11:44:47.077379-08:00 localhost kernel: [  390.076842] wl0:
> wlc_bmac_xtal: want 1
> 2010-12-10T11:44:47.077394-08:00 localhost kernel: [  390.076928] wl0:
> wlc_up: radio_disabled=0
> 2010-12-10T11:44:47.077415-08:00 localhost kernel: [  390.076935] wl0:
> wlc_bmac_up_prep:
> 2010-12-10T11:44:47.077431-08:00 localhost kernel: [  390.076940] wl0:
> wlc_bmac_xtal: want 1
> 2010-12-10T11:44:47.077447-08:00 localhost kernel: [  390.076947] wl0:
> wlc_bmac_up_prep: Bus type is PCI
> 2010-12-10T11:44:47.077465-08:00 localhost kernel: [  390.076959]
> wlc_bmac_radio_read_hwdisabled: enter
> 2010-12-10T11:44:47.077480-08:00 localhost kernel: [  390.076965]
> wlc_bmac_radio_read_hwdisabled: !clk
> 2010-12-10T11:44:47.077495-08:00 localhost kernel: [  390.076999]
> wlc_bmac_radio_read_hwdisabled: v=true
> 2010-12-10T11:44:47.077511-08:00 localhost kernel: [  390.077004]
> wlc_bmac_radio_read_hwdisabled: !clk, disable core
> 2010-12-10T11:44:47.077526-08:00 localhost kernel: [  390.077062] wl0:
> wlc_bmac_xtal: want 0
> 2010-12-10T11:44:47.077541-08:00 localhost kernel: [  390.077069] wl0:
> wlc_up: radio off
> 2010-12-10T11:44:47.077560-08:00 localhost kernel: [  390.077075] wl0:
> wlc_up: radio_disabled(2)=2
> 2010-12-10T11:44:47.077576-08:00 localhost kernel: [  390.077086] wl0:
> wlc_up: exiting early :(
>
>
> At this point, wlc_up exits early, which causes the "wl0:
> wlc_wme_setparams : no-clock" errors below.
>
>
> 2010-12-10T11:44:47.082288-08:00 localhost kernel: [  390.081513] wl0:
> wlc_doiovar
> 2010-12-10T11:44:47.082357-08:00 localhost kernel: [  390.081523] wl0:
> wlc_doiovar: id 3
> 2010-12-10T11:44:47.082375-08:00 localhost kernel: [  390.081528] wl0:
> wlc_doiovar
> 2010-12-10T11:44:47.082396-08:00 localhost kernel: [  390.081552] wl0:
> wlc_doiovar: id 3
> 2010-12-10T11:44:47.082415-08:00 localhost kernel: [  390.081557] wl0:
> wlc_doiovar
> 2010-12-10T11:44:47.082431-08:00 localhost kernel: [  390.081562] wl0:
> wlc_doiovar: id 2
> 2010-12-10T11:44:47.082449-08:00 localhost kernel: [  390.081568] wl0:
> wlc_doiovar
> 2010-12-10T11:44:47.082465-08:00 localhost kernel: [  390.081573] wl0:
> wlc_doiovar: id 2
> 2010-12-10T11:44:47.082481-08:00 localhost kernel: [  390.081615] wl0:
> wlc_wme_setparams : no-clock
> 2010-12-10T11:44:47.082501-08:00 localhost kernel: [  390.081621] wl0:
> wlc_wme_setparams : no-clock
> 2010-12-10T11:44:47.082521-08:00 localhost kernel: [  390.081627] wl0:
> wlc_wme_setparams : no-clock
> 2010-12-10T11:44:47.082536-08:00 localhost kernel: [  390.081633] wl0:
> wlc_wme_setparams : no-clock
> 2010-12-10T11:44:47.082561-08:00 localhost kernel: [  390.082204]
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 2010-12-10T11:44:47.097526-08:00 localhost udevd[974]: unknown key
> 'HOTPLUG' in /etc/udev/rules.d/99-monitor-hotplug.rules:2
> 2010-12-10T11:44:47.268948-08:00 localhost kernel: [  390.268195]
> ops->tx called while down
> 2010-12-10T11:44:47.269008-08:00 localhost kernel: [  390.268207]
> ops->tx called while down
> 2010-12-10T11:44:47.269035-08:00 localhost kernel: [  390.268214]
> ops->tx called while down
> 2010-12-10T11:44:47.269063-08:00 localhost kernel: [  390.268220]
> ops->tx called while down
> 2010-12-10T11:44:47.269090-08:00 localhost kernel: [  390.268226]
> ops->tx called while down
> 2010-12-10T11:44:47.269117-08:00 localhost kernel: [  390.268232]
> ops->tx called while down
> 2010-12-10T11:44:47.269143-08:00 localhost kernel: [  390.268238]
> ops->tx called while down
> 2010-12-10T11:44:47.269171-08:00 localhost kernel: [  390.268244]
> ops->tx called while down
> 2010-12-10T11:44:47.269197-08:00 localhost kernel: [  390.268290]
> ops->tx called while down
> 2010-12-10T11:44:47.269225-08:00 localhost kernel: [  390.268298]
> ops->tx called while down
> 2010-12-10T11:44:47.269256-08:00 localhost kernel: [  390.268306]
> ops->tx called while down
> 2010-12-10T11:44:47.269285-08:00 localhost kernel: [  390.268314]
> ------------[ cut here ]------------
> 2010-12-10T11:44:47.269318-08:00 localhost kernel: [  390.268353]
> WARNING: at net/mac80211/tx.c:1438 ieee80211_pspoll_get+0x1405/0x1569
> [mac80211]()
> 2010-12-10T11:44:47.269348-08:00 localhost kernel: [  390.268365]
> Hardware name: 20040M18
> 2010-12-10T11:44:47.269377-08:00 localhost kernel: [  390.268373] tx
> refused but queue active
> 2010-12-10T11:44:47.269427-08:00 localhost kernel: [  390.268381]
> Modules linked in: brcm80211(C) uvcvideo videodev hid_cando tsl2563(C)
> industrialio(C) snd_hda_codec_conexant snd_hda_intel mac80211 rtc_cmos
> snd_hda_codec serio_raw snd_hwdep tpm_tis tpm snd_pcm cfg80211
> tpm_bios pcspkr xt_mark tg3 wmi i2c_i801 snd_timer nm10_gpio
> snd_page_alloc i2c_dev [last unloaded: tpm_bios]
> 2010-12-10T11:44:47.269465-08:00 localhost kernel: [  390.268485] Pid:
> 4123, comm: phy0 Tainted: G        WC  2.6.35 #1
> 2010-12-10T11:44:47.269495-08:00 localhost kernel: [  390.268494] Call
> Trace:
> 2010-12-10T11:44:47.269532-08:00 localhost kernel: [  390.268517]
> [<7902d7da>] warn_slowpath_common+0x6a/0x7f
> 2010-12-10T11:44:47.269568-08:00 localhost kernel: [  390.268547]
> [<b86b38c1>] ? ieee80211_pspoll_get+0x1405/0x1569 [mac80211]
> 2010-12-10T11:44:47.269601-08:00 localhost kernel: [  390.268566]
> [<7902d862>] warn_slowpath_fmt+0x2b/0x2f
> 2010-12-10T11:44:47.269632-08:00 localhost kernel: [  390.268595]
> [<b86b38c1>] ieee80211_pspoll_get+0x1405/0x1569 [mac80211]
> 2010-12-10T11:44:47.269666-08:00 localhost kernel: [  390.268628]
> [<b86b3a1d>] ieee80211_pspoll_get+0x1561/0x1569 [mac80211]
> 2010-12-10T11:44:47.269702-08:00 localhost kernel: [  390.268657]
> [<b86b23f0>] ? ieee80211_probereq_get+0xdd/0xf1 [mac80211]
> 2010-12-10T11:44:47.269737-08:00 localhost kernel: [  390.268686]
> [<b86b3a67>] ieee80211_tx_skb+0x42/0x49 [mac80211]
> 2010-12-10T11:44:47.269771-08:00 localhost kernel: [  390.268714]
> [<b86b69e8>] ieee80211_send_probe_req+0xb1/0xc1 [mac80211]
> 2010-12-10T11:44:47.269806-08:00 localhost kernel: [  390.268743]
> [<b86a50e9>] ieee80211_scan_work+0x309/0x3b4 [mac80211]
> 2010-12-10T11:44:47.269837-08:00 localhost kernel: [  390.268764]
> [<7903ee77>] worker_thread+0x140/0x1b3
> 2010-12-10T11:44:47.269865-08:00 localhost kernel: [  390.268792]
> [<b86a4de0>] ? ieee80211_scan_work+0x0/0x3b4 [mac80211]
> 2010-12-10T11:44:47.269955-08:00 localhost kernel: [  390.268810]
> [<7904211f>] ? autoremove_wake_function+0x0/0x34
> 2010-12-10T11:44:47.269989-08:00 localhost kernel: [  390.268827]
> [<7903ed37>] ? worker_thread+0x0/0x1b3
> 2010-12-10T11:44:47.270021-08:00 localhost kernel: [  390.268841]
> [<79041dc9>] kthread+0x64/0x69
> 2010-12-10T11:44:47.270051-08:00 localhost kernel: [  390.268856]
> [<79041d65>] ? kthread+0x0/0x69
> 2010-12-10T11:44:47.270086-08:00 localhost kernel: [  390.268872]
> [<79002d56>] kernel_thread_helper+0x6/0x10
> 2010-12-10T11:44:47.270116-08:00 localhost kernel: [  390.268883] ---[
> end trace 6d450e935ee1897e ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


