Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52889 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab0EAJ1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 05:27:46 -0400
Received: from localhost
	([127.0.0.1] helo=purkki.valot.fi ident=kvalo)
	by purkki.valot.fi with esmtp (Exim 4.69)
	(envelope-from <kvalo@adurom.com>)
	id 1O88zA-0004dw-8r
	for linux-wireless@vger.kernel.org; Sat, 01 May 2010 12:27:44 +0300
To: linux-wireless@vger.kernel.org
Subject: HT rate warning with openwrt AP using wireless-compat and ath9k
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 01 May 2010 12:27:44 +0300
Message-ID: <87och0j7jj.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm running OpenWrt 10.03 on Netgear WNDR3700 and I'm having stability
issues. The AP reboots few times a week, maybe even daily. I get the
feeling that my wife's windows laptop is related to the reboots
somehow, but I haven't investigated this in detail yet. Also I do not
have access to serial console, so I don't have proper logs.

But today the AP didn't reboot, wireless was just dead. I managed to
find this with ssh:

------------[ cut here ]------------
WARNING: at
/home/openwrt/backfire/build/ar71xx/build_dir/linux-ar71xx/compat-wireless-2010-03-24/net/mac80211/rx.c:2528
0x83115884()
Rate marked as an HT rate but passed status->rate_idx is not an MCS
index [0-76]: 123 (0x7b)
Modules linked in: ip6t_REJECT ip6t_LOG ip6t_rt ip6t_hbh ip6t_mh
ip6t_ipv6header ip6t_frag ip6t_eui64 ip6t_ah ip6table_raw ip6_queue
ip6table_mangle ip6table_filter ip6_tables nf_conntrack_ipv6
nf_nat_tftp nf_conntrack_tftp nf_nat_irc nf_conntrack_irc nf_nat_ftp
nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_NOTRACK
iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack
pppoe pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport
xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp
x_tables sit tunnel4 ppp_async ppp_generic slhc ath9k ath9k_common
ath9k_hw ath mac80211 crc_ccitt cfg80211 compat_firmware_class compat
arc4 aes_generic deflate ecb cbc ipv6 leds_gpio button_hotplug
gpio_buttons input_polldev input_core
Call Trace:[<8007d338>] 0x8007d338
[<800683c4>] 0x800683c4
[<800683c4>] 0x800683c4
[<8007cb6c>] 0x8007cb6c
[<83115884>] 0x83115884
[<8007cbec>] 0x8007cbec
[<800d5ab0>] 0x800d5ab0
[<83115884>] 0x83115884
[<801e1ed8>] 0x801e1ed8
[<83b96c38>] 0x83b96c38
[<830858b0>] 0x830858b0
[<830847d0>] 0x830847d0
[<80081b98>] 0x80081b98
[<800a7968>] 0x800a7968
[<8008238c>] 0x8008238c
[<8008246c>] 0x8008246c
[<8006082c>] 0x8006082c
[<80060a00>] 0x80060a00
[<8006b330>] 0x8006b330
[<8006c7d0>] 0x8006c7d0
[<80060a20>] 0x80060a20
[<802d1a48>] 0x802d1a48
[<802d13a8>] 0x802d13a8

---[ end trace 85c3d4dc1fef0e68 ]---

Some info about the setup:

Linux harkko.valot.fi 2.6.32.10 #20 Tue Apr 6 15:01:26 CEST 2010 mips
GNU/Linux

kmod-ath9k - 2.6.32.10+2010-03-24-5
kmod-mac80211 - 2.6.32.10+2010-03-24-5

DISTRIB_ID="OpenWrt"
DISTRIB_RELEASE="10.03"
DISTRIB_CODENAME="backfire"
DISTRIB_DESCRIPTION="OpenWrt Backfire 10.03"

phy0: Atheros AR9280 Rev:2 mem=0xb0000000, irq=48
phy1: Atheros AR9280 Rev:2 mem=0xb0010000, irq=49

-- 
Kalle Valo
