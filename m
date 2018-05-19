Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbeESHI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 May 2018 03:08:57 -0400
Date: Sat, 19 May 2018 09:08:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] NFC: pn533: don't send USB data off of the stack
Message-ID: <20180519070838.GC2943@kroah.com> (sfid-20180519_090901_241417_63905957)
References: <20180518103811.GA29186@kroah.com>
 <20180518154847.GB2668@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180518154847.GB2668@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 18, 2018 at 05:48:47PM +0200, Johan Hovold wrote:
> On Fri, May 18, 2018 at 12:38:11PM +0200, Greg Kroah-Hartman wrote:
> > It's amazing that this driver ever worked, but now that x86 doesn't
> > allow USB data to be sent off of the stack, it really does not work at
> > all.  Fix this up by properly allocating the data for the small
> > "commands" that get sent to the device.
> > 
> > The USB stack will free the buffer when the data has been transmitted,
> > that is why there is no kfree() to mirror the call to kmalloc().
> 
> It looks like you're now leaking all but the final transfer buffer that
> is allocated for outgoing commands, as the URBs themselves are not freed
> until disconnect() (and that's when core would free the buffers along
> with the URBs if URB_FREE_BUFFER is set).

Ugh, you are right.  The urb handling in this driver is crazy...

Let me go redo this whole thing, give me a few days...

thanks for the review, much appreciated.

Carlos, it would be good to know if your testing showed that the patch
at least enables the device to work for now.  It will leak memory like
crazy, so I don't recomment relying on the driver, but it should be good
enough to see if my thinking as to why the driver was not working is
correct or not.

greg k-h
