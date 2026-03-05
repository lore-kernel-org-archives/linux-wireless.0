Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5424347FC3
	for <linux-wireless@vger.kernel.org>; Thu,  5 Mar 2026 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772717890; cv=none; b=pWt8/69t6U1J8ouj+/I3tElQQU/XDTcJDEI3LmnR3V2HVHCnBl1LlE1kCWpOf3lPkUuJlZ/Z6HPSEjzwIPydHEIpHvQTqM1DcJloYrZ0cIlqeEk88N/VuX7859gX6OMvuzwmgc2Y34dLuXH3DwhwFDseLjg23xBC75wROIiF3ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772717890; c=relaxed/simple;
	bh=qATtZi6TDhEUJnq6libaFBS3qijKWgEjPywQ/WV47p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLMAiLyXPrwIjhxDzIbf2AvnYQjB739C3YqEtmhErcvk5/WkYoq/gmcrih8P3x+HTQNh/0V/+1e410nOrEZW868iLdiEKvssgbsDOGfpav+UUbsk8bu3MRM/XX9Zy3NOAoiFMyXNgpwfhAQAOEMnD68I+m8rOAvpQzCA44dgnSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=pBz+cQS8; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="pBz+cQS8"
Received: (wp-smtpd smtp.wp.pl 48126 invoked from network); 5 Mar 2026 14:37:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772717876; bh=/3abGi7evwLWXQJjkEgO5RC5Krbz99qub/2NWdzMOtw=;
          h=From:To:Cc:Subject;
          b=pBz+cQS8j2n4Ot+oj+zTbVREbuWjVTjK+gRt/su4MH5e5yQ6V5tt42NyPcDjmgzq6
           vGx2iGs9fAitYe3Uubwxr5uyt2EdifuoCspvc5oC9Vhi6GiazyQBl5hJBL/p5nuJir
           RiJlgfce7PIev66Y3AGRP3RipcueNM+11z988Etteg7Ph7j+XHIrOfbOW0ho4aDPNn
           q6CFW+C+ZcRY6jIh91PZOrvaL1M7CWwO2+FbnN607RqJtIC0vIlsdWuzfrFYedMtQP
           GyfFSBLjjYPnshFAwMfsqeIqOAIJ53gWgti5Qq7pgv2YDu8q4TSAwTSRb0gSNffvAi
           sJ68pO0y+Zx3Q==
Received: from 213-134-167-77.net.autocom.pl (HELO localhost) (stf_xl@wp.pl@[77.236.6.2])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <johan@kernel.org>; 5 Mar 2026 14:37:55 +0100
Date: Thu, 5 Mar 2026 14:37:55 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Johan Hovold <johan@kernel.org>
Cc: linux-wireless@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] wifi: rt2x00: drop redundant device reference
Message-ID: <20260305133755.GA75655@wp.pl>
References: <20260305110713.17725-1-johan@kernel.org>
 <20260305110713.17725-11-johan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305110713.17725-11-johan@kernel.org>
X-WP-MailID: 862d98d6c9156f90b21829b69ab25d56
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cXOE]                               

On Thu, Mar 05, 2026 at 12:07:10PM +0100, Johan Hovold wrote:
> Driver core holds a reference to the USB interface and its parent USB
> device while the interface is bound to a driver and there is no need to
> take additional references unless the structures are needed after
> disconnect.
> 
> Drop the redundant device reference to reduce cargo culting, make it

Getting the reference in probe() and drop it in disconnect() was not a cargo cult.
That was requirement from usb_get_dev() comment, that later it was changed
by below commit:

commit f6a9a2d64dd168b7d71076c0e6b2be7db7cb7399
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Fri Feb 25 09:38:25 2022 -0500

    USB: core: Update kerneldoc for usb_get_dev() and usb_get_intf()

    The kerneldoc for usb_get_dev() and usb_get_intf() says that drivers
    should always refcount the references they hold for the usb_device or
    usb_interface structure, respectively.  But this is an overstatement:
    In many cases drivers do not access these references after they have
    been unbound, and in such cases refcounting is unnecessary.

    This patch updates the kerneldoc for the two routines, explaining when
    a driver does not need to increment and decrement the refcount.  This
    should help dispel misconceptions which might otherwise afflict
    programmers new to the USB subsystem.

    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Link: https://lore.kernel.org/r/Yhjp4Rp9Alipmwtq@rowland.harvard.edu
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Regards
Stanislaw

> easier to spot drivers where an extra reference is needed, and reduce
> the risk of memory leaks when drivers fail to release it.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> index 54599cad78f9..83d00b6baf64 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> @@ -802,14 +802,12 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
>  	struct rt2x00_dev *rt2x00dev;
>  	int retval;
>  
> -	usb_dev = usb_get_dev(usb_dev);
>  	usb_reset_device(usb_dev);
>  
>  	hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
>  	if (!hw) {
>  		rt2x00_probe_err("Failed to allocate hardware\n");
> -		retval = -ENOMEM;
> -		goto exit_put_device;
> +		return -ENOMEM;
>  	}
>  
>  	usb_set_intfdata(usb_intf, hw);
> @@ -851,10 +849,6 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
>  
>  exit_free_device:
>  	ieee80211_free_hw(hw);
> -
> -exit_put_device:
> -	usb_put_dev(usb_dev);
> -
>  	usb_set_intfdata(usb_intf, NULL);
>  
>  	return retval;
> @@ -873,11 +867,7 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
>  	rt2x00usb_free_reg(rt2x00dev);
>  	ieee80211_free_hw(hw);
>  
> -	/*
> -	 * Free the USB device data.
> -	 */
>  	usb_set_intfdata(usb_intf, NULL);
> -	usb_put_dev(interface_to_usbdev(usb_intf));
>  }
>  EXPORT_SYMBOL_GPL(rt2x00usb_disconnect);
>  
> -- 
> 2.52.0
> 
