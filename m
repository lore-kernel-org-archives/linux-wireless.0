Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34977 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbeEUIie (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 04:38:34 -0400
Date: Mon, 21 May 2018 10:38:25 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] NFC: pn533: don't send USB data off of the stack
Message-ID: <20180521083825.GO30172@localhost> (sfid-20180521_103838_652695_1BA8EFF6)
References: <20180520131946.GA7325@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180520131946.GA7325@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 20, 2018 at 03:19:46PM +0200, Greg Kroah-Hartman wrote:
> It's amazing that this driver ever worked, but now that x86 doesn't
> allow USB data to be sent off of the stack, it really does not work at
> all.  Fix this up by properly allocating the data for the small
> "commands" that get sent to the device off of the stack.
> 
> We do this for one command by having a whole urb just for ack messages,
> as they can be submitted in interrupt context, so we can not use
> usb_bulk_msg().  But the poweron command can sleep (and does), so use
> usb_bulk_msg() for that transfer.
> 
> Reported-by: Carlos Manuel Santos <cmmpsantos@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> v4: don't use urb transfer buffer flags as the memory is tied to the urb
>     (thanks to Johan)  Now we have a new static urb, and we use
>     usb_bulk_msg() for the other message.
> v3: actually use the correct buffer (thanks to Arend van Spriel)
>     use kmemdup (thanks to Johannes Berg and Julia Lawall)
> v2: set the urb flags correctly

Your changes look correct now so feel free to add:

Reviewed-by: Johan Hovold <johan@kernel.org>

It seems we could end up returning an errno from probe with active urbs
(if pn533_finalize_setup() fails) in which case the ack buffer would
leak. But freeing the urbs while active would then be the bigger
problem, and that wasn't introduced by this patch.

Johan
