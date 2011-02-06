Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:46470 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898Ab1BFLfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 06:35:19 -0500
Message-ID: <20110206133511.69015ympfxh2xgg0@hayate.sektori.org>
Date: Sun, 06 Feb 2011 13:35:11 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and
 EP_INT_IN from interrupt to bulk
References: <20110206083522.16858.24185.stgit@fate.lan>
 <19790.26333.573535.551182@gargle.gargle.HOWL>
In-Reply-To: <19790.26333.573535.551182@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Sujith <m.sujith@gmail.com>:

> Jussi Kivilinna wrote:
>> +static int usb_endpoint_int_to_bulk(struct usb_device *udev,  
>> unsigned int pipe)
>> +{
>> +	struct usb_host_endpoint *ep;
>> +
>> +	ep = usb_pipe_endpoint(udev, pipe);
>> +	if (!ep)
>> +		return -EPIPE;
>> +
>> +	switch (ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
>> +	case USB_ENDPOINT_XFER_INT:
>> +		ep->desc.bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
>> +		ep->desc.bmAttributes |= USB_ENDPOINT_XFER_BULK;
>> +		ep->desc.bInterval = 0;
>> +		/* passthru */
>
> ath9k_htc does the same thing (see ath/ath9k/hif_usb.c).
> It does seem to be working properly but I am wondering if the
> USB subsystem has to be updated after the driver messes around with  
> bmAttributes.
> (lsusb would still show the endpoint type as INT).
>
> You have a usb_reset_configuration() call before changing
> the endpoint type, why is that necessary ? And would that
> reset the endpoints as well ?

Choosed to place intr->bulk change after reset as that seemed less  
likely to wrong. Tested in the other order and that works too.




