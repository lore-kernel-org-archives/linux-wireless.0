Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:57481 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932186Ab2CSCqj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 22:46:39 -0400
Message-ID: <1332125197.23125.41.camel@joe2Laptop> (sfid-20120319_034643_031597_1473A602)
Subject: Re: [PATCH] rtlwifi: Preallocate USB read buffers and eliminate
 kalloc in read routine
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 18 Mar 2012 19:46:37 -0700
In-Reply-To: <4f669d14.5MVnZ/K9sIFwYerB%Larry.Finger@lwfinger.net>
References: <4f669d14.5MVnZ/K9sIFwYerB%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-03-18 at 21:42 -0500, Larry Finger wrote:
> The current version of rtlwifi for USB operations uses kmalloc to
> acquire a 32-bit buffer for reading.

trivia:

> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
[]
> @@ -955,6 +947,13 @@ int __devinit rtl_usb_probe(struct usb_i
>  		return -ENOMEM;
>  	}
>  	rtlpriv = hw->priv;
> +	rtlpriv->usb_data = kzalloc(RTL_USB_MAX_RX_COUNT * sizeof(u32),
> +				    GFP_KERNEL);
> +	if (!rtlpriv->usb_data) {
> +		RT_ASSERT(false, "USB data buffer allocation failed\n");

The RT_ASSERT isn't really necessary as kzalloc already
does a dump_stack on allocation failure.

