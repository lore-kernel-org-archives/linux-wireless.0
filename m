Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59646 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbYEZUZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 16:25:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: oops on b43 insertion on mips
Date: Mon, 26 May 2008 22:25:18 +0200
Cc: linux-wireless@vger.kernel.org
References: <483B105E.4090800@wpkg.org>
In-Reply-To: <483B105E.4090800@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805262225.19007.mb@bu3sch.de> (sfid-20080526_222554_224631_63D881D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 May 2008 21:32:46 Tomasz Chmielewski wrote:
> I just compiled 2.6.25.4 for BCM47XX (little endian MIPS).
> 
> When I try to insert a b43 module, the kernel oopses. Are there any 
> fixes for that?
> 
> b43-phy0: Broadcom 4318 WLAN found
> Data bus error, epc == 8013406c, ra == 801b28b4
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 1000d801 81c85454 801b26a4
> $ 4   : c00003f8 81c85454 00000001 802e9a20
> $ 8   : 81a3bfe0 0000d800 00000000 802a6000
> $12   : 6e0fbc91 00000008 f6cef100 003d08da
> $16   : 81c85400 81c85454 000003f8 00000007
> $20   : c00b4000 00000001 81923448 8128ad40
> $24   : 00008000 801b260c
> $28   : 81a3a000 81a3bcd0 8128ad40 801b28b4
> Hi    : 003d08da
> Lo    : f6cef100
> epc   : 8013406c     Not tainted
> ra    : 801b28b4 Status: 1000d803    KERNEL EXL IE
> Cause : 0080001c
> PrId  : 00029006 (Broadcom BCM3302)
> Modules linked in: b43(+) mac80211 cfg80211
> Process insmod (pid: 1040, threadinfo=81a3a000, task=81945958)
> Stack : 00004318 00000005 0000017f 81923000 0000017f 81923000 00000002 
> c00681c4
>          00000001 00000001 00004318 00000005 81a3bd28 00000000 811ae9d8 
> 81c8bb64
>          00000003 81c85400 81c59400 8128addc 00000001 81a3be00 c00842f4 
> 81c85454
>          c0084310 81c8948c c00b4000 0000001b c00d8d98 c00d88b8 c00a709c 
> 801b0a1c
>          81c85454 800c9e8c 81c7f288 8012265c 81c894a8 81c89400 80155530 
> 801554d4
>          ...
> Call 
> Trace:[<c00681c4>][<c00a709c>][<801b0a1c>][<800c9e8c>][<8012265c>][<80155530>][<801554d4>][<8025157c>][<801559c8>][<801540f8>][<80122bd0>][<80122428>][<80155850>][<80154278>][<80122c30>][<80153f24>][<80154f98>][<80154f70>][<80123524>][<80156118>][<8005a9d0>][<80071bd8>][<c0054028>][<80071da4>][<8004d804>][<8003b7c8>][<8000b0d0>]
> 
> Code: 90820000  03e00008  304200ff <94820000> 03e00008  3042ffff 
> 8c820000  03e00008  00000000

Are you running openwrt?
It currently has a linkage bug. People are working on it.
If you're not running openwrt, please provide useful debugging information.

-- 
Greetings Michael.
