Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36931 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbcBWIVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 03:21:36 -0500
Received: by mail-wm0-f50.google.com with SMTP id g62so198327889wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 00:21:35 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 23 Feb 2016 09:21:34 +0100
Message-ID: <CALhHN=r5Wthk5ru6Eb_8AD3xYsUsk4a02kP7MEK4jc5cmKUSdw@mail.gmail.com> (sfid-20160223_092146_561167_8C72B6A3)
Subject: intel7260 - iface up sometimes failed
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have intel7260 connected via external PCIe + DELL latitude e6430.

[ 5199.805417] iwlwifi 0000:04:00.0: enabling device (0100 -> 0102)
[ 5199.809222] iwlwifi 0000:04:00.0: loaded firmware version
17.275772.0 op_mode iwlmvm
[ 5199.819548] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless AC 7260, REV=0x144
[ 5199.819658] iwlwifi 0000:04:00.0: L1 Enabled - LTR Disabled
[ 5199.820018] iwlwifi 0000:04:00.0: L1 Enabled - LTR Disabled
[ 5200.012786] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[ 5200.020148] iwlwifi 0000:04:00.0 wlan3: renamed from wlan0

[ 5282.743987] iwlwifi 0000:04:00.0: L1 Enabled - LTR Disabled
[ 5282.781812] ------------[ cut here ]------------
[ 5282.781823] WARNING: CPU: 3 PID: 3760 at
drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1561
iwl_trans_pcie_grab_nic_access+0xe6/0xf0 [iwlwifi]()
[ 5282.781824] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
[ 5282.781825] Modules linked in: iwldvm(E) arc4(E) iwlmvm(E)
mac80211(E) iwlwifi(E) cfg80211(E) drbg(E) ansi_cprng(E) dm_crypt(E)
cmac(E) dell_laptop(E) dcdbas(E) dell_smm_hwmon(E) dell_wmi(E)
intel_rapl(E) sparse_keymap(E) x86_pkg_temp_thermal(E)
intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E)
crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) rfcomm(E)
uvcvideo(E) aesni_intel(E) snd_hda_codec_idt(E) aes_x86_64(E) lrw(E)
gf128mul(E) bnep(E) glue_helper(E) ablk_helper(E)
snd_hda_codec_generic(E) videobuf2_vmalloc(E) cryptd(E)
videobuf2_memops(E) videobuf2_v4l2(E) videobuf2_core(E) videodev(E)
snd_hda_intel(E) media(E) snd_hda_codec(E) snd_hda_core(E)
snd_hwdep(E) joydev(E) snd_pcm(E) snd_seq_midi(E)
snd_seq_midi_event(E) ath3k(E) btusb(E) btrtl(E) btbcm(E) btintel(E)
bluetooth(E) serio_raw(E) snd_rawmidi(E) lpc_ich(E) snd_seq(E)
snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) mei_me(E)
dell_smo8800(E) mei(E) shpchp(E) mac_hid(E) parport_pc(E)
binfmt_misc(E) ppdev(E) lp(E) parport(E) nouveau(E) i915(E) mxm_wmi(E)
ttm(E) i2c_algo_bit(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E)
sysimgblt(E) fb_sys_fops(E) e1000e(E) ahci(E) sdhci_pci(E) ptp(E)
psmouse(E) libahci(E) sdhci(E) pps_core(E) drm(E) wmi(E) video(E)
[ 5282.781860] CPU: 3 PID: 3760 Comm: ifconfig Tainted: G        W   E
  4.5.0-rc2-master-2016-02-18-01-wt-ath+ #17
