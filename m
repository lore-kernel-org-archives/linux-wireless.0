Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:39145 "EHLO willies.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbZBPWc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 17:32:58 -0500
Subject: Re: [Developers] ISL3880IK crashes with 2.6.19.1 / .21.1
From: Jan Willies <jan@willies.info>
To: developers@islsm.org
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46631BD2.20704@willies.info>
References: <46631BD2.20704@willies.info>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 22:57:03 +0100
Message-Id: <1234821423.21691.96.camel@localhost.localdomain> (sfid-20090216_233303_547652_DC367D9D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag, den 03.06.2007, 21:51 +0200 schrieb Jan Willies:
> I tried to replace my broken atheros card with an ISL3880IK one but it 
> crashes. I tried both wireless-tools.28/29 and kernel 2.6.19.1/2.6.21.1
> 
> My system is OpenWrt on a Netgear WGT634U (mipsel).
> 
> root@OpenWrt:/# iwconfig
> lo        no wireless extensions.
> 
> ethData bus error, epc == c010810c, ra == c010765c
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 1000b800 abad0000 a1fa02e8
> $ 4   : 00000001 c00f0000 00000013 00000001
> $ 8   : 00000004 800fbb6c 00000000 00000000
> $12   : 00000000 00000100 00000400 00000000
> $16   : 818a1980 1000b801 81ee0a80 81ee0800
> $20   : 00000010 00000000 a1fa0000 ff02000d
> $24   : 00000000 2abd45f0
> $28   : 81c7c000 81c7dce8 00000000 c010765c
> Hi    : 000002fc
> Lo    : 00035866
> epc   : c010810c     Not tainted
> ra    : c010765c Status: 1000b803    KERNEL EXL IE
> Cause : 0000001c
> PrId  : 00029007
> Modules linked in: sch_red sch_sfq sch_hfsc cls_fw prism54 
> ip_conntrack_tftp ip_nat_irc ip_conntrack_irc ip_nat_ftp 
> ip_conntrack_ftp ipt_TTL ipt_ttl ipt_TOS ipt_time ipt_tos xt_MARK 
> xt_mark xt_mac xt_length ipt_ECN ipt_ecn xt_CLASSIFY imq ipt_IMQ 
> ipt_layer7 ipt_ipp2p xt_NOTRACK iptable_raw xt_portscan xt_DELUDE 
> xt_string ipt_recent ipt_owner ipt_LOG xt_helper xt_CONNMARK xt_connmark 
> tun ppp_async ppp_generic slhc crc_ccitt nfs lockd sunrpc switch_robo 
> switch_core diag
> Process iwconfig (pid: 2228, threadinfo=81c7c000, task=81cc15a0)
> Stack : 0000000a 8034e000 812318c0 8034e000 00000000 81cc15a0 8003d39c 
> 81ee0e30
>          81ee0e30 8002f260 00000004 00000000 00000000 801f79ac 7fd95178 
> 0000008a
>          ff02000d 81ee0a80 81c7dd98 c0110aa8 812318c0 8034e000 00000000 
> 812318c0
>          00000004 81c7dd50 00000000 8002a7fc 81c7de70 81c7de70 81c7de60 
> 801f79ac
>          7fd95178 7fd951f8 81c7de60 00008b01 81ee0800 c010b5b8 80001e30 
> 00000005
>          ...
> Call 
> Trace:[<8003d39c>][<8002f260>][<c0110aa8>][<8002a7fc>][<c010b5b8>][<80001e30>][<800039a0>][<c010b53c>][<80166258>][<800fbb5c>][<c010b53c>][<80166794>][<8011e3f8>][<80157fe0>][<8001f2c8>][<80112914>][<801128f4>][<8008282c>][<80082b48>][<80073db0>][<8007136c>][<80082bc8>][<800617e0>][<80061710>][<8000cdc0>][<8000cdc0>]
> 
> Code: 10800014  24020002  3c02abad <8ca30010> 3442face  1462000f 
> 24020008  08042050  00000000
> 0      no wireless extensions.
> 
> eth0.0    no wireless extensions.
> 
> eth0.1    no wireless extensions.
> 
> imq0      no wireless extensions.
> 
> imq1      no wireless extensions.
> 
> Segmentation fault

Well, it turned out that the mini-pci slot in the WGT634U was b0rked
after all and not the atheros card or the p54/prism54 driver :/

The p54 driver works fine on my x86 system, even with AP-mode. Thanks
for making this happen!


cheers

- jan

