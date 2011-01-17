Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 124-197-1-37.callplus.net.nz ([124.197.1.37]:37121 "EHLO
	elm.torus.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1AQCUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 21:20:16 -0500
Message-ID: <4D33A5A5.9090706@davenport.net.nz>
Date: Mon, 17 Jan 2011 15:12:53 +1300
From: Hugh Davenport <hugh@davenport.net.nz>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org
CC: linux-wireless@vger.kernel.org
Subject: issues with AHB support on ubiquiti bullet 2 (AR2315)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey all,

I'm just letting you know that I have been having issues getting the the
AHB support with the ath5k driver working (from compat-wireless 2011-01-05).

I'm testing it on an ubiquiti bullet 2 device which internally is a
AR2315 WiSoC. I am using openwrt backfire with the mac80211 package
patched to use a later version of compat-wireless (ie one with AHB
support in ath5k). I had to modify some of the patches in openwrt so
they applied cleanly, but don't think any affected the ath5k (and would
cause the problem i have).

Basically the issue is this. When I try to load the module as is in the
source tree, the system hangs and module never loads (device restarts
itself).

I tried a bit of debugging (sorry about any newbie techniques here, im
new to kernel debugging) by just printing and returning errors after
every main function called. The problem seemed to be with the first time
it called ath5k_hw_reg_write, which from my tracing seemed to be in th
wisoc reset function in the following chain.

ath5k_hw_reg_write (ath5k.h)
ath5k_hw_wisoc_reset (reset.c)
ath5k_hw_nic_wakeup (reset.c)
ath5k_hw_init (attach.c)
ath5k_init_softc (base.c)
ath_ahb_probe (ahb.c)


I then tried out a few things in the vain attempt to get it to load the
module, one which seemed to work is taking out the ioremap_nocache call
in ath_ahb_probe, and set mem to be res->start (on my system this is
0xb0000000 (the same as what madwifi tells me as well)). With this /fix/
the module now loads, gives the output below, but i can't bring the
interface up (device crashes again).

Atheros AR2315 chip found (MAC: 0x87, PHY: 0x48)


continuing traces when bring interface up brings me to another
ath5k_hw_reg_write call in the following chain

ath5k_hw_reg_write (ath5k.h)
ath5k_hw_start_rx_dma (dma.c)
ath5k_rx_start (base.c)
ath5k_reset (base.c)
ath5k_init_hw (base.c)
ath5k_start (mac80211-ops.c)


I am sorry about the long email, but I thought the more info you guys
have, the better.

If you have any ideas I can try, any more testing you may need me to do,
or anything that could help me get it working, let me know, and i'll do
my best to get anything done asap.

Cheers,

Hugh Davenport
