Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62742 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbaHGKvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 06:51:55 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so4744798wiw.12
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 03:51:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix sending URBs with wrong type when using full-speed
Date: Thu, 07 Aug 2014 12:51:39 +0200
Message-ID: <9263316.qJ7UgtQDIG@blech> (sfid-20140807_125158_611177_8991CB54)
In-Reply-To: <53E347D2.6050108@raritan.com>
References: <1407403442-27268-1-git-send-email-ronald.wahl@raritan.com> <53E347D2.6050108@raritan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Thursday, August 07, 2014 11:33:06 AM Ronald Wahl wrote:
> On 07.08.2014 11:24, Ronald Wahl wrote:
> > +	/* We need to remember the type of endpoint 4 because it differs
> > +	 * between high- and full-speed configuration. The high-speed
> > +	 * configuration specifies it as interrupt and the full-speed
> > +	 * configuration as bulk endpoint. This information is required
> > +	 * later when sending urbs to that endpoint.
> > +	 */
> > +	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
> > +		ep = &intf->cur_altsetting->endpoint[i].desc;
> > +
> > +		if (usb_endpoint_dir_out(ep) && usb_endpoint_num(ep) == 4)
> > +			ar->usb_ep4_is_bulk = true;
> > +	}
> 
> just after sending out that patch I have seen that I should better use 
> AR9170_USB_EP_CMD instead of 4 when checking for the endpoint and maybe 
> rename the flag into usb_ep_cmd_is_bulk. But before creating v2 of the 
> patch I want to hear your comments.

Good catch! Also: thanks for the patch! 

my comments:
 - Patch needs a "signed-off-by: <Your Name> <Your Mail> tag"
   (see Section 12 - Sign your work [0]) for details.

 - Do you see any improvement on a fullspeed port now? 
   (If so, this should be a stable- patch)

 - CC' "John W. Linville" <linville@tuxdriver.com>

 - checkpatch.pl [0] mutters about:

CHECK: Alignment should match open parenthesis
#97: FILE: drivers/net/wireless/ath/carl9170/usb.c:626:
+               usb_fill_bulk_urb(urb, ar->udev, usb_sndbulkpipe(ar->udev,
+                       AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,

CHECK: Alignment should match open parenthesis
#101: FILE: drivers/net/wireless/ath/carl9170/usb.c:630:
+               usb_fill_int_urb(urb, ar->udev, usb_sndintpipe(ar->udev,
+                       AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,

 - code
>@@ -1050,6 +1056,21 @@ static int carl9170_usb_probe(struct usb_interface *intf,
>        ar->intf = intf;
>        ar->features = id->driver_info;
> 
>+       /* We need to remember the type of endpoint 4 because it differs
>+        * between high- and full-speed configuration. The high-speed
>+        * configuration specifies it as interrupt and the full-speed
>+        * configuration as bulk endpoint. This information is required
>+        * later when sending urbs to that endpoint.
>+        */
>+       for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
>+               ep = &intf->cur_altsetting->endpoint[i].desc;
>+
>+               if (usb_endpoint_dir_out(ep) &&
>+                   usb_endpoint_num(ep) == AR9170_USB_EP_CMD)
>+                       ar->usb_ep_cmd_is_bulk =
>+                               usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK;
What about this:

               if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
                   usb_endpoint_is_bulk_out(ep))
                       ar->usb_ep_cmd_is_bulk = true;
(the driver context "ar" is zero'd out - It is not necessary to set 
usb_ep_cmd_is_bulk to false.)

BTW: I'll make a patch to carl9170 firmware too. 

Regards

Christian

[0] https://www.kernel.org/doc/Documentation/SubmittingPatches


