Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753062AbeFIOCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 10:02:03 -0400
Date: Sat, 9 Jun 2018 16:01:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] NFC: pn533: don't send USB data off of the stack
Message-ID: <20180609140139.GA28854@kroah.com> (sfid-20180609_160206_985404_14B16EE2)
References: <20180520131946.GA7325@kroah.com>
 <20180609095401.GB25115@caravaggio.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180609095401.GB25115@caravaggio.jf.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 09, 2018 at 11:54:01AM +0200, Samuel Ortiz wrote:
> Greg,
> 
> On Sun, May 20, 2018 at 03:19:46PM +0200, Greg Kroah-Hartman wrote:
> > It's amazing that this driver ever worked, but now that x86 doesn't
> > allow USB data to be sent off of the stack, it really does not work at
> > all.  Fix this up by properly allocating the data for the small
> > "commands" that get sent to the device off of the stack.
> > 
> > We do this for one command by having a whole urb just for ack messages,
> > as they can be submitted in interrupt context, so we can not use
> > usb_bulk_msg().  But the poweron command can sleep (and does), so use
> > usb_bulk_msg() for that transfer.
> > 
> > Reported-by: Carlos Manuel Santos <cmmpsantos@gmail.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > v4: don't use urb transfer buffer flags as the memory is tied to the urb
> >     (thanks to Johan)  Now we have a new static urb, and we use
> >     usb_bulk_msg() for the other message.
> > v3: actually use the correct buffer (thanks to Arend van Spriel)
> >     use kmemdup (thanks to Johannes Berg and Julia Lawall)
> > v2: set the urb flags correctly
> > 
> >  drivers/nfc/pn533/usb.c |   42 ++++++++++++++++++++++++++++++------------
> >  1 file changed, 30 insertions(+), 12 deletions(-)
> I can take that one through nfc-next, and the few subsequent patches
> from Hans and Julia. Please let me know what's more convenient for you.

This patch is already in Linus's tree, along with whatever applied from
Julia's patch series.  Hans needs to rebase and resend anyway, so either
tree is fine once 4.18-rc1 is out.

thanks,

greg k-h
