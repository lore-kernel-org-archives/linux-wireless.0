Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACF1C282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 09:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8309E208E3
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554714017;
	bh=KlP0E7/mZluoKskgnvb6IfBd6a2nPtIoxbfDYHqy6MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EPjYuHc78VAKfusPMlBIIX2d00V37EfI5k3ydvU5+LDHF6ynRqy4oLSBBAh5P4Zos
	 s3MKO3+7zhwxKbjiaiKoRaSqULYTVnhDwY1Uqnc3fq5FA/SKbNeqiYLysnbqdKOUDJ
	 McP00eAvJ2AyVjvka4vz8WL6Zclj36fIjgbWU9Hk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfDHJAQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 05:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfDHJAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 05:00:16 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F97C20870;
        Mon,  8 Apr 2019 09:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554714014;
        bh=KlP0E7/mZluoKskgnvb6IfBd6a2nPtIoxbfDYHqy6MY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GWnC8MY6yXH6aT/pddHnD/gbqNf9ZTeamygAOVTscOxdQatKUFveAJTaaL96G7R6S
         qZQIpp2+ir9HHbBt2AU37FmFIpXZfkpTJVkYydrVVTi2ucWkgrp/ps/nahktRU9iS6
         6eb/SkJ1+e160EAAZxndQvKGO2DjHuuEcJsMFuH8=
Date:   Mon, 8 Apr 2019 12:00:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH 0/6] stricter netlink validation
Message-ID: <20190408090010.GG3201@mtr-leonro.mtl.com>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nQHD+3g9yI+EYXJy"
Content-Disposition: inline
In-Reply-To: <20190404065408.5864-1-johannes@sipsolutions.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--nQHD+3g9yI+EYXJy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2019 at 08:54:02AM +0200, Johannes Berg wrote:
> Here's a version that has passed build testing ;-)
>
> As mentioned in the RFC postings, this was inspired by talks
> between David, Pablo and myself. Pablo is somewhat firmly on
> the side of less strict validation, while David and myself
> are in the very strict validation camp. If I understand him
> correctly, Pablo doesn't mind the strict validation if it is
> accompanied by exposing the policy to userspace, but that
> isn't something we can do today. I'll work on it later.
>
> What this series does is basically first replace nla_parse()
> and all its friends by nla_parse_deprecated(), while making
> all of those just inlines around __nla_parse() and friends
> with configurable strict checking bits. Three versions exist
> after this patchset:
>  * liberal           - no bits set
>  * deprecated_strict - reject attrs > maxtype
>                        reject trailing junk
>  * new default       - reject trailing junk
>                        reject attrs > maxtype
>                        reject policy entries that are NLA_UNSPEC
>                        require a policy
>                        strictly validate attributes
>
> The NLA_UNSPEC one can be opted in even in existing code with
> existing userspace in the future, as policies are updated.
>
> In addition, infrastructure is added to opt in to the strict
> attribute validation even for new attributes added to existing
> policies, regardless of the nla_parse() strictness setting
> described above, as new attributes should not be a compatibility
> issue.
>
> Finally, much of this is plumbed through generic netlink etc.,
> and I've included a patch to tag nl80211 with the future attribute
> strictness for reference.
>
> johannes


Hi Johannes,

This series crashes on mlx4 devices with the following kernel panic.

