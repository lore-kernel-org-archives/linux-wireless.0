Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:39320 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751344AbeFIJyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 05:54:15 -0400
Date: Sat, 9 Jun 2018 11:54:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] NFC: pn533: don't send USB data off of the stack
Message-ID: <20180609095401.GB25115@caravaggio.jf.intel.com> (sfid-20180609_115418_991856_9AFF1919)
References: <20180520131946.GA7325@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180520131946.GA7325@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

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
> 
>  drivers/nfc/pn533/usb.c |   42 ++++++++++++++++++++++++++++++------------
>  1 file changed, 30 insertions(+), 12 deletions(-)
I can take that one through nfc-next, and the few subsequent patches
from Hans and Julia. Please let me know what's more convenient for you.

Cheers,
Samuel.
