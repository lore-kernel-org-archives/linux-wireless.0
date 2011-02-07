Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1BGPJF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 10:09:05 -0500
Date: Mon, 7 Feb 2011 16:07:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/6] rtlwifi: Add usb driver
Message-ID: <20110207150755.GC2319@redhat.com>
References: <4d4eec04.v8FQZqbn2LYPF8zs%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d4eec04.v8FQZqbn2LYPF8zs%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 12:44:20PM -0600, Larry Finger wrote:
> +enum {
> +	VENDOR_WRITE = 0x00,
> +	VENDOR_READ = 0x01,
> +};
[snip]
> +static int _usbctrl_vendorreq_async(struct usb_device *udev, u8 request,
> +					  u16 value, u16 index, void *pdata,
> +					  u16 len, u8 requesttype)
> +{
It whould be better to leave old name and remove requesttype argument.
We never call  _usbctrl_vendorreq_async with VENDOR_READ, and 
 _usbctrl_vendorreq_sync with VENDOR_WRITE.

If this is not preparation for future changes, that need to
cleaned up, and VENDOR_WRITE and VENDOR_READ definition removed at all.

> +	wvalue = (u16)(addr&0x0000ffff);
wvalue = (u16) addr;

> +static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +
> +	if (&rtlpriv->io)
How it can be NULL? :-) Perhaps this should be rtlpriv check?

> +	/*  TODO: think of race condition... */
[snip]
> +	/*  TODO:	statistics */
[snip]
> +
[snip]
> +		/* TODO: Shall I ignore error and keep issue other urbs? */
[snip]
> +		/* TODO: reinsert skb to list or free the skb? */
[snip]
> +	/* TODO: if usb suspend, we may queue the skb and wake device up.
> +	 * Then xmit.
> +	 * TODO: may change this statement and check all usb state */

Lots of TODO, is this code working? :-)

Is this driver for devices that are currently on the market,
or for future product? I have 3 Realtek dongles, but all works
only with staging driver ...

Stanislaw
