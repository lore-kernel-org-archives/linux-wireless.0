Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:52831 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764419AbZDHToF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 15:44:05 -0400
MIME-Version: 1.0
Date: Wed, 08 Apr 2009 22:43:48 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "eugene.sobol" <eugene.sobol@promwad.com>,
	linux-wireless@vger.kernel.org, hintak.leung@gmail.com
Subject: Re: rtl8187 diversity
In-Reply-To: <49DCE741.7080406@lwfinger.net>
References: <200904081530.51962.eugene.sobol@promwad.com> <49DCE741.7080406@lwfinger.net>
Message-ID: <1e0576e9ab550ccec84402b8b0805633@promwad.com> (sfid-20090408_214411_062057_480F05EC)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> My first comment is that the patch should be in-line rather than as an
> attachment. Reviewing is easier.
> 
> You should be using the wireless-testing tree to derive your patches.
> Otherwise,
> they cannot be applied. For example, the following hunk is already in
w-t:
> 
> @@ -257,6 +261,7 @@
> 
>         usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev,
> ep),
>                           buf, skb->len, rtl8187_tx_cb, skb);
> +       urb->transfer_flags |= URB_ZERO_PACKET;
>         rc = usb_submit_urb(urb, GFP_ATOMIC);
>         if (rc < 0) {
>                 usb_free_urb(urb);
> 
> 
> I don't like the idea of having the antenna diversity as a compile-time
> option.
> That works OK for a single user, but it fails when distros are
considered.
> They
> would have to have it on for all cases even though very few users would
> need it.
> Does the EEPROM for your device have special encoding that indicates the
> presence of multiple antennas? You should be able to compile the antenna
> diversity code unconditionally and use such a special EEPROM value.
> Alternatively, the USB ID's (13d1:abe6) could be used to select its
> execution.
> 
> You should run the patch through the scripts/checkpatch.pl routine. Yours
> shows
> 55 errors and 34 warnings.
> 
> Please split out the part that adds the new USB_DEVICE and submit it now.
> That
> will be needed no matter what happens to the antenna diversity code.
> 
> Larry
> --

Hello Larry, thanks for comments! Surely Eugene will fix patch issues and 
resubmit patch inline. Actually in its current stage this patch just show
an 
diversity idea and will be cleaned-up for submission with Signed-off-by.
Currently the question was about correctness of calculation of signal
quality
and making decision when switching between antennas should be done. Anyway
it will be easier to say about this when patch will be inline.

Btw, USB_DEVICE is already added: http://lkml.org/lkml/2008/11/17/39

Best regards,
Ivan





