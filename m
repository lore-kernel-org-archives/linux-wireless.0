Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppa01.Princeton.EDU ([128.112.128.213]:57370 "EHLO
	ppa01.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab2DYGRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:17:38 -0400
Received: from csgsmtp201l.Princeton.EDU (csgsmtp201l.Princeton.EDU [128.112.134.60])
	by ppa01.Princeton.EDU (8.14.4/8.14.4) with ESMTP id q3P6HbT0025585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 02:17:37 -0400
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com [209.85.217.174])
	(authenticated bits=0)
	by csgsmtp201l.Princeton.EDU (8.13.8/8.12.9) with ESMTP id q3P6Harx003037
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 02:17:37 -0400
Received: by lbbgf7 with SMTP id gf7so1292630lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 23:17:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dchyan@princeton.edu
In-Reply-To: <CANUX_P0JsyA53T_vs5Ea0pE5Ye4G9xRC4xKcdwgAmoC8E63sHg@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
	<CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com>
	<CAOvK7nDO4fS6R5go+ZXYBqyQc8hhbJGun9Weh=-EyX5k11+tXw@mail.gmail.com>
	<CANUX_P2rzvDCBVLmU2rfaZmUOCMuMDe5=TXE_jwxq4ULrvc=QQ@mail.gmail.com>
	<CAOvK7nCwRbDNZSnn0EvFMpcQMvX1DmU-tBuFT4kRW1TigwyJDQ@mail.gmail.com>
	<CANUX_P0JsyA53T_vs5Ea0pE5Ye4G9xRC4xKcdwgAmoC8E63sHg@mail.gmail.com>
Date: Wed, 25 Apr 2012 02:17:35 -0400
Message-ID: <CAOvK7nCf6k_ugJ=UBF8y0VBr_kVmESpetfnpn=NW73r_K=kKyw@mail.gmail.com> (sfid-20120425_081741_509149_4E947785)
Subject: Re: iwlwifi bug
From: Daniel Chyan <dchyan@princeton.edu>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to confirm, the commands are "sudo make CONFIG_IWLWIFI_DEBUG=y"
and then "sudo make install"?

If those commands are correct, here is the dmesg output:

[  422.515639] ------------[ cut here ]------------
[  422.515688] WARNING: at
/home/foo/bar/ness/compat-wireless-2012-04-23/net/mac80211/driver-ops.h:12
ieee80211_bss_info_change_notify+0x2d1/0x2e0 [mac80211]()
[  422.515696] Hardware name: 4177CTO
[  422.515700] wlan0:  Failed check-sdata-in-driver check, flags: 0x4
[  422.515704] Modules linked in: btrfs zlib_deflate libcrc32c ufs
qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs parport_pc
ppdev snd_hda_codec_hdmi snd_hda_codec_conexant bnep rfcomm bluetooth
speedstep_lib binfmt_misc snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm thinkpad_acpi snd_seq_midi snd_rawmidi i915 arc4
snd_seq_midi_event snd_seq snd_timer snd_seq_device iwlwifi(-)
uvcvideo psmouse videodev mei(C) v4l2_compat_ioctl32 tpm_tis snd
drm_kms_helper nvram drm i2c_algo_bit soundcore serio_raw
snd_page_alloc mac80211 cfg80211 wmi compat video lp parport usbhid
hid firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci ahci libahci
e1000e
[  422.515801] Pid: 19766, comm: modprobe Tainted: G         C
3.0.0-17-generic #30-Ubuntu
[  422.515806] Call Trace:
[  422.515823]  [<ffffffff8105e8ff>] warn_slowpath_common+0x7f/0xc0
[  422.515832]  [<ffffffff8105e9f6>] warn_slowpath_fmt+0x46/0x50
[  422.515858]  [<ffffffffa010e70e>] ? __sta_info_destroy+0x1e/0x560 [mac80211]
[  422.515881]  [<ffffffffa010aa11>]
ieee80211_bss_info_change_notify+0x2d1/0x2e0 [mac80211]
[  422.515915]  [<ffffffffa012f6f0>]
ieee80211_destroy_auth_data+0x50/0x80 [mac80211]
[  422.515948]  [<ffffffffa01353c1>] ieee80211_mgd_teardown+0x51/0x70 [mac80211]
[  422.515975]  [<ffffffffa0118aec>]
ieee80211_teardown_sdata+0xdc/0x100 [mac80211]
[  422.515985]  [<ffffffff814dd9e0>] rollback_registered_many+0x1a0/0x260
[  422.515993]  [<ffffffff814ddabb>] unregister_netdevice_many+0x1b/0x80
[  422.516019]  [<ffffffffa0119c20>]
ieee80211_remove_interfaces+0xd0/0x110 [mac80211]
[  422.516042]  [<ffffffffa0109133>]
ieee80211_unregister_hw+0x53/0x120 [mac80211]
[  422.516063]  [<ffffffffa026d24b>] iwlagn_mac_unregister+0x2b/0x40 [iwlwifi]
[  422.516081]  [<ffffffffa02653b1>] iwl_op_mode_dvm_stop+0x51/0xe0 [iwlwifi]
[  422.516106]  [<ffffffffa0285c27>] iwl_drv_stop+0x47/0x70 [iwlwifi]
[  422.516135]  [<ffffffffa029b34f>] iwl_pci_remove+0x22/0xcd3 [iwlwifi]
[  422.516148]  [<ffffffff81312736>] pci_device_remove+0x46/0x110
[  422.516162]  [<ffffffff813d06bc>] __device_release_driver+0x7c/0xe0
[  422.516174]  [<ffffffff813d0e48>] driver_detach+0xc8/0xd0
[  422.516186]  [<ffffffff813d0519>] bus_remove_driver+0x79/0xd0
[  422.516198]  [<ffffffff813d1602>] driver_unregister+0x62/0xa0
[  422.516210]  [<ffffffff813115b5>] pci_unregister_driver+0x45/0xc0
[  422.516240]  [<ffffffffa02848e5>]
iwl_pci_unregister_driver+0x15/0x20 [iwlwifi]
[  422.516270]  [<ffffffffa029aa59>] iwl_exit+0x9/0x1c [iwlwifi]
[  422.516282]  [<ffffffff8109f1ce>] sys_delete_module+0x18e/0x250
[  422.516294]  [<ffffffff81135593>] ? do_munmap+0x1f3/0x2f0
[  422.516307]  [<ffffffff815fb342>] system_call_fastpath+0x16/0x1b
[  422.516315] ---[ end trace 45b9addccc842009 ]---
[  422.560312] iwlwifi 0000:03:00.0: PCI INT A disabled
[  432.738352] cfg80211: Calling CRDA to update world regulatory domain
[  432.748736] cfg80211: World regulatory domain updated:
[  432.748745] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  432.748755] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  432.748762] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  432.748769] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  432.748776] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  432.748782] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  432.753876] iwlwifi: Unknown parameter `debug'

- Daniel

On Wed, Apr 25, 2012 at 2:07 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Wed, Apr 25, 2012 at 08:58, Daniel Chyan <dchyan@princeton.edu> wrote:
>> Correct me if I did it incorrectly. I issue "sudo modprobe iwlwifi
>> debug=0x80000000" but I receive an "Unknown symbol in module, or
>> unknown parameter" error.
>>
>
> All right, please compile with CONFIG_IWLWIFI_DEBUG=y
