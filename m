Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33186 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdB1Uvc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 15:51:32 -0500
Received: by mail-io0-f176.google.com with SMTP id f84so16672906ioj.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 12:51:18 -0800 (PST)
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
To: sara.sharon@intel.com
References: <c60e6859-f1ec-6656-2625-b5ce5f18059a@kernel.dk>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        liad.kaufman@intel.com
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9c4d1814-d6f2-e9c2-0b66-bbfadc002b15@kernel.dk> (sfid-20170228_215411_111702_20538597)
Date: Tue, 28 Feb 2017 13:41:42 -0700
MIME-Version: 1.0
In-Reply-To: <c60e6859-f1ec-6656-2625-b5ce5f18059a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2017 11:02 AM, Jens Axboe wrote:
> Hi,
> 
> I'm hitting this one a lot with current -git, which is this one:
> 
> if (iwl_mvm_is_dqa_supported(mvm)) {                            
>         iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);          
>         /*                                                      
>          * If pending_frames is set at this point - it must be  
>          * driver internal logic error, since queues are empty  
>          * and removed successuly.                              
>          * warn on it but set it to 0 anyway to avoid station   
>          * not being removed later in the function              
>          */                                                     
>         WARN_ON(atomic_xchg(&mvm->pending_frames[sta_id], 0));  
> }
> 
> It's hit 4 times over the last day. The bug is probably older than the
> commit that added this warning:
> 
> commit 94c3e614df2117626fccfac8f821c66e30556384
> Author: Sara Sharon <sara.sharon@intel.com>
> Date:   Wed Dec 7 15:04:37 2016 +0200
> 
>     iwlwifi: mvm: fix pending frame counter calculation
> 
> but the pestering is new.

Forgot to include the traces, find them below.


