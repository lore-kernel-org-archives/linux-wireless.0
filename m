Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:34689 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0LGUlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:41:03 -0500
Received: by bwz16 with SMTP id 16so492572bwz.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 12:41:02 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs
Date: Tue, 7 Dec 2010 21:39:48 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1291311849-13086-1-git-send-email-helmut.schaa@googlemail.com> <20101207194920.GH2700@tuxdriver.com>
In-Reply-To: <20101207194920.GH2700@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012072139.48659.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 7. Dezember 2010 schrieb John W. Linville:
> On Thu, Dec 02, 2010 at 06:44:09PM +0100, Helmut Schaa wrote:
> > mac80211 doesn't handle shared skbs correctly at the moment. As a result
> > a possible resize can trigger a BUG in pskb_expand_head.
> > 
> > [  676.030000] Kernel bug detected[#1]:
> > [  676.030000] Cpu 0
> > [  676.030000] $ 0   : 00000000 00000000 819662ff 00000002
> > [  676.030000] $ 4   : 81966200 00000020 00000000 00000020
> > [  676.030000] $ 8   : 819662e0 800043c0 00000002 00020000
> > [  676.030000] $12   : 3b9aca00 00000000 00000000 00470000
> > [  676.030000] $16   : 80ea2000 00000000 00000000 00000000
> > [  676.030000] $20   : 818aa200 80ea2018 80ea2000 00000008
> > [  676.030000] $24   : 00000002 800ace5c                  
> > [  676.030000] $28   : 8199a000 8199bd20 81938f88 80f180d4
> > [  676.030000] Hi    : 0000026e
> > [  676.030000] Lo    : 0000757e
> > [  676.030000] epc   : 801245e4 pskb_expand_head+0x44/0x1d8
> > [  676.030000]     Not tainted
> > [  676.030000] ra    : 80f180d4 ieee80211_skb_resize+0xb0/0x114 [mac80211]
> > [  676.030000] Status: 1000a403    KERNEL EXL IE 
> > [  676.030000] Cause : 10800024
> > [  676.030000] PrId  : 0001964c (MIPS 24Kc)
> > [  676.030000] Modules linked in: mac80211_hwsim rt2800lib rt2x00soc rt2x00pci rt2x00lib mac80211 crc_itu_t crc_ccitt cfg80211 compat arc4 aes_generic deflate ecb cbc [last unloaded: rt2800pci]
> > [  676.030000] Process kpktgend_0 (pid: 97, threadinfo=8199a000, task=81879f48, tls=00000000)
> > [  676.030000] Stack : ffffffff 00000000 00000000 00000014 00000004 80ea2000 00000000 00000000
> > [  676.030000]         818aa200 80f180d4 ffffffff 0000000a 81879f78 81879f48 81879f48 00000018
> > [  676.030000]         81966246 80ea2000 818432e0 80f1a420 80203050 81814d98 00000001 81879f48
> > [  676.030000]         81879f48 00000018 81966246 818432e0 0000001a 8199bdd4 0000001c 80f1b72c
> > [  676.030000]         80203020 8001292c 80ef4aa2 7f10b55d 801ab5b8 81879f48 00000188 80005c90
> > [  676.030000]         ...
> > [  676.030000] Call Trace:
> > [  676.030000] [<801245e4>] pskb_expand_head+0x44/0x1d8
> > [  676.030000] [<80f180d4>] ieee80211_skb_resize+0xb0/0x114 [mac80211]
> > [  676.030000] [<80f1a420>] ieee80211_xmit+0x150/0x22c [mac80211]
> > [  676.030000] [<80f1b72c>] ieee80211_subif_start_xmit+0x6f4/0x73c [mac80211]
> > [  676.030000] [<8014361c>] pktgen_thread_worker+0xfac/0x16f8
> > [  676.030000] [<8002ebe8>] kthread+0x7c/0x88
> > [  676.030000] [<80008e0c>] kernel_thread_helper+0x10/0x18
> > [  676.030000] 
> > [  676.030000] 
> > [  676.030000] Code: 24020001  10620005  2502001f <0200000d> 0804917a  00000000  2502001f  00441023  00531021 
> > 
> > Fix this by making a local copy of shared skbs prior to mangeling them.
> > To avoid copying the skb unnecessarily move the skb_copy call below the
> > checks that don't need write access to the skb.
> > 
> > Also, move the assignment of nh_pos and h_pos below the skb_copy to point
> > to the correct skb.
> > 
> > It would be possible to avoid another resize of the copied skb by using
> > skb_copy_expand instead of skb_copy but that would make the patch more
> > complex. Also, shared skbs are a corner case right now, so the resize
> > shouldn't matter much.
> > 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> Is this intended for 2.6.37?  It looks like it would apply there.

Fine with me, however, the patch is based on wireless-testing.

Thanks,
Helmut