[ 5282.781861] Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS
A13 09/02/2013
[ 5282.781862]  ffffffffc09c67d0 ffff88007a1efa08 ffffffff813aec6d
ffff88007a1efa50
[ 5282.781864]  ffff88007a1efa40 ffffffff81078916 ffff8801ac814000
ffff8801ac817644
[ 5282.781865]  ffff88007a1efad8 0000000000000000 ffff88007a3a55d8
ffff88007a1efaa0
[ 5282.781866] Call Trace:
[ 5282.781871]  [<ffffffff813aec6d>] dump_stack+0x44/0x57
[ 5282.781874]  [<ffffffff81078916>] warn_slowpath_common+0x86/0xc0
[ 5282.781875]  [<ffffffff8107899c>] warn_slowpath_fmt+0x4c/0x50
[ 5282.781878]  [<ffffffffc09a50ff>] ? iwl_read32+0x1f/0x70 [iwlwifi]
[ 5282.781881]  [<ffffffffc09b4806>]
iwl_trans_pcie_grab_nic_access+0xe6/0xf0 [iwlwifi]
[ 5282.781883]  [<ffffffffc09a54b3>] iwl_read_prph+0x23/0x60 [iwlwifi]
[ 5282.781886]  [<ffffffffc09b27f4>] iwl_pcie_apm_init+0x244/0x2b0 [iwlwifi]
[ 5282.781889]  [<ffffffffc09b61dc>]
iwl_trans_pcie_start_hw+0x5c/0x100 [iwlwifi]
[ 5282.781893]  [<ffffffffc0abd35b>] iwl_mvm_up+0x2b/0x530 [iwlmvm]
[ 5282.781896]  [<ffffffff81195c7c>] ? zone_statistics+0x7c/0xa0
[ 5282.781898]  [<ffffffff8117e8f9>] ? get_page_from_freelist+0x449/0x960
[ 5282.781901]  [<ffffffffc0ac2def>] __iwl_mvm_mac_start+0x35f/0x490 [iwlmvm]
[ 5282.781904]  [<ffffffffc0ac2f5d>] iwl_mvm_mac_start+0x3d/0x120 [iwlmvm]
[ 5282.781906]  [<ffffffff8172bba8>] ? inetdev_event+0x38/0x500
[ 5282.781908]  [<ffffffff816a2ac9>] ? skb_dequeue+0x59/0x70
[ 5282.781919]  [<ffffffffc09da634>] drv_start+0x44/0xd0 [mac80211]
[ 5282.781925]  [<ffffffffc09eef0e>] ieee80211_do_open+0x2ae/0x930 [mac80211]
[ 5282.781932]  [<ffffffffc09ef5e2>] ieee80211_open+0x52/0x60 [mac80211]
[ 5282.781933]  [<ffffffff816bab91>] __dev_open+0xb1/0x130
[ 5282.781934]  [<ffffffff816bae8d>] __dev_change_flags+0x9d/0x160
[ 5282.781935]  [<ffffffff816baf79>] dev_change_flags+0x29/0x60
[ 5282.781937]  [<ffffffff8172c78f>] devinet_ioctl+0x64f/0x740
[ 5282.781938]  [<ffffffff8172d8f7>] inet_ioctl+0x57/0x80
[ 5282.781940]  [<ffffffff81699955>] sock_do_ioctl+0x25/0x50
[ 5282.781942]  [<ffffffff81699e74>] sock_ioctl+0x1d4/0x2b0
[ 5282.781943]  [<ffffffff8120b2d6>] do_vfs_ioctl+0x96/0x590
[ 5282.781945]  [<ffffffff81207403>] ? putname+0x53/0x60
[ 5282.781946]  [<ffffffff8120b849>] SyS_ioctl+0x79/0x90
[ 5282.781948]  [<ffffffff817bf5b6>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 5282.781949] ---[ end trace 4d5ced3fefbe0a4f ]---
[ 5283.043951] iwlwifi 0000:04:00.0: L1 Enabled - LTR Disabled
[ 5290.241921] iwlwifi 0000:04:00.0: Failed to load firmware chunk!
[ 5290.247922] iwlwifi 0000:04:00.0: Could not load the [0] uCode section
[ 5290.254447] iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110
[ 5290.260624] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110

Linux dell6430 4.5.0-rc2

BR
Janusz
