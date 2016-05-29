Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34910 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbcE2SzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 14:55:04 -0400
Received: by mail-wm0-f46.google.com with SMTP id a136so58035368wme.0
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2016 11:55:03 -0700 (PDT)
Subject: Re: BCM4331 reset leads to wl lockup
To: Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
References: <20160526121210.GA7006@wunner.de> <20160526144246.217bfff1@wiggum>
 <20160529110248.GA12632@wunner.de>
Cc: linux-wlan-client-support-list@broadcom.com, 1332647@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <574B3B05.3020106@broadcom.com> (sfid-20160529_205510_294996_616DCAA9)
Date: Sun, 29 May 2016 20:55:01 +0200
MIME-Version: 1.0
In-Reply-To: <20160529110248.GA12632@wunner.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-05-16 13:02, Lukas Wunner wrote:
> On Thu, May 26, 2016 at 02:42:46PM +0200, Michael Büsch wrote:
>> On Thu, 26 May 2016 14:12:10 +0200 Lukas Wunner <lukas@wunner.de> wrote:
>>> +	mmio = early_ioremap(addr, BCM4331_MMIO_SIZE);
>>> +	if (!mmio) {
>>> +		pr_err("Cannot iomap Apple AirPort card\n");
>>> +		return;
>>> +	}
>>> +	pr_info("Resetting Apple AirPort card\n");
>>> +	iowrite32(BCMA_RESET_CTL_RESET,
>>> +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
>>> +	early_iounmap(mmio, BCM4331_MMIO_SIZE);
>>
>> Just writing that bit is not the correct reset procedure.
>> So it might cause problems depending on how wl does the core reset
>> later.
>>
>> Please try this:
>> - wait for BCMA_RESET_ST to be 0
>> - set reset bit
>> - flush
>> - wait 1us
>> - reset reset bit
>> - flush
>> - wait 10us
>>
>> See bcma_core_disable()
> 
> It turned out that the lockups are triggered by bec3cfdca36b
> ("net: skb_segment() provides list head and tail") in Linux 3.18
> and that Eric Duzamet has kindly provided a fix for broadcom-sta:
> https://bugs.gentoo.org/show_bug.cgi?id=523326#c24
> https://523326.bugs.gentoo.org/attachment.cgi?id=393374

Looked at the patch and it provides little context. So before diving in
the code would you know if the patched broadcom-sta driver works for
kernels before 3.18?

Regards,
Arend
