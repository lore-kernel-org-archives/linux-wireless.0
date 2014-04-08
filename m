Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.pawisda.de ([213.157.4.156]:58962 "EHLO mail.pawisda.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbaDHVgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 17:36:31 -0400
Received: from localhost (localhost.intra.frontsite.de [127.0.0.1])
	by mail.pawisda.de (Postfix) with ESMTP id 3667F4DE1E
	for <linux-wireless@vger.kernel.org>; Tue,  8 Apr 2014 23:07:06 +0200 (CEST)
Received: from mail.pawisda.de ([127.0.0.1])
 by localhost (ndb [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 04851-10 for <linux-wireless@vger.kernel.org>;
 Tue,  8 Apr 2014 23:07:05 +0200 (CEST)
Received: from [10.76.107.12] (unknown [192.168.12.254])
	by mail.pawisda.de (Postfix) with ESMTP id 893064B7D5
	for <linux-wireless@vger.kernel.org>; Tue,  8 Apr 2014 23:07:05 +0200 (CEST)
Message-ID: <534464F9.1080805@sp.consulting.lsexperts.de> (sfid-20140408_233636_176148_44D5A66B)
Date: Tue, 08 Apr 2014 23:07:05 +0200
From: Stefan Pietsch <stefan.pietsch@lsexperts.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlwifi: Invalid RXON when trying to join IBSS network
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list,

trying to join an IBSS network gives me these kernel messages:



[  383.857059] iwlwifi 0000:03:00.0: mac/bssid mcast!
[  383.857061] ------------[ cut here ]------------
[  383.857071] WARNING: CPU: 0 PID: 3165 at
/build/linux-l673CV/linux-3.13.7/drivers/net/wireless/iwlwifi/dvm/rxon.c:843
iwlagn_commit_rxon+0x551/0xbb0 [iwldvm]()
[  383.857073] Invalid RXON (0x10), channel 1
[  383.857075] Modules linked in: iwldvm iwlwifi pci_stub vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) bnep rfcomm cpufreq_stats
cpufreq_conservative cpufreq_userspace cpufreq_powersave snd_hrtimer
bridge stp llc firewire_sbp2 firewire_core crc_itu_t loop fuse ecryptfs
parport_pc ppdev lp parport snd_hda_codec_hdmi snd_hda_codec_conexant
iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp
cdc_mbim cdc_ncm usbnet cdc_wdm mii cdc_acm arc4 intel_rapl btusb
coretemp bluetooth kvm_intel mac80211 kvm snd_hda_intel psmouse evdev
snd_hda_codec serio_raw i2c_i801 snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm snd_page_alloc cfg80211 tpm_tis lpc_ich snd_seq_midi
thinkpad_acpi wmi tpm mfd_core snd_seq_midi_event i915 nvram rfkill
snd_rawmidi ac battery snd_seq drm_kms_helper snd_seq_device snd_timer
drm i2c_algo_bit i2c_core snd video mei_me soundcore mei processor
button ext4 crc16 mbcache jbd2 sha256_ssse3 sha256_generic dm_crypt
dm_mod nbd sg sd_mod crc_t10dif crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ahci libahci ghash_clmulni_intel libata
scsi_mod aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper
cryptd sdhci_pci sdhci mmc_core xhci_hcd ehci_pci ehci_hcd usbcore
usb_common e1000e ptp pps_core thermal thermal_sys [last unloaded: iwlwifi]
[  383.857167] CPU: 0 PID: 3165 Comm: ifconfig Tainted: G        W  O
3.13-1-amd64 #1 Debian 3.13.7-1
[  383.857169] Hardware name: LENOVO 429136G/429136G, BIOS 8DET69WW
(1.39 ) 07/18/2013
[  383.857171]  0000000000000009 ffffffff8149bdff ffff880212fd9ab0
ffffffff8105b8f2
[  383.857175]  ffff880214ce17b0 ffff880212fd9b00 0000000000000010
000000000000000f
[  383.857179]  ffff880214ce17b0 ffffffff8105b957 ffffffffa0838ad0
0000000000000028
[  383.857182] Call Trace:
[  383.857189]  [<ffffffff8149bdff>] ? dump_stack+0x41/0x51
[  383.857193]  [<ffffffff8105b8f2>] ? warn_slowpath_common+0x72/0x90
[  383.857196]  [<ffffffff8105b957>] ? warn_slowpath_fmt+0x47/0x50
[  383.857201]  [<ffffffff81278536>] ? sprintf+0x46/0x50
[  383.857206]  [<ffffffffa08331a1>] ? iwlagn_commit_rxon+0x551/0xbb0
[iwldvm]
[  383.857211]  [<ffffffff810a43f3>] ? print_time.part.5+0x63/0x90
[  383.857214]  [<ffffffff810a4480>] ? print_prefix+0x60/0xa0
[  383.857225]  [<ffffffffa047340d>] ?
cfg80211_can_use_iftype_chan+0x2d/0x4f0 [cfg80211]
[  383.857230]  [<ffffffffa0833d10>] ?
iwlagn_bss_info_changed+0x1a0/0x560 [iwldvm]
[  383.857240]  [<ffffffffa05f0b31>] ?
ieee80211_bss_info_change_notify+0x91/0x1b0 [mac80211]
[  383.857250]  [<ffffffffa05ff40a>] ? ieee80211_ibss_join+0x1ea/0x230
[mac80211]
[  383.857260]  [<ffffffffa0491850>] ? __cfg80211_join_ibss+0x160/0x250
[cfg80211]
[  383.857269]  [<ffffffffa0491c46>] ?
cfg80211_ibss_wext_join+0x116/0x200 [cfg80211]
[  383.857277]  [<ffffffffa0470dfb>] ?
cfg80211_netdev_notifier_call+0x47b/0x600 [cfg80211]
[  383.857282]  [<ffffffff814566aa>] ? addrconf_notify+0xda/0x970
[  383.857286]  [<ffffffff814203e6>] ? inetdev_event+0xa6/0x4c0
[  383.857291]  [<ffffffff814a50f4>] ? notifier_call_chain+0x44/0x70
[  383.857295]  [<ffffffff813bd3c0>] ? __dev_notify_flags+0x30/0xb0
[  383.857298]  [<ffffffff813bdb56>] ? dev_change_flags+0x46/0x60
[  383.857302]  [<ffffffff81420f33>] ? devinet_ioctl+0x673/0x760
[  383.857306]  [<ffffffff813a146b>] ? sock_do_ioctl+0x1b/0x50
[  383.857309]  [<ffffffff813a1e4c>] ? compat_sock_ioctl+0x4cc/0xaf0
[  383.857312]  [<ffffffff814a4ca1>] ? __do_page_fault+0x1d1/0x500
[  383.857316]  [<ffffffff811c62af>] ? compat_sys_ioctl+0xbf/0x1110
[  383.857321]  [<ffffffff814aa9ec>] ? sysenter_dispatch+0x7/0x21
[  383.857323] ---[ end trace 177f561882aba5e8 ]---
[  383.857326] iwlwifi 0000:03:00.0: Invalid RXON configuration. Not
committing.
[  383.857337] wlan0: Trigger new scan to find an IBSS to join
[  383.993550] iwlwifi 0000:03:00.0: mac/bssid mcast!
[  383.993556] ------------[ cut here ]------------



Wireless card:
Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] [8086:0085]
(rev 34)

Kernel version:
3.13-1-amd64 #1 SMP Debian 3.13.7-1 (2014-03-25)



Regards,
Stefan
