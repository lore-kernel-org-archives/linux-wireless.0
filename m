Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbbICPrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 11:47:19 -0400
Date: Thu, 3 Sep 2015 08:47:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "johnny.kim" <johnny.kim@atmel.com>
Cc: Tony Cho <tony.cho@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, chris.park@atmel.com,
	rachel.kim@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	jude.lee@atmel.com, robin.hwang@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 3/5] staging: wilc1000: use id value as argument
Message-ID: <20150903154718.GA27860@kroah.com> (sfid-20150903_174730_732656_D3E4A64F)
References: <1440055974-9998-1-git-send-email-tony.cho@atmel.com>
 <1440055974-9998-4-git-send-email-tony.cho@atmel.com>
 <20150903013331.GA19804@kroah.com>
 <55E7EFF8.2060705@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55E7EFF8.2060705@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 03, 2015 at 04:00:08PM +0900, johnny.kim wrote:
> Hello Greg.
> 
> On 2015년 09월 03일 10:33, Greg KH wrote:
> >On Thu, Aug 20, 2015 at 04:32:52PM +0900, Tony Cho wrote:
> >>From: Johnny Kim <johnny.kim@atmel.com>
> >>
> >>The driver communicates with the chipset via the address of handlers
> >>to distinguish async data frame. The SendConfigPkt function gets the
> >>pointer address indicating the handlers as the last argument, but this
> >>requires redundant typecasting and does not support the 64 bit machine.
> >>
> >>This patch adds the function which assigns ID values instead of pointer
> >>representing the driver handler to the address and then uses the ID
> >>instead of pointer as the last argument of SendConfigPkt. The driver
> >>also gets the handler's address from the ID in the data frame when it
> >>receives them.
> >>
> >I don't understand this code at all.  You are randomly adding values to
> >a list, and then assuming that you can use the index into that list for
> >some type of representation?  As this is a local list, why not just use
> >the real variables instead of having a list and dealing with them in
> >this very ackward manner?
> >
> >In other words, I don't see the need for the list at all, just use the
> >real types here, you have all the needed information (hint, if you know
> >the index, you really know the data as well...)
> >
> The value is needed to send it to chipset and to distinguish async data
> packet mutually.

What is the value, the index or some random pointer?

> The length of the data field is 4byte and the data field has been
> filled with the address of pointer so far.

So the data field can just be any random number, as long as it is
consistent?  What does the chip do with the random number?

> But this patch changes it to unique index value corresponding to the address
> for 64bit address machine. If real type is used as your opinion, new patch
> will have the same meaning with current code.

I'm sorry, but I don't understand.  How exactly does the chip need an
index now, but was using a pointer before?  That sounds like you are
changing the functionality.

confused,

greg k-h
