Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbbIDDv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 23:51:59 -0400
Date: Thu, 3 Sep 2015 20:51:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "johnny.kim" <johnny.kim@atmel.com>
Cc: Tony Cho <tony.cho@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, chris.park@atmel.com,
	rachel.kim@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	jude.lee@atmel.com, robin.hwang@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 3/5] staging: wilc1000: use id value as argument
Message-ID: <20150904035156.GA7793@kroah.com> (sfid-20150904_055220_990841_0BCE4CE8)
References: <1440055974-9998-1-git-send-email-tony.cho@atmel.com>
 <1440055974-9998-4-git-send-email-tony.cho@atmel.com>
 <20150903013331.GA19804@kroah.com>
 <55E7EFF8.2060705@atmel.com>
 <20150903154718.GA27860@kroah.com>
 <55E90EED.5010502@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55E90EED.5010502@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 04, 2015 at 12:24:29PM +0900, johnny.kim wrote:
> 
> 
> On 2015년 09월 04일 00:47, Greg KH wrote:
> >On Thu, Sep 03, 2015 at 04:00:08PM +0900, johnny.kim wrote:
> >>Hello Greg.
> >>
> >>On 2015년 09월 03일 10:33, Greg KH wrote:
> >>>On Thu, Aug 20, 2015 at 04:32:52PM +0900, Tony Cho wrote:
> >>>>From: Johnny Kim <johnny.kim@atmel.com>
> >>>>
> >>>>The driver communicates with the chipset via the address of handlers
> >>>>to distinguish async data frame. The SendConfigPkt function gets the
> >>>>pointer address indicating the handlers as the last argument, but this
> >>>>requires redundant typecasting and does not support the 64 bit machine.
> >>>>
> >>>>This patch adds the function which assigns ID values instead of pointer
> >>>>representing the driver handler to the address and then uses the ID
> >>>>instead of pointer as the last argument of SendConfigPkt. The driver
> >>>>also gets the handler's address from the ID in the data frame when it
> >>>>receives them.
> >>>>
> >>>I don't understand this code at all.  You are randomly adding values to
> >>>a list, and then assuming that you can use the index into that list for
> >>>some type of representation?  As this is a local list, why not just use
> >>>the real variables instead of having a list and dealing with them in
> >>>this very ackward manner?
> >>>
> >>>In other words, I don't see the need for the list at all, just use the
> >>>real types here, you have all the needed information (hint, if you know
> >>>the index, you really know the data as well...)
> >>>
> >>The value is needed to send it to chipset and to distinguish async data
> >>packet mutually.
> >What is the value, the index or some random pointer?
> 
> The value of current patch substitutes the corresponding index for
> some random pointer(= address of device handler).

Ok.

> >>The length of the data field is 4byte and the data field has been
> >>filled with the address of pointer so far.
> >So the data field can just be any random number, as long as it is
> >consistent?  What does the chip do with the random number?
> Current driver normally create a couple of network interface.

Multiple network interfaces for the same hardware?

> The driver can send some commands(data frame) to the network
> interfaces at the same time and wait the results. Both driver and
> chipset need unique value to distinguish whom the interface owner
> of the commands is.
> And the value always has same value while the interface is alive.

But as you created the interfaces, just use a unique number for each.
It could be a #define, as you know how many interfaces you will create,
that's not a dynamic thing.  No need to keep looking up something in an
index and converting to a structure.

> >>But this patch changes it to unique index value corresponding to the address
> >>for 64bit address machine. If real type is used as your opinion, new patch
> >>will have the same meaning with current code.
> >I'm sorry, but I don't understand.  How exactly does the chip need an
> >index now, but was using a pointer before?  That sounds like you are
> >changing the functionality.
> >
> >confused,
> There is a reserved field to distinguish the data frames in chipset.
> Because the field has 4byte space, this patch creates the index
> corresponding to the pointer and uses the index to input the identifier
> in the size instead of the pointer value.
> 
> I'm sorry, too. It's not easy to explain it in English.

It's not easy to explain that in any language :)

As you "know" the interfaces you create, just use a "fixed" number for
them, and refer to them that way.  No need to have an array and iterate
over the whole array every time.

There are lots of wrapper functions and pointers in this driver that
need to be stripped away.  I think you will find the end result of all
of that work to be much simpler, and smaller.  See the patches that I
did for the driver this evening as an example, it removed code, and in
doing so, also fixed a long-time bug.  There's a lot of work to be done
here still...

thanks,

greg k-h
