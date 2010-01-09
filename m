Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39364 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0AIXPN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 18:15:13 -0500
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id 0EA01852C
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 00:15:11 +0100 (CET)
Received: from hauke-m.de ([127.0.0.1])
	by localhost (hauke-m.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GELLkRN+ETfB for <linux-wireless@vger.kernel.org>;
	Sun, 10 Jan 2010 00:15:07 +0100 (CET)
Received: from [192.168.0.152] (host-091-097-244-008.ewe-ip-backbone.de [91.97.244.8])
	by hauke-m.de (Postfix) with ESMTPSA id 680D18526
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 00:15:07 +0100 (CET)
Message-ID: <4B490DF9.10802@hauke-m.de>
Date: Sun, 10 Jan 2010 00:15:05 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: kernel panic with b43 and hostap on mips
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using compat-wireless of 2010-01-07 and mac80211: fix netdev 
queues, mac80211: fix a few work bugs and mac80211: fix endian error by 
Johannes.

The system is running OpenWrt with kernel 2.6.30.10 on Asus WL-500GP 
(brcm47xx system mips) and hostap git of 2010-01-08.

The Systems and hostapd starts normal, but if a client tries to connect 
to the access point the AP crashes. Without encryption it works without 
any problems but with PSK and WPA1 the system crashes with the attached 
panic. I have not tried other encryption modes. With compat-wireless of 
2009-12-05 and hostap git of 2009-11-29 the system worked link expected.

Hauke

root@OpenWrt:/# Unhandled kernel unaligned access[#1]:
Cpu 0
$ 0   : 00000000 00478a6b 00002000 0001a680
$ 4   : 00001520 80f4e300 00000003 00000005
$ 8   : 00000002 00000001 00100000 00000000
$12   : 00000000 00000000 00000083 00470000
$16   : 0000174f 80e38b80 80f4e300 80f60800
$20   : 80f4e300 00000091 00000300 00000000
$24   : 00000001 80f6f8e1
$28   : 80f34000 80f35c98 fffffff0 80198884
Hi    : 00000000
Lo    : 00000080
epc   : 8019889c dev_queue_xmit+0x1d0/0x418
     Not tainted
ra    : 80198884 dev_queue_xmit+0x1b8/0x418
Status: 1000dc03    KERNEL EXL IE
Cause : 00800010
BadVA : 0000174f
PrId  : 00029006 (Broadcom BCM3302)
Modules linked in: usb_storage uhci_hcd ohci_hcd nf_nat_tftp 
nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp 
nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_NOTRACK 
iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack 
ehci_hcd sd_mod pppoe pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_multiport 
xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp 
x_tables ext3 jbd ppp_async ppp_generic slhc vfat fat jbd2 b43legacy b43 
nls_utf8 nls_koi8_r nls_iso8859_2 nls_iso8859_15 nls_iso8859_13 
nls_iso8859_1 nls_cp866 nls_cp852 nls_cp850 nls_cp775 nls_cp437 
nls_cp1251 nls_cp1250 usbcore scsi_mod nls_base mac80211 cfg80211 compat 
mbcache crc16 crc_ccitt arc4 aes_generic deflate ecb cbc switch_robo 
switch_core diag
Process hostapd (pid: 3325, threadinfo=80f34000, task=80f52568, 
tls=00000000)
Stack : fffffff0 80187ce8 80f35d38 000000f1 00000000 00000091 80f60800 
80f35e08
         80ee5a00 8020d1d4 80289b88 8001e480 00000cfd 00000000 00000000 
00000000
         00000000 81804424 80f35d58 00000000 00000091 80f35e24 80f35e44 
80f35e44
         80f35e24 00000000 00000010 80184510 80f35e44 80f35e44 00000000 
7fe63134
         80f35e84 80184104 81c204c8 00000091 818b0940 80f35e18 00000000 
80f35e08
         ...
Call Trace:
[<8019889c>] dev_queue_xmit+0x1d0/0x418
[<8020d1d4>] packet_sendmsg+0x1ec/0x38c
[<80184510>] sock_sendmsg+0xa8/0xd8
[<801846e8>] sys_sendmsg+0x1a8/0x224
[<800031f0>] stack_done+0x20/0x3c


Code: 3042cfff  34422000  a642007c <8e030000> 1060003f  00000000 
8e02004c  30420004  10400005
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 3 seconds..

