Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59779 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab0LBQcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:32:18 -0500
Received: by mail-yw0-f46.google.com with SMTP id 5so4208507ywl.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 08:32:17 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: "Kernel bug detected" when using pktgen together with mac80211_hwsim
Date: Thu, 2 Dec 2010 17:31:09 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012021731.09440.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In order to get some reasonable numbers on how single patches improve/degrade
performance of mac80211 I wanted to run pktgen on a mac80211_hwsim interface.

Unfortunately pktgen keeps a reference to the skb and thus pskb_expand_head
triggers a BUG when called from mac80211. I worked around that issue by adding
a skb_copy for shared skbs.

Maybe, someone else has a better idea on how to fix that?

Here's the stack trace.

[  676.030000] Kernel bug detected[#1]:
[  676.030000] Cpu 0
[  676.030000] $ 0   : 00000000 00000000 819662ff 00000002
[  676.030000] $ 4   : 81966200 00000020 00000000 00000020
[  676.030000] $ 8   : 819662e0 800043c0 00000002 00020000
[  676.030000] $12   : 3b9aca00 00000000 00000000 00470000
[  676.030000] $16   : 80ea2000 00000000 00000000 00000000
[  676.030000] $20   : 818aa200 80ea2018 80ea2000 00000008
[  676.030000] $24   : 00000002 800ace5c                  
[  676.030000] $28   : 8199a000 8199bd20 81938f88 80f180d4
[  676.030000] Hi    : 0000026e
[  676.030000] Lo    : 0000757e
[  676.030000] epc   : 801245e4 pskb_expand_head+0x44/0x1d8
[  676.030000]     Not tainted
[  676.030000] ra    : 80f180d4 ieee80211_skb_resize+0xb0/0x114 [mac80211]
[  676.030000] Status: 1000a403    KERNEL EXL IE 
[  676.030000] Cause : 10800024
[  676.030000] PrId  : 0001964c (MIPS 24Kc)
[  676.030000] Modules linked in: mac80211_hwsim rt2800lib rt2x00soc rt2x00pci rt2x00lib mac80211 crc_itu_t crc_ccitt cfg80211 compat arc4 aes_generic deflate ecb cbc [last unloaded: rt2800pci]
[  676.030000] Process kpktgend_0 (pid: 97, threadinfo=8199a000, task=81879f48, tls=00000000)
[  676.030000] Stack : ffffffff 00000000 00000000 00000014 00000004 80ea2000 00000000 00000000
[  676.030000]         818aa200 80f180d4 ffffffff 0000000a 81879f78 81879f48 81879f48 00000018
[  676.030000]         81966246 80ea2000 818432e0 80f1a420 80203050 81814d98 00000001 81879f48
[  676.030000]         81879f48 00000018 81966246 818432e0 0000001a 8199bdd4 0000001c 80f1b72c
[  676.030000]         80203020 8001292c 80ef4aa2 7f10b55d 801ab5b8 81879f48 00000188 80005c90
[  676.030000]         ...
[  676.030000] Call Trace:
[  676.030000] [<801245e4>] pskb_expand_head+0x44/0x1d8
[  676.030000] [<80f180d4>] ieee80211_skb_resize+0xb0/0x114 [mac80211]
[  676.030000] [<80f1a420>] ieee80211_xmit+0x150/0x22c [mac80211]
[  676.030000] [<80f1b72c>] ieee80211_subif_start_xmit+0x6f4/0x73c [mac80211]
[  676.030000] [<8014361c>] pktgen_thread_worker+0xfac/0x16f8
[  676.030000] [<8002ebe8>] kthread+0x7c/0x88
[  676.030000] [<80008e0c>] kernel_thread_helper+0x10/0x18
[  676.030000] 
[  676.030000] 
[  676.030000] Code: 24020001  10620005  2502001f <0200000d> 0804917a  00000000  2502001f  00441023  00531021 
[  676.030000] Disabling lock debugging due to kernel taint
[  676.440000] Kernel panic - not syncing: Fatal exception in interrupt
[  676.460000] Rebooting in 3 seconds..


Thanks,
Helmut
