Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbbICBdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 21:33:32 -0400
Date: Wed, 2 Sep 2015 18:33:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, jude.lee@atmel.com,
	robin.hwang@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 3/5] staging: wilc1000: use id value as argument
Message-ID: <20150903013331.GA19804@kroah.com> (sfid-20150903_033335_671481_514EE46D)
References: <1440055974-9998-1-git-send-email-tony.cho@atmel.com>
 <1440055974-9998-4-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440055974-9998-4-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2015 at 04:32:52PM +0900, Tony Cho wrote:
> From: Johnny Kim <johnny.kim@atmel.com>
> 
> The driver communicates with the chipset via the address of handlers
> to distinguish async data frame. The SendConfigPkt function gets the
> pointer address indicating the handlers as the last argument, but this
> requires redundant typecasting and does not support the 64 bit machine.
> 
> This patch adds the function which assigns ID values instead of pointer
> representing the driver handler to the address and then uses the ID
> instead of pointer as the last argument of SendConfigPkt. The driver
> also gets the handler's address from the ID in the data frame when it
> receives them.
> 

I don't understand this code at all.  You are randomly adding values to
a list, and then assuming that you can use the index into that list for
some type of representation?  As this is a local list, why not just use
the real variables instead of having a list and dealing with them in
this very ackward manner?

In other words, I don't see the need for the list at all, just use the
real types here, you have all the needed information (hint, if you know
the index, you really know the data as well...)

thanks,

greg k-h
