Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44284 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1BFMHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 07:07:35 -0500
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19790.36590.884287.572619@gargle.gargle.HOWL>
Date: Sun, 6 Feb 2011 17:37:10 +0530
To: "Martin Schleier" <drahemmaps@gmx.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	linville@tuxdriver.com, kune@deine-taler.de,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
	gregkh@suse.de
Subject: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
In-Reply-To: <20110206102710.152130@gmx.net>
References: <20110206102710.152130@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Schleier wrote:
> Interesting, I know that interrupt and bulk endpoints share a lot of
> common logic so I can see how this should work. But is it really
> possible [and more to the point: sane?!] to override the endpoint
> descriptors?
> 
> I know that usb_submit_urb checks [when config_usb_debug is enabled]
> if the xfertype of the submitted urb matches the one of the endpoint,
> so I wonder I started to wonder if we are fooling "just" the code
> here, or ourselves in the process?
>  
> > ath9k_htc does the same thing (see ath/ath9k/hif_usb.c).
> > It does seem to be working properly but I am wondering if the
> > USB subsystem has to be updated after the driver messes around with bmAttributes.
> > (lsusb would still show the endpoint type as INT).
> > 
> > You have a usb_reset_configuration() call before changing
> > the endpoint type, why is that necessary ? And would that
> > reset the endpoints as well ?
> Huh, has this already catched on?

Well, for ath9k_htc, the FW changes the descriptor type after it is
transferred to the target. The USB devs suggested that usb_device_reset()
should be called by the driver in such cases, but in ath9k_htc's case,
the device is disconnected and the error message "device firmware changed"
is displayed.

Agreed, this is a dirty hack - but is there any way for a driver to make the USB
subsystem re-configure the endpoints ?

Sujith
