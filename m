Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35679 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbeERPtl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 11:49:41 -0400
Date: Fri, 18 May 2018 17:48:47 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] NFC: pn533: don't send USB data off of the stack
Message-ID: <20180518154847.GB2668@localhost> (sfid-20180518_174945_620568_C8232127)
References: <20180518103811.GA29186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180518103811.GA29186@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 18, 2018 at 12:38:11PM +0200, Greg Kroah-Hartman wrote:
> It's amazing that this driver ever worked, but now that x86 doesn't
> allow USB data to be sent off of the stack, it really does not work at
> all.  Fix this up by properly allocating the data for the small
> "commands" that get sent to the device.
> 
> The USB stack will free the buffer when the data has been transmitted,
> that is why there is no kfree() to mirror the call to kmalloc().

It looks like you're now leaking all but the final transfer buffer that
is allocated for outgoing commands, as the URBs themselves are not freed
until disconnect() (and that's when core would free the buffers along
with the URBs if URB_FREE_BUFFER is set).

Johan
