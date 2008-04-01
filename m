Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:50405 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131AbYDAN6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 09:58:05 -0400
Date: Tue, 1 Apr 2008 15:58:02 +0200 (CEST)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: Dan Williams <dcbw@redhat.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	julian.calaby@gmail.com, david@woodhou.se, dwmw2@infradead.org,
	andreamrl@tiscali.it
Subject: Re: [RFC][PATCH] mrv8k: Driver for "Marvell 88w8335 [Libertas]"
In-Reply-To: <1206992394.12973.39.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0804011523240.21835@bugs.comnets.uni-bremen.de> (sfid-20080401_145809_638095_DE65180C)
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
 <200803191124.03743.hs4233@mail.mn-solutions.de>
 <Pine.LNX.4.64.0803281122240.21835@bugs.comnets.uni-bremen.de>
 <1206992394.12973.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan.

On Mon, 31 Mar 2008, Dan Williams wrote:

> So a few comments...  the driver as-is needs to be cleaned up for a few
> general issues, inline below.  Do you have some time to address the
> cleanups, or would you like some help with them?

I am working on it. Some comments inline.

> Kill this file; as long as the rest of the files have the short GPL,
> it's OK, as the kernel is already distributed under the GPL.

OK.

[...]
>> +ifeq ($(CONFIG_MRV8K_DEBUG),y)
>> +EXTRA_CFLAGS += -DDEBUG
>> +endif
>
> Don't do this; in your code, just use:
>
> #ifdef CONFIG_MRV8K_DEBUG
>    <debug stuff>
> #endif
>
> Don't need additional defines in the makefile.

OK.

[...]
>> +#if !defined(MAC_ARG)
>> +#define MAC_ARG(x) (\
>> +((u8 *)(x))[0], ((u8 *)(x))[1], \
>> +((u8 *)(x))[2], ((u8 *)(x))[3], \
>> +((u8 *)(x))[4], ((u8 *)(x))[5])
>> +#endif
>
> Remove this; just use the kernel definitions in ethdev.h or whatever it
> is.  If the define is already in kernel git, it doesn't need to be in
> the driver.  If you want to keep compat with older kernels, you get to
> maintain those bits out-of-tree as additional patches on top of the
> upstream kernel.

OK, it was only used once anyway. Instead I am gonna use perm_addr 
directly.

[...]
>> +static void _mrv_send_cmd(struct mrv_priv *priv, u32 addr)
>> +{
>> +  /*	printk(KERN_ERR"_mrv_send_cmd\n");*/
>
> Either remove the commented out code, or set up debugging prints that
> are switched on/off with CONFIG_MRV8K_DEBUG.  Or better yet, have a
> 'debug' module parameter that can dynamically update the debugging
> output if the driver has been compiled with CONFIG_MRV8K_DEBUG by
> echoing something else to /sys/modules/mrv8k/parameters/debug.

Setting up debugging prints for the moment.

[...]
>> +	} else {
>> +	  printk(KERN_ERR"status %x\n", priv->cmd_status);
>
> Formatting issues; you'll want to run the patch through checkpatch.pl
> before submitting.

I was running it through checkpatch.pl, might have slipped through the 
warnings for 80 chars/line.

[...]
>> +		mrv_int_enable(priv);
>> +		return IRQ_NONE;
>> +	}
>> +
>> +	if (status & 0x4) {
>
> Any idea if these status bits can be #defined somewhere instead of being
> magic numbers?

Defining them in the header.

>> +/*
>> +static int mrv_set_allowed_rates(struct mrv_priv *priv, int allowg)
>
> If the function is commented out, it should probably either be removed
> entirely and added back later when it works.

I am uncommenting the function. Did not want to through code away, that 
was in the original driver without reason.

[...]
>
> Any idea why the .flags bits are commented out?
>

I have added #include <net/ieee80211.h>, but the compiler complains with 
error "'IEEE80211_CCK_RATE_1MB_MASK' undeclared here (not in a function)" 
and I don't know how to fix it.

[...]
> I think this was already shadowed above?  Since it's included in
> mrv8k.c, doesn't need to be here too.
OK.

[...]
>> +	int AntNum;
>> +	int FwVer;
>> +	int HwVer;
>> +	int TxRingNum;
>> +	int RegionCode;
>> +	int TxHwDma0;
>> +	int TxHwDma1;
>> +	int TxHwDma2;
>> +	int TxHwDma3;
>> +	int RxHwDmaR;
>> +	int RxHwDmaW;
>
> Any chance you could un-studly-caps the variables?  Normal kernel style
> is first_second_third, so in this case it would be like "rx_hw_dma_w"
> not "RxHwDmaW".

No problem.

Thanks,
Markus
