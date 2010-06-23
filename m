Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub3.uq.edu.au ([130.102.148.131]:51660 "EHLO
	mailhub3.uq.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0FWXtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 19:49:14 -0400
Received: from smtp3.uq.edu.au (smtp3.uq.edu.au [130.102.128.18])
	by mailhub3.uq.edu.au (8.13.8/8.13.8) with ESMTP id o5NNa7RX012317
	for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 09:36:08 +1000
Received: from cb8fa4ad.qrl.nicta.com.au (cb8fa4ad.qrl.nicta.com.au [203.143.164.173])
	(authenticated bits=0)
	by smtp3.uq.edu.au (8.13.8/8.13.8) with ESMTP id o5NNa7SI001256
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 09:36:07 +1000
From: Peizhao Hu <peizhao@itee.uq.edu.au>
Content-Type: text/plain; charset=us-ascii
Subject: PCI error for some CM9 chipsets when using ath5k
Date: Thu, 24 Jun 2010 09:36:06 +1000
Message-Id: <1608CB75-51CF-4F43-9B8E-940F98F5C494@itee.uq.edu.au>
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I have a number of CM9 cards that crash every time I reload ath5k (compat-wireless-2010-05-24) with the following error message. The strange thing is that it only happen to my newer CM9 cards (AR5213A-001 chipset), older version cards (AR5213A-00 chipset) work fine.  The same card works fine if I use madwifi as the driver. When I replace the CM9 card with a EMP-8602 PLUS-S card, the ath5k seems working ok as well.

Anyone know why and how to fix it?

dmesg output when I reload the driver
========================
ath_rate_minstrel: unloaded
wlan: mac acl policy unregistered
wlan: driver unloaded
ath_pci: driver unloaded
ath_hal: driver unloaded
ath9k: Driver unloaded
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: AU
ath5k 0000:00:14.0: registered as 'phy0'
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF5112B multiband radio found (0x36)
cfg80211: Calling CRDA for country: US
cfg80211: Current regulatory domain intersected:
   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
   (2457000 KHz - 2472000 KHz @ 15000 KHz), (300 mBi, 2000 mBm)
   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)


error message right after the reload
====================
root@OpenWrt:/# PCI error 1 at PCI addr 0x10008020
Data bus error, epc == 87c468e0, ra == 87c468d8
Oops[#1]:
Cpu 0
$ 0   : 00000000 806b0000 deadc0de b0000000
$ 4   : 00000002 b0008034 b0000000 00000000
$ 8   : 0000000a 00000000 00000001 0000004d
$12   : 00000050 87defb98 ca62c1d6 87defc40
$16   : 87e24000 00008024 00008020 00000001
$20   : 00001f30 00001ef0 000003e8 018003e8
$24   : 00000000 8f1bbcdc
$28   : 87dee000 87defce0 00000064 87c468d8
Hi    : 00000000
Lo    : 00000000
epc   : 87c468e0 ath5k_hw_reset_tsf+0x44/0x90 [ath5k]
   Tainted: P
ra    : 87c468d8 ath5k_hw_reset_tsf+0x3c/0x90 [ath5k]
Status: 1800f403    KERNEL EXL IE
Cause : 1080001c
PrId  : 00019374 (MIPS 24Kc)
Modules linked in: ath9k ath9k_common ath9k_hw ath5k ath mac80211 cfg80211 ohci_hcd nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_c
onntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd pppoe pppox ipt_REJECT
xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables nfs ppp_async ppp_generic slhc lockd sun
rpc usbcore nls_base crc_ccitt compat_firmware_class compat arc4 aes_generic deflate ecb cbc leds_gpio button_hotplug gpio_buttons input_polldev input_core [
last unloaded: cfg80211]
Process phy0 (pid: 729, threadinfo=87dee000, task=87884488, tls=00000000)
Stack : 802d0000 806c0c99 806c0c5c 00000000 000003e8 00008030 00008034 87e24000
       00000001 87c46ae8 00000002 87defdd0 00000064 87c4e6c8 00000000 87defdd0
       00000003 8772e2c0 8772e2c0 87e78200 8772e564 00000002 87defdd0 87e87710
       87defdd0 8018d8f0 8755e4e0 00009920 87e787e4 87e8d8d4 00000001 5077ec03
       87defdd0 87e78200 8772e2c0 00000000 fffffffe 8772e564 00000000 00000000
       ...
Call Trace:
[<87c468e0>] ath5k_hw_reset_tsf+0x44/0x90 [ath5k]
[<87c46ae8>] ath5k_hw_init_beacon+0x1bc/0x254 [ath5k]
[<87e87710>] __ieee80211_sta_join_ibss+0x6c/0x43c [mac80211]
[<87e8884c>] ieee80211_ibss_work+0x55c/0x6f8 [mac80211]
[<8008e47c>] worker_thread+0x134/0x1d8
[<80091e60>] kthread+0x7c/0x88
[<8006cbac>] kernel_thread_helper+0x10/0x18


Code: 00642021  8e0400ac  8e060098 <3c030100> 02202821  00439825  0244280b  00c52821  0c05fe7e

--
Regard;

Peizhao Hu






