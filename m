Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36217 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760027AbcDEXrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 19:47:15 -0400
Received: by mail-oi0-f50.google.com with SMTP id y204so37594785oie.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 16:47:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1456257946.9910.23.camel@sipsolutions.net>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com> <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
 <1456222441.2041.10.camel@sipsolutions.net> <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
 <1456257946.9910.23.camel@sipsolutions.net>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 5 Apr 2016 19:46:55 -0400
Message-ID: <CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com> (sfid-20160406_014744_559518_97701E9A)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation timeout.
To: Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2016 at 3:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2016-02-23 at 13:43 -0500, Avery Pennarun wrote:
>> We're putting my version of the patch into our devices in order to be
>> able to try different values and see how it changes the percentage of
>> devices with nonzero 'pending' field in agg_status.  I'm hoping using
>> zero here will result in total elimination of the pending problem,
>> but we'll see.
>
> :)
> I for one would be interested in the result. And, if you find mac80211
> is at fault, knowing what happens there.

Here's the promised update!  The news is not as good as I had hoped.

Across the GFiber fleet, number of APs per day observing the problem
(ie. the pending field > 0 for more than a minute for any station),
with the original aggregation timeout, is about 41% (yikes).  With the
aggregation timeout set to zero, the number of APs observing the
problem in a day drops to about 10%.

Obviously this is a huge improvement, but the problem isn't completely
eliminated.  In retrospect that's not totally surprising, as there are
reasons other than an AP-side aggregation timeout that an aggregation
would need to be negotiated, and a race condition in aggregation queue
setup could happen at any of those times.  I was just hoping that
those other cases would be much less frequent than they apparently
are.

This test was with backports-20150525 on ath9k.  (We have newer
versions in the queue, but they haven't rolled out to our customers
yet.  Anyway, earlier in this thread, I was able to trigger the race
condition on much newer backports.  Unfortunately the current fix
makes my reproducible test case go away, but I don't know any reason
to assume the race condition is fixed.)

While we're here, unfortunately it turns out that just observing the
agg_status file can cause crashes (though not very often... except for
a few unlucky customers), probably due to a different race condition.
Any suggestions about this one?  Stack trace attached below.  (I think
the stack trace suggests a mac80211 problem?)

Thanks!

Avery


