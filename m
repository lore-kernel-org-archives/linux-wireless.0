Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34668 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0LFLo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 06:44:27 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 03:44:12 -0800
Date: Mon, 6 Dec 2010 17:14:02 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 12/27] ath9k_hw: Find chansel of
	AR_PHY_65NM_CH0_SYNTH7 from an array for AR9485
Message-ID: <20101206114401.GT12908@vasanth-laptop>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com> <1291288031-3409-13-git-send-email-vasanth@atheros.com> <4CF84BB8.8090007@openwrt.org> <20101203045054.GP12908@vasanth-laptop> <4CF8DF08.2060307@openwrt.org> <20101203124050.GR12908@vasanth-laptop> <4CF8E718.9070207@openwrt.org> <20101206060310.GS12908@vasanth-laptop> <4CFCBE04.7070509@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CFCBE04.7070509@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I don't have any doc for this register yet.
> I'm pretty sure that the format of the register is still exactly the
> same. I guess they added a small frequency offset to reduce spur.
> 
> >> But how exactly is *one* magic number (and it's even a very small one)
> >> worse than 14 of them, especially since anybody can verify that the
> >> generated raw values are exactly the same?
> > 
> > Anyway, still this formula gets it wrong for channel 14.
> > Lets have this table for now, I'll clean this up once I
> > get the proper doc for this register?.
> How did you test this? When I put this part into a test program, it
> generates exactly the same values as the table  all channels,
> including 14.

I just did the following

#define CHANSEL_2G_9485(_freq) ((((freq) * 0x10000) - 215) / CHANSEL_DIV)
 for (i = 0; i < 14; i++) {
               freq = 2412 + (i * 5);
               printk("chan %d : %x \n",i + 1,CHANSEL_2G_9485(freq));
      }

output:

chan 1 : a0ccbe
chan 2 : a12213
chan 3 : a17769
chan 4 : a1ccbe
chan 5 : a22213
chan 6 : a27769
chan 7 : a2ccbe
chan 8 : a32213
chan 9 : a37769
chan 10 : a3ccbe
chan 11 : a42213
chan 12 : a47769
chan 13 : a4ccbe
chan 14 : a52213

Vasanth
