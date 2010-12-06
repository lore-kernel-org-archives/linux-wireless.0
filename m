Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52482 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0LFLun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 06:50:43 -0500
Message-ID: <4CFCCE0E.6020906@openwrt.org>
Date: Mon, 06 Dec 2010 12:50:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 12/27] ath9k_hw: Find chansel of	AR_PHY_65NM_CH0_SYNTH7
 from an array for AR9485
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com> <1291288031-3409-13-git-send-email-vasanth@atheros.com> <4CF84BB8.8090007@openwrt.org> <20101203045054.GP12908@vasanth-laptop> <4CF8DF08.2060307@openwrt.org> <20101203124050.GR12908@vasanth-laptop> <4CF8E718.9070207@openwrt.org> <20101206060310.GS12908@vasanth-laptop> <4CFCBE04.7070509@openwrt.org> <20101206114401.GT12908@vasanth-laptop>
In-Reply-To: <20101206114401.GT12908@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-12-06 12:44 PM, Vasanthakumar Thiagarajan wrote:
>> > I don't have any doc for this register yet.
>> I'm pretty sure that the format of the register is still exactly the
>> same. I guess they added a small frequency offset to reduce spur.
>> 
>> >> But how exactly is *one* magic number (and it's even a very small one)
>> >> worse than 14 of them, especially since anybody can verify that the
>> >> generated raw values are exactly the same?
>> > 
>> > Anyway, still this formula gets it wrong for channel 14.
>> > Lets have this table for now, I'll clean this up once I
>> > get the proper doc for this register?.
>> How did you test this? When I put this part into a test program, it
>> generates exactly the same values as the table  all channels,
>> including 14.
> 
> I just did the following
> 
> #define CHANSEL_2G_9485(_freq) ((((freq) * 0x10000) - 215) / CHANSEL_DIV)
>  for (i = 0; i < 14; i++) {
>                freq = 2412 + (i * 5);
>                printk("chan %d : %x \n",i + 1,CHANSEL_2G_9485(freq));
>       }
> 
> output:
> 
> chan 1 : a0ccbe
> chan 2 : a12213
> chan 3 : a17769
> chan 4 : a1ccbe
> chan 5 : a22213
> chan 6 : a27769
> chan 7 : a2ccbe
> chan 8 : a32213
> chan 9 : a37769
> chan 10 : a3ccbe
> chan 11 : a42213
> chan 12 : a47769
> chan 13 : a4ccbe
> chan 14 : a52213
2412 + 13 * 5 == 2477, not 2484.

- Felix
