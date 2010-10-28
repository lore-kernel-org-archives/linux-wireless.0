Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowhand.arndnet.de ([88.198.19.76]:49802 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752858Ab0J1TtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 15:49:17 -0400
Received: from [192.168.1.62] (80-230.eduroam.RWTH-Aachen.DE [134.61.80.230])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.unitix.de (Postfix) with ESMTP id DC72113EA0
	for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 21:49:16 +0200 (CEST)
Message-ID: <4CC9D3BB.9070107@arndnet.de>
Date: Thu, 28 Oct 2010 21:49:15 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WARNING: at net/wireless/mlme.c:285 __cfg80211_auth_remove+0xc8/0xd4
 [cfg80211]()
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

on recent Linus git, it get the following backtrace with b43 sdio.
I only got it once so far, and could not easily reproduce it, but
just thought you might be interested anyway:

[  120.609375] ------------[ cut here ]------------
[  120.609375] WARNING: at net/wireless/mlme.c:285 __cfg80211_auth_remove+0xc8/0xd4 [cfg80211]()
[  120.617187] Modules linked in: af_packet arc4 ecb crypto_blkcipher cryptomgr aead crypto_algapi 
b43 ssb mac80211 cfg80211 crypto mmc_block tmio_mmc leds_gpio led_class
[  120.625000] Backtrace:
[  120.632812] [<c002a2c8>] (dump_backtrace+0x0/0x110) from [<c0211c30>] (dump_stack+0x18/0x1c)
[  120.640625]  r6:bf03b536 r5:0000011d r4:00000000 r3:c02b76a4
[  120.648437] [<c0211c18>] (dump_stack+0x0/0x1c) from [<c003677c>] (warn_slowpath_common+0x54/0x6c
)
[  120.656250] [<c0036728>] (warn_slowpath_common+0x0/0x6c) from [<c00367b8>] (warn_slowpath_null+0
x24/0x2c)
[  120.664062]  r8:c610c288 r7:c7796b58 r6:c7796b48 r5:00000004 r4:00000000
[  120.671875] r3:00000009
[  120.671875] [<c0036794>] (warn_slowpath_null+0x0/0x2c) from [<bf033d68>] (__cfg80211_auth_remove+0xc8/0xd4 [cfg80211])
[  120.679687] [<bf033ca0>] (__cfg80211_auth_remove+0x0/0xd4 [cfg80211]) from [<bf034594>] (cfg80211_send_auth_timeout+0x94/0xa8 [cfg80211])
[  120.687500]  r8:c66820c0 r7:c7796b64 r6:c7796800 r5:c610c288 r4:c7796b48
[  120.695312] r3:00000000
[  120.695312] [<bf034500>] (cfg80211_send_auth_timeout+0x0/0xa8 [cfg80211]) from [<bf059314>] (ieee80211_probe_auth_done+0x28/0x90 [mac80211])
[  120.703125]  r8:c6682260 r7:c6682260 r6:c7796b40 r5:00000000 r4:c610c260
[  120.710937] [<bf0592ec>] (ieee80211_probe_auth_done+0x0/0x90 [mac80211]) from [<bf05b51c>] (ieee80211_work_work+0x1028/0x1078 [mac80211])
[  120.718750]  r5:c702ff1c r4:c610c260
[  120.726562] [<bf05a4f4>] (ieee80211_work_work+0x0/0x1078 [mac80211]) from [<c0048094>] (process_one_work+0x1ec/0x318)
[  120.734375] [<c0047ea8>] (process_one_work+0x0/0x318) from [<c00498cc>] (worker_thread+0x1b0/0x2d0)
[  120.742187] [<c004971c>] (worker_thread+0x0/0x2d0) from [<c004cc60>] (kthread+0x8c/0x94)
[  120.750000] [<c004cbd4>] (kthread+0x0/0x94) from [<c0039678>] (do_exit+0x0/0x5a0)
[  120.757812]  r7:00000013 r6:c0039678 r5:c004cbd4 r4:c701ff00
[  120.765625] ---[ end trace 447bb063ece29a7c ]---


Regards
Arnd