[   92.937629] BUG: unable to handle kernel paging request at 0000000000001023
[   92.940094] #PF error: [normal kernel read fault]
[   92.941731] PGD 80000002291da067 P4D 80000002291da067 PUD 20f295067 PMD 0
[   92.943983] Oops: 0000 [#1] SMP PTI
[   92.945248] CPU: 1 PID: 3976 Comm: devlink Not tainted 5.1.0-rc2-J2742-G9070daeb7d6d #1
[   92.947951] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   92.950921] RIP: 0010:genl_lock_dumpit+0x10/0xb0
[   92.952502] Code: c7 c7 a0 e6 30 82 e9 ef 96 a7 ff 0f 1f 44 00 00 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 53 48 8b 46 20 48 8b
28 <0f> b6 55 23 f6 c2 02 75 4d 4c 8b 48 08 83 e2 04 4c 8b 5e 08 80 fa
[   92.958146] RSP: 0018:ffffc90002df7c30 EFLAGS: 00010202
[   92.959817] RAX: ffffc90002df7be8 RBX: ffff888231b0e800 RCX: 0000000000000ec0
[   92.962079] RDX: 00000000000000a8 RSI: ffff888231b0eb30 RDI: ffff88823195b400
[   92.964297] RBP: 0000000000001000 R08: 0000000000001ec0 R09: ffffffff81686c01
[   92.966475] R10: ffffea0008c656c0 R11: 0000000000000040 R12: 0000000000001000
[   92.968575] R13: ffff888231b0eb30 R14: 0000000000000000 R15: ffff888230f63700
[   92.970688] FS:  00007fa7e963bb80(0000) GS:ffff888237a80000(0000) knlGS:0000000000000000
[   92.973158] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   92.974895] CR2: 0000000000001023 CR3: 000000020f8fa001 CR4: 00000000003606a0
[   92.976994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   92.979033] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   92.981030] Call Trace:
[   92.981870]  netlink_dump+0x166/0x390
[   92.982995]  netlink_recvmsg+0x2ef/0x3e0
[   92.984184]  ? copy_msghdr_from_user+0xd5/0x150
[   92.985540]  ___sys_recvmsg+0xf5/0x250
[   92.986685]  ? netlink_sendmsg+0x120/0x3a0
[   92.987905]  ? __sys_sendto+0x10e/0x140
[   92.989077]  ? __sys_recvmsg+0x5b/0xa0
[   92.990205]  __sys_recvmsg+0x5b/0xa0
[   92.991253]  do_syscall_64+0x48/0x100
[   92.992327]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   92.993743] RIP: 0033:0x7fa7e8d48437
[   92.994783] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00
00 00 8b 05 1a f4 2b 00 48 63 d2 48 63 ff 85 c0 75 18 b8 2f 00 00 00 0f
05 <48> 3d 00 f0 ff ff 77 59 f3 c3 0f 1f 80 00 00 00 00 53 48 89 f3 48
[   92.999640] RSP: 002b:00007ffcee2ae168 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
[   93.001745] RAX: ffffffffffffffda RBX: 0000000000707320 RCX: 00007fa7e8d48437
[   93.003556] RDX: 0000000000000000 RSI: 00007ffcee2ae190 RDI: 0000000000000012
[   93.005383] RBP: 0000000000707260 R08: 00007fa7e900b0e0 R09: 000000000000000c
[   93.007206] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004035e0
[   93.009023] R13: 00007ffcee2ae348 R14: 0000000000000000 R15: 0000000000000000
[   93.010847] Modules linked in: mlx4_en mlx4_ib mlx4_core geneve
ip6_udp_tunnel udp_tunnel bonding ip6_gre ip6_tunnel tunnel6 ip_gre gre
ip_tunnel rdma_ucm ib_uverbs ib_ipoib ib_umad ib_srp scsi_transport_srp
rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm
ib_core [last unloaded: mlx4_core]
[   93.016658] CR2: 0000000000001023
[   93.017489] ---[ end trace 295441d824c2b8ba ]---
[   93.018440] RIP: 0010:genl_lock_dumpit+0x10/0xb0
[   93.019577] Code: c7 c7 a0 e6 30 82 e9 ef 96 a7 ff 0f 1f 44 00 00 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 53 48 8b 46 20 48 8b
28 <0f> b6 55 23 f6 c2 02 75 4d 4c 8b 48 08 83 e2 04 4c 8b 5e 08 80 fa
[   93.023640] RSP: 0018:ffffc90002df7c30 EFLAGS: 00010202
[   93.024836] RAX: ffffc90002df7be8 RBX: ffff888231b0e800 RCX: 0000000000000ec0
[   93.026321] RDX: 00000000000000a8 RSI: ffff888231b0eb30 RDI: ffff88823195b400
[   93.027867] RBP: 0000000000001000 R08: 0000000000001ec0 R09: ffffffff81686c01
[   93.029333] R10: ffffea0008c656c0 R11: 0000000000000040 R12: 0000000000001000
[   93.030744] R13: ffff888231b0eb30 R14: 0000000000000000 R15: ffff888230f63700
[   93.032187] FS:  00007fa7e963bb80(0000) GS:ffff888237a80000(0000) knlGS:0000000000000000
[   93.033881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.035071] CR2: 0000000000001023 CR3: 000000020f8fa001 CR4: 00000000003606a0
[   93.036502] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.037898] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   93.052853] BUG: unable to handle kernel paging request at ffffc90002df7be8
[   93.054466] #PF error: [normal kernel read fault]
[   93.055615] PGD 236931067 P4D 236931067 PUD 236934067 PMD 226489067 PTE 0
[   93.057203] Oops: 0000 [#2] SMP PTI
[   93.058069] CPU: 1 PID: 43 Comm: kworker/1:1 Tainted: G      D 5.1.0-rc2-J2742-G9070daeb7d6d #1
[   93.060241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   93.062335] Workqueue: events netlink_sock_destruct_work
[   93.063579] RIP: 0010:genl_lock_done+0xf/0x60
[   93.064641] Code: 48 c7 c7 e0 e6 30 82 e9 8f 6f 19 00 0f 1f 44 00 00
66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 53 48 83 ec 08 48 8b 47
20 <48> 8b 28 31 c0 48 83 7d 18 00 74 2f 48 89 fb 48 c7 c7 e0 e6 30 82
[   93.068791] RSP: 0018:ffffc90000173e50 EFLAGS: 00010286
[   93.070042] RAX: ffffc90002df7be8 RBX: ffff888231b0e800 RCX: 0000000000000000
[   93.071695] RDX: 0000000000000000 RSI: ffff888231b0e94c RDI: ffff888231b0eb30
[   93.073296] RBP: ffff888231b0e800 R08: 000073746e657665 R09: 8080808080808080
[   93.074964] R10: ffffc9000006bdf0 R11: fefefefefefefeff R12: ffff888237aa4200
[   93.076566] R13: 0000000000000000 R14: ffff888237aa0380 R15: 0000000000000000
[   93.078209] FS:  0000000000000000(0000) GS:ffff888237a80000(0000) knlGS:0000000000000000
[   93.080107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.081403] CR2: ffffc90002df7be8 CR3: 0000000229700004 CR4: 00000000003606a0
[   93.083006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.084590] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   93.086277] Call Trace:
[   93.086924]  netlink_sock_destruct+0x2a/0xa0
[   93.087949]  __sk_destruct+0x24/0x180
[   93.088817]  process_one_work+0x17d/0x3b0
[   93.089835]  worker_thread+0x30/0x370
[   93.090670]  ? process_one_work+0x3b0/0x3b0
[   93.091624]  kthread+0x113/0x130
[   93.092382]  ? kthread_park+0x90/0x90
[   93.093260]  ret_from_fork+0x35/0x40
[   93.094067] Modules linked in: mlx4_en mlx4_ib mlx4_core geneve
ip6_udp_tunnel udp_tunnel bonding ip6_gre ip6_tunnel tunnel6 ip_gre gre
ip_tunnel rdma_ucm ib_uverbs ib_ipoib ib_umad ib_srp scsi_transport_srp
rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm
ib_core [last unloaded: mlx4_core]
[   93.099824] CR2: ffffc90002df7be8
[   93.100718] ---[ end trace 295441d824c2b8bb ]---
[   93.101829] RIP: 0010:genl_lock_dumpit+0x10/0xb0
[   93.102919] Code: c7 c7 a0 e6 30 82 e9 ef 96 a7 ff 0f 1f 44 00 00 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 53 48 8b 46 20 48 8b
28 <0f> b6 55 23 f6 c2 02 75 4d 4c 8b 48 08 83 e2 04 4c 8b 5e 08 80 fa
[   93.107107] RSP: 0018:ffffc90002df7c30 EFLAGS: 00010202
[   93.108382] RAX: ffffc90002df7be8 RBX: ffff888231b0e800 RCX: 0000000000000ec0
[   93.110007] RDX: 00000000000000a8 RSI: ffff888231b0eb30 RDI: ffff88823195b400
[   93.111941] RBP: 0000000000001000 R08: 0000000000001ec0 R09: ffffffff81686c01
[   93.113574] R10: ffffea0008c656c0 R11: 0000000000000040 R12: 0000000000001000
[   93.115220] R13: ffff888231b0eb30 R14: 0000000000000000 R15: ffff888230f63700
[   93.116821] FS:  0000000000000000(0000) GS:ffff888237a80000(0000) knlGS:0000000000000000
[   93.118937] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.120592] CR2: ffffc90002df7be8 CR3: 0000000229700004 CR4: 00000000003606a0
[   93.122196] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.123791] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   93.528971] BUG: unable to handle kernel paging request at 0000000000001023
[   93.532427] #PF error: [normal kernel read fault]
[   93.534683] PGD 8000000228100067 P4D 8000000228100067 PUD 20f87e067 PMD 0
[   93.537776] Oops: 0000 [#3] SMP PTI
[   93.539379] CPU: 2 PID: 4005 Comm: devlink Tainted: G      D 5.1.0-rc2-J2742-G9070daeb7d6d #1
[   93.543345] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   93.547167] RIP: 0010:genl_lock_dumpit+0x10/0xb0
[   93.549214] Code: c7 c7 a0 e6 30 82 e9 ef 96 a7 ff 0f 1f 44 00 00 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 53 48 8b 46 20 48 8b
28 <0f> b6 55 23 f6 c2 02 75 4d 4c 8b 48 08 83 e2 04 4c 8b 5e 08 80 fa
[   93.556214] RSP: 0018:ffffc90002e97c30 EFLAGS: 00010202
[   93.558301] RAX: ffffc90002e97be8 RBX: ffff888232bf8800 RCX: 0000000000000ec0
[   93.561059] RDX: 00000000000000a8 RSI: ffff888232bf8b30 RDI: ffff888228cf9700
[   93.563644] RBP: 0000000000001000 R08: 0000000000001ec0 R09: ffffffff81686c01
[   93.566212] R10: ffffea0008a33e40 R11: 0000000000000040 R12: 0000000000001000
[   93.568773] R13: ffff888232bf8b30 R14: 0000000000000000 R15: ffff888225084000
[   93.571347] FS:  00007f1754062b80(0000) GS:ffff888237b00000(0000) knlGS:0000000000000000
[   93.574320] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.591673] CR2: 0000000000001023 CR3: 000000020f30e004 CR4: 00000000003606a0
[   93.593943] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.596196] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   93.598425] Call Trace:
[   93.599303]  netlink_dump+0x166/0x390
[   93.600509]  netlink_recvmsg+0x2ef/0x3e0
[   93.601792]  ? copy_msghdr_from_user+0xd5/0x150
[   93.603242]  ___sys_recvmsg+0xf5/0x250
[   93.604477]  ? netlink_sendmsg+0x120/0x3a0
[   93.605816]  ? __sys_sendto+0x10e/0x140
[   93.607076]  ? __sys_recvmsg+0x5b/0xa0
[   93.608308]  __sys_recvmsg+0x5b/0xa0
[   93.609503]  do_syscall_64+0x48/0x100
[   93.610649]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   93.612160] RIP: 0033:0x7f175376f437
[   93.613295] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00
00 00 8b 05 1a f4 2b 00 48 63 d2 48 63 ff 85 c0 75 18 b8 2f 00 00 00 0f
05 <48> 3d 00 f0 ff ff 77 59 f3 c3 0f 1f 80 00 00 00 00 53 48 89 f3 48
[   93.618540] RSP: 002b:00007ffcb7c72218 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
[   93.620790] RAX: ffffffffffffffda RBX: 000000000186d320 RCX: 00007f175376f437
[   93.622768] RDX: 0000000000000000 RSI: 00007ffcb7c72240 RDI: 000000000000000c
[   93.624688] RBP: 000000000186d260 R08: 00007f1753a320e0 R09: 000000000000000c
[   93.626610] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004035e0
[   93.628533] R13: 00007ffcb7c723f8 R14: 0000000000000000 R15: 0000000000000000
[   93.630457] Modules linked in: mlx4_en mlx4_ib mlx4_core geneve
ip6_udp_tunnel udp_tunnel bonding ip6_gre ip6_tunnel tunnel6 ip_gre gre
ip_tunnel rdma_ucm ib_uverbs ib_ipoib ib_umad ib_srp scsi_transport_srp
rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm
ib_core [last unloaded: mlx4_core]
[   93.637391] CR2: 0000000000001023
[   93.638348] ---[ end trace 295441d824c2b8bc ]---
[   93.639610] RIP: 0010:genl_lock_dumpit+0x10/0xb0
[   93.640876] Code: c7 c7 a0 e6 30 82 e9 ef 96 a7 ff 0f 1f 44 00 00 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 53 48 8b 46 20 48 8b
28 <0f> b6 55 23 f6 c2 02 75 4d 4c 8b 48 08 83 e2 04 4c 8b 5e 08 80 fa
[   93.645621] RSP: 0018:ffffc90002df7c30 EFLAGS: 00010202
[   93.646966] RAX: ffffc90002df7be8 RBX: ffff888231b0e800 RCX: 0000000000000ec0
[   93.648733] RDX: 00000000000000a8 RSI: ffff888231b0eb30 RDI: ffff88823195b400
[   93.650510] RBP: 0000000000001000 R08: 0000000000001ec0 R09: ffffffff81686c01
[   93.652283] R10: ffffea0008c656c0 R11: 0000000000000040 R12: 0000000000001000
[   93.654061] R13: ffff888231b0eb30 R14: 0000000000000000 R15: ffff888230f63700
[   93.655803] FS:  00007f1754062b80(0000) GS:ffff888237b00000(0000) knlGS:0000000000000000
[   93.657761] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.658951] CR2: 0000000000001023 CR3: 000000020f30e004 CR4: 00000000003606a0
[   93.660431] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.661971] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   93.684915] BUG: unable to handle kernel paging request at ffffc90002e97be8
[   93.686561] #PF error: [normal kernel read fault]
[   93.687650] PGD 236931067 P4D 236931067 PUD 236934067 PMD 228084067 PTE 0
[   93.689182] Oops: 0000 [#4] SMP PTI
[   93.690035] CPU: 2 PID: 38 Comm: kworker/2:1 Tainted: G      D 5.1.0-rc2-J2742-G9070daeb7d6d #1
[   93.692162] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   93.694147] Workqueue: events netlink_sock_destruct_work
[   93.695381] RIP: 0010:genl_lock_done+0xf/0x60
[   93.696387] Code: 48 c7 c7 e0 e6 30 82 e9 8f 6f 19 00 0f 1f 44 00 00
66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 53 48 83 ec 08 48 8b 47
20 <48> 8b 28 31 c0 48 83 7d 18 00 74 2f 48 89 fb 48 c7 c7 e0 e6 30 82
[   93.700436] RSP: 0018:ffffc9000014be50 EFLAGS: 00010286
[   93.701605] RAX: ffffc90002e97be8 RBX: ffff888232bf8800 RCX: 0000000000000000
[   93.703153] RDX: 0000000000000000 RSI: ffff888232bf894c RDI: ffff888232bf8b30
[   93.704712] RBP: ffff888232bf8800 R08: 000073746e657665 R09: 8080808080808080
[   93.706351] R10: ffffc900000c3df0 R11: fefefefefefefeff R12: ffff888237b24200
[   93.707943] R13: 0000000000000000 R14: ffff888237b20380 R15: 0000000000000000
[   93.709567] FS:  0000000000000000(0000) GS:ffff888237b00000(0000) knlGS:0000000000000000
[   93.711426] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.712712] CR2: ffffc90002e97be8 CR3: 000000021ce62006 CR4: 00000000003606a0
[   93.714299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.715888] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   93.717426] Call Trace:
[   93.718093]  netlink_sock_destruct+0x2a/0xa0
[   93.719157]  __sk_destruct+0x24/0x180
[   93.720027]  process_one_work+0x17d/0x3b0
[   93.721033]  worker_thread+0x30/0x370
[   93.721946]  ? process_one_work+0x3b0/0x3b0
[   93.722926]  kthread+0x113/0x130
[   93.723753]  ? kthread_park+0x90/0x90
[   93.724606]  ret_from_fork+0x35/0x40
[   93.725494] Modules linked in: mlx4_en mlx4_ib mlx4_core geneve
ip6_udp_tunnel udp_tunnel bonding ip6_gre ip6_tunnel tunnel6 ip_gre gre
ip_tunnel rdma_ucm ib_uverbs ib_ipoib ib_umad ib_srp scsi_transport_srp
rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm
ib_core [last unloaded: mlx4_core]
[   93.731221] CR2: ffffc90002e97be8
[   93.732069] ---[ end trace 295441d824c2b8bd ]---
[   93.733128] RIP: 0010:genl_lock_dumpit+0x10/0xb0
[   93.734186] Code: c7 c7 a0 e6 30 82 e9 ef 96 a7 ff 0f 1f 44 00 00 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 53 48 8b 46 20 48 8b
28 <0f> b6 55 23 f6 c2 02 75 4d 4c 8b 48 08 83 e2 04 4c 8b 5e 08 80 fa
[   93.738319] RSP: 0018:ffffc90002df7c30 EFLAGS: 00010202
[   93.739515] RAX: ffffc90002df7be8 RBX: ffff888231b0e800 RCX: 0000000000000ec0
[   93.741111] RDX: 00000000000000a8 RSI: ffff888231b0eb30 RDI: ffff88823195b400
[   93.742665] RBP: 0000000000001000 R08: 0000000000001ec0 R09: ffffffff81686c01
[   93.744233] R10: ffffea0008c656c0 R11: 0000000000000040 R12: 0000000000001000
[   93.745866] R13: ffff888231b0eb30 R14: 0000000000000000 R15: ffff888230f63700
[   93.747438] FS:  0000000000000000(0000) GS:ffff888237b00000(0000) knlGS:0000000000000000
[   93.749209] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.750540] CR2: ffffc90002e97be8 CR3: 000000021ce62006 C00000000000 DR1: 0000000000000000




