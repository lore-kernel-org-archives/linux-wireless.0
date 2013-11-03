Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:35100 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3KCJVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 04:21:11 -0500
Message-ID: <5276134B.8070808@wzyboy.org> (sfid-20131103_102125_603737_A4B63F29)
Date: Sun, 03 Nov 2013 17:11:39 +0800
From: wzyboy <wzyboy@wzyboy.org>
MIME-Version: 1.0
To: ilw@linux.intel.com
CC: linux-wireless@vger.kernel.org
Subject: Intel Wireless 7260 hardware timed out randomly
Content-Type: multipart/mixed;
 boundary="------------090405020004000801010700"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090405020004000801010700
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, there.

I am encountering some bugs with iwlwifi.ko in Linux 3.11.6.

My laptop is a ThinkPad X240s with Network controller Intel Corporation 
Wireless 7260 (rev 6b). I have Arch Linux with kernel 3.11.6 installed 
on it. The wireless works out-of-box, thanks for your work!

However, after using wireless for some time (could be either an hour 
with normal web page browsing, or several hours with heavy Internet 
downloading), the wireless works abnormally. The sympton is that every 
connection get lost, and the hardware "timed out" when I try to take 
down or take up the interface with `ip link set wlan0 down' or `ip link 
set wlan0 up'. When this bug occurs, even reloading the kernel modules 
(with `modprobe') could not bring the wireless back alive. What I could 
only do is to reboot the laptop.

After encountering this bug for several times, I found something useful 
in `dmesg', as I've attached. Please take a look at the log and find out 
then squash this bug.

If I could be helpful by providing more debugging information please let 
me know.


Sincere regards.

-- 
wzyboy

--------------090405020004000801010700
Content-Type: text/x-log;
 name="iwlwifi.error2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iwlwifi.error2.log"

[ 7675.500236] ------------[ cut here ]------------
[ 7675.500268] WARNING: CPU: 3 PID: 12926 at drivers/net/wireless/iwlwifi/pcie/trans.c:883 iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
[ 7675.500270] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
[ 7675.500272] Modules linked in: nls_cp437 vfat fat usb_storage fuse tun ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb bluetooth media joydev arc4 x86_pkg_temp_thermal coretemp kvm_intel kvm psmouse iwlmvm mac80211 serio_raw iTCO_wdt iTCO_vendor_support rtsx_pci_ms memstick pcspkr snd_hda_codec_realtek snd_hda_codec_hdmi iwlwifi thinkpad_acpi tpm_tis e1000e cfg80211 ptp snd_hda_intel tpm microcode tpm_bios mei_me mei wmi pps_core shpchp nvram i2c_i801 battery snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer lpc_ich snd thermal ac evdev rfkill soundcore mperf processor vboxnetflt(O) vboxdrv(O) nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2
[ 7675.500316]  dm_crypt dm_mod hid_generic usbhid hid sd_mod rtsx_pci_sdmmc mmc_core ahci libahci xhci_hcd crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd libata ehci_pci ehci_hcd scsi_mod rtsx_pci usbcore usb_common i915 video button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[ 7675.500334] CPU: 3 PID: 12926 Comm: kworker/u16:2 Tainted: G           O 3.11.6-1-ARCH #1
[ 7675.500335] Hardware name: LENOVO 20AKCTO1WW/20AKCTO1WW, BIOS GIET62WW (2.12 ) 09/25/2013
[ 7675.500341] Workqueue: phy0 ieee80211_ba_session_work [mac80211]
[ 7675.500342]  0000000000000009 ffff8801916dfb70 ffffffff814dba02 ffff8801916dfbb8
[ 7675.500345]  ffff8801916dfba8 ffffffff8106193d ffff8802133e8000 ffff8802133eb258
[ 7675.500346]  ffff8801916dfc58 00000000ffffffff ffff880213416098 ffff8801916dfc08
[ 7675.500348] Call Trace:
[ 7675.500353]  [<ffffffff814dba02>] dump_stack+0x54/0x8d
[ 7675.500356]  [<ffffffff8106193d>] warn_slowpath_common+0x7d/0xa0
[ 7675.500359]  [<ffffffff810619ac>] warn_slowpath_fmt+0x4c/0x50
[ 7675.500362]  [<ffffffffa08d63d8>] iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]
[ 7675.500365]  [<ffffffffa08c949e>] iwl_write_prph+0x2e/0xe0 [iwlwifi]
[ 7675.500368]  [<ffffffffa08d4809>] iwl_trans_pcie_txq_disable+0x79/0x150 [iwlwifi]
[ 7675.500372]  [<ffffffffa09eb795>] iwl_mvm_sta_tx_agg_stop+0x1b5/0x220 [iwlmvm]
[ 7675.500375]  [<ffffffffa09e2612>] iwl_mvm_mac_ampdu_action+0x172/0x1c0 [iwlmvm]
[ 7675.500379]  [<ffffffffa095893a>] ___ieee80211_stop_tx_ba_session+0x14a/0x580 [mac80211]
[ 7675.500384]  [<ffffffffa0957857>] ieee80211_ba_session_work+0x187/0x1b0 [mac80211]
[ 7675.500386]  [<ffffffff8107c6e7>] process_one_work+0x167/0x450
[ 7675.500388]  [<ffffffff8107d0f1>] worker_thread+0x121/0x3a0
[ 7675.500390]  [<ffffffff8107cfd0>] ? manage_workers.isra.23+0x2b0/0x2b0
[ 7675.500393]  [<ffffffff81083960>] kthread+0xc0/0xd0
[ 7675.500395]  [<ffffffff810838a0>] ? kthread_create_on_node+0x120/0x120
[ 7675.500397]  [<ffffffff814ea52c>] ret_from_fork+0x7c/0xb0
[ 7675.500399]  [<ffffffff810838a0>] ? kthread_create_on_node+0x120/0x120
[ 7675.500400] ---[ end trace be7fe29c912fd23d ]---
[ 7677.527284] iwlwifi 0000:03:00.0: Error sending ADD_STA: time out after 2000ms.
[ 7677.527288] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 56
[ 7677.527292] wlan0: HW problem - can not stop rx aggregation for 14:e6:e4:3c:24:f8 tid 0
[ 7812.827249] iwlwifi 0000:03:00.0: Error sending MAC_CONTEXT_CMD: time out after 2000ms.
[ 7812.827253] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 57
[ 7812.827255] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -110
[ 7812.827257] iwlwifi 0000:03:00.0: failed to update MAC 5c:51:4f:0d:82:ac
[ 7812.829190] wlan0: deauthenticating from 14:e6:e4:3c:24:f8 by local choice (reason=3)
[ 7814.828876] iwlwifi 0000:03:00.0: Error sending MAC_CONTEXT_CMD: time out after 2000ms.
[ 7814.828880] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 58
[ 7814.828882] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -110
[ 7814.828884] iwlwifi 0000:03:00.0: failed to update MAC 5c:51:4f:0d:82:ac
[ 7816.830496] iwlwifi 0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 2000ms.
[ 7816.830499] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 59
[ 7816.830501] iwlwifi 0000:03:00.0: failed to update power mode
[ 7818.832103] iwlwifi 0000:03:00.0: Error sending ADD_STA: time out after 2000ms.
[ 7818.832107] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 60
[ 7818.832110] wlan0: failed to remove key (0, 14:e6:e4:3c:24:f8) from hardware (-110)
[ 7820.833753] iwlwifi 0000:03:00.0: Error sending REPLY_BEACON_FILTERING_CMD: time out after 2000ms.
[ 7820.833757] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 61
[ 7820.833759] ------------[ cut here ]------------
[ 7820.833767] WARNING: CPU: 0 PID: 469 at drivers/net/wireless/iwlwifi/mvm/mac80211.c:1047 iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]()
[ 7820.833768] Modules linked in: nls_cp437 vfat fat usb_storage fuse tun ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb bluetooth media joydev arc4 x86_pkg_temp_thermal coretemp kvm_intel kvm psmouse iwlmvm mac80211 serio_raw iTCO_wdt iTCO_vendor_support rtsx_pci_ms memstick pcspkr snd_hda_codec_realtek snd_hda_codec_hdmi iwlwifi thinkpad_acpi tpm_tis e1000e cfg80211 ptp snd_hda_intel tpm microcode tpm_bios mei_me mei wmi pps_core shpchp nvram i2c_i801 battery snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer lpc_ich snd thermal ac evdev rfkill soundcore mperf processor vboxnetflt(O) vboxdrv(O) nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2
[ 7820.833803]  dm_crypt dm_mod hid_generic usbhid hid sd_mod rtsx_pci_sdmmc mmc_core ahci libahci xhci_hcd crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd libata ehci_pci ehci_hcd scsi_mod rtsx_pci usbcore usb_common i915 video button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[ 7820.833822] CPU: 0 PID: 469 Comm: wpa_supplicant Tainted: G        W  O 3.11.6-1-ARCH #1
[ 7820.833823] Hardware name: LENOVO 20AKCTO1WW/20AKCTO1WW, BIOS GIET62WW (2.12 ) 09/25/2013
[ 7820.833824]  0000000000000009 ffff880213233780 ffffffff814dba02 0000000000000000
[ 7820.833826]  ffff8802132337b8 ffffffff8106193d 0000000000000000 0000000000000004
[ 7820.833828]  0000000000000003 ffff8802117a51a0 ffff8802117ad7e0 ffff8802132337c8
[ 7820.833830] Call Trace:
[ 7820.833835]  [<ffffffff814dba02>] dump_stack+0x54/0x8d
[ 7820.833839]  [<ffffffff8106193d>] warn_slowpath_common+0x7d/0xa0
[ 7820.833841]  [<ffffffff81061a1a>] warn_slowpath_null+0x1a/0x20
[ 7820.833844]  [<ffffffffa09e2910>] iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]
[ 7820.833850]  [<ffffffffa09518de>] sta_info_move_state+0xee/0x7a0 [mac80211]
[ 7820.833854]  [<ffffffffa095207b>] __sta_info_destroy+0xeb/0x380 [mac80211]
[ 7820.833858]  [<ffffffffa095244d>] sta_info_flush_defer+0x7d/0xa0 [mac80211]
[ 7820.833864]  [<ffffffffa098ba4f>] ieee80211_set_disassoc+0xaf/0x3c0 [mac80211]
[ 7820.833869]  [<ffffffffa0990093>] ieee80211_mgd_deauth+0x253/0x2c0 [mac80211]
[ 7820.833874]  [<ffffffffa0966928>] ieee80211_deauth+0x18/0x20 [mac80211]
[ 7820.833881]  [<ffffffffa07f39ac>] cfg80211_mlme_deauth+0x9c/0x1c0 [cfg80211]
[ 7820.833885]  [<ffffffffa07e2053>] nl80211_deauthenticate+0xe3/0x140 [cfg80211]
[ 7820.833888]  [<ffffffff8141cfa4>] genl_family_rcv_msg+0x344/0x390
[ 7820.833891]  [<ffffffff8141cff0>] ? genl_family_rcv_msg+0x390/0x390
[ 7820.833893]  [<ffffffff8141d081>] genl_rcv_msg+0x91/0xd0
[ 7820.833895]  [<ffffffff8141c299>] netlink_rcv_skb+0xa9/0xc0
[ 7820.833896]  [<ffffffff8141cc48>] genl_rcv+0x28/0x40
[ 7820.833898]  [<ffffffff8141b81d>] netlink_unicast+0xdd/0x190
[ 7820.833901]  [<ffffffff812968ad>] ? memcpy_fromiovec+0x4d/0x90
[ 7820.833903]  [<ffffffff8141bcdb>] netlink_sendmsg+0x35b/0x760
[ 7820.833906]  [<ffffffff81093b22>] ? default_wake_function+0x12/0x20
[ 7820.833909]  [<ffffffff813d6783>] sock_sendmsg+0xb3/0xd0
[ 7820.833911]  [<ffffffff8113291c>] ? find_get_page+0x5c/0x90
[ 7820.833913]  [<ffffffff81134c40>] ? filemap_fault+0x70/0x430
[ 7820.833916]  [<ffffffff81197126>] ? mem_cgroup_update_page_stat+0x16/0x50
[ 7820.833918]  [<ffffffff813d733c>] ___sys_sendmsg+0x36c/0x380
[ 7820.833921]  [<ffffffff8115dd5d>] ? handle_mm_fault+0x2bd/0x650
[ 7820.833923]  [<ffffffff813d8d91>] ? SyS_sendto+0x121/0x170
[ 7820.833926]  [<ffffffff813d9202>] __sys_sendmsg+0x42/0x80
[ 7820.833928]  [<ffffffff813d9252>] SyS_sendmsg+0x12/0x20
[ 7820.833930]  [<ffffffff814ea5dd>] system_call_fastpath+0x1a/0x1f
[ 7820.833931] ---[ end trace be7fe29c912fd23e ]---
[ 7822.835345] iwlwifi 0000:03:00.0: Error sending TXPATH_FLUSH: time out after 2000ms.
[ 7822.835350] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 62
[ 7822.835352] iwlwifi 0000:03:00.0: Failed to send flush command (-110)
[ 7822.835355] ------------[ cut here ]------------
[ 7822.835381] WARNING: CPU: 0 PID: 469 at net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380 [mac80211]()
[ 7822.835382] Modules linked in: nls_cp437 vfat fat usb_storage fuse tun ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb bluetooth media joydev arc4 x86_pkg_temp_thermal coretemp kvm_intel kvm psmouse iwlmvm mac80211 serio_raw iTCO_wdt iTCO_vendor_support rtsx_pci_ms memstick pcspkr snd_hda_codec_realtek snd_hda_codec_hdmi iwlwifi thinkpad_acpi tpm_tis e1000e cfg80211 ptp snd_hda_intel tpm microcode tpm_bios mei_me mei wmi pps_core shpchp nvram i2c_i801 battery snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer lpc_ich snd thermal ac evdev rfkill soundcore mperf processor vboxnetflt(O) vboxdrv(O) nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2
[ 7822.835452]  dm_crypt dm_mod hid_generic usbhid hid sd_mod rtsx_pci_sdmmc mmc_core ahci libahci xhci_hcd crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd libata ehci_pci ehci_hcd scsi_mod rtsx_pci usbcore usb_common i915 video button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[ 7822.835472] CPU: 0 PID: 469 Comm: wpa_supplicant Tainted: G        W  O 3.11.6-1-ARCH #1
[ 7822.835473] Hardware name: LENOVO 20AKCTO1WW/20AKCTO1WW, BIOS GIET62WW (2.12 ) 09/25/2013
[ 7822.835475]  0000000000000009 ffff880213233828 ffffffff814dba02 0000000000000000
[ 7822.835478]  ffff880213233860 ffffffff8106193d ffff8802117ac5e0 ffff8802117a4800
[ 7822.835481]  ffff8802117a4800 00000000ffffff92 ffff8801f42b1000 ffff880213233870
[ 7822.835484] Call Trace:
[ 7822.835502]  [<ffffffff814dba02>] dump_stack+0x54/0x8d
[ 7822.835506]  [<ffffffff8106193d>] warn_slowpath_common+0x7d/0xa0
[ 7822.835523]  [<ffffffff81061a1a>] warn_slowpath_null+0x1a/0x20
[ 7822.835529]  [<ffffffffa09522cc>] __sta_info_destroy+0x33c/0x380 [mac80211]
[ 7822.835533]  [<ffffffffa095244d>] sta_info_flush_defer+0x7d/0xa0 [mac80211]
[ 7822.835539]  [<ffffffffa098ba4f>] ieee80211_set_disassoc+0xaf/0x3c0 [mac80211]
[ 7822.835545]  [<ffffffffa0990093>] ieee80211_mgd_deauth+0x253/0x2c0 [mac80211]
[ 7822.835552]  [<ffffffffa0966928>] ieee80211_deauth+0x18/0x20 [mac80211]
[ 7822.835573]  [<ffffffffa07f39ac>] cfg80211_mlme_deauth+0x9c/0x1c0 [cfg80211]
[ 7822.835579]  [<ffffffffa07e2053>] nl80211_deauthenticate+0xe3/0x140 [cfg80211]
[ 7822.835598]  [<ffffffff8141cfa4>] genl_family_rcv_msg+0x344/0x390
[ 7822.835601]  [<ffffffff8141cff0>] ? genl_family_rcv_msg+0x390/0x390
[ 7822.835602]  [<ffffffff8141d081>] genl_rcv_msg+0x91/0xd0
[ 7822.835605]  [<ffffffff8141c299>] netlink_rcv_skb+0xa9/0xc0
[ 7822.835606]  [<ffffffff8141cc48>] genl_rcv+0x28/0x40
[ 7822.835608]  [<ffffffff8141b81d>] netlink_unicast+0xdd/0x190
[ 7822.835611]  [<ffffffff812968ad>] ? memcpy_fromiovec+0x4d/0x90
[ 7822.835613]  [<ffffffff8141bcdb>] netlink_sendmsg+0x35b/0x760
[ 7822.835616]  [<ffffffff81093b22>] ? default_wake_function+0x12/0x20
[ 7822.835620]  [<ffffffff813d6783>] sock_sendmsg+0xb3/0xd0
[ 7822.835623]  [<ffffffff8113291c>] ? find_get_page+0x5c/0x90
[ 7822.835626]  [<ffffffff81134c40>] ? filemap_fault+0x70/0x430
[ 7822.835631]  [<ffffffff81197126>] ? mem_cgroup_update_page_stat+0x16/0x50
[ 7822.835634]  [<ffffffff813d733c>] ___sys_sendmsg+0x36c/0x380
[ 7822.835651]  [<ffffffff8115dd5d>] ? handle_mm_fault+0x2bd/0x650
[ 7822.835654]  [<ffffffff813d8d91>] ? SyS_sendto+0x121/0x170
[ 7822.835657]  [<ffffffff813d9202>] __sys_sendmsg+0x42/0x80
[ 7822.835659]  [<ffffffff813d9252>] SyS_sendmsg+0x12/0x20
[ 7822.835662]  [<ffffffff814ea5dd>] system_call_fastpath+0x1a/0x1f
[ 7822.835664] ---[ end trace be7fe29c912fd23f ]---
[ 7824.836981] iwlwifi 0000:03:00.0: Error sending MAC_CONTEXT_CMD: time out after 2000ms.
[ 7824.836985] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 63
[ 7824.836987] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -110
[ 7824.836988] iwlwifi 0000:03:00.0: failed to update MAC 5c:51:4f:0d:82:ac
[ 7826.838635] iwlwifi 0000:03:00.0: Error sending REMOVE_STA: time out after 2000ms.
[ 7826.838639] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 64
[ 7826.838642] iwlwifi 0000:03:00.0: Failed to remove station. Id=1
[ 7826.838643] iwlwifi 0000:03:00.0: failed to remove AP station
[ 7828.840248] iwlwifi 0000:03:00.0: Error sending TIME_QUOTA_CMD: time out after 2000ms.
[ 7828.840252] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 65
[ 7828.840254] iwlwifi 0000:03:00.0: Failed to send quota: -110
[ 7828.840255] iwlwifi 0000:03:00.0: failed to update quotas
[ 7830.841889] iwlwifi 0000:03:00.0: Error sending POWER_TABLE_CMD: time out after 2000ms.
[ 7830.841893] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 66
[ 7830.841895] iwlwifi 0000:03:00.0: failed to update power mode
[ 7832.843498] iwlwifi 0000:03:00.0: Error sending MAC_CONTEXT_CMD: time out after 2000ms.
[ 7832.843501] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 67
[ 7832.843504] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -110
[ 7832.843506] iwlwifi 0000:03:00.0: failed to update MAC 5c:51:4f:0d:82:ac
[ 7834.845139] iwlwifi 0000:03:00.0: Error sending BINDING_CONTEXT_CMD: time out after 2000ms.
[ 7834.845143] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 68
[ 7834.845145] iwlwifi 0000:03:00.0: Failed to send binding (action:3): -110
[ 7836.900144] iwlwifi 0000:03:00.0: Error sending TXPATH_FLUSH: time out after 2000ms.
[ 7836.900147] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 69
[ 7836.900150] iwlwifi 0000:03:00.0: Failed to send flush command (-110)
[ 7838.901746] iwlwifi 0000:03:00.0: Error sending MAC_CONTEXT_CMD: time out after 2000ms.
[ 7838.901750] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 55 write_ptr 70
[ 7838.901752] iwlwifi 0000:03:00.0: Failed to remove MAC context: -110
[ 7841.817443] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
[ 7844.559422] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
[ 7847.345808] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
[ 7850.077841] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
[ 7852.757346] cfg80211: Calling CRDA to update world regulatory domain
[ 8023.976971] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 8024.029556] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 8030.083742] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[ 8030.083745] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[ 8030.083748] iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
[ 8032.790625] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
[ 8035.524712] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
[ 8038.311693] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
[ 8041.045362] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
[ 8041.045964] [sched_delayed] sched: RT throttling activated

--------------090405020004000801010700--
