Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42014 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3JFBt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 21:49:26 -0400
Received: by mail-vc0-f174.google.com with SMTP id gd11so2399237vcb.33
        for <linux-wireless@vger.kernel.org>; Sat, 05 Oct 2013 18:49:25 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 Oct 2013 21:49:25 -0400
Message-ID: <CAOAOC6YT=ek4S=s0YNqejD2iCdPYng6FnJ1ROegwWhmcVZhyOg@mail.gmail.com> (sfid-20131006_034933_662289_19A47C3B)
Subject: pci-half-mini 7206 ac/bluetooth issues
From: Tim Nelson <tim.l.nelson@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If I use both the wifi and the bluetooth at the same time on the
adapter eventually wifi dies.

Here is a complete log from my syslog, I rmmod'd the iwlmvm and then
modprobed it to resolve the issue.  This only happens when using
wifi/bluetooth at the same time.

Oct  5 21:11:28 nix-S405C whoopsie[1177]: online
Oct  5 21:11:53 nix-S405C kernel: [ 3381.041396] perf samples too long
(2527 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
Oct  5 21:12:01 nix-S405C whoopsie[1177]: online
Oct  5 21:13:18  whoopsie[1177]: last message repeated 2 times
Oct  5 21:14:11 nix-S405C whoopsie[1177]: online
Oct  5 21:15:19  whoopsie[1177]: last message repeated 2 times
Oct  5 21:16:48 nix-S405C kernel: [ 3676.130121] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:16:48 nix-S405C kernel: [ 3676.130418] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 236
Oct  5 21:16:48 nix-S405C kernel: [ 3676.130678] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:17:01 nix-S405C acpid: client 1157[0:0] has disconnected
Oct  5 21:17:01 nix-S405C acpid: client connected from 1157[0:0]
Oct  5 21:17:01 nix-S405C acpid: 1 client rule loaded
Oct  5 21:17:01 nix-S405C CRON[6025]: (root) CMD (   cd / && run-parts
--report /etc/cron.hourly)
Oct  5 21:18:09 nix-S405C NetworkManager[941]: <info> (wlan1):
disconnecting for new activation request.
Oct  5 21:18:09 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: activated -> disconnected (reason 'none') [100 30 0]
Oct  5 21:18:09 nix-S405C NetworkManager[941]: <info> (wlan1):
deactivating device (reason 'none') [0]
Oct  5 21:18:09 nix-S405C NetworkManager[941]: <info> (wlan1):
canceled DHCP transaction, DHCP client pid 4131
Oct  5 21:18:09 nix-S405C avahi-daemon[877]: Withdrawing address
record for fe80::e8b:fdff:fe32:dec6 on wlan1.
Oct  5 21:18:09 nix-S405C avahi-daemon[877]: Leaving mDNS multicast
group on interface wlan1.IPv6 with address fe80::e8b:fdff:fe32:dec6.
Oct  5 21:18:09 nix-S405C avahi-daemon[877]: Interface wlan1.IPv6 no
longer relevant for mDNS.
Oct  5 21:18:09 nix-S405C avahi-daemon[877]: Withdrawing address
record for 192.168.11.7 on wlan1.
Oct  5 21:18:09 nix-S405C avahi-daemon[877]: Leaving mDNS multicast
group on interface wlan1.IPv4 with address 192.168.11.7.
Oct  5 21:18:11 nix-S405C avahi-daemon[877]: Interface wlan1.IPv4 no
longer relevant for mDNS.
Oct  5 21:18:11 nix-S405C avahi-daemon[877]: Joining mDNS multicast
group on interface wlan1.IPv6 with address fe80::e8b:fdff:fe32:dec6.
Oct  5 21:18:11 nix-S405C avahi-daemon[877]: New relevant interface
wlan1.IPv6 for mDNS.
Oct  5 21:18:11 nix-S405C avahi-daemon[877]: Registering new address
record for fe80::e8b:fdff:fe32:dec6 on wlan1.*.
Oct  5 21:18:11 nix-S405C kernel: [ 3759.456601] iwlwifi 0000:02:00.0:
Error sending MAC_CONTEXT_CMD: time out after 2000ms.
Oct  5 21:18:11 nix-S405C kernel: [ 3759.456614] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 237
Oct  5 21:18:11 nix-S405C kernel: [ 3759.456622] iwlwifi 0000:02:00.0:
Failed to send MAC context (action:2): -110
Oct  5 21:18:11 nix-S405C kernel: [ 3759.456629] iwlwifi 0000:02:00.0:
failed to update MAC 0c:8b:fd:32:de:c6
Oct  5 21:18:11 nix-S405C kernel: [ 3759.456789] wlan1:
deauthenticating from b0:c7:45:36:60:10 by local choice (reason=3)
Oct  5 21:18:13 nix-S405C kernel: [ 3761.457552] iwlwifi 0000:02:00.0:
Error sending MAC_CONTEXT_CMD: time out after 2000ms.
Oct  5 21:18:13 nix-S405C kernel: [ 3761.457565] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 238
Oct  5 21:18:13 nix-S405C kernel: [ 3761.457573] iwlwifi 0000:02:00.0:
Failed to send MAC context (action:2): -110
Oct  5 21:18:13 nix-S405C kernel: [ 3761.457580] iwlwifi 0000:02:00.0:
failed to update MAC 0c:8b:fd:32:de:c6
Oct  5 21:18:15 nix-S405C kernel: [ 3763.458449] iwlwifi 0000:02:00.0:
Error sending POWER_TABLE_CMD: time out after 2000ms.
Oct  5 21:18:15 nix-S405C kernel: [ 3763.458463] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 239
Oct  5 21:18:15 nix-S405C kernel: [ 3763.458470] iwlwifi 0000:02:00.0:
failed to update power mode
Oct  5 21:18:17 nix-S405C kernel: [ 3765.459338] iwlwifi 0000:02:00.0:
Error sending ADD_STA: time out after 2000ms.
Oct  5 21:18:17 nix-S405C kernel: [ 3765.459352] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 240
Oct  5 21:18:17 nix-S405C kernel: [ 3765.459362] wlan1: HW problem -
can not stop rx aggregation for b0:c7:45:36:60:10 tid 0
Oct  5 21:18:19 nix-S405C kernel: [ 3767.460238] iwlwifi 0000:02:00.0:
Error sending ADD_STA: time out after 2000ms.
Oct  5 21:18:19 nix-S405C kernel: [ 3767.460259] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 241
Oct  5 21:18:19 nix-S405C kernel: [ 3767.460269] wlan1: failed to
remove key (0, b0:c7:45:36:60:10) from hardware (-110)
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461136] iwlwifi 0000:02:00.0:
Error sending REPLY_BEACON_FILTERING_CMD: time out after 2000ms.
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461148] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 242
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461155] ------------[ cut
here ]------------
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461183] WARNING: CPU: 1 PID:
4103 at /build/buildd/linux-3.11.0/drivers/net/wireless/iwlwifi/mvm/mac80211.c:1
047 iwl_mvm_mac_sta_state+0x21b/0x280 [iwlmvm]()
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461187] Modules linked in:
hidp hid pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF)
vboxdrv(OF) dm_crypt(F
) parport_pc(F) ppdev(F) bnep rfcomm joydev(F) binfmt_misc(F) uvcvideo
videobuf2_vmalloc videobuf2_memops asus_nb_wmi videobuf2_core asus_wmi
sparse_k
eymap videodev x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel(F) kvm(F) crc32_pclmul(F) aesni_intel(F) aes_i586(F) xts(F)
lrw(F) gf128mul(F)
 ablk_helper(F) cryptd(F) arc4(F) btusb iwlmvm mac80211 bluetooth
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep(F) sn
d_pcm(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F)
snd_rawmidi(F) microcode(F) psmouse(F) serio_raw(F) iwlwifi lpc_ich
rtsx_pci_ms memst
ick cfg80211 snd_seq(F) snd_seq_device(F) snd_timer(F) mei_me snd(F)
mei soundcore(F) mac_hid lp(F) parport(F) i915 rtsx_pci_sdmmc
i2c_algo_bit drm_km
s_helper drm ahci(F) libahci(F) r8169 wmi rtsx_pci mii(F) video(F)
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461315] CPU: 1 PID: 4103
Comm: wpa_supplicant Tainted: GF          O 3.11.0-11-generic
#17-Ubuntu
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461319] Hardware name:
ASUSTeK COMPUTER INC. K46CA/K46CA, BIOS K46CA.315 05/17/2013
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461324]  00000000 00000000
f0bf5a54 c16316eb 00000000 f0bf5a84 c105273e c1805cc4
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461338]  00000001 00001007
f90e6a98 00000417 f90ce89b f90ce89b f5c54c20 edc60de0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461351]  efdb1300 f0bf5a94
c1052802 00000009 00000000 f0bf5ad8 f90ce89b f1b27064
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461365] Call Trace:
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461380]  [<c16316eb>]
dump_stack+0x41/0x52
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461391]  [<c105273e>]
warn_slowpath_common+0x7e/0xa0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461408]  [<f90ce89b>] ?
iwl_mvm_mac_sta_state+0x21b/0x280 [iwlmvm]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461421]  [<f90ce89b>] ?
iwl_mvm_mac_sta_state+0x21b/0x280 [iwlmvm]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461430]  [<c1052802>]
warn_slowpath_null+0x22/0x30
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461443]  [<f90ce89b>]
iwl_mvm_mac_sta_state+0x21b/0x280 [iwlmvm]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461458]  [<f90ce680>] ?
iwl_mvm_mac_conf_tx+0x80/0x80 [iwlmvm]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461488]  [<f933cea6>]
sta_info_move_state+0x196/0x630 [mac80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461515]  [<f933d40a>]
__sta_info_destroy+0xca/0x330 [mac80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461553]  [<f9359d23>] ?
ieee80211_xmit+0x93/0xf0 [mac80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461580]  [<f933d77d>]
sta_info_flush_defer+0x6d/0x90 [mac80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461623]  [<f9370303>]
ieee80211_set_disassoc+0xa3/0x400 [mac80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461663]  [<f93743ca>]
ieee80211_mgd_deauth+0x1aa/0x210 [mac80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461699]  [<f934dbc6>]
ieee80211_deauth+0x16/0x20 [mac80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461735]  [<f8b9f3dd>]
cfg80211_mlme_deauth+0x8d/0x120 [cfg80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461745]  [<c1634f1d>] ?
__mutex_lock_slowpath+0x14d/0x180
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461776]  [<f8b8c334>]
nl80211_deauthenticate+0xd4/0x120 [cfg80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461808]  [<f8b8ab50>] ?
__cfg80211_wdev_from_attrs+0x180/0x180 [cfg80211]
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461818]  [<c157ff89>]
genl_rcv_msg+0x1e9/0x360
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461832]  [<c157fda0>] ?
__genl_register_family_with_ops+0x70/0x70
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461839]  [<c157e6b6>]
netlink_rcv_skb+0x86/0xa0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461846]  [<c157eb41>]
genl_rcv+0x21/0x30
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461853]  [<c157ddcf>]
netlink_unicast+0xbf/0x150
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461861]  [<c157e0b6>]
netlink_sendmsg+0x256/0x6c0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461871]  [<c1544d8b>]
sock_sendmsg+0x7b/0xb0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461883]  [<c1545091>]
___sys_sendmsg+0x291/0x2a0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461892]  [<c1117c36>] ?
unlock_page+0x46/0x50
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461902]  [<c11371e0>] ?
__do_fault+0x3f0/0x520
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461912]  [<c113a101>] ?
handle_pte_fault+0xa1/0x560
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461922]  [<c10631ca>] ?
signal_setup_done+0x3a/0x70
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461932]  [<c113b0ca>] ?
handle_mm_fault+0x22a/0x310
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461941]  [<c1545f28>]
__sys_sendmsg+0x38/0x70
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461951]  [<c1545f76>]
SyS_sendmsg+0x16/0x20
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461958]  [<c154665b>]
SyS_socketcall+0x29b/0x2f0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461968]  [<c100ed12>] ?
restore_sigcontext+0xf2/0x110
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461976]  [<c163b3d0>] ?
__do_page_fault+0x4f0/0x4f0
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461985]  [<c163ee0d>]
sysenter_do_call+0x12/0x28
Oct  5 21:18:21 nix-S405C kernel: [ 3769.461991] ---[ end trace
7ea9c88ab48819bc ]---
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462142] iwlwifi 0000:02:00.0:
Error sending TXPATH_FLUSH: time out after 2000ms.
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462155] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 243
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462163] iwlwifi 0000:02:00.0:
Failed to send flush command (-110)
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462169] ------------[ cut
here ]------------
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462212] WARNING: CPU: 0 PID:
4103 at /build/buildd/linux-3.11.0/net/mac80211/sta_info.c:839
__sta_info_destro
y+0x221/0x330 [mac80211]()
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462216] Modules linked in:
hidp hid pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF)
vboxdrv(OF) dm_crypt(F
) parport_pc(F) ppdev(F) bnep rfcomm joydev(F) binfmt_misc(F) uvcvideo
videobuf2_vmalloc videobuf2_memops asus_nb_wmi videobuf2_core asus_wmi
sparse_k
eymap videodev x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel(F) kvm(F) crc32_pclmul(F) aesni_intel(F) aes_i586(F) xts(F)
lrw(F) gf128mul(F)
 ablk_helper(F) cryptd(F) arc4(F) btusb iwlmvm mac80211 bluetooth
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep(F) sn
d_pcm(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F)
snd_rawmidi(F) microcode(F) psmouse(F) serio_raw(F) iwlwifi lpc_ich
rtsx_pci_ms memst
ick cfg80211 snd_seq(F) snd_seq_device(F) snd_timer(F) mei_me snd(F)
mei soundcore(F) mac_hid lp(F) parport(F) i915 rtsx_pci_sdmmc
i2c_algo_bit drm_km
s_helper drm ahci(F) libahci(F) r8169 wmi rtsx_pci mii(F) video(F)
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462349] CPU: 0 PID: 4103
Comm: wpa_supplicant Tainted: GF       W  O 3.11.0-11-generic
#17-Ubuntu
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462353] Hardware name:
ASUSTeK COMPUTER INC. K46CA/K46CA, BIOS K46CA.315 05/17/2013
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462357]  00000000 00000000
f0bf5ad8 c16316eb 00000000 f0bf5b08 c105273e c1805cc4
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462372]  00000000 00001007
f938da8c 00000347 f933d561 f933d561 efdb1000 f90ce680
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462386]  edc60360 f0bf5b18
c1052802 00000009 00000000 f0bf5b50 f933d561 00000001
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462399] Call Trace:
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462414]  [<c16316eb>]
dump_stack+0x41/0x52
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462425]  [<c105273e>]
warn_slowpath_common+0x7e/0xa0
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462456]  [<f933d561>] ?
__sta_info_destroy+0x221/0x330 [mac80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462481]  [<f933d561>] ?
__sta_info_destroy+0x221/0x330 [mac80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462497]  [<f90ce680>] ?
iwl_mvm_mac_conf_tx+0x80/0x80 [iwlmvm]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462506]  [<c1052802>]
warn_slowpath_null+0x22/0x30
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462531]  [<f933d561>]
__sta_info_destroy+0x221/0x330 [mac80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462558]  [<f933d77d>]
sta_info_flush_defer+0x6d/0x90 [mac80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462622]  [<f9370303>]
ieee80211_set_disassoc+0xa3/0x400 [mac80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462664]  [<f93743ca>]
ieee80211_mgd_deauth+0x1aa/0x210 [mac80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462701]  [<f934dbc6>]
ieee80211_deauth+0x16/0x20 [mac80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462743]  [<f8b9f3dd>]
cfg80211_mlme_deauth+0x8d/0x120 [cfg80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462756]  [<c1634f1d>] ?
__mutex_lock_slowpath+0x14d/0x180
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462789]  [<f8b8c334>]
nl80211_deauthenticate+0xd4/0x120 [cfg80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462822]  [<f8b8ab50>] ?
__cfg80211_wdev_from_attrs+0x180/0x180 [cfg80211]
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462832]  [<c157ff89>]
genl_rcv_msg+0x1e9/0x360
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462846]  [<c157fda0>] ?
__genl_register_family_with_ops+0x70/0x70
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462854]  [<c157e6b6>]
netlink_rcv_skb+0x86/0xa0
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462861]  [<c157eb41>]
genl_rcv+0x21/0x30
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462868]  [<c157ddcf>]
netlink_unicast+0xbf/0x150
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462876]  [<c157e0b6>]
netlink_sendmsg+0x256/0x6c0
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462887]  [<c1544d8b>]
sock_sendmsg+0x7b/0xb0
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462898]  [<c1545091>]
___sys_sendmsg+0x291/0x2a0
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462908]  [<c1117c36>] ?
unlock_page+0x46/0x50
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462918]  [<c11371e0>] ?
__do_fault+0x3f0/0x520
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462929]  [<c113a101>] ?
handle_pte_fault+0xa1/0x560
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462940]  [<c10631ca>] ?
signal_setup_done+0x3a/0x70
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462949]  [<c113b0ca>] ?
handle_mm_fault+0x22a/0x310
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462959]  [<c1545f28>]
__sys_sendmsg+0x38/0x70
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462969]  [<c1545f76>]
SyS_sendmsg+0x16/0x20
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462975]  [<c154665b>]
SyS_socketcall+0x29b/0x2f0
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462985]  [<c100ed12>] ?
restore_sigcontext+0xf2/0x110
Oct  5 21:18:23 nix-S405C kernel: [ 3771.462994]  [<c163b3d0>] ?
__do_page_fault+0x4f0/0x4f0
Oct  5 21:18:23 nix-S405C kernel: [ 3771.463003]  [<c163ee0d>]
sysenter_do_call+0x12/0x28
Oct  5 21:18:23 nix-S405C kernel: [ 3771.463009] ---[ end trace
7ea9c88ab48819bd ]---
Oct  5 21:18:25 nix-S405C kernel: [ 3773.463062] iwlwifi 0000:02:00.0:
Error sending MAC_CONTEXT_CMD: time out after 2000ms.
Oct  5 21:18:25 nix-S405C kernel: [ 3773.463076] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 244
Oct  5 21:18:25 nix-S405C kernel: [ 3773.463083] iwlwifi 0000:02:00.0:
Failed to send MAC context (action:2): -110
Oct  5 21:18:25 nix-S405C kernel: [ 3773.463090] iwlwifi 0000:02:00.0:
failed to update MAC 0c:8b:fd:32:de:c6
Oct  5 21:18:27 nix-S405C kernel: [ 3775.463990] iwlwifi 0000:02:00.0:
Error sending REMOVE_STA: time out after 2000ms.
Oct  5 21:18:27 nix-S405C kernel: [ 3775.464004] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 245
Oct  5 21:18:27 nix-S405C kernel: [ 3775.464012] iwlwifi 0000:02:00.0:
Failed to remove station. Id=1
Oct  5 21:18:27 nix-S405C kernel: [ 3775.464017] iwlwifi 0000:02:00.0:
failed to remove AP station
Oct  5 21:18:29 nix-S405C kernel: [ 3777.464912] iwlwifi 0000:02:00.0:
Error sending TIME_QUOTA_CMD: time out after 2000ms.
Oct  5 21:18:29 nix-S405C kernel: [ 3777.464925] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 246
Oct  5 21:18:29 nix-S405C kernel: [ 3777.464932] iwlwifi 0000:02:00.0:
Failed to send quota: -110
Oct  5 21:18:29 nix-S405C kernel: [ 3777.464938] iwlwifi 0000:02:00.0:
failed to update quotas
Oct  5 21:18:31 nix-S405C kernel: [ 3779.465741] iwlwifi 0000:02:00.0:
Error sending POWER_TABLE_CMD: time out after 2000ms.
Oct  5 21:18:31 nix-S405C kernel: [ 3779.465880] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 247
Oct  5 21:18:31 nix-S405C kernel: [ 3779.465993] iwlwifi 0000:02:00.0:
failed to update power mode
Oct  5 21:18:33 nix-S405C kernel: [ 3781.466757] iwlwifi 0000:02:00.0:
Error sending MAC_CONTEXT_CMD: time out after 2000ms.
Oct  5 21:18:33 nix-S405C kernel: [ 3781.466898] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 248
Oct  5 21:18:33 nix-S405C kernel: [ 3781.467032] iwlwifi 0000:02:00.0:
Failed to send MAC context (action:2): -110
Oct  5 21:18:33 nix-S405C kernel: [ 3781.467157] iwlwifi 0000:02:00.0:
failed to update MAC 0c:8b:fd:32:de:c6
Oct  5 21:18:35 nix-S405C kernel: [ 3783.467682] iwlwifi 0000:02:00.0:
Error sending BINDING_CONTEXT_CMD: time out after 2000ms.
Oct  5 21:18:35 nix-S405C kernel: [ 3783.467827] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 249
Oct  5 21:18:35 nix-S405C kernel: [ 3783.467941] iwlwifi 0000:02:00.0:
Failed to send binding (action:3): -110
Oct  5 21:18:35 nix-S405C wpa_supplicant[4103]: wlan1:
CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
Oct  5 21:18:35 nix-S405C kernel: [ 3783.472205] cfg80211: Calling
CRDA to update world regulatory domain
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <warn> DNS: plugin
dnsmasq update failed
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> Removing DNS
information from /sbin/resolvconf
Oct  5 21:18:35 nix-S405C dnsmasq[1848]: setting upstream servers from DBus
Oct  5 21:18:35 nix-S405C kernel: [ 3783.484992] cfg80211: World
regulatory domain updated:
Oct  5 21:18:35 nix-S405C kernel: [ 3783.484996] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Oct  5 21:18:35 nix-S405C kernel: [ 3783.484999] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  5 21:18:35 nix-S405C kernel: [ 3783.485002] cfg80211:   (2457000
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  5 21:18:35 nix-S405C kernel: [ 3783.485005] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Oct  5 21:18:35 nix-S405C kernel: [ 3783.485007] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  5 21:18:35 nix-S405C kernel: [ 3783.485009] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  5 21:18:35 nix-S405C whoopsie[1177]: offline
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) starting connection 'dev_null'
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: disconnected -> prepare (reason 'none') [30 40 0]
Oct  5 21:18:35 nix-S405C dbus[691]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: completed -> disconnected
Oct  5 21:18:35 nix-S405C whoopsie[1177]: offline
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) started...
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) scheduled...
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) complete.
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) starting...
Oct  5 21:18:35 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: prepare -> config (reason 'none') [40 50 0]
Oct  5 21:18:35 nix-S405C dbus[691]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1/wireless): access point 'dev_null' has security, but secrets
are required.
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: config -> need-auth (reason 'none') [50 60 0]
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) complete.
Oct  5 21:18:37 nix-S405C kernel: [ 3785.580656] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:37 nix-S405C kernel: [ 3785.580797] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 250
Oct  5 21:18:37 nix-S405C kernel: [ 3785.580912] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) started...
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: need-auth -> prepare (reason 'none') [60 40 0]
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) scheduled...
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) complete.
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) starting...
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: prepare -> config (reason 'none') [40 50 0]
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1/wireless): connection 'dev_null' has security, and secrets
exist.  No new secr
ets needed.
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Config: added
'ssid' value 'dev_null'
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Config: added
'scan_ssid' value '1'
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Config: added
'auth_alg' value 'OPEN'
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Config: added
'psk' value '<omitted>'
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) complete.
Oct  5 21:18:37 nix-S405C NetworkManager[941]: <info> Config: set
interface ap_scan to 1
Oct  5 21:18:39 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:18:39 nix-S405C kernel: [ 3787.641610] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:39 nix-S405C kernel: [ 3787.641753] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 251
Oct  5 21:18:39 nix-S405C kernel: [ 3787.641869] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:41 nix-S405C acpid: client 1157[0:0] has disconnected
Oct  5 21:18:41 nix-S405C acpid: client connected from 1157[0:0]
Oct  5 21:18:41 nix-S405C acpid: 1 client rule loaded
Oct  5 21:18:42 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:18:42 nix-S405C kernel: [ 3790.642990] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:42 nix-S405C kernel: [ 3790.643003] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 252
Oct  5 21:18:42 nix-S405C kernel: [ 3790.643011] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:45 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:18:45 nix-S405C kernel: [ 3793.644349] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:45 nix-S405C kernel: [ 3793.644371] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 253
Oct  5 21:18:45 nix-S405C kernel: [ 3793.644380] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:48 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:18:48 nix-S405C kernel: [ 3796.645707] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:48 nix-S405C kernel: [ 3796.645751] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 254
Oct  5 21:18:48 nix-S405C kernel: [ 3796.645756] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:51 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:18:51 nix-S405C kernel: [ 3799.647126] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:51 nix-S405C kernel: [ 3799.647142] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 255
Oct  5 21:18:51 nix-S405C kernel: [ 3799.647152] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:53 nix-S405C NetworkManager[941]: <info> (wlan1):
disconnecting for new activation request.
Oct  5 21:18:53 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: config -> disconnected (reason 'none') [50 30 0]
Oct  5 21:18:53 nix-S405C NetworkManager[941]: <info> (wlan1):
deactivating device (reason 'none') [0]
Oct  5 21:18:54 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) starting connection 'Auto DEV_NULL'
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: disconnected -> prepare (reason 'none') [30 40 0]
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) started...
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) scheduled...
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) complete.
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) starting...
Oct  5 21:18:54 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: prepare -> config (reason 'none') [40 50 0]
Oct  5 21:18:54 nix-S405C kernel: [ 3802.648414] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:54 nix-S405C kernel: [ 3802.648421] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 0
Oct  5 21:18:54 nix-S405C kernel: [ 3802.648424] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:54 nix-S405C whoopsie[1177]: offline
Oct  5 21:18:54 nix-S405C whoopsie[1177]: offline
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1/wireless): access point 'Auto DEV_NULL' has security, but
secrets are required
.
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: config -> need-auth (reason 'none') [50 60 0]
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) complete.
Oct  5 21:18:56 nix-S405C kernel: [ 3804.649435] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:56 nix-S405C kernel: [ 3804.649449] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 1
Oct  5 21:18:56 nix-S405C kernel: [ 3804.649457] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: disconnected -> inactive
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) started...
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: need-auth -> prepare (reason 'none') [60 40 0]
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) scheduled...
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) complete.
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) starting...
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: prepare -> config (reason 'none') [40 50 0]
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1/wireless): connection 'Auto DEV_NULL' has security, and secrets
exist.  No new
 secrets needed.
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Config: added
'ssid' value 'DEV_NULL'
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Config: added
'scan_ssid' value '1'
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Config: added
'auth_alg' value 'OPEN'
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Config: added
'psk' value '<omitted>'
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) complete.
Oct  5 21:18:56 nix-S405C NetworkManager[941]: <info> Config: set
interface ap_scan to 1
Oct  5 21:18:58 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:18:58 nix-S405C kernel: [ 3806.702405] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:18:58 nix-S405C kernel: [ 3806.702419] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 2
Oct  5 21:18:58 nix-S405C kernel: [ 3806.702427] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:19:01 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:19:01 nix-S405C kernel: [ 3809.703773] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:19:01 nix-S405C kernel: [ 3809.703787] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 3
Oct  5 21:19:01 nix-S405C kernel: [ 3809.703795] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:19:04 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: config -> unavailable (reason 'none') [50 20 0]
Oct  5 21:19:04 nix-S405C NetworkManager[941]: <info> (wlan1):
deactivating device (reason 'none') [0]
Oct  5 21:19:04 nix-S405C wpa_supplicant[4103]: wlan1: Failed to
initiate AP scan
Oct  5 21:19:04 nix-S405C NetworkManager[941]: <info> (wlan1): taking
down device.
Oct  5 21:19:04 nix-S405C whoopsie[1177]: offline
Oct  5 21:19:04 nix-S405C kernel: [ 3812.705056] iwlwifi 0000:02:00.0:
Error sending SCAN_REQUEST_CMD: time out after 2000ms.
Oct  5 21:19:04 nix-S405C kernel: [ 3812.705062] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 4
Oct  5 21:19:04 nix-S405C kernel: [ 3812.705067] iwlwifi 0000:02:00.0:
Scan failed! status 0x1 ret -110
Oct  5 21:19:06 nix-S405C kernel: [ 3814.734060] iwlwifi 0000:02:00.0:
Error sending TXPATH_FLUSH: time out after 2000ms.
Oct  5 21:19:06 nix-S405C kernel: [ 3814.734073] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 5
Oct  5 21:19:06 nix-S405C kernel: [ 3814.734081] iwlwifi 0000:02:00.0:
Failed to send flush command (-110)
Oct  5 21:19:08 nix-S405C kernel: [ 3816.735032] iwlwifi 0000:02:00.0:
Error sending MAC_CONTEXT_CMD: time out after 2000ms.
Oct  5 21:19:08 nix-S405C kernel: [ 3816.735051] iwlwifi 0000:02:00.0:
Current CMD queue read_ptr 235 write_ptr 6
Oct  5 21:19:08 nix-S405C kernel: [ 3816.735058] iwlwifi 0000:02:00.0:
Failed to remove MAC context: -110
Oct  5 21:19:08 nix-S405C kernel: [ 3816.742152] iwlwifi 0000:02:00.0:
Failing on timeout while stopping DMA channel 1 [0xa5a5a5a2]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.747865] iwlwifi 0000:02:00.0:
Failing on timeout while stopping DMA channel 3 [0xa5a5a5a2]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.753501] iwlwifi 0000:02:00.0:
Failing on timeout while stopping DMA channel 4 [0xa5a5a5a2]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.759220] iwlwifi 0000:02:00.0:
Failing on timeout while stopping DMA channel 6 [0xa5a5a5a2]
Oct  5 21:19:08 nix-S405C avahi-daemon[877]: Interface wlan1.IPv6 no
longer relevant for mDNS.
Oct  5 21:19:08 nix-S405C avahi-daemon[877]: Leaving mDNS multicast
group on interface wlan1.IPv6 with address fe80::e8b:fdff:fe32:dec6.
Oct  5 21:19:08 nix-S405C avahi-daemon[877]: Withdrawing address
record for fe80::e8b:fdff:fe32:dec6 on wlan1.
Oct  5 21:19:08 nix-S405C NetworkManager[941]: <info> WiFi hardware
radio set disabled
Oct  5 21:19:08 nix-S405C NetworkManager[941]: <info> WiFi now
disabled by radio killswitch
Oct  5 21:19:08 nix-S405C kernel: [ 3816.760528] iwlwifi 0000:02:00.0:
RF_KILL bit toggled to disable radio.
Oct  5 21:19:08 nix-S405C NetworkManager[941]: <info> (wlan1):
bringing up device.
Oct  5 21:19:08 nix-S405C NetworkManager[941]: <info> WiFi hardware
radio set enabled
Oct  5 21:19:08 nix-S405C NetworkManager[941]: <info> WiFi now enabled
by radio killswitch
Oct  5 21:19:08 nix-S405C NetworkManager[941]: <info> (wlan1):
bringing up device.
Oct  5 21:19:08 nix-S405C kernel: [ 3816.848619] iwlwifi 0000:02:00.0:
RF_KILL bit toggled to enable radio.
Oct  5 21:19:08 nix-S405C kernel: [ 3816.849211] iwlwifi 0000:02:00.0:
L1 Disabled; Enabling L0S
Oct  5 21:19:08 nix-S405C kernel: [ 3816.849358] iwlwifi 0000:02:00.0:
L1 Disabled; Enabling L0S
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857479] ------------[ cut
here ]------------
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857528] WARNING: CPU: 0 PID:
941 at /build/buildd/linux-3.11.0/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c:10
33 iwl_mvm_mac_ctxt_add+0x87/0xa0 [iwlmvm]()
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857537] Adding active MAC
0c:8b:fd:32:de:c6/2
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857542] Modules linked in:
hidp hid pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF)
vboxdrv(OF) dm_crypt(F
) parport_pc(F) ppdev(F) bnep rfcomm joydev(F) binfmt_misc(F) uvcvideo
videobuf2_vmalloc videobuf2_memops asus_nb_wmi videobuf2_core asus_wmi
sparse_k
eymap videodev x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel(F) kvm(F) crc32_pclmul(F) aesni_intel(F) aes_i586(F) xts(F)
lrw(F) gf128mul(F)
 ablk_helper(F) cryptd(F) arc4(F) btusb iwlmvm mac80211 bluetooth
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep(F) sn
d_pcm(F) snd_page_alloc(F) snd_seq_midi(F) snd_seq_midi_event(F)
snd_rawmidi(F) microcode(F) psmouse(F) serio_raw(F) iwlwifi lpc_ich
rtsx_pci_ms memst
ick cfg80211 snd_seq(F) snd_seq_device(F) snd_timer(F) mei_me snd(F)
mei soundcore(F) mac_hid lp(F) parport(F) i915 rtsx_pci_sdmmc
i2c_algo_bit drm_km
s_helper drm ahci(F) libahci(F) r8169 wmi rtsx_pci mii(F) video(F)
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857728] CPU: 0 PID: 941 Comm:
NetworkManager Tainted: GF       W  O 3.11.0-11-generic #17-Ubuntu
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857736] Hardware name:
ASUSTeK COMPUTER INC. K46CA/K46CA, BIOS K46CA.315 05/17/2013
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857742]  00000000 00000000
ef4bd9b8 c16316eb ef4bd9f8 ef4bd9e8 c105273e f90e958f
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857763]  ef4bda14 000003ad
f90e7000 00000409 f90d2567 f90d2567 f5c54cf4 f5c54c20
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857782]  00000000 ef4bda00
c1052793 00000009 ef4bd9f8 f90e958f ef4bda14 ef4bda20
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857803] Call Trace:
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857821]  [<c16316eb>]
dump_stack+0x41/0x52
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857837]  [<c105273e>]
warn_slowpath_common+0x7e/0xa0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857867]  [<f90d2567>] ?
iwl_mvm_mac_ctxt_add+0x87/0xa0 [iwlmvm]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857888]  [<f90d2567>] ?
iwl_mvm_mac_ctxt_add+0x87/0xa0 [iwlmvm]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857900]  [<c1052793>]
warn_slowpath_fmt+0x33/0x40
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857922]  [<f90d2567>]
iwl_mvm_mac_ctxt_add+0x87/0xa0 [iwlmvm]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857945]  [<f90cf111>]
iwl_mvm_mac_add_interface+0xa1/0x240 [iwlmvm]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.857999]  [<f93485d7>] ?
ieee80211_del_virtual_monitor.part.17+0xf7/0x170 [mac80211]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858012]  [<c151a17d>] ?
led_set_brightness+0x4d/0x60
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858023]  [<c151ab8d>] ?
led_trigger_event+0x3d/0x60
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858072]  [<f9349a61>]
ieee80211_do_open+0x331/0xc20 [mac80211]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858085]  [<c163b421>] ?
notifier_call_chain+0x41/0x60
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858133]  [<f934a3ad>]
ieee80211_open+0x5d/0x60 [mac80211]
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858148]  [<c155ac6b>]
__dev_open+0x9b/0x120
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858162]  [<c1637946>] ?
_raw_spin_unlock_bh+0x16/0x20
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858174]  [<c155aef1>]
__dev_change_flags+0x81/0x160
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858186]  [<c155b078>]
dev_change_flags+0x18/0x50
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858199]  [<c1567370>]
do_setlink+0x2e0/0x820
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858214]  [<c1084e7a>] ?
update_curr+0xaa/0x1f0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858231]  [<c130f4c2>] ?
nla_parse+0x22/0xa0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858243]  [<c1568468>]
rtnl_newlink+0x388/0x570
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858262]  [<c127bff4>] ?
security_sock_rcv_skb+0x14/0x20
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858274]  [<c1569fa1>] ?
sk_filter+0x21/0x90
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858287]  [<c12b1870>] ?
apparmor_capable+0x20/0xb0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858299]  [<c127c81c>] ?
security_capable+0x1c/0x30
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858310]  [<c1565118>]
rtnetlink_rcv_msg+0x88/0x1f0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858326]  [<c1158a96>] ?
__kmalloc_track_caller+0x46/0x150
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858338]  [<c154cb20>] ?
__alloc_skb+0x60/0x270
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858348]  [<c1565090>] ?
rtnetlink_rcv+0x30/0x30
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858360]  [<c157e6b6>]
netlink_rcv_skb+0x86/0xa0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858370]  [<c1565081>]
rtnetlink_rcv+0x21/0x30
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858380]  [<c157ddcf>]
netlink_unicast+0xbf/0x150
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858390]  [<c157e0b6>]
netlink_sendmsg+0x256/0x6c0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858401]  [<c157b42b>] ?
netlink_rcv_wake+0x3b/0x50
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858415]  [<c1544d8b>]
sock_sendmsg+0x7b/0xb0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858432]  [<c1545091>]
___sys_sendmsg+0x291/0x2a0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858445]  [<c15450a0>] ?
___sys_sendmsg+0x2a0/0x2a0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858464]  [<c15457ee>] ?
SYSC_sendto+0x10e/0x130
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858470]  [<c111e2be>] ?
free_pages.part.69+0x1e/0x20
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858474]  [<c1178241>] ?
do_filp_open+0x31/0x80
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858478]  [<c1545f28>]
__sys_sendmsg+0x38/0x70
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858483]  [<c1545f76>]
SyS_sendmsg+0x16/0x20
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858486]  [<c154665b>]
SyS_socketcall+0x29b/0x2f0
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858491]  [<c1055f93>] ?
SyS_time+0x13/0x50
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858496]  [<c163ee0d>]
sysenter_do_call+0x12/0x28
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858499]  [<c163007b>] ?
alignfile+0x4/0x8c
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858503]  [<c1630000>] ?
create_elf_tables+0x3dd/0x454
Oct  5 21:19:08 nix-S405C kernel: [ 3816.858505] ---[ end trace
7ea9c88ab48819be ]---
Oct  5 21:19:59 nix-S405C avahi-daemon[877]: Withdrawing workstation
service for wlan1.
Oct  5 21:19:59 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: unavailable -> unmanaged (reason 'removed') [20 10 36]
Oct  5 21:19:59 nix-S405C NetworkManager[941]: <info> (wlan1): cleaning up...
Oct  5 21:19:59 nix-S405C NetworkManager[941]: <warn> (3) failed to
find interface name for index
Oct  5 21:19:59 nix-S405C NetworkManager[941]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Oct  5 21:19:59 nix-S405C NetworkManager[941]: <error>
[1381022399.841749] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get int
erface link object
Oct  5 21:19:59 nix-S405C NetworkManager[941]: <info> Unmanaged Device
found; state CONNECTED forced.
(seehttp://bugs.launchpad.net/bugs/191889)
Oct  5 21:19:59 nix-S405C NetworkManager[941]: <info> Unmanaged Device
found; state CONNECTED forced.
(seehttp://bugs.launchpad.net/bugs/191889)
Oct  5 21:19:59 nix-S405C NetworkManager[941]:    SCPlugin-Ifupdown:
devices removed (path:
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan
1, iface: wlan1)
Oct  5 21:19:59 nix-S405C NetworkManager[941]: <info> radio killswitch
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/ieee80211/phy0/rfkill1
disapp
eared
Oct  5 21:19:59 nix-S405C whoopsie[1177]: offline
Oct  5 21:20:11 nix-S405C kernel: [ 3879.136181] iwlwifi 0000:02:00.0:
Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
Oct  5 21:20:11 nix-S405C kernel: [ 3879.136247] iwlwifi 0000:02:00.0:
L1 Disabled; Enabling L0S
Oct  5 21:20:11 nix-S405C kernel: [ 3879.136391] iwlwifi 0000:02:00.0:
L1 Disabled; Enabling L0S
Oct  5 21:20:11 nix-S405C kernel: [ 3879.357359] ieee80211 phy1:
Selected rate control algorithm 'iwl-mvm-rs'
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> rfkill3: found
WiFi radio killswitch (at
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/ieee8
0211/phy1/rfkill3) (driver iwlwifi)
Oct  5 21:20:11 nix-S405C NetworkManager[941]:    SCPlugin-Ifupdown:
devices added (path:
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan1,
 iface: wlan1)
Oct  5 21:20:11 nix-S405C NetworkManager[941]:    SCPlugin-Ifupdown:
device added (path:
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan1,
iface: wlan1): no ifupdown configuration found.
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1): using
nl80211 for WiFi device control
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1): driver
supports Access Point (AP) mode
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1): new
802.11 WiFi device (driver: 'iwlwifi' ifindex: 4)
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1):
exported as /org/freedesktop/NetworkManager/Devices/2
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1):
bringing up device.
Oct  5 21:20:11 nix-S405C kernel: [ 3879.374415] iwlwifi 0000:02:00.0:
L1 Disabled; Enabling L0S
Oct  5 21:20:11 nix-S405C kernel: [ 3879.374578] iwlwifi 0000:02:00.0:
L1 Disabled; Enabling L0S
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1): preparing device.
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1):
deactivating device (reason 'managed') [2]
Oct  5 21:20:11 nix-S405C kernel: [ 3879.388900] IPv6:
ADDRCONF(NETDEV_UP): wlan1: link is not ready
Oct  5 21:20:11 nix-S405C kernel: [ 3879.389334] IPv6:
ADDRCONF(NETDEV_UP): wlan1: link is not ready
Oct  5 21:20:11 nix-S405C whoopsie[1177]: offline
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1) supports
5 scan SSIDs
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <warn> Trying to remove
a non-existant call id.
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: starting -> ready
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: unavailable -> disconnected (reason
'supplicant-available') [20 30
 42]
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: ready -> inactive
Oct  5 21:20:11 nix-S405C NetworkManager[941]: <info> (wlan1) supports
5 scan SSIDs
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Auto-activating
connection 'dev_null'.
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) starting connection 'dev_null'
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: disconnected -> prepare (reason 'none') [30 40 0]
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) scheduled...
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) started...
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) scheduled...
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 1 of 5 (Device Prepare) complete.
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) starting...
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: prepare -> config (reason 'none') [40 50 0]
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1/wireless): connection 'dev_null' has security, and secrets
exist.  No new secr
ets needed.
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Config: added
'ssid' value 'dev_null'
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Config: added
'scan_ssid' value '1'
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Config: added
'auth_alg' value 'OPEN'
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Config: added
'psk' value '<omitted>'
Oct  5 21:20:14 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 2 of 5 (Device Configure) complete.
Oct  5 21:20:14 nix-S405C whoopsie[1177]: offline
Oct  5 21:20:15 nix-S405C NetworkManager[941]: <info> Config: set
interface ap_scan to 1
Oct  5 21:20:15 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: inactive -> scanning
Oct  5 21:20:18 nix-S405C wpa_supplicant[4103]: wlan1: SME: Trying to
authenticate with b0:c7:45:36:60:15 (SSID='dev_null' freq=5200 MHz)
Oct  5 21:20:18 nix-S405C kernel: [ 3886.797549] wlan1: authenticate
with b0:c7:45:36:60:15
Oct  5 21:20:18 nix-S405C kernel: [ 3886.798934] wlan1: send auth to
b0:c7:45:36:60:15 (try 1/3)
Oct  5 21:20:18 nix-S405C wpa_supplicant[4103]: wlan1: Trying to
associate with b0:c7:45:36:60:15 (SSID='dev_null' freq=5200 MHz)
Oct  5 21:20:18 nix-S405C kernel: [ 3886.799532] wlan1: authenticated
Oct  5 21:20:18 nix-S405C kernel: [ 3886.803298] wlan1: associate with
b0:c7:45:36:60:15 (try 1/3)
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: scanning -> authenticating
Oct  5 21:20:18 nix-S405C wpa_supplicant[4103]: wlan1: Associated with
b0:c7:45:36:60:15
Oct  5 21:20:18 nix-S405C kernel: [ 3886.809688] wlan1: RX AssocResp
from b0:c7:45:36:60:15 (capab=0x11 status=0 aid=2)
Oct  5 21:20:18 nix-S405C kernel: [ 3886.810521] wlan1: associated
Oct  5 21:20:18 nix-S405C kernel: [ 3886.810548] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: authenticating -> associating
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: associating -> 4-way handshake
Oct  5 21:20:18 nix-S405C wpa_supplicant[4103]: wlan1: WPA: Key
negotiation completed with b0:c7:45:36:60:15 [PTK=CCMP GTK=CCMP]
Oct  5 21:20:18 nix-S405C wpa_supplicant[4103]: wlan1:
CTRL-EVENT-CONNECTED - Connection to b0:c7:45:36:60:15 completed
(auth) [id=0 id_str=]
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> (wlan1):
supplicant interface state: 4-way handshake -> completed
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless n
etwork 'dev_null'.
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 3 of 5 (IP Configure Start) scheduled.
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 3 of 5 (IP Configure Start) started...
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: config -> ip-config (reason 'none') [50 70 0]
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Beginning DHCPv4 transaction (timeout in 45 seconds)
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> dhclient started
with pid 6242
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Beginning IP6 addrconf.
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 3 of 5 (IP Configure Start) complete.
Oct  5 21:20:18 nix-S405C dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Oct  5 21:20:18 nix-S405C dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Oct  5 21:20:18 nix-S405C dhclient: All rights reserved.
Oct  5 21:20:18 nix-S405C dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Oct  5 21:20:18 nix-S405C dhclient:
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> (wlan1): DHCPv4
state changed nbi -> preinit
Oct  5 21:20:18 nix-S405C dhclient: Listening on LPF/wlan1/0c:8b:fd:32:de:c6
Oct  5 21:20:18 nix-S405C dhclient: Sending on   LPF/wlan1/0c:8b:fd:32:de:c6
Oct  5 21:20:18 nix-S405C dhclient: Sending on   Socket/fallback
Oct  5 21:20:18 nix-S405C dhclient: DHCPREQUEST of 192.168.11.7 on
wlan1 to 255.255.255.255 port 67 (xid=0x4d5eabeb)
Oct  5 21:20:18 nix-S405C dhclient: DHCPACK of 192.168.11.7 from 192.168.11.1
Oct  5 21:20:18 nix-S405C dhclient: bound to 192.168.11.7 -- renewal
in 82225 seconds.
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> (wlan1): DHCPv4
state changed preinit -> reboot
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info>   address 192.168.11.7
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info>   prefix 24
(255.255.255.0)
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info>   gateway 192.168.11.1
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info>   nameserver
'192.168.11.1'
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Oct  5 21:20:18 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 5 of 5 (IPv4 Commit) started...
Oct  5 21:20:18 nix-S405C avahi-daemon[877]: Joining mDNS multicast
group on interface wlan1.IPv4 with address 192.168.11.7.
Oct  5 21:20:18 nix-S405C avahi-daemon[877]: New relevant interface
wlan1.IPv4 for mDNS.
Oct  5 21:20:18 nix-S405C avahi-daemon[877]: Registering new address
record for 192.168.11.7 on wlan1.IPv4.
Oct  5 21:20:19 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: ip-config -> secondaries (reason 'none') [70 90 0]
Oct  5 21:20:19 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 5 of 5 (IPv4 Commit) complete.
Oct  5 21:20:19 nix-S405C NetworkManager[941]: <info> (wlan1): device
state change: secondaries -> activated (reason 'none') [90 100 0]
Oct  5 21:20:19 nix-S405C NetworkManager[941]: <info> Policy set
'dev_null' (wlan1) as default for IPv4 routing and DNS.
Oct  5 21:20:19 nix-S405C NetworkManager[941]: <info> Writing DNS
information to /sbin/resolvconf
Oct  5 21:20:19 nix-S405C dnsmasq[1848]: setting upstream servers from DBus
Oct  5 21:20:19 nix-S405C dnsmasq[1848]: using nameserver 192.168.11.1#53
Oct  5 21:20:20 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) successful, device activated.
Oct  5 21:20:20 nix-S405C dbus[691]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Oct  5 21:20:20 nix-S405C dbus[691]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Oct  5 21:20:20 nix-S405C whoopsie[1177]: offline
Oct  5 21:20:20 nix-S405C avahi-daemon[877]: Joining mDNS multicast
group on interface wlan1.IPv6 with address fe80::e8b:fdff:fe32:dec6.
Oct  5 21:20:20 nix-S405C avahi-daemon[877]: New relevant interface
wlan1.IPv6 for mDNS.
Oct  5 21:20:20 nix-S405C avahi-daemon[877]: Registering new address
record for fe80::e8b:fdff:fe32:dec6 on wlan1.*.
Oct  5 21:20:20 nix-S405C whoopsie[1177]: online
Oct  5 21:20:21 nix-S405C whoopsie[1177]: online
Oct  5 21:20:26 nix-S405C ntpdate[6338]: adjust time server
91.189.94.4 offset 0.073376 sec
Oct  5 21:20:32 nix-S405C whoopsie[1177]: online
Oct  5 21:20:39 nix-S405C NetworkManager[941]: <info> (wlan1): IP6
addrconf timed out or failed.
Oct  5 21:20:39 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Oct  5 21:20:39 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 4 of 5 (IPv6 Configure Timeout) started...
Oct  5 21:20:39 nix-S405C NetworkManager[941]: <info> Activation
(wlan1) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Oct  5 21:21:31 nix-S405C whoopsie[1177]: online
Oct  5 21:22:49  whoopsie[1177]: last message repeated 5 times
