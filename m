Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36937 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1BFJQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 04:16:35 -0500
Received: by pva4 with SMTP id 4so701376pva.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 01:16:34 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19790.26333.573535.551182@gargle.gargle.HOWL>
Date: Sun, 6 Feb 2011 14:46:13 +0530
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk
In-Reply-To: <20110206083522.16858.24185.stgit@fate.lan>
References: <20110206083522.16858.24185.stgit@fate.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jussi Kivilinna wrote:
> +static int usb_endpoint_int_to_bulk(struct usb_device *udev, unsigned int pipe)
> +{
> +	struct usb_host_endpoint *ep;
> +
> +	ep = usb_pipe_endpoint(udev, pipe);
> +	if (!ep)
> +		return -EPIPE;
> +
> +	switch (ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
> +	case USB_ENDPOINT_XFER_INT:
> +		ep->desc.bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
> +		ep->desc.bmAttributes |= USB_ENDPOINT_XFER_BULK;
> +		ep->desc.bInterval = 0;
> +		/* passthru */

ath9k_htc does the same thing (see ath/ath9k/hif_usb.c).
It does seem to be working properly but I am wondering if the
USB subsystem has to be updated after the driver messes around with bmAttributes.
(lsusb would still show the endpoint type as INT).

You have a usb_reset_configuration() call before changing
the endpoint type, why is that necessary ? And would that
reset the endpoints as well ?

Sujith
