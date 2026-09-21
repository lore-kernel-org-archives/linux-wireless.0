Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5FA3C09F5
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 12:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992255; cv=none; b=KJnAAe95D154K8JqZj3SBEid6czXSN4mrwcAUxq7tsIsM8rnRJfePdVNz9KW+fKSLBfE/gFeKDHKcS46K+W1euUW9Ny+NfyQ+rSBSc4dZllKYHV6Vp8h6dJ3bPbXQ+thvaCuPyvsMPrqpOyGjZLHOksd36uPGQBG5UVd/fhm/zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992255; c=relaxed/simple;
	bh=V2NAvhreAAB9fNyLU7P2x9rrZQXJtm0Z1JGEMd7t28Y=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=mcF9sWhzN9tCTJA4olG95MwKKX9dMgzHdjmKvalw7diQS/IGuyMdS7AarwluCnPfydBs1erantXXUnLGXqUJIK4UN9yX44PbdDjAEKmAzrfmqRNG+T0JifiqTyY7Vod9Q5e8rBWhtPz7M9MWiMRMoiHlQysG9mcX9tcs3zEZkZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-469debb526fso3584934fac.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 05:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992250; x=1790597050;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LNIyPUr3d9jDospW94D2w+VBWVwYmRIPgaoRAx0vhJM=;
        b=CcSx3vcDxULE1YIsDPsBvCI2ugvrMeTkfWo47rrfCjIze7tU1UKcPD3Qnx0rqxdAIe
         8mBwkEXIb5/+K6OtIQtdqegi5WLUes1JAwPO2CqcY2BEulFMqLL316NCs/0EUu79R3sU
         3uZxabK6N2qlytZYE0H56GAQzUuZ/cMGBGUpNUBQBO3m//vCy0HZCKVrI99yU7IFgUGZ
         Oq6+u8Zy3LyBW6I0A39yi08P4ew7PpffqUUT5ww8/3PU25M0UAlfEvoR/GIcc3VdT2Jt
         I+PQC/NJ7KVePes1ymQIX/gdrrN7PcGHhYdWGEo2Dd2/FOPREADxN2xhUYRygf5Qu39M
         pxlA==
X-Forwarded-Encrypted: i=1; AKwUvBwTx5Jj+d4qLtRdcn/q89vtZmx67+4qloMGcv+gr3+uSE3gX+gVEJqkIeeOuh6YvTtYFB3HKeJ8Hj8HLyJW6w==@vger.kernel.org
X-Gm-Message-State: AFuF++l+4pZzU4APaFHc26FAaCPFLhMMezBO+8GpfyzXXaD/Tcljd4aZ
	Rv6JzMnRQYUhr0uc/wg60w3UfvFtGKoZNmgkpo+t++I+lE0YV16clBZnU0yt+ttCtbetsDEQA7y
	NQV+CS/0PYTu8D8j5IkEj4PCDZPainE7hSLMmJiVAlHSRTWRulFFQhavLq8E=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:188c:b0:6b7:83d6:2928 with SMTP id
 006d021491bc7-6ca9c6552cbmr9841319eaf.43.1789992250478; Mon, 21 Sep 2026
 05:04:10 -0700 (PDT)
Date: Mon, 21 Sep 2026 05:04:10 -0700
In-Reply-To: <20260918170746.3824-1-roryl@candelatech.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab11d3a.514bccd6.255447.0013.GAE@google.com>
Subject: [syzbot ci] Re: net: cfg80211: Validate monitor channel set against
 radio usage
From: syzbot ci <syzbot+ci5f68e9bd92e2cda0@syzkaller.appspotmail.com>
To: dylan.eskew@candelatech.com, johannes@sipsolutions.net, 
	linux-wireless@vger.kernel.org, roryl@candelatech.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: cfg80211: Validate monitor channel set against radio usage
https://lore.kernel.org/all/20260918170746.3824-1-roryl@candelatech.com
* [PATCH wireless-next] net: cfg80211: Validate monitor channel set against radio usage

and found the following issues:
* UBSAN: shift-out-of-bounds in cfg80211_set_monitor_channel
* UBSAN: shift-out-of-bounds in corrupted

Full report is available here:
https://ci.syzbot.org/series/8cc9e8b7-7ee7-4960-86f8-d3d32e74b751

***

UBSAN: shift-out-of-bounds in cfg80211_set_monitor_channel

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      3b35f726c20d138fafa154182ee926a419306269
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/007f6283-0b6e-4ff9-84e0-69128d745e0c/config
syz repro: https://ci.syzbot.org/findings/ba5a8e20-28a0-4771-b097-95a9703e3244/syz_repro

UBSAN: shift-out-of-bounds in net/wireless/chan.c:1831:49
shift exponent -22 is negative
CPU: 0 UID: 0 PID: 5850 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 cfg80211_can_set_monitor_channel net/wireless/chan.c:1831 [inline]
 cfg80211_set_monitor_channel+0x38a/0x8d0 net/wireless/chan.c:1844
 __nl80211_set_channel+0x340/0x990 net/wireless/nl80211.c:4203
 nl80211_set_wiphy+0x127c/0x3050 net/wireless/nl80211.c:-1
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc73059e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc731480028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc730825fa0 RCX: 00007fc73059e159
RDX: 0000000004040000 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007fc73063506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc730826038 R14: 00007fc730825fa0 R15: 00007ffd4fd500b8
 </TASK>
---[ end trace ]---


***

UBSAN: shift-out-of-bounds in corrupted

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      3b35f726c20d138fafa154182ee926a419306269
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/007f6283-0b6e-4ff9-84e0-69128d745e0c/config

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in net/wireless/chan.c:1831:49
shift exponent -22 is negative
CPU: 0 UID: 0 PID: 6635 Comm: syz.3.380 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 ubsan_epilogue+0xa/0x30
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400
 cfg80211_set_monitor_channel+0x38a/0x8d0
 __nl80211_set_channel+0x340/0x990
 nl80211_set_wiphy+0x127c/0x3050
 genl_family_rcv_msg_doit+0x233/0x340
 genl_rcv_msg+0x614/0x7a0
 netlink_rcv_skb+0x226/0x4a0
 genl_rcv+0x28/0x40
 netlink_unicast+0x7bd/0x940
 netlink_sendmsg+0x813/0xb40
 sock_sendmsg_nosec+0x13a/0x180
 ____sys_sendmsg+0x54e/0x850
 ___sys_sendmsg+0x2a5/0x360
 __x64_sys_sendmsg+0x1b1/0x290
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbeb4b9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbeb5aef028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbeb4e25fa0 RCX: 00007fbeb4b9e159
RDX: 0000000004040000 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007fbeb4c3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbeb4e26038 R14: 00007fbeb4e25fa0 R15: 00007ffe46366df8
 </TASK>
---[ end trace ]---


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