03/30,133400.674 Unable to handle kernel paging request at virtual
address 5b35da9e
03/30,133400.675 pgd = ac238000
03/30,133400.675 [5b35da9e] *pgd=00000000
03/30,133400.675 Internal error: Oops: 5 [#1] PREEMPT SMP
03/30,133400.680 Modules linked in: ccm nf_conntrack_netlink
auto_bridge(O) fci(O) nfnetlink pktgen ath9k_htc(O) mwifiex_usb(O)
mwifiex(O) ath10k_pci(O) ath10k_core(O) arc4 ath9k(O) mac80211(O)
ath9k_common(O) ath9k_hw(O) ath(O) cfg80211(O) compat(O) bmoca(O)
xt_connmark ip6table_mangle xt_CLASSIFY iptable_mangle xt_helper
nf_nat_sip nf_conntrack_sip ip6t_REJECT ip6t_LOG nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables nf_nat_rtsp
nf_conntrack_rtsp nf_nat_h323 nf_conntrack_h323 nf_nat_irc
nf_conntrack_irc nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre
nf_nat_proto_gre nf_nat_tftp nf_conntrack_tftp nf_nat_ftp
nf_conntrack_ftp ipt_MASQUERADE ipt_REJECT ipt_LOG xt_limit xt_pkttype
xt_conntrack xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables pfe(O)
03/30,133400.753 CPU: 0    Tainted: G           O  (3.2.26 #1)
03/30,133400.758 PC is at sta_agg_status_read+0xeb/0x170 [mac80211]
03/30,133400.764 LR is at sta_agg_status_read+0xd8/0x170 [mac80211]
03/30,133400.770 pc : [<838b4d0c>]    lr : [<838b4cf9>]    psr: 20010033
03/30,133400.770 sp : ac0c3c58  ip : 0000000f  fp : ac0c3c71
03/30,133400.782 r10: ac341800  r9 : af7f3b53  r8 : 00000001
03/30,133400.787 r7 : 00000007  r6 : 5b35da40  r5 : ac0c3f38  r4 : ac0c3d90
03/30,133400.794 r3 : ac0c3d8d  r2 : 838c6958  r1 : 000001a8  r0 : ac0c3d90
03/30,133400.800 Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb
 Segment user
03/30,133400.807 Control: 50c53c7d  Table: 2c23804a  DAC: 00000015
03/30,133400.813 Process psstat (pid: 25220, stack limit = 0xac0c22f0)
03/30,133400.819 Stack: (0xac0c3c58 to 0xac0c4000)
03/30,133400.824 3c40:
      00000209 a6199050
03/30,133400.832 3c60: ac0c3d58 7e957143 00000001 ac0c3f88 78656e00
69642074 676f6c61 6b6f745f
03/30,133400.840 3c80: 203a6e65 0a317830 09444954 09585209 4e4b5444
4e535309 58540909 4b544409
03/30,133400.848 3ca0: 6570094e 6e69646e 30300a67 09300909 30307830
30783009 09093030 78300930
03/30,133400.857 3cc0: 30093030 300a3030 30090931 30783009 78300930
09303030 30093009 09303078
03/30,133400.865 3ce0: 0a303030 09093230 78300930 30093030 30303078
09300909 30307830 30303009
03/30,133400.873 3d00: 0933300a 30093009 09303078 30307830 30090930
30783009 30300930 34300a30
03/30,133400.881 3d20: 09300909 30307830 30783009 09093030 78300930
30093030 300a3030 30090935
03/30,133400.889 3d40: 30783009 78300930 09303030 30093009 09303078
0a303030 09093630 78300931
03/30,133400.898 3d60: 30096632 32323678 31090966 38783009 32310933
30343230 35383333 0937300a
03/30,133400.906 3d80: 30093109 09303578 31307830 31090961 38300a00
09300909 30307830 30783009
03/30,133400.914 3da0: 09093030 78300930 30093030 300a3030 30090939
30783009 78300930 09303030
03/30,133400.922 3dc0: 30093009 09303078 0a303030 09093031 78300930
30093030 30303078 09300909
03/30,133400.930 3de0: 30307830 30303009 0931310a 30093009 09303078
30307830 30090930 30783009
03/30,133400.939 3e00: 30300930 32310a30 09300909 30307830 30783009
09093030 78300930 30093030
03/30,133400.947 3e20: 310a3030 30090933 30783009 78300930 09303030
30093009 09303078 0a303030
03/30,133400.955 3e40: 09093431 78300930 30093030 30303078 09300909
30307830 30303009 0935310a
03/30,133400.963 3e60: 30093009 09303078 30307830 30090930 30783009
30300930 00000a30 bfa440c0
03/30,133400.971 3e80: 842caf64 842cadb4 ac0c3e90 8401ea65 00000000
c55f8337 c55f8337 000015e4
03/30,133400.980 3ea0: bb3f54b8 ac0c3eb8 c55f8337 84021ad3 bf82f060
00000001 80000000 00000000
03/30,133400.988 3ec0: 84008b15 00000000 00000002 84040045 ffffffff
00000000 00000002 84470aac
03/30,133400.996 3ee0: ac0c3f18 bb05f780 00000000 840401b5 00000000
84431160 ac0c2000 bb3f5480
03/30,133401.004 3f00: ac0c3f18 842c792d 84cb6160 00000005 ac0c3f18
00000001 bd3e9668 00000001
03/30,133401.012 3f20: 842caf64 842cadb4 8400caf5 00000000 00000000
00000000 8443e8b8 bd3e9660
03/30,133401.021 3f40: 838b4c21 7e957143 ac0c3f88 7e957143 ac0c2000
00000000 0002802c 840993bb
03/30,133401.029 3f60: 00000030 00000001 bd3e9660 00000001 000001fa
00000000 7e957143 84099637
03/30,133401.037 3f80: ac0c2000 00000000 000001fa 00000000 00000001
0049fc94 0049fcca 00000003
03/30,133401.045 3fa0: 8400cc44 8400ca81 00000001 0049fc94 00000000
7e957143 00000001 00000030
03/30,133401.054 3fc0: 00000001 0049fc94 0049fcca 00000003 ffffffff
00028028 00000000 0002802c
03/30,133401.062 3fe0: 00000000 7e957134 00014428 2ac417cc 60010010
00000000 00000000 00000000
03/30,133401.070 [<838b4d0c>] (sta_agg_status_read+0xeb/0x170
[mac80211]) from [<840993bb>] (vfs_read+0x5f/0xcc)
03/30,133401.080 [<840993bb>] (vfs_read+0x5f/0xcc) from [<84099637>]
(sys_read+0x27/0x48)
03/30,133401.088 [<84099637>] (sys_read+0x27/0x48) from [<8400ca81>]
(ret_fast_syscall+0x1/0x46)
03/30,133401.096 Code: f1b8 0f00 d036 4620 (f896) 305e
03/30,133401.104 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0,
skipped old beacon
03/30,133401.106 waveguide: ZONEED: APs=63
peer-APs=LOFHAL(-10),QIYQAW(-26) stations=
03/30,133401.106 waveguide: Connected station VVMKUW taxonomy:
BCM4339;iPhone 6/6+;802.11ac n:1,w:80
03/30,133401.106 waveguide: Connected station FYLWIQ taxonomy:
SHA:f0297d6b773948dcc4c86451a0207ba7d9e97e1cc864b3031001ae2105faa872;Unknown;802.11n
n:2,w:40
03/30,133401.143 ---[ end trace e62670ec7c09380f ]---
03/30,133401.148 Kernel panic - not syncing: Fatal exception
03/30,133401.153 [<840111e1>] (unwind_backtrace+0x1/0x8c) from
[<842c61fd>] (panic+0x5d/0x134)
03/30,133401.162 [<842c61fd>] (panic+0x5d/0x134) from [<8400f60b>]
(die+0x203/0x224)
03/30,133401.169 [<8400f60b>] (die+0x203/0x224) from [<842c5897>]
(__do_kernel_fault.part.5+0x4f/0x5c)
03/30,133401.178 [<842c5897>] (__do_kernel_fault.part.5+0x4f/0x5c)
from [<84013d23>] (do_page_fault+0x20b/0x268)
03/30,133401.188 [<84013d23>] (do_page_fault+0x20b/0x268) from
[<84008293>] (do_DataAbort+0x2f/0x70)
03/30,133401.197 [<84008293>] (do_DataAbort+0x2f/0x70) from
[<8400c4f5>] (__dabt_svc+0x35/0x60)
03/30,133401.206 Exception stack(0xac0c3c10 to 0xac0c3c58)
03/30,133401.211 3c00:                                     ac0c3d90
000001a8 838c6958 ac0c3d8d
03/30,133401.220 3c20: ac0c3d90 ac0c3f38 5b35da40 00000007 00000001
af7f3b53 ac341800 ac0c3c71
03/30,133401.228 3c40: 0000000f ac0c3c58 838b4cf9 838b4d0c 20010033 ffffffff
03/30,133401.235 [<8400c4f5>] (__dabt_svc+0x35/0x60) from [<838b4d0c>]
(sta_agg_status_read+0xeb/0x170 [mac80211])
03/30,133401.245 [<838b4d0c>] (sta_agg_status_read+0xeb/0x170
[mac80211]) from [<840993bb>] (vfs_read+0x5f/0xcc)
03/30,133401.255 [<840993bb>] (vfs_read+0x5f/0xcc) from [<84099637>]
(sys_read+0x27/0x48)
03/30,133401.263 [<84099637>] (sys_read+0x27/0x48) from [<8400ca81>]
(ret_fast_syscall+0x1/0x46)
03/30,133401.272 CPU1: stopping
03/30,133401.275 [<840111e1>] (unwind_backtrace+0x1/0x8c) from
[<8401088d>] (handle_IPI+0xcd/0x104)
03/30,133401.283 [<8401088d>] (handle_IPI+0xcd/0x104) from
[<8400c7c1>] (__irq_usr+0x41/0xa0)
03/30,133401.292 Rebooting in 3 seconds..
