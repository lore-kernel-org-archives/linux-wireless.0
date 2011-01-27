Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53261 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab1A0Pcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 10:32:51 -0500
Received: by ywe10 with SMTP id 10so633102ywe.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 07:32:50 -0800 (PST)
Subject: oops in mesh_table_hash
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 10:31:57 -0500
Message-ID: <1296142317.27551.53.camel@mythtv.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I periodically get the oops below in mesh_table_hash. The second & third
locations in the call trace don't make much sense to me. 

I'm running on an Atheros AR7161 rev 2 in a NETGEAR WNDR3700 and
compat-wireless-2011-01-24 w/ a 2.6.37 kernel.

gdb mac80211.ko says:

(gdb) info line *mesh_table_hash+0x0c
Line 141 of "include/linux/jhash.h" starts at address 0x242e4
<mesh_table_hash+12> and ends at 0x242e8 <mesh_table_hash+16>.

I sure don't understand the cast.

Steve

------------------------------

u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata, struct mesh_table *tbl)
{
        /* Use last four bytes of hw addr and interface index as hash index */
        return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex, tbl->hash_rnd)
                & tbl->hash_mask;
}

--------------------

Unhandled kernel unaligned access[#1]:
Cpu 0
$ 0   : 00000000 80320000 6d6f6465 81082018
$ 4   : 482a9a3e 35c9d0d2 83a10e80 8302545c
$ 8   : 35c9d0d2 83a10e90 00000000 fefad0b8
$12   : 00000050 83839bd8 ca62c1d6 83839c80
$16   : 83a10e00 83a10e80 83ace900 82a86080
$20   : 83a86480 00000000 830108cc 83af7875
$24   : 00000000 8f1bbcdc
$28   : 83838000 83839de8 80330000 8302547c
Hi    : 00000000
Lo    : 00000000
epc   : 83024158 mesh_table_hash+0xc/0x170 [mac80211]
    Not tainted
ra    : 8302547c mesh_path_lookup_by_idx+0x17c/0x384 [mac80211]
Status: 1000fc03    KERNEL EXL IE
Cause : 00800010
BadVA : 6d6f64cd
PrId  : 00019374 (MIPS 24Kc)
Modules linked in: ohci_hcd ledtrig_usbdev nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_recent xt_helper xt_conntrack xt_connmark xt_connbytes xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd pppoe pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables tun ppp_async ppp_generic slhc ath9k ath9k_common ath9k_hw ath mac80211 usbcore nls_base crc_ccitt cfg80211 compat arc4 aes_generic deflate ecb cbc leds_gpio button_hotplug gpio_buttons input_polldev input_core
Process kworker/u:1 (pid: 1936, threadinfo=83838000, task=82bd6a80, tls=00000000)
Stack : 00000000 00000000 07080001 00000002 83ace900 83a10e80 00000000 830255e4
        82b76790 80079f54 82b58020 00000002 83a86480 83030000 00000012 8032c27c
        83af7800 83026434 8032c27c 800795dc 83988c20 83976680 82b86584 82b865f8
        82b86300 83024428 00000012 8032c27c 83af7800 00000000 830108cc 82b86574
        82b76780 80091884 00000008 80072db0 83b81570 83b81570 82b76780 82b76780
        ...
Call Trace:
[<83024158>] mesh_table_hash+0xc/0x170 [mac80211]
[<8302547c>] mesh_path_lookup_by_idx+0x17c/0x384 [mac80211]
[<830255e4>] mesh_path_lookup_by_idx+0x2e4/0x384 [mac80211]


Code: 8ca2016c  8cc5000c  8c840002 <8c420068> 3c03dead  3463beef  00a32821  00a42021  00a21021
Disabling lock debugging due to kernel taint
CPU 0 Unable to handle kernel paging request at virtual address fffffffc, epc == 80096cc4, ra == 800936e4
Oops[#2]:
Cpu 0
$ 0   : 00000000 00000001 00000000 00000040
$ 4   : 82bd6a80 00000000 838188b0 8026d5a0
$ 8   : 82bd6a80 ffd23940 00000052 9c06ef00
$12   : 000000cd 00000060 83838008 44a69270
$16   : 00000000 82bd6a80 82bd6be4 83818000
$20   : 82bd6b68 82bd6a78 802e58c0 80320060
$24   : 00000000 8011e4f8
$28   : 83838000 83839c50 802e0000 800936e4
Hi    : 000004ce
Lo    : 58d30b00
epc   : 80096cc4 kthread_data+0x4/0xc
    Tainted: G      D
ra    : 800936e4 wq_worker_sleeping+0x14/0xb8
Status: 1000fc02    KERNEL EXL
Cause : 80800008
BadVA : fffffffc
PrId  : 00019374 (MIPS 24Kc)
Modules linked in: ohci_hcd ledtrig_usbdev nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_recent xt_helper xt_conntrack xt_connmark xt_connbytes xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd pppoe pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables tun ppp_async ppp_generic slhc ath9k ath9k_common ath9k_hw ath mac80211 usbcore nls_base crc_ccitt cfg80211 compat arc4 aes_generic deflate ecb cbc leds_gpio button_hotplug gpio_buttons input_polldev input_core
Process kworker/u:1 (pid: 1936, threadinfo=83838000, task=82bd6a80, tls=00000000)
Stack : 00000000 82bd6a80 82bd6a80 80080d08 ffffffff 80069e30 82bd6a80 800802f0
        746f206b 65726e65 ffffffff 83839cb4 82bd6a80 83818000 82bd6b68 82bd6a78
        00000001 82bd6b68 ffffffff 80082174 83a86480 00000000 830108cc 83af7875
        82bd6bb0 83839cb4 83839cb4 83af7875 0000000b 83839d38 802a796c 00000000
        83a86480 00000000 830108cc 83af7875 80330000 80070d68 00000000 00000004
        ...
Call Trace:
[<80096cc4>] kthread_data+0x4/0xc
[<800936e4>] wq_worker_sleeping+0x14/0xb8
[<80069e30>] schedule+0xf4/0x3dc
[<80082174>] do_exit+0x5b0/0x5c4
[<80070d68>] default_cu2_call+0x0/0x4c



