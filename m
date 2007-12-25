Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:13783 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750891AbXLYJE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 04:04:29 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Andrew Lutomirski" <luto@myrealbox.com>
Subject: Re: ath5k oops (recent regression, I think)
Date: Tue, 25 Dec 2007 18:04:13 +0900
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
In-Reply-To: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712251804.13693.bruno@thinktube.com> (sfid-20071225_090440_411356_7DF3857B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello!

i'm seeing the same oops, it seems to be a regression from 

commit fd640775bd16e1df50c867cc547af0787f9bd4ab
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Dec 19 01:31:26 2007 +0100

    mac80211: dont use interface indices in drivers

seems ath5k likes to write some rate registers before vif is set up. i used 
the following as a stopgap fix. johannes, do you have any advice how to 
properly fix that?

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index f4478f6..2e9f5c5 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -510,6 +510,11 @@ static inline void ath5k_hw_write_rate_duration(struct 
ath5k_hw *ah,
        const struct ath5k_rate_table *rt;
        unsigned int i;

+       if (sc->vif == NULL) {
+               printk("*** sc->vif NULL\n");
+               return;
+       }
+
        /* Get rate table for the current operating mode */
        rt = ath5k_hw_get_rate_table(ah,
                driver_mode);

bruno

On Tuesday 25 December 2007 12:06:25 Andrew Lutomirski wrote:
> I'm getting oopses in ath5k, which is either:
> 1. A recent regression (past few days in wireless-2.6 everything branch.
> 2. A less-recent regression that I think is recent because I don't
> really know how to use git.
>
> A slightly older version didn't oops but couldn't associate.  madwifi
> works fine.
>
> I'm running 2d0811f5ed506397d85792abfd8ef0983f4e8b7c, I think.
>
> I can try to bisect in the next few days or provide any other useful
> debugging, but I figured I'd let you all know first.
>
> Relevant pieces of dmesg are:
>
> [   15.097097] ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY:
> 0x43) [   15.097107] ath5k phy0: RF5112A multiband radio found (0x36)
>
> ...
>
> [  149.641321] BUG: unable to handle kernel paging request at virtual
> address fffffd88
> [  149.641329] printing eip: b0335b41 *pde = 00490027 *pte = 00000000
> [  149.641336] Oops: 0000 [#1] PREEMPT
> [  149.641339] Modules linked in: ipv6 binfmt_misc cpufreq_stats
> cpufreq_ondemand cpufreq_powersave cpufreq_userspace bay container sbs
> sbshc dock sbp2 joydev pcmcia snd_intel8x0 snd_ac97_codec ac97_bus
> snd_pcm_oss snd_mixer_oss snd_pcm psmouse serio_raw snd_seq_dummy
> snd_seq_oss pcspkr snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
> snd_timer snd_seq_device snd soundcore snd_page_alloc yenta_socket
> rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support intel_agp
> agpgart evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic
> ata_piix ohci1394 ieee1394 libata scsi_mod ehci_hcd uhci_hcd usbcore
> fan fuse
> [  149.641379]
> [  149.641382] Pid: 5808, comm: NetworkManager Not tainted (2.6.24-rc5 #4)
> [  149.641386] EIP: 0060:[<b0335b41>] EFLAGS: 00210246 CPU: 0
> [  149.641395] EIP is at ieee80211_generic_frame_duration+0x21/0x70
> [  149.641398] EAX: cdb28160 EBX: cdb28160 ECX: 0000000a EDX: 00000000
> [  149.641400] ESI: 00000000 EDI: 0000000a EBP: 000003e8 ESP: cd833b08
> [  149.641403]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  149.641407] Process NetworkManager (pid: 5808, ti=cd832000
> task=cdd7cc80 task.ti=cd832000)
> [  149.641409] Stack: b028ec3b 0016ba51 0000876c 00000000 cdb52000
> b028b4ed 0000000a 4fa14d63
> [  149.641416]        00000034 cdb28160 00000000 b0359aa4 cdb28f0c
> 00000000 00000000 00000003
> [  149.641423]        00000002 00000002 00000014 00000000 b0359a80
> cdb28e00 00000000 00000000
> [  149.641429] Call Trace:
> [  149.641431]  [<b028ec3b>] ath5k_hw_rfgain+0x4b/0x80
> [  149.641441]  [<b028b4ed>] ath5k_hw_reset+0xa9d/0xeb0
> [  149.641453]  [<b0283e76>] ath5k_init+0x46/0x110
> [  149.641462]  [<b03231cc>] ieee80211_open+0x19c/0x4e0
> [  149.641468]  [<b011a4be>] set_next_entity+0xae/0xd0
> [  149.641479]  [<b02afdec>] dev_open+0x4c/0x80
> [  149.641486]  [<b02aee62>] dev_change_flags+0x82/0x1b0
> [  149.641492]  [<b02b7d46>] do_setlink+0x2d6/0x3b0
> [  149.641497]  [<b015d5d6>] __alloc_pages+0x56/0x360
> [  149.641506]  [<b02b914b>] rtnl_setlink+0xdb/0x130
> [  149.641517]  [<b015d500>] __free_pages+0x20/0x30
> [  149.641522]  [<b02b9070>] rtnl_setlink+0x0/0x130
> [  149.641526]  [<b02b8d6c>] rtnetlink_rcv_msg+0x1cc/0x200
> [  149.641532]  [<b02b8ba0>] rtnetlink_rcv_msg+0x0/0x200
> [  149.641536]  [<b02c6550>] netlink_rcv_skb+0x70/0xa0
> [  149.641542]  [<b02b8b94>] rtnetlink_rcv+0x14/0x20
> [  149.641546]  [<b02c62e3>] netlink_unicast+0x203/0x230
> [  149.641553]  [<b02c6b00>] netlink_sendmsg+0x200/0x2f0
> [  149.641563]  [<b02a2a01>] sock_sendmsg+0x101/0x120
> [  149.641575]  [<b0136310>] autoremove_wake_function+0x0/0x50
> [  149.641585]  [<b0136310>] autoremove_wake_function+0x0/0x50
> [  149.641590]  [<b0314b27>] unix_stream_recvmsg+0x3c7/0x630
> [  149.641600]  [<b02a1f48>] sock_aio_write+0x118/0x140
> [  149.641608]  [<b02a2b84>] sys_sendmsg+0x164/0x280
> [  149.641620]  [<b02c5a16>] netlink_insert+0xe6/0x170
> [  149.641625]  [<b017c5ed>] fget_light+0x9d/0xc0
> [  149.641631]  [<b02a370f>] move_addr_to_user+0x5f/0x70
> [  149.641637]  [<b02a3cc7>] sys_getsockname+0xd7/0xe0
> [  149.641642]  [<b02a4cb5>] lock_sock_nested+0xd5/0xf0
> [  149.641647]  [<b012762e>] local_bh_enable+0x2e/0xb0
> [  149.641654]  [<b02a6449>] sock_setsockopt+0x149/0x5e0
> [  149.641658]  [<b018e281>] d_alloc+0x131/0x1a0
> [  149.641665]  [<b018e125>] d_instantiate+0x45/0x70
> [  149.641670]  [<b017c5ed>] fget_light+0x9d/0xc0
> [  149.641674]  [<b02a20d2>] sockfd_lookup_light+0x32/0x60
> [  149.641683]  [<b02a414f>] sys_socketcall+0x24f/0x280
> [  149.641691]  [<b0126faa>] sys_time+0xa/0x30
> [  149.641695]  [<b010421e>] sysenter_past_esp+0x5f/0x85
> [  149.641706]  =======================
> [  149.641707] Code: 5d c3 90 8d b4 26 00 00 00 00 83 ec 14 89 5c 24
> 08 89 c3 89 74 24 0c 89 d6 89 7c 24 10 89 cf 8b 4c 24 18 83 78 0c 02
> 74 31 31 d2 <8b> 86 88 fd ff ff 89 14 24 89 fa 83 e0 08 89 44 24 04 89
> d8 e8
> [  149.641740] EIP: [<b0335b41>]
> ieee80211_generic_frame_duration+0x21/0x70 SS:ESP 0068:cd833b08
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


