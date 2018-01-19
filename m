Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754930AbeASKYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 05:24:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Paul Menzel <pmenzel+linux-ath10k@molgen.mpg.de>
Cc: <ath10k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Mario Limonciello" <mario.limonciello@dell.com>,
        <it+linux-ath10k@molgen.mpg.de>, linux-wireless@vger.kernel.org
Subject: Re: UBSAN: Undefined behaviour in drivers/net/wireless/ath/ath10k/mac.c:3092:53: signed integer overflow
References: <70aa931f-2f02-dd26-c98b-695d1321f71b@molgen.mpg.de>
Date: Fri, 19 Jan 2018 12:24:11 +0200
In-Reply-To: <70aa931f-2f02-dd26-c98b-695d1321f71b@molgen.mpg.de> (Paul
        Menzel's message of "Wed, 3 Jan 2018 17:34:08 +0100")
Message-ID: <87d1269mes.fsf@kamboji.qca.qualcomm.com> (sfid-20180119_112424_157025_9072AFFB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding linux-wireless.=20

For linux-wireless the full report is here:

https://lkml.kernel.org/r/70aa931f-2f02-dd26-c98b-695d1321f71b@molgen.mpg.de

Paul Menzel <pmenzel+linux-ath10k@molgen.mpg.de> writes:

> I enabled the undefined behavior sanitizer, and built Linus=E2=80=99 mast=
er
> branch under Ubuntu 16.04 with gcc (Ubuntu 5.4.0-6ubuntu1~16.04.5)
> 5.4.0 20160609.

As you just recently enabled UBSAN I guess I can assume that this isn't
a new regression but instead the bug is an old issue?

Can you reproduce the problem easily? That would help with testing
patches.

> ```
> $ grep UBSAN /boot/config-4.15.0-rc6+
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=3Dy
> # CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
> CONFIG_UBSAN=3Dy
> CONFIG_UBSAN_SANITIZE_ALL=3Dy
> # CONFIG_UBSAN_ALIGNMENT is not set
> CONFIG_UBSAN_NULL=3Dy
> ```
>
> Suspending and resuming the system *Dell XPS 13 9360* from ACPI S3 the
> messages below are printed.
>
> ```
> $ git describe --tags
> 4.15-rc6
> $ git log --oneline -1
> 30a7acd Linux 4.15-rc6
> $ dmesg
> [=E2=80=A6]
> [  960.737724]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> [  960.737730] UBSAN: Undefined behaviour in
> drivers/net/wireless/ath/ath10k/mac.c:3092:53

This line is from ath10k_update_channel_list():

			ch->max_antenna_gain =3D channel->max_antenna_gain * 2;

> [  960.737733] signed integer overflow:
> [  960.737735] 2147483647 * 2 cannot be represented in type 'int'

2147483647 is MAX_INT but I can't immeaditely figure out where that's
coming from. Maybe unitialised stack somewhere?

> [  960.737738] CPU: 1 PID: 2663 Comm: crda Not tainted 4.15.0-rc6+ #36
> [  960.737739] Hardware name: Dell Inc. XPS 13 9360/0839Y6, BIOS 2.4.2
> 11/21/2017
> [  960.737740] Call Trace:
> [  960.737749]  dump_stack+0x70/0xb2
> [  960.737753]  ubsan_epilogue+0x9/0x40
> [  960.737758]  handle_overflow+0xce/0xf0
> [  960.737762]  ? ecryptfs_decode_and_decrypt_filename+0x104/0x530
> [  960.737764]  ? __kmalloc+0x265/0x370
> [  960.737774]  ath10k_regd_update+0x39d/0x5f0 [ath10k_core]
> [  960.737782]  ath10k_reg_notifier+0x114/0x180 [ath10k_core]
> [  960.737802]  set_regdom+0x275/0x910 [cfg80211]
> [  960.737821]  nl80211_set_reg+0x19c/0x630 [cfg80211]
> [  960.737826]  genl_family_rcv_msg+0x2c4/0x610
> [  960.737830]  ? radix_tree_next_chunk+0x9f/0x570
> [  960.737832]  genl_rcv_msg+0x5d/0xe0
> [  960.737835]  ? __alloc_skb+0x82/0x260
> [  960.737838]  ? genl_family_rcv_msg+0x610/0x610
> [  960.737840]  netlink_rcv_skb+0xd5/0x130
> [  960.737842]  genl_rcv+0x24/0x40
> [  960.737844]  netlink_unicast+0x1cc/0x300
> [  960.737847]  netlink_sendmsg+0x29a/0x5f0
> [  960.737850]  sock_sendmsg+0x4c/0xa0
> [  960.737853]  ___sys_sendmsg+0x30e/0x440
> [  960.737857]  ? pagevec_lru_move_fn+0xc3/0x130
> [  960.737859]  ? trace_event_raw_event_mm_lru_activate+0x100/0x100
> [  960.737862]  ? __lru_cache_add+0x6a/0xb0
> [  960.737865]  ? __sys_sendmsg+0x51/0x90
> [  960.737868]  __sys_sendmsg+0x51/0x90
> [  960.737872]  entry_SYSCALL_64_fastpath+0x1e/0x81

Ok, so crda calls NL80211_CMD_SET_REG and somehow ath10k gets
max_antenna_gain as MAX_INT, but no idea why.

> [  960.737875] RIP: 0033:0x7ff956d7c450
> [  960.737877] RSP: 002b:00007ffd454a2418 EFLAGS: 00000246 ORIG_RAX:
> 000000000000002e
> [  960.737879] RAX: ffffffffffffffda RBX: 00007ff957038b20 RCX:
> 00007ff956d7c450
> [  960.737880] RDX: 0000000000000000 RSI: 00007ffd454a24a0 RDI:
> 0000000000000000
> [  960.737881] RBP: 0000000000001010 R08: 0000000000000000 R09:
> 0000000001254010
> [  960.737882] R10: 00000000000000eb R11: 0000000000000246 R12:
> 00007ff957038b78
> [  960.737883] R13: 000000000125c360 R14: 0000000001254000 R15:
> 0000000001254000
> [  960.737885]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> [  970.814067] PM: suspend entry (deep)
> [  970.814103] PM: Syncing filesystems ... done.
> [  970.830679] Freezing user space processes ... (elapsed 0.001
> seconds) done.
> [  970.832429] OOM killer disabled.
> [  970.832430] Freezing remaining freezable tasks ... (elapsed 0.001
> seconds) done.
> [  970.833581] Suspending console(s) (use no_console_suspend to debug)
> [  971.250651] psmouse serio1: Failed to disable mouse on isa0060/serio1
> [=E2=80=A6]
> [  975.724595] ath10k_pci 0000:3a:00.0: Unknown eventid: 90118
> [  975.780813] IPv6: ADDRCONF(NETDEV_UP): wlp58s0: link is not ready
> [  975.874965] IPv6: ADDRCONF(NETDEV_UP): wlp58s0: link is not ready
> [  985.562004] wlp58s0: authenticate with 6c:f3:7f:10:ae:18
> [  985.562028]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> [  985.562037] UBSAN: Undefined behaviour in
> drivers/net/wireless/ath/ath10k/mac.c:1444:65
> [  985.562041] signed integer overflow:
> [  985.562044] 2147483647 * 2 cannot be represented in type 'int'

Again max_antenna_gain with MAX_INT but now from
ath10k_vdev_start_restart():

	arg.channel.max_antenna_gain =3D chandef->chan->max_antenna_gain * 2;

> [  985.562049] CPU: 0 PID: 1135 Comm: wpa_supplicant Not tainted
> 4.15.0-rc6+ #36
> [  985.562051] Hardware name: Dell Inc. XPS 13 9360/0839Y6, BIOS 2.4.2
> 11/21/2017
> [  985.562052] Call Trace:
> [  985.562064]  dump_stack+0x70/0xb2
> [  985.562069]  ubsan_epilogue+0x9/0x40
> [  985.562075]  handle_overflow+0xce/0xf0
> [  985.562107]  ? cfg80211_iter_combinations+0x2b8/0x670 [cfg80211]
> [  985.562124]  ath10k_vdev_start_restart+0x42c/0x5d0 [ath10k_core]
> [  985.562138]  ath10k_mac_op_assign_vif_chanctx+0x6e/0x310 [ath10k_core]
> [  985.562150]  ? ath10k_config+0xd0/0xd0 [ath10k_core]
> [  985.562190]  ieee80211_assign_vif_chanctx+0x1ff/0x960 [mac80211]
> [  985.562229]  ieee80211_vif_use_channel+0x1a6/0x480 [mac80211]
> [  985.562265]  ieee80211_prep_connection+0x48f/0xfb0 [mac80211]
> [  985.562300]  ? __sdata_info+0x68/0x100 [mac80211]
> [  985.562336]  ieee80211_mgd_auth+0x32b/0x4c0 [mac80211]
> [  985.562375]  cfg80211_mlme_auth+0x17f/0x480 [cfg80211]
> [  985.562383]  ? sock_poll+0x64/0x150
> [  985.562412]  nl80211_authenticate+0x3e7/0x7c0 [cfg80211]
> [  985.562420]  genl_family_rcv_msg+0x2c4/0x610
> [  985.562426]  ? ep_poll_callback+0x14e/0x4e0
> [  985.562431]  genl_rcv_msg+0x5d/0xe0
> [  985.562434]  ? __alloc_skb+0x82/0x260
> [  985.562437]  ? genl_family_rcv_msg+0x610/0x610
> [  985.562440]  netlink_rcv_skb+0xd5/0x130
> [  985.562445]  genl_rcv+0x24/0x40
> [  985.562448]  netlink_unicast+0x1cc/0x300
> [  985.562451]  netlink_sendmsg+0x29a/0x5f0
> [  985.562456]  sock_sendmsg+0x4c/0xa0
> [  985.562460]  ___sys_sendmsg+0x30e/0x440
> [  985.562465]  ? sock_sendmsg+0x4c/0xa0
> [  985.562468]  ? SYSC_sendto+0xef/0x1a0
> [  985.562473]  ? __sys_sendmsg+0x51/0x90
> [  985.562476]  __sys_sendmsg+0x51/0x90
> [  985.562483]  entry_SYSCALL_64_fastpath+0x1e/0x81

This time wpasupplicant calling NL80211_CMD_AUTHENTICATE after resume,
which is normal.

No time to investigate more right now, but hopefully others have some
ideas.

--=20
Kalle Valo
