Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45418 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932775AbdCJPnU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 10:43:20 -0500
Message-ID: <1489160576.22435.19.camel@coelho.fi> (sfid-20170310_164322_969896_47FCDFF0)
From: Luca Coelho <luca@coelho.fi>
To: Jens Axboe <axboe@kernel.dk>
Cc: sara.sharon@intel.com, liad.kaufman@intel.com,
        linux-wireless@vger.kernel.org
Date: Fri, 10 Mar 2017 17:42:56 +0200
In-Reply-To: <eeb29124-0955-c2df-e39b-3981d76740a7@kernel.dk>
References: <f2bedfee-e74f-47d6-9088-94171f0e5538@email.android.com>
         <05fff778-8703-f429-f555-aa533c2df25f@kernel.dk>
         <fdfbfffa-31c9-7646-82b5-b6a759b73d21@kernel.dk>
         <1489147283.22435.14.camel@coelho.fi>
         <aceb734b-8e2c-e5b6-300d-172f8d28f471@kernel.dk>
         <eeb29124-0955-c2df-e39b-3981d76740a7@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-10 at 08:37 -0700, Jens Axboe wrote:
> On 03/10/2017 08:23 AM, Jens Axboe wrote:
> > On 03/10/2017 05:01 AM, Luca Coelho wrote:
> > > Hi Jens,
> > > 
> > > On Thu, 2017-03-09 at 21:41 -0700, Jens Axboe wrote:
> > > > On 03/01/2017 09:10 PM, Jens Axboe wrote:
> > > > > On 03/01/2017 08:33 PM, Luca Coelho wrote:
> > > > > > Hi Jens,
> > > > > > 
> > > > > > On Mar 1, 2017 20:25, Jens Axboe <axboe@kernel.dk> wrote:
> > > > > > 
> > > > > >     Not that folks have been jumping all over this, but in case someone is
> > > > > >     curious, it triggered twice here today. For those two times, the value
> > > > > >     of mvm->pending_frames[sta_id] was 80 and 39, respectively.
> > > > > > 
> > > > > > Sorry for the delay, I'm on vacation now with limited internet access.
> > > > > > But we'll take a look into this early next week at the latest.
> > > > > > 
> > > > > > Thanks a lot for the detailed report!
> > > > > 
> > > > > No worries, thanks for responding. I just wanted to ensure this wasn't
> > > > > dropped on the floor.
> > > > > 
> > > > > BTW, a few more values of ->pending_frames[sta_id]:
> > > > > 
> > > > > $ dmesg | grep "ret="
> > > > > [ 2334.308254] ret=39
> > > > > [ 7915.311828] ret=80
> > > > > [31602.317204] ret=41
> > > > > [32139.510993] ret=54
> > > > > [33292.917759] ret=96
> > > > > 
> > > > > it seems to often happen around resume.
> > > > 
> > > > This is still happening all the time in current -git.
> > > 
> > > Could you collect traces with trace-cmd, as explained in our wiki[1]?
> > > This will probably help point out the problem.  I know it's a bit
> > > difficult because it appears to happen randomly for you, but it's worth
> > > trying.
> > 
> > Sure I can, but honestly I'm a little puzzled that nobody else can
> > reproduce this, it happens every time I resume of switch access points.
> > Is anyone trying to reproduce this?
> > 
> > I'll have to recompile with iwlwifi tracing enabled, then I'll send a trace
> > when it happens.
> 
> Booted up, logged in, and started tracing:
> 
> $ sudo trace-cmd record -e iwlwifi -e mac80211 -e cfg80211 -e iwlwifi_msg
> /sys/kernel/tracing/events/iwlwifi/filter
> /sys/kernel/tracing/events/*/iwlwifi/filter
> /sys/kernel/tracing/events/mac80211/filter
> /sys/kernel/tracing/events/*/mac80211/filter
> /sys/kernel/tracing/events/cfg80211/filter
> /sys/kernel/tracing/events/*/cfg80211/filter
> /sys/kernel/tracing/events/iwlwifi_msg/filter
> /sys/kernel/tracing/events/*/iwlwifi_msg/filter
> Hit Ctrl^C to stop recording
> 
> Then I switched to a different access point, and I immediately got the
> trace in dmesg:
> [   41.439499] wlp4s0: deauthenticating from b4:75:0e:99:1f:e0 by local choice (Reason: 3=DEAUTH_LEAVING)
> [   41.548817] ------------[ cut here ]------------
> [   41.548833] WARNING: CPU: 1 PID: 1001 at drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3f6/0x470 [iwlmvm]
> [   41.548834] Modules linked in: ctr ccm rfcomm fuse bnep arc4 binfmt_misc snd_hda_codec_hdmi nls_iso8859_1 nls_cp437 vfat snd_hda_codec_conexant snd_hda_codec_generic fat snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core iwlmvm snd_pcm snd_seq_midi snd_seq_midi_event mac80211 snd_rawmidi snd_seq x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm iwlwifi snd_seq_device snd_timer irqbypass uvcvideo videobuf2_vmalloc videobuf2_memops snd aesni_intel videobuf2_v4l2 aes_x86_64 crypto_simd btusb btintel videobuf2_core cryptd bluetooth glue_helper videodev cfg80211 soundcore hid_generic usbhid hid i915 psmouse e1000e ptp pps_core xhci_pci xhci_hcd intel_gtt
> [   41.548880] CPU: 1 PID: 1001 Comm: wpa_supplicant Tainted: G     U          4.11.0-rc1+ #24
> [   41.548881] Hardware name: LENOVO 20FBCTO1WW/20FBCTO1WW, BIOS N1FET45W (1.19 ) 11/08/2016
> [   41.548882] Call Trace:
> [   41.548888]  dump_stack+0x4d/0x63
> [   41.548891]  __warn+0xcb/0xf0
> [   41.548894]  warn_slowpath_null+0x1d/0x20
> [   41.548903]  iwl_mvm_rm_sta+0x3f6/0x470 [iwlmvm]
> [   41.548910]  iwl_mvm_mac_sta_state+0x516/0x600 [iwlmvm]
> [   41.548925]  drv_sta_state+0x83/0x4b0 [mac80211]
> [   41.548938]  __sta_info_destroy_part2+0x128/0x160 [mac80211]
> [   41.548951]  __sta_info_flush+0xdb/0x180 [mac80211]
> [   41.548969]  ieee80211_set_disassoc+0xba/0x3c0 [mac80211]
> [   41.548988]  ieee80211_mgd_deauth+0xfa/0x210 [mac80211]
> [   41.549005]  ieee80211_deauth+0x18/0x20 [mac80211]
> [   41.549025]  cfg80211_mlme_deauth+0xa0/0x1e0 [cfg80211]
> [   41.549041]  nl80211_deauthenticate+0x124/0x160 [cfg80211]
> [   41.549045]  genl_family_rcv_msg+0x1b5/0x360
> [   41.549048]  genl_rcv_msg+0x44/0x80
> [   41.549051]  ? genl_family_rcv_msg+0x360/0x360
> [   41.549053]  netlink_rcv_skb+0x97/0xb0
> [   41.549055]  genl_rcv+0x28/0x40
> [   41.549058]  netlink_unicast+0x181/0x210
> [   41.549060]  netlink_sendmsg+0x2d8/0x390
> [   41.549064]  sock_sendmsg+0x38/0x50
> [   41.549067]  ___sys_sendmsg+0x25f/0x270
> [   41.549069]  ? ___sys_recvmsg+0x141/0x1b0
> [   41.549073]  ? __set_current_blocked+0x55/0x60
> [   41.549076]  ? signal_setup_done+0x5c/0xa0
> [   41.549078]  ? do_signal+0x175/0x640
> [   41.549081]  ? __fpu__restore_sig+0x8c/0x4e0
> [   41.549085]  __sys_sendmsg+0x45/0x80
> [   41.549088]  SyS_sendmsg+0x12/0x20
> [   41.549091]  entry_SYSCALL_64_fastpath+0x13/0x94
> [   41.549093] RIP: 0033:0x7f94475358a0
> [   41.549094] RSP: 002b:00007ffd7dd1a1d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [   41.549097] RAX: ffffffffffffffda RBX: 000055ff43bb1f90 RCX: 00007f94475358a0
> [   41.549098] RDX: 0000000000000000 RSI: 00007ffd7dd1a260 RDI: 0000000000000007
> [   41.549099] RBP: 000055ff43bb24d0 R08: 0000000000000000 R09: 0000000000000000
> [   41.549100] R10: 000055ff43bb3300 R11: 0000000000000246 R12: 0000000000000001
> [   41.549101] R13: 00007ffd7dd1a888 R14: 000055ff43bb26f0 R15: 000000000000000b
> [   41.549103] ---[ end trace 30bc14424e760dd4 ]---
> [   41.555170] iwlwifi 0000:04:00.0: Failed to find station
> [   41.555177] wlp4s0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-22)
> 
> Then I stopped tracing:
> 
> ^CKernel buffer statistics:
>   Note: "entries" are the entries left in the kernel ring buffer and are not
>         recorded in the trace data. They should all be zero.
> Kernel buffer statistics:
>   Note: "entries" are the entries left in the kernel ring buffer and are not
>         recorded in the trace data. They should all be zero.
> 
> CPU: 0
> entries: 0
> overrun: 0
> commit overrun: 0
> bytes: 2584
> oldest event ts:    44.361525
> now ts:    45.772870
> dropped events: 0
> read events: 3281
> 
> CPU: 1
> entries: 0
> overrun: 0
> commit overrun: 0
> bytes: 1636
> oldest event ts:    43.917128
> now ts:    45.772909
> dropped events: 0
> read events: 557
> 
> CPU: 2
> entries: 0
> overrun: 0
> commit overrun: 0
> bytes: 2472
> oldest event ts:    44.211886
> now ts:    45.772938
> dropped events: 0
> read events: 314
> 
> CPU: 3
> entries: 0
> overrun: 0
> commit overrun: 0
> bytes: 1864
> oldest event ts:    44.023886
> now ts:    45.772966
> dropped events: 0
> read events: 204
> 
> CPU0 data recorded at offset=0x3dd000
>     507904 bytes in size
> CPU1 data recorded at offset=0x459000
>     81920 bytes in size
> CPU2 data recorded at offset=0x46d000
>     61440 bytes in size
> CPU3 data recorded at offset=0x47c000
>     32768 bytes in size
> 
> And I have attached trace.dat for you.

Great, thanks! I'll take a look and also try to repro locally.

--
Cheers,
Luca.
