Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:53475 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3DARMa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 13:12:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by uplift.swm.pp.se (Postfix) with ESMTP id 96F539A
	for <linux-wireless@vger.kernel.org>; Mon,  1 Apr 2013 19:12:27 +0200 (CEST)
Date: Mon, 1 Apr 2013 19:12:27 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-wireless@vger.kernel.org
Subject: Re: problems with iwlwifi - intel 5300 - 5GHz - all versions
In-Reply-To: <alpine.DEB.2.00.1303291240580.11255@uplift.swm.pp.se>
Message-ID: <alpine.DEB.2.00.1304011908390.23668@uplift.swm.pp.se> (sfid-20130401_191237_181984_A9EDAC20)
References: <alpine.DEB.2.00.1303291240580.11255@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 29 Mar 2013, Mikael Abrahamsson wrote:

Another data point.

With 3.2.0-39 with backported 3.6 drivers 
(linux-backports-modules-cw-3.6-3.2.0-39-generic-pae).

$ dmesg | egrep -v '(mBi)|(width channel with regulatory)'
[258225.012319] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258227.020323] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258227.032182] ------------[ cut here ]------------
[258227.032212] WARNING: at 
/build/buildd/linux-backports-modules-3.2.0-3.2.0/debian/build/build-generic-pae/cw-3.6/drivers/net/wireless/iwlwifi/dvm/tx.c:1187 
iwlagn_rx_reply_tx+0x984/0x9b0 [iwldvm]()
[258227.032222] Hardware name: 7454CTO
[258227.032227] Modules linked in: iwldvm(O) iwlwifi(O) pci_stub 
vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) rfcomm(O) parport_pc 
bnep(O) ppdev binfmt_misc dm_crypt arc4 mac80211(O) dm_multipath 
snd_hda_codec_conexant thinkpad_acpi uvcvideo videodev snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm btusb(O) bluetooth(O) snd_seq_midi psmouse 
snd_rawmidi serio_raw crystalhd(C) cfg80211(O) snd_seq_midi_event 
compat(O) snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc 
nvram tpm_tis mei(C) mac_hid coretemp lp parport raid10 raid456 
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx 
raid1 raid0 multipath linear wmi i915 drm_kms_helper drm i2c_algo_bit 
video [last unloaded: iwlwifi]
[258227.032385] Pid: 0, comm: swapper/0 Tainted: G        WC O 
3.2.0-39-generic-pae #62-Ubuntu
[258227.032392] Call Trace:
[258227.032408]  [<c159294f>] ? printk+0x2d/0x2f
[258227.032421]  [<c105a5b2>] warn_slowpath_common+0x72/0xa0
[258227.032441]  [<f92fad44>] ? iwlagn_rx_reply_tx+0x984/0x9b0 [iwldvm]
[258227.032460]  [<f92fad44>] ? iwlagn_rx_reply_tx+0x984/0x9b0 [iwldvm]
[258227.032470]  [<c105a602>] warn_slowpath_null+0x22/0x30
[258227.032489]  [<f92fad44>] iwlagn_rx_reply_tx+0x984/0x9b0 [iwldvm]
[258227.032513]  [<f93043ce>] iwl_rx_dispatch+0x6e/0xe0 [iwldvm]
[258227.032524]  [<c15a870d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[258227.032546]  [<f9235de1>] iwl_irq_tasklet+0x761/0xe10 [iwlwifi]
[258227.032559]  [<c1061270>] ? local_bh_enable_ip+0x90/0x90
[258227.032567]  [<c1060d93>] tasklet_action+0x63/0x110
[258227.032576]  [<c1061270>] ? local_bh_enable_ip+0x90/0x90
[258227.032584]  [<c10612f1>] __do_softirq+0x81/0x1a0
[258227.032593]  [<c1061270>] ? local_bh_enable_ip+0x90/0x90
[258227.032599]  <IRQ>  [<c1061636>] ? irq_exit+0x76/0xa0
[258227.032615]  [<c15b00db>] ? do_IRQ+0x4b/0xc0
[258227.032625]  [<c1017be8>] ? sched_clock+0x8/0x10
[258227.032636]  [<c107ffeb>] ? sched_clock_local+0xcb/0x1c0
[258227.032645]  [<c15aff30>] ? common_interrupt+0x30/0x38
[258227.032654]  [<c10800d8>] ? sched_clock_local+0x1b8/0x1c0
[258227.032667]  [<c132ad49>] ? arch_local_irq_enable+0x7/0xb
[258227.032676]  [<c132ba7d>] ? acpi_idle_enter_bm+0x228/0x268
[258227.032688]  [<c147e86d>] ? cpuidle_idle_call+0xad/0x250
[258227.032698]  [<c101075c>] ? cpu_idle+0x9c/0xe0
[258227.032707]  [<c15755a5>] ? rest_init+0x5d/0x68
[258227.032719]  [<c1879787>] ? start_kernel+0x352/0x358
[258227.032728]  [<c18793c6>] ? pass_bootoption.constprop.2+0xe2/0xe2
[258227.032738]  [<c18790ba>] ? i386_start_kernel+0xa9/0xaf
[258227.032744] ---[ end trace feca50f599babef6 ]---
[258227.056390] cfg80211: All devices are disconnected, going to restore regulatory settings
[258227.056403] cfg80211: Restoring regulatory settings
[258227.056457] cfg80211: Calling CRDA to update world regulatory domain
[258227.066918] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[258227.066929] cfg80211: World regulatory domain updated:
[258227.066934] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[258229.064322] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258229.862563] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy1
[258232.182146] wlan0: authenticate with 00:21:91:dc:94:57
[258232.189197] wlan0: send auth to 00:21:91:dc:94:57 (try 1/3)
[258232.392066] wlan0: send auth to 00:21:91:dc:94:57 (try 2/3)
[258232.392619] wlan0: authenticated
[258232.396126] wlan0: associate with 00:21:91:dc:94:57 (try 1/3)
[258232.398428] wlan0: RX AssocResp from 00:21:91:dc:94:57 (capab=0x111 status=0 aid=3)
[258232.401793] wlan0: associated
[258232.402327] cfg80211: Calling CRDA for country: GB
[258232.415042] cfg80211: Disabling freq 5745 MHz
[258232.415047] cfg80211: Disabling freq 5765 MHz
[258232.415052] cfg80211: Disabling freq 5785 MHz
[258232.415057] cfg80211: Disabling freq 5805 MHz
[258232.415062] cfg80211: Disabling freq 5825 MHz
[258232.415074] cfg80211: Regulatory domain changed to country: GB
[258232.415079] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[258232.415087] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258232.415094] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258232.415101] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258232.415109] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[258232.422442] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy1
[258246.404269] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258253.008079] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258255.996296] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258258.004275] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258258.040592] cfg80211: All devices are disconnected, going to restore regulatory settings
[258258.040604] cfg80211: Restoring regulatory settings
[258258.040622] cfg80211: Calling CRDA to update world regulatory domain
[258258.051346] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[258258.051357] cfg80211: World regulatory domain updated:
[258258.051362] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[258260.044161] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258260.889810] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy1
[258263.210853] wlan0: authenticate with 00:21:91:dc:94:57
[258263.223043] wlan0: send auth to 00:21:91:dc:94:57 (try 1/3)
[258263.424067] wlan0: send auth to 00:21:91:dc:94:57 (try 2/3)
[258263.475989] wlan0: authenticated
[258263.480083] wlan0: associate with 00:21:91:dc:94:57 (try 1/3)
[258263.481062] wlan0: RX AssocResp from 00:21:91:dc:94:57 (capab=0x111 status=0 aid=3)
[258263.485398] wlan0: associated
[258263.485970] cfg80211: Calling CRDA for country: GB
[258263.500626] cfg80211: Disabling freq 5745 MHz
[258263.500631] cfg80211: Disabling freq 5765 MHz
[258263.500636] cfg80211: Disabling freq 5785 MHz
[258263.500640] cfg80211: Disabling freq 5805 MHz
[258263.500645] cfg80211: Disabling freq 5825 MHz
[258263.500656] cfg80211: Regulatory domain changed to country: GB
[258263.500662] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[258263.500670] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258263.500677] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258263.500685] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258263.500692] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[258263.552238] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy1
[258366.416322] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258366.416534] wlan0: deauthenticating from 00:21:91:dc:94:57 by local choice (reason=3)
[258368.424282] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258370.432326] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258372.448317] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[258372.449675] cfg80211: All devices are disconnected, going to restore regulatory settings
[258372.449687] cfg80211: Restoring regulatory settings
[258372.449699] cfg80211: Calling CRDA to update world regulatory domain
[258372.483302] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[258372.483306] cfg80211: World regulatory domain updated:
[258372.483308] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[258373.783594] iwlwifi 0000:03:00.0: PCI INT A disabled
[258377.916613] Intel(R) Wireless WiFi driver for Linux, in-tree:
[258377.916617] Copyright(c) 2003-2012 Intel Corporation
[258377.916670] iwlwifi 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[258377.916683] iwlwifi 0000:03:00.0: setting latency timer to 64
[258377.916708] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[258377.916710] iwlwifi 0000:03:00.0: pci_resource_base = f8450000
[258377.916713] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
[258377.916799] iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
[258377.922557] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
[258377.928633] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[258377.928636] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[258377.928663] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[258377.928665] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[258377.928667] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[258377.928670] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[258377.928672] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[258377.928674] iwlwifi 0000:03:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
[258377.928736] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[258377.950610] iwlwifi 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[258377.950613] iwlwifi 0000:03:00.0: Device SKU: 0xF0
[258377.950615] iwlwifi 0000:03:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
[258377.950754] Registered led device: phy2-led
[258377.950788] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[258377.951642] ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
[258377.963777] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[258377.966853] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
[258378.116464] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[258378.119418] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
[258378.168759] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[258378.169344] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[258380.186475] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy2
[258385.789055] wlan0: authenticate with 00:21:91:dc:94:57
[258385.794819] wlan0: send auth to 00:21:91:dc:94:57 (try 1/3)
[258385.996051] wlan0: send auth to 00:21:91:dc:94:57 (try 2/3)
[258385.996547] wlan0: authenticated
[258386.000041] wlan0: associate with 00:21:91:dc:94:57 (try 1/3)
[258386.000931] wlan0: RX AssocResp from 00:21:91:dc:94:57 (capab=0x111 status=0 aid=3)
[258386.002233] wlan0: associated
[258386.002390] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[258386.002461] cfg80211: Calling CRDA for country: GB
[258386.008598] cfg80211: Disabling freq 5745 MHz
[258386.008600] cfg80211: Disabling freq 5765 MHz
[258386.008603] cfg80211: Disabling freq 5785 MHz
[258386.008605] cfg80211: Disabling freq 5805 MHz
[258386.008607] cfg80211: Disabling freq 5825 MHz
[258386.008613] cfg80211: Regulatory domain changed to country: GB
[258386.008616] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[258386.008620] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258386.008623] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258386.008627] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[258386.008630] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[258386.023210] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy2