[ 3829.774681] ------------[ cut here ]------------
[ 3829.774708] WARNING: CPU: 2 PID: 9155 at drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[ 3829.774710] Modules linked in: rfcomm fuse ctr ccm arc4 bnep snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device iwlmvm mac80211 binfmt_misc snd_timer iwlwifi uvcvideo x86_pkg_temp_thermal intel_powerclamp kvm_intel videobuf2_vmalloc kvm snd videobuf2_memops nls_iso8859_1 nls_cp437 irqbypass aesni_intel videobuf2_v4l2 aes_x86_64 videobuf2_core crypto_simd btusb vfat cryptd fat glue_helper videodev soundcore btintel cfg80211 bluetooth hid_generic usbhid hid psmouse i915 e1000e ptp pps_core xhci_pci xhci_hcd intel_gtt
[ 3829.774785] CPU: 2 PID: 9155 Comm: kworker/u8:0 Tainted: G     U          4.10.0+ #17
[ 3829.774787] Hardware name: LENOVO 20FBCTO1WW/20FBCTO1WW, BIOS N1FET45W (1.19 ) 11/08/2016
[ 3829.774824] Workqueue: phy0 ieee80211_iface_work [mac80211]
[ 3829.774826] Call Trace:
[ 3829.774837]  dump_stack+0x4d/0x63
[ 3829.774843]  __warn+0xcb/0xf0
[ 3829.774849]  warn_slowpath_null+0x1d/0x20
[ 3829.774864]  iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[ 3829.774875]  iwl_mvm_mac_sta_state+0x3fb/0x590 [iwlmvm]
[ 3829.774898]  drv_sta_state+0x83/0x4b0 [mac80211]
[ 3829.774922]  __sta_info_destroy_part2+0x128/0x160 [mac80211]
[ 3829.774945]  __sta_info_flush+0xdb/0x180 [mac80211]
[ 3829.774979]  ieee80211_set_disassoc+0xba/0x3c0 [mac80211]
[ 3829.775017]  ieee80211_sta_connection_lost.constprop.23+0x2a/0x50 [mac80211]
[ 3829.775056]  ieee80211_sta_work+0x1f3/0x1440 [mac80211]
[ 3829.775063]  ? update_curr+0x76/0x190
[ 3829.775069]  ? dequeue_task_fair+0x612/0x1830
[ 3829.775100]  ieee80211_iface_work+0x332/0x430 [mac80211]
[ 3829.775104]  ? finish_task_switch+0x78/0x200
[ 3829.775111]  process_one_work+0x1f3/0x4a0
[ 3829.775116]  worker_thread+0x48/0x4e0
[ 3829.775121]  kthread+0x101/0x140
[ 3829.775125]  ? process_one_work+0x4a0/0x4a0
[ 3829.775129]  ? kthread_create_on_node+0x40/0x40
[ 3829.775135]  ret_from_fork+0x29/0x40
[ 3829.775140] ---[ end trace 4da4612127066e04 ]---
[ 3829.780886] iwlwifi 0000:04:00.0: Failed to find station
[ 3829.780899] wlp4s0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-22)
[ 3829.780934] iwlwifi 0000:04:00.0: Failed to find station
[ 3829.780938] wlp4s0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-22)
[ 3829.903700] wlp4s0: authenticate with b4:75:0e:99:1f:e0
[ 3829.911954] wlp4s0: send auth to b4:75:0e:99:1f:e0 (try 1/3)
[ 3829.924048] wlp4s0: authenticated
[ 3829.927968] wlp4s0: associate with b4:75:0e:99:1f:e0 (try 1/3)
[ 3829.932783] wlp4s0: RX AssocResp from b4:75:0e:99:1f:e0 (capab=0x11 status=0 aid=1)
[ 3829.933844] wlp4s0: associated
[...]
[15590.492927] wlp4s0: deauthenticating from e2:cc:f8:1a:52:be by local choice (Reason: 3=DEAUTH_LEAVING)
[15590.503419] ------------[ cut here ]------------
[15590.503429] WARNING: CPU: 1 PID: 1012 at drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[15590.503430] Modules linked in: iwlmvm iwlwifi rfcomm fuse ctr ccm arc4 bnep snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device mac80211 binfmt_misc snd_timer uvcvideo x86_pkg_temp_thermal intel_powerclamp kvm_intel videobuf2_vmalloc kvm snd videobuf2_memops nls_iso8859_1 nls_cp437 irqbypass aesni_intel videobuf2_v4l2 aes_x86_64 videobuf2_core crypto_simd btusb vfat cryptd fat glue_helper videodev soundcore btintel cfg80211 bluetooth hid_generic usbhid hid psmouse i915 e1000e ptp pps_core xhci_pci xhci_hcd intel_gtt [last unloaded: iwlwifi]
[15590.503458] CPU: 1 PID: 1012 Comm: wpa_supplicant Tainted: G     U  W       4.10.0+ #17
[15590.503459] Hardware name: LENOVO 20FBCTO1WW/20FBCTO1WW, BIOS N1FET45W (1.19 ) 11/08/2016
[15590.503460] Call Trace:
[15590.503464]  dump_stack+0x4d/0x63
[15590.503466]  __warn+0xcb/0xf0
[15590.503468]  warn_slowpath_null+0x1d/0x20
[15590.503472]  iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[15590.503475]  iwl_mvm_mac_sta_state+0x3fb/0x590 [iwlmvm]
[15590.503490]  drv_sta_state+0x83/0x4b0 [mac80211]
[15590.503496]  __sta_info_destroy_part2+0x128/0x160 [mac80211]
[15590.503502]  __sta_info_flush+0xdb/0x180 [mac80211]
[15590.503512]  ieee80211_set_disassoc+0xba/0x3c0 [mac80211]
[15590.503521]  ieee80211_mgd_deauth+0xfa/0x210 [mac80211]
[15590.503530]  ieee80211_deauth+0x18/0x20 [mac80211]
[15590.503546]  cfg80211_mlme_deauth+0xa0/0x1e0 [cfg80211]
[15590.503554]  nl80211_deauthenticate+0x124/0x160 [cfg80211]
[15590.503556]  genl_family_rcv_msg+0x1b5/0x360
[15590.503558]  genl_rcv_msg+0x59/0xa0
[15590.503560]  ? genl_register_family+0x630/0x630
[15590.503561]  netlink_rcv_skb+0x97/0xb0
[15590.503563]  genl_rcv+0x28/0x40
[15590.503564]  netlink_unicast+0x181/0x210
[15590.503566]  netlink_sendmsg+0x2d8/0x390
[15590.503567]  sock_sendmsg+0x38/0x50
[15590.503568]  ___sys_sendmsg+0x25f/0x270
[15590.503569]  ? ___sys_recvmsg+0x141/0x1b0
[15590.503572]  ? __set_current_blocked+0x55/0x60
[15590.503574]  ? signal_setup_done+0x5c/0xa0
[15590.503575]  ? do_signal+0x175/0x640
[15590.503577]  ? __fpu__restore_sig+0x8c/0x4e0
[15590.503578]  __sys_sendmsg+0x45/0x80
[15590.503580]  SyS_sendmsg+0x12/0x20
[15590.503582]  entry_SYSCALL_64_fastpath+0x13/0x94
[15590.503583] RIP: 0033:0x7f78c96308a0
[15590.503583] RSP: 002b:00007fff812ffe28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[15590.503585] RAX: ffffffffffffffda RBX: 0000556ff4800f90 RCX: 00007f78c96308a0
[15590.503585] RDX: 0000000000000000 RSI: 00007fff812ffeb0 RDI: 0000000000000007
[15590.503586] RBP: 0000556ff48014a0 R08: 0000000000000000 R09: 0000000000000000
[15590.503586] R10: 0000556ff483ee80 R11: 0000000000000246 R12: 0000000000000001
[15590.503587] R13: 00007fff813004d8 R14: 0000556ff48016f0 R15: 000000000000000b
[15590.503588] ---[ end trace 4da4612127066e06 ]---
[15590.508925] iwlwifi 0000:04:00.0: Failed to find station
[15590.508929] wlp4s0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-22)
[15590.508941] iwlwifi 0000:04:00.0: Failed to find station
[15590.508943] wlp4s0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-22)
[...]
[15605.883212] wlp4s0: authenticate with b4:75:0e:99:1f:e0
[15605.891574] wlp4s0: send auth to b4:75:0e:99:1f:e0 (try 1/3)
[15605.897327] wlp4s0: authenticated
[15605.903406] wlp4s0: associate with b4:75:0e:99:1f:e0 (try 1/3)
[15605.904771] wlp4s0: RX AssocResp from b4:75:0e:99:1f:e0 (capab=0x11 status=0 aid=2)
[15605.905850] wlp4s0: associated
[15605.905895] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
[15632.617250] wlp4s0: disconnect from AP b4:75:0e:99:1f:e0 for new auth to b4:75:0e:99:1f:df
[15632.621364] ------------[ cut here ]------------
[15632.621377] WARNING: CPU: 0 PID: 1012 at drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[15632.621378] Modules linked in: iwlmvm iwlwifi rfcomm fuse ctr ccm arc4 bnep snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device mac80211 binfmt_misc snd_timer uvcvideo x86_pkg_temp_thermal intel_powerclamp kvm_intel videobuf2_vmalloc kvm snd videobuf2_memops nls_iso8859_1 nls_cp437 irqbypass aesni_intel videobuf2_v4l2 aes_x86_64 videobuf2_core crypto_simd btusb vfat cryptd fat glue_helper videodev soundcore btintel cfg80211 bluetooth hid_generic usbhid hid psmouse i915 e1000e ptp pps_core xhci_pci xhci_hcd intel_gtt [last unloaded: iwlwifi]
[15632.621417] CPU: 0 PID: 1012 Comm: wpa_supplicant Tainted: G     U  W       4.10.0+ #17
[15632.621418] Hardware name: LENOVO 20FBCTO1WW/20FBCTO1WW, BIOS N1FET45W (1.19 ) 11/08/2016
[15632.621419] Call Trace:
[15632.621424]  dump_stack+0x4d/0x63
[15632.621427]  __warn+0xcb/0xf0
[15632.621430]  warn_slowpath_null+0x1d/0x20
[15632.621436]  iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[15632.621442]  iwl_mvm_mac_sta_state+0x3fb/0x590 [iwlmvm]
[15632.621455]  drv_sta_state+0x83/0x4b0 [mac80211]
[15632.621468]  __sta_info_destroy_part2+0x128/0x160 [mac80211]
[15632.621480]  __sta_info_flush+0xdb/0x180 [mac80211]
[15632.621497]  ieee80211_set_disassoc+0xba/0x3c0 [mac80211]
[15632.621512]  ieee80211_mgd_auth+0x2f5/0x330 [mac80211]
[15632.621528]  ieee80211_auth+0x18/0x20 [mac80211]
[15632.621544]  cfg80211_mlme_auth+0xf3/0x210 [cfg80211]
[15632.621558]  nl80211_authenticate+0x2e0/0x340 [cfg80211]
[15632.621562]  genl_family_rcv_msg+0x1b5/0x360
[15632.621565]  genl_rcv_msg+0x59/0xa0
[15632.621567]  ? genl_register_family+0x630/0x630
[15632.621569]  netlink_rcv_skb+0x97/0xb0
[15632.621572]  genl_rcv+0x28/0x40
[15632.621574]  netlink_unicast+0x181/0x210
[15632.621576]  netlink_sendmsg+0x2d8/0x390
[15632.621579]  sock_sendmsg+0x38/0x50
[15632.621581]  ___sys_sendmsg+0x25f/0x270
[15632.621582]  ? ___sys_recvmsg+0x141/0x1b0
[15632.621585]  ? iput+0x1c5/0x240
[15632.621587]  ? dentry_free+0x4e/0x80
[15632.621589]  ? mntput_no_expire+0x2c/0x1b0
[15632.621590]  ? mntput+0x24/0x40
[15632.621592]  ? __fput+0x174/0x1e0
[15632.621594]  __sys_sendmsg+0x45/0x80
[15632.621597]  SyS_sendmsg+0x12/0x20
[15632.621600]  entry_SYSCALL_64_fastpath+0x13/0x94
[15632.621601] RIP: 0033:0x7f78c96308a0
[15632.621602] RSP: 002b:00007fff813000f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[15632.621604] RAX: ffffffffffffffda RBX: 0000000000000013 RCX: 00007f78c96308a0
[15632.621606] RDX: 0000000000000000 RSI: 00007fff81300180 RDI: 0000000000000007
[15632.621606] RBP: 0000556ff484221c R08: 0000000000000000 R09: 00000000000000df
[15632.621607] R10: 0000556ff4811de0 R11: 0000000000000246 R12: 0000556ff484221c
[15632.621608] R13: 0000556ff4857490 R14: 0000000000000000 R15: 0000000000000000
[15632.621610] ---[ end trace 4da4612127066e07 ]---
[15632.627578] wlp4s0: authenticate with b4:75:0e:99:1f:df
[15632.636345] wlp4s0: send auth to b4:75:0e:99:1f:df (try 1/3)
[15632.650504] wlp4s0: authenticated
[15632.655376] wlp4s0: associate with b4:75:0e:99:1f:df (try 1/3)
[15632.660036] wlp4s0: RX AssocResp from b4:75:0e:99:1f:df (capab=0x1411 status=0 aid=1)
[15632.675702] wlp4s0: associated
[15759.464681] ------------[ cut here ]------------
[15759.464718] WARNING: CPU: 1 PID: 23668 at drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[15759.464720] Modules linked in: iwlmvm iwlwifi rfcomm fuse ctr ccm arc4 bnep snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device mac80211 binfmt_misc snd_timer uvcvideo x86_pkg_temp_thermal intel_powerclamp kvm_intel videobuf2_vmalloc kvm snd videobuf2_memops nls_iso8859_1 nls_cp437 irqbypass aesni_intel videobuf2_v4l2 aes_x86_64 videobuf2_core crypto_simd btusb vfat cryptd fat glue_helper videodev soundcore btintel cfg80211 bluetooth hid_generic usbhid hid psmouse i915 e1000e ptp pps_core xhci_pci xhci_hcd intel_gtt [last unloaded: iwlwifi]
[15759.464819] CPU: 1 PID: 23668 Comm: kworker/u8:4 Tainted: G     U  W       4.10.0+ #17
[15759.464822] Hardware name: LENOVO 20FBCTO1WW/20FBCTO1WW, BIOS N1FET45W (1.19 ) 11/08/2016
[15759.464871] Workqueue: phy1 ieee80211_iface_work [mac80211]
[15759.464875] Call Trace:
[15759.464889]  dump_stack+0x4d/0x63
[15759.464897]  __warn+0xcb/0xf0
[15759.464904]  warn_slowpath_null+0x1d/0x20
[15759.464925]  iwl_mvm_rm_sta+0x3ce/0x450 [iwlmvm]
[15759.464939]  iwl_mvm_mac_sta_state+0x3fb/0x590 [iwlmvm]
[15759.464971]  drv_sta_state+0x83/0x4b0 [mac80211]
[15759.465002]  __sta_info_destroy_part2+0x128/0x160 [mac80211]
[15759.465033]  __sta_info_flush+0xdb/0x180 [mac80211]
[15759.465079]  ieee80211_set_disassoc+0xba/0x3c0 [mac80211]
[15759.465121]  ieee80211_sta_connection_lost.constprop.23+0x2a/0x50 [mac80211]
[15759.465161]  ieee80211_sta_work+0x1f3/0x1440 [mac80211]
[15759.465168]  ? update_curr+0x76/0x190
[15759.465173]  ? dequeue_task_fair+0x612/0x1830
[15759.465212]  ieee80211_iface_work+0x332/0x430 [mac80211]
[15759.465218]  ? finish_task_switch+0x78/0x200
[15759.465227]  process_one_work+0x1f3/0x4a0
[15759.465234]  worker_thread+0x48/0x4e0
[15759.465240]  kthread+0x101/0x140
[15759.465247]  ? process_one_work+0x4a0/0x4a0
[15759.465252]  ? kthread_create_on_node+0x40/0x40
[15759.465260]  ret_from_fork+0x29/0x40
[15759.465267] ---[ end trace 4da4612127066e08 ]---
[15759.473252] iwlwifi 0000:04:00.0: Failed to find station
[15759.473267] wlp4s0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-22)
[15759.596780] wlp4s0: authenticate with b4:75:0e:99:1f:e0
[15759.605604] wlp4s0: send auth to b4:75:0e:99:1f:e0 (try 1/3)
[15759.607833] wlp4s0: authenticated
[15759.617745] wlp4s0: associate with b4:75:0e:99:1f:e0 (try 1/3)
[15759.619111] wlp4s0: RX AssocResp from b4:75:0e:99:1f:e0 (capab=0x11 status=0 aid=2)
[15759.620061] wlp4s0: associated

-- 
Jens Axboe
