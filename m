Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:46788 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbeEMSpI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 May 2018 14:45:08 -0400
Date: Sun, 13 May 2018 11:47:14 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot+e64565577af34b3768dc@syzkaller.appspotmail.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in dev_vprintk_emit
Message-ID: <20180513184714.GA677@sol.localdomain> (sfid-20180513_204524_231442_249A0179)
References: <001a113a36724a053a0562f93c05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <001a113a36724a053a0562f93c05@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+MAC80211 list and maintainer]

On Wed, Jan 17, 2018 at 05:58:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> c92a9a461dff6140c539c61e457aa97df29517d6
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e64565577af34b3768dc@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> WARNING: CPU: 1 PID: 3652 at drivers/base/core.c:2884 create_syslog_header
> drivers/base/core.c:2884 [inline]
> WARNING: CPU: 1 PID: 3652 at drivers/base/core.c:2884
> dev_vprintk_emit+0x159/0x510 drivers/base/core.c:2894
> Kernel panic - not syncing: panic_on_warn set ...
> 
> CPU: 1 PID: 3652 Comm: syzkaller376059 Not tainted 4.15.0-rc7+ #260
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  panic+0x1e4/0x41c kernel/panic.c:183
>  __warn+0x1dc/0x200 kernel/panic.c:547
>  report_bug+0x211/0x2d0 lib/bug.c:184
>  fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
>  fixup_bug arch/x86/kernel/traps.c:247 [inline]
>  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
>  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
>  invalid_op+0x22/0x40 arch/x86/entry/entry_64.S:1079
> RIP: 0010:create_syslog_header drivers/base/core.c:2884 [inline]
> RIP: 0010:dev_vprintk_emit+0x159/0x510 drivers/base/core.c:2894
> RSP: 0018:ffff8801bc40ee68 EFLAGS: 00010286
> RAX: dffffc0000000008 RBX: ffff8801bc080980 RCX: ffffffff8159da9e
> RDX: 0000000000000000 RSI: 1ffff100378f9d2d RDI: 0000000000000293
> RBP: ffff8801bc40efa8 R08: 1ffff10037881d60 R09: 0000000000000000
> R10: ffff8801bc40f090 R11: 0000000000000000 R12: 1ffff10037881dd4
> R13: ffff8801d472c400 R14: ffff8801bc40eec0 R15: ffff8801bc40efe0
>  dev_printk_emit+0xc0/0xf0 drivers/base/core.c:2907
>  __dev_printk+0xa7/0x120 drivers/base/core.c:2919
>  dev_printk+0x111/0x170 drivers/base/core.c:2936
>  ieee80211_init_rate_ctrl_alg+0x2d5/0x4a0 net/mac80211/rate.c:978
>  ieee80211_register_hw+0x1448/0x3100 net/mac80211/main.c:1091
>  mac80211_hwsim_new_radio+0x1b2e/0x2b90
> drivers/net/wireless/mac80211_hwsim.c:2700
>  hwsim_new_radio_nl+0x5b7/0x7c0 drivers/net/wireless/mac80211_hwsim.c:3152
>  genl_family_rcv_msg+0x7b7/0xfb0 net/netlink/genetlink.c:599
>  genl_rcv_msg+0xb2/0x140 net/netlink/genetlink.c:624
>  netlink_rcv_skb+0x224/0x470 net/netlink/af_netlink.c:2408
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:635
>  netlink_unicast_kernel net/netlink/af_netlink.c:1275 [inline]
>  netlink_unicast+0x4ee/0x700 net/netlink/af_netlink.c:1301
>  netlink_sendmsg+0xa4a/0xe60 net/netlink/af_netlink.c:1864
>  sock_sendmsg_nosec net/socket.c:638 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:648
>  ___sys_sendmsg+0x767/0x8b0 net/socket.c:2028
>  __sys_sendmsg+0xe5/0x210 net/socket.c:2062
>  SYSC_sendmsg net/socket.c:2073 [inline]
>  SyS_sendmsg+0x2d/0x50 net/socket.c:2069
>  entry_SYSCALL_64_fastpath+0x23/0x9a
> RIP: 0033:0x43fd89
> RSP: 002b:00007ffe0ab23e98 EFLAGS: 00000203 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 000000000043fd89
> RDX: 0000000000000000 RSI: 0000000020b3dfc8 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000203 R12: 00000000004016f0
> R13: 0000000000401780 R14: 0000000000000000 R15: 0000000000000000
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> If you want to test a patch for this bug, please reply with:
> #syz test: git://repo/address.git branch
> and provide the patch inline or as an attachment.
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.

The bug is that mac80211_hwsim allows creating device names that are too long,
via HWSIM_CMD_NEW_RADIO.  Commit a7cfebcb7594a2 ("cfg80211: limit wiphy names to
128 bytes") limited them to 128 bytes, but it's not enough because
dev_vprintk_emit() needs the device name plus some other stuff to not exceed 128
bytes.  Here's a reproducer that works on Linus' tree (commit ccda3c4b777),
provided that CONFIG_MAC80211_HWSIM=y.  Note that you'll probably need to change
the hardcoded MAC80211_HWSIM generic netlink family ID for it to work.
Johannes, what would you say about limiting the name length to 64 bytes instead?

#include <linux/genetlink.h>
#include <sys/socket.h>
#include <unistd.h>

#define HWSIM_CMD_NEW_RADIO     4
#define HWSIM_ATTR_RADIO_NAME   17

/* Replace with `genl-ctrl-list | awk '/MAC80211_HWSIM/{print $1}'` */
#define MAC80211_HWSIM_GENL_ID  0x17

/* Length of name to test */
#define NAMELEN 128

int main()
{
        struct {
                struct nlmsghdr         hdr;
                struct genlmsghdr       ghdr;
                struct nlattr           attr;
                char radio_name[NLA_ALIGN(NAMELEN)];
        } msg = {
                .hdr = {
                        .nlmsg_len = sizeof(msg),
                        .nlmsg_type = MAC80211_HWSIM_GENL_ID,
                        .nlmsg_flags = NLM_F_REQUEST,
                },
                .ghdr = { .cmd = HWSIM_CMD_NEW_RADIO },
                .attr = {
                        .nla_len = sizeof(struct nlattr) + NAMELEN,
                        .nla_type = HWSIM_ATTR_RADIO_NAME,
                },
                .radio_name = {[0 ... NAMELEN-1] = 'A'},
        };

        int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
        write(fd, &msg, sizeof(msg));
}
