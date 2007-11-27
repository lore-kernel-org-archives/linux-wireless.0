Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:8817 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbXK0Sk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 13:40:29 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1064014nfb
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 10:40:25 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [RFC/T] rt2x00: Remove redundant code in rfkill setup
Date: Tue, 27 Nov 2007 20:43:48 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <474c4e19.tFKoUyFEw/5q8HAB%Larry.Finger@lwfinger.net>
In-Reply-To: <474c4e19.tFKoUyFEw/5q8HAB%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711272043.49429.IvDoorn@gmail.com> (sfid-20071127_184037_271962_2A05FAA7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 November 2007, Larry Finger wrote:
> In rt2x00rfkill.c, routine input_allocate_device() is called even though
> input_allocate_polled_device(), which was just called, includes a call to
> that routine. This patch, which has not been tested, removes the redundant code.

Either I was blind for not noticing that before, or the behavior has changed recently. ;)
Applied to rt2x00.git, I will push it to John in a few minutes along with some other patches.

Thanks.

Ivo

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-2.6/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> +++ wireless-2.6/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> @@ -141,12 +141,6 @@ int rt2x00rfkill_allocate(struct rt2x00_
>  	rt2x00dev->poll_dev->poll = rt2x00rfkill_poll;
>  	rt2x00dev->poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
>  
> -	rt2x00dev->poll_dev->input = input_allocate_device();
> -	if (!rt2x00dev->poll_dev->input) {
> -		ERROR(rt2x00dev, "Failed to allocate input device.\n");
> -		goto exit_free_polldev;
> -	}
> -
>  	rt2x00dev->poll_dev->input->name = rt2x00dev->ops->name;
>  	rt2x00dev->poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
>  	rt2x00dev->poll_dev->input->id.bustype = BUS_HOST;
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2005.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
> 


