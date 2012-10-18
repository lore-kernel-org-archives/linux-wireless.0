Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61637 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab2JRCaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 22:30:19 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so8087240obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2012 19:30:18 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 10:30:18 +0800
Message-ID: <CAEFj985aEc+fe=0spye=mNCaK4oET4WZ7ZyMD6Cqcj1tOjWAEA@mail.gmail.com> (sfid-20121018_043030_840753_F3EB51AE)
Subject: Re: [PATCH] mac80211: close peer link after consecutive beacon misses
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Marco

I have tried to use this patch in open mesh, no problem.

But if testing with secured mesh (authsae), it causes the following
kernel panic.

Appreciate if you can take a look on this. Thanks

Regards,
Chun-Yeow

[  153.790000] Cpu 0
[  153.790000] $ 0   : 00000000 80330000 00000001 000003e8
[  153.790000] $ 4   : 8142a2e8 ffffc6e3 00000000 00005b79
[  153.790000] $ 8   : 00000000 00000800 00000001 0000007f
[  153.790000] $12   : 00000005 0000000c 81574748 0000021c
[  153.790000] $16   : 8142a2e8 ffffc6e3 00000000 81c43d38
[  153.790000] $20   : 000000cc 00000000 00000fff 81fa2a58
[  153.790000] $24   : 00000000 80095350
[  153.790000] $28   : 81c42000 81c43c88 815cd664 814af9fc
[  153.790000] Hi    : 00000000
[  153.790000] Lo    : 00000000
[  153.790000] epc   : 8007c300 mod_timer+0x94/0x180
[  153.790000]     Tainted: G           O
[  153.790000] ra    : 814af9fc mesh_pathtbl_unregister+0x740/0xa9c [mac80211]
[  153.790000] Status: 1000d403    KERNEL EXL IE
[  153.790000] Cause : 10800034
[  153.790000] PrId  : 00019374 (MIPS 24Kc)
[  153.790000] Modules linked in: ath79_wdt ohci_hcd ledtrig_netdev
nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE
iptable_nat nf_nat pppoe xt_conntrack xt_CT xt_NOTRACK iptable_raw
xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd pppox
ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit
iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables ppp_async
ppp_generic slhc ath9k(O) ath9k_common(O) ath9k_hw(O) ath(O)
mac80211(O) usbcore usb_common nls_base crc_ccitt cfg80211(O)
compat(O) arc4 aes_generic crypto_algapi ledtrig_timer
ledtrig_default_on leds_gpio gpio_button_hotplug(O)
[  153.790000] Process kworker/u:1 (pid: 7, threadinfo=81c42000,
task=81c198f0, tls=00000000)
[  153.790000] Stack : ffffffff ffffffff 81c43d38 00000000 815cd664
81563720 8142a000 ffffc6e3
[  153.790000]         814e904a 814af9fc 00000000 00000000 00000000
00000000 00000000 00000000
[  153.790000]         00000001 81c43cc8 815cd380 815cd380 815cd380
814e9040 81c43d38 00000080
[  153.790000]         81fa0a80 814bc620 00000000 814afef0 00000000
00000000 00000001 814e8040
[  153.790000]         815cd380 815cd380 814e9040 00000000 81ffc0d8
814ac4fc 81c82900 00000000
[  153.790000]         ...
[  153.790000] Call Trace:
[  153.790000] [<8007c300>] mod_timer+0x94/0x180
[  153.790000] [<814af9fc>] mesh_pathtbl_unregister+0x740/0xa9c [mac80211]
[  153.790000]
[  153.790000]
[  153.790000] Code: 24120001  8e020010  2c420001
[  153.790000]  02002021  0c01ef3d  27a50010  8e030000  10600011
