Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:49642 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYB0Vmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 16:42:39 -0500
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k WARNING: at ieee80211_rate.h:149
References: <m38x17sk2g.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 27 Feb 2008 22:42:37 +0100
In-Reply-To: <m38x17sk2g.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Tue\, 26 Feb 2008 18\:29\:11 +0100")
Message-ID: <m3pruim5yq.fsf@maximus.localdomain> (sfid-20080227_214252_712888_E91CBF15)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Krzysztof Halasa <khc@pm.waw.pl> writes:

> ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> phy0: Adding new IBSS station XXX (dev=wlan0)
> ------------[ cut here ]------------
> WARNING: at net/mac80211/ieee80211_rate.h:149 rate_control_pid_rate_init+0x6c/0x7c()
> Modules linked in: ixp4xx_eth ixp4xx_hss ixp4xx_qmgr ixp4xx_npe ath5k
> [<c00c1b3c>] (dump_stack+0x0/0x14) from [<c00d463c>] (warn_on_slowpath+0x4c/0x60)
> [<c00d45f0>] (warn_on_slowpath+0x0/0x60) from [<c032a50c>] (rate_control_pid_rate_init+0x6c/0x7c)
>  r6:c689e800 r5:c7cace18 r4:c68ab000
> [<c032a4a0>] (rate_control_pid_rate_init+0x0/0x7c) from [<c031e56c>] (ieee80211_ibss_add_sta+0xb0/0x114)
>  r5:c7cac160 r4:c68ab000
> [<c031e4bc>] (ieee80211_ibss_add_sta+0x0/0x114) from [<c0323b5c>] (__ieee80211_rx_handle_packet+0x87c/0x978)
>  r8:c6876030 r7:c7cac160 r6:c689eb60 r5:00000000 r4:00000000
> [<c03232e0>] (__ieee80211_rx_handle_packet+0x0/0x978) from [<c0324a54>] (__ieee80211_rx+0x2b4/0x6dc)
> [<c03247a0>] (__ieee80211_rx+0x0/0x6dc) from [<bf0028cc>] (ath5k_tasklet_rx+0x35c/0x66c [ath5k])
> [<bf002570>] (ath5k_tasklet_rx+0x0/0x66c [ath5k]) from [<c00da158>] (tasklet_action+0x70/0xe8)
> [<c00da0e8>] (tasklet_action+0x0/0xe8) from [<c00da000>] (__do_softirq+0x68/0xe0)
>  r5:c0404764 r4:00000001
> [<c00d9f98>] (__do_softirq+0x0/0xe0) from [<c00da3a8>] (irq_exit+0x48/0x50)
>  r7:00000000 r6:c040be90 r5:c03e2ff4 r4:0000001d
> [<c00da360>] (irq_exit+0x0/0x50) from [<c00bd048>] (asm_do_IRQ+0x48/0x5c)
> [<c00bd000>] (asm_do_IRQ+0x0/0x5c) from [<c00bd604>] (__irq_svc+0x24/0x60)
> Exception stack(0xc03ddf50 to 0xc03ddf98)
> df40:                                     c03f39b4 60000013 00000000 c03f36f0 
> df60: c00beaa4 c03dc000 c03f36e8 c03dfc18 0001e8c8 690541c1 0001e7c4 c03ddfa4 
> df80: c03ddfa8 c03ddf98 c00be960 c00beac4 60000013 ffffffff                   
>  r7:c03dfc18 r6:20000000 r5:0000001f r4:ffffffff
> [<c00beaa4>] (default_idle+0x0/0x4c) from [<c00be960>] (cpu_idle+0x44/0x60)
> [<c00be91c>] (cpu_idle+0x0/0x60) from [<c032b16c>] (rest_init+0x50/0x60)
>  r6:c00b8ef8 r5:c03f3290 r4:c04070c8
> [<c032b11c>] (rest_init+0x0/0x60) from [<c0008d64>] (start_kernel+0x220/0x2f0)
> [<c0008b44>] (start_kernel+0x0/0x2f0) from [<00008034>] (0x8034)
>  r6:c00b92fc r5:c03f3750 r4:000039fd
> ---[ end trace ba328405e244b5ec ]---

This one is occuring on ARM little-endian as well.
-- 
Krzysztof Halasa
