Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37197 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbaHGNEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 09:04:41 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so10581505wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 06:04:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix sending URBs with wrong type when using full-speed
Date: Thu, 07 Aug 2014 15:04:33 +0200
Message-ID: <7450698.ipAbWqfnUT@blech> (sfid-20140807_150455_301808_A5E78B7E)
In-Reply-To: <53E36624.9060905@raritan.com>
References: <1407403442-27268-1-git-send-email-ronald.wahl@raritan.com> <9263316.qJ7UgtQDIG@blech> <53E36624.9060905@raritan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, August 07, 2014 01:42:28 PM Ronald Wahl wrote:
> On 07.08.2014 12:51, Christian Lamparter wrote:
> > my comments:
> >   - Patch needs a "signed-off-by: <Your Name> <Your Mail> tag"
> >     (see Section 12 - Sign your work [0]) for details.
> >
> >   - Do you see any improvement on a fullspeed port now?
> >     (If so, this should be a stable- patch)
> 
> Yes, it actually works now. Before this change you could crash the 
> system because of the constant logging of the warnings it was almost 
> dead. My embedded device just rebooted after a while (maybe the
> watchdog triggered).

Ok, this is important then ;).

> >> @@ -1050,6 +1056,21 @@ static int carl9170_usb_probe(struct usb_interface *intf,
> >>         ar->intf = intf;
> >>         ar->features = id->driver_info;
> >>
> >> +       /* We need to remember the type of endpoint 4 because it differs
> >> +        * between high- and full-speed configuration. The high-speed
> >> +        * configuration specifies it as interrupt and the full-speed
> >> +        * configuration as bulk endpoint. This information is required
> >> +        * later when sending urbs to that endpoint.
> >> +        */
> >> +       for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
> >> +               ep = &intf->cur_altsetting->endpoint[i].desc;
> >> +
> >> +               if (usb_endpoint_dir_out(ep) &&
> >> +                   usb_endpoint_num(ep) == AR9170_USB_EP_CMD)
> >> +                       ar->usb_ep_cmd_is_bulk =
> >> +                               usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK;
> > What about this:
> >
> >                 if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
> >                     usb_endpoint_is_bulk_out(ep))
> >                         ar->usb_ep_cmd_is_bulk = true;
> > (the driver context "ar" is zero'd out - It is not necessary to set
> > usb_ep_cmd_is_bulk to false.)
> 
> This is what my first patch has done but we need to check the endpoint 
> type if its bulk or not. Otherwise it will fail in the high-speed case.
> Or did you mean:
> 
> 		if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
> 		    usb_endpoint_is_bulk_out(ep) &&
> 		    usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK)
> 			ar->usb_ep_cmd_is_bulk = true;
usb_endpoint_is_bulk_out [0] "checks if the endpoint is bulk OUT". 
This function should perform both checks (ie.: is bulk? is out?).

> > BTW: I'll make a patch to carl9170 firmware too.
> 
> great!
> 
> I will fix the remaining things you mentioned.

great!

Regards

Christian

[0] http://lxr.free-electrons.com/source/include/uapi/linux/usb/ch9.h#L539