>
>

--nQHD+3g9yI+EYXJy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcqw2aAAoJEORje4g2clinaSsP/1kqoLgZhNy+PpDfwjjnMpRS
19DW9Tzo9EoJG4WPXmiuVU4NOHykjLoCckUIvgNfZ499BpnaePHdYeQEMRskWVqi
AuPC/iJ5toNdIG6+1erBDKmvk+yznTHKQMuyj10KAD2wSPcS+0j/HY9pHdhXfLMK
tuwoJuByBxldFjHm2XeOrG7uNHkxyrDJbKvwdOK/9ljITtHYjKIV9PCt5p9pEInY
GZRr//v2CiPCer1adkDPFX5vOsYbKISqtWowwB73eUC1AUI5zoL8fQ16tjkp7wEB
3PguhhcxHGJ7AsUpIHOZeULU22qZirWRX+gTwIJy+uDaQCFWDGE0E/IlLNb41jP6
elQWZP972Ak8d/fvdhXdxmnmKqoL2DWq9djf2/AFX63TKDFK13jwjikglwf3Okvz
chVtohmQvUPjnSGOsbpLAMcYZxBcZG4HyazBLCUFMnxVtbu6BGlXyELNAoYcXNog
GLnjYyBdj353c+QT4W2aJ4l5Vnup/KtPB397UBOnkfU9WN/jaY8V3iYj0Zw4OwTA
WwflpXglvVH0nYwbJVwGVv6fjT7wc+cDMwVuuNaMw/Lb935WDoyoKVfESHNaIKYh
4T/nQ8yhNPySXaqIZcMWmLC5yt5J45j/LfciA2wj3s+5gmP+ZucxpdKx+m0Ov1P0
AlD8QlQHbhRyekiBtfI9
=pajj
-----END PGP SIGNATURE-----

--nQHD+3g9yI+EYXJy--
