Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:40247 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZLSFDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 00:03:44 -0500
Received: by vws30 with SMTP id 30so1218322vws.33
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 21:03:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091218200753.30718.qmail@stuge.se>
References: <20091216172356.15849.qmail@stuge.se> <20091216174112.GD11461@tux>
	 <20091216222157.28840.qmail@stuge.se> <20091216234308.GA425@tux>
	 <20091218115708.14617.qmail@stuge.se> <20091218161854.GA6231@tux>
	 <20091218200753.30718.qmail@stuge.se>
Date: Sat, 19 Dec 2009 10:33:43 +0530
Message-ID: <8e92b4100912182103n5e3402echbedb85ab62f28e57@mail.gmail.com>
Subject: Re: [ath9k-devel] No probe response from AP after 500ms,
	disconnecting.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 19, 2009 at 1:37 AM, Peter Stuge <peter@stuge.se> wrote:

> So what could give us more information? If the debug output is not
> enough I'm happy to sprinkle printks over the driver in strategic
> places, but I need some hints on where to do it.
>
> What is the general operation of the driver? (I have some experience
> with writing Linux drivers so feel free to get technical.) RX
> descriptors and DMA? Is beacon reception special in any way from
> reception of other packets? Would it be useful to try monitor mode
> with PM enabled?

If the issue is specific to AR5416 and power save, then the TIM_TIMER
interrupt might be causing the trouble. You can check whether any
ATH9K_INT_TIM_TIMER interrupt is received in the ath_isr when the
disconnection happens.
This is the hw timer used by the chip to wakeup for  every beacon listen
interval.

Vivek.
