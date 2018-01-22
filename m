Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39929 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeAVNry (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 08:47:54 -0500
Received: by mail-pf0-f194.google.com with SMTP id e11so7128497pff.6
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 05:47:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ZOimZPrSfphPMiHKXA3=kOmaFfwdofrmuv_rpXmx+vgA@mail.gmail.com>
References: <001a11c14bc837f9760560a03d51@google.com> <20171219090121.GA10221@kroah.com>
 <CACT4Y+ZggKsEjCRZsFPW5-7_ByBcz4G0uRdieLL==r4mLQjhFA@mail.gmail.com> <CACT4Y+ZOimZPrSfphPMiHKXA3=kOmaFfwdofrmuv_rpXmx+vgA@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 22 Jan 2018 14:47:33 +0100
Message-ID: <CACT4Y+YMMfsXb+X4ApcWW02Qe7FmARhHjg97H4J-369OEMnwhw@mail.gmail.com> (sfid-20180122_144816_094406_75A247EA)
Subject: Re: WARNING in sysfs_warn_dup
To: Greg KH <gregkh@linuxfoundation.org>
Cc: syzbot
        <bot+1fdad4e2731bf0c1bc19953ccc5061237ec92783@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        jakub.kicinski@netronome.com,
        Willem de Bruijn <willemb@google.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        John Fastabend <john.fastabend@gmail.com>,
        "Tobin C. Harding" <me@tobin.cc>, netdev <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 19, 2017 at 10:06 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Tue, Dec 19, 2017 at 10:03 AM, Dmitry Vyukov <dvyukov@google.com> wrot=
e:
>>
>> On Tue, Dec 19, 2017 at 10:01 AM, Greg KH <gregkh@linuxfoundation.org> w=
rote:
>>>
>>> On Mon, Dec 18, 2017 at 08:57:01AM -0800, syzbot wrote:
>>> > Hello,
>>> >
>>> > syzkaller hit the following crash on
>>> > 6084b576dca2e898f5c101baef151f7bfdbb606d
>>> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/mas=
ter
>>> > compiler: gcc (GCC) 7.1.1 20170620
>>> > .config is attached
>>> > Raw console output is attached.
>>> >
>>> > Unfortunately, I don't have any reproducer for this bug yet.
>>> >
>>> >
>>> > netlink: 9 bytes leftover after parsing attributes in process
>>> > `syz-executor3'.
>>> > sg_write: data in/out 822404280/197 bytes for SCSI command 0x12-- gue=
ssing
>>> > data in;
>>> >    program syz-executor0 not setting count and/or reply_len properly
>>> > sg_write: data in/out 262364/161 bytes for SCSI command 0xff-- guessi=
ng data
>>> > in;
>>> >    program syz-executor0 not setting count and/or reply_len properly
>>> > WARNING: CPU: 1 PID: 22282 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x60/0=
x80
>>> > fs/sysfs/dir.c:30
>>> > Kernel panic - not syncing: panic_on_warn set ...
>>>
>>> Looks like a networking issue, it tried to create two sysfs directories
>>> with the same name, which isn't a sysfs bug :)
>
>
> Now as plain text:
>
> +net/core/dev.c maintainers


Also happens for wiphy_register (on upstream
a8750ddca918032d6349adbf9a4b6555e7db20da):

------------[ cut here ]------------
sysfs: cannot create duplicate filename
'/class/ieee80211/=C5=A1=C2=A7"=C2=AD=C3=BBt{=C2=A7=C3=94=C2=AD=C3=B0=C3=B4=
 =C5=A0!=C3=97 =C5=BE 7=E2=80=A6 =C5=A0=E2=80=A0=C3=B5i=C3=B9S6 =C3=88< =C2=
=BB=C3=BE {_CK5=C3=A4=C3=A1   =C3=97=C3=9D=C3=8Am=C3=B4 Be'
WARNING: CPU: 1 PID: 8233 at fs/sysfs/dir.c:31
sysfs_warn_dup+0x7e/0xa0 fs/sysfs/dir.c:30
Kernel panic - not syncing: panic_on_warn set ...

CPU: 1 PID: 8233 Comm: syz-executor7 Not tainted 4.15.0-rc8+ #263
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x194/0x257 lib/dump_stack.c:53
 panic+0x1e4/0x41c kernel/panic.c:183
 __warn+0x1dc/0x200 kernel/panic.c:547
 report_bug+0x211/0x2d0 lib/bug.c:184
 fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
 fixup_bug arch/x86/kernel/traps.c:247 [inline]
 do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
 do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
 invalid_op+0x22/0x40 arch/x86/entry/entry_64.S:1085
RIP: 0010:sysfs_warn_dup+0x7e/0xa0 fs/sysfs/dir.c:30
RSP: 0018:ffff8801d00def20 EFLAGS: 00010286
RAX: dffffc0000000008 RBX: ffff8801c4ff2ac0 RCX: ffffffff8159dade
RDX: 000000000000cb4f RSI: ffffc9000192b000 RDI: ffff8801d00dec28
RBP: ffff8801d00def38 R08: 1ffff1003a01bd61 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801d976fa80
R13: ffff8801d833e380 R14: 0000000000000001 R15: ffffffffffffffef
 sysfs_do_create_link_sd.isra.2+0xf3/0x110 fs/sysfs/symlink.c:51
 sysfs_do_create_link fs/sysfs/symlink.c:80 [inline]
 sysfs_create_link+0x65/0xc0 fs/sysfs/symlink.c:92
 device_add_class_symlinks drivers/base/core.c:1603 [inline]
 device_add+0x74a/0x1650 drivers/base/core.c:1801
 wiphy_register+0x1468/0x2050 net/wireless/core.c:800
 ieee80211_register_hw+0x1162/0x3100 net/mac80211/main.c:1038
 mac80211_hwsim_new_radio+0x1b2e/0x2b90
drivers/net/wireless/mac80211_hwsim.c:2700
 hwsim_new_radio_nl+0x5b7/0x7c0 drivers/net/wireless/mac80211_hwsim.c:3152
 genl_family_rcv_msg+0x7b7/0xfb0 net/netlink/genetlink.c:599
 genl_rcv_msg+0xb2/0x140 net/netlink/genetlink.c:624
 netlink_rcv_skb+0x224/0x470 net/netlink/af_netlink.c:2408
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:635
 netlink_unicast_kernel net/netlink/af_netlink.c:1275 [inline]
 netlink_unicast+0x4ee/0x700 net/netlink/af_netlink.c:1301
 netlink_sendmsg+0xa4a/0xe60 net/netlink/af_netlink.c:1864
 sock_sendmsg_nosec net/socket.c:638 [inline]
 sock_sendmsg+0xca/0x110 net/socket.c:648
 ___sys_sendmsg+0x767/0x8b0 net/socket.c:2028
 __sys_sendmsg+0xe5/0x210 net/socket.c:2062
 SYSC_sendmsg net/socket.c:2073 [inline]
 SyS_sendmsg+0x2d/0x50 net/socket.c:2069
 entry_SYSCALL_64_fastpath+0x29/0xa0



If you fix this, please add:
Reported-by: syzbot+1fdad4e2731bf0c1bc19953ccc5061237ec92783@syzkaller.apps=
potmail.com
tag. It will help syzbot understand when the bug is fixed.
