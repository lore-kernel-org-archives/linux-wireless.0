Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:60847 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031525AbXD1Mba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 08:31:30 -0400
Date: Sat, 28 Apr 2007 14:31:23 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: Oops in ieee80211_register_hw
Message-ID: <20070428143123.5a1a905a@logostar.upir.cz>
In-Reply-To: <200704272026.11196.flamingice@sourmilk.net>
References: <20070427233738.5842decf@griffin.suse.cz>
	<200704272026.11196.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 20:26:06 -0400, Michael Wu wrote:
> I've attached a patch. I don't have the hardware so I don't know if it'll 
> work, but it seems right to me.

It fixes the problem for me. Thanks!

 Jiri


> ssb_devices_register sets sdev->dev after the device is registered. This
> moves it before device_register so it can be used during probe if an
> appropriate driver is found during device_register.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---
> 
>  drivers/ssb/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index 682aa5c..c8afd1b 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -364,6 +364,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
>  
>  		dev->release = ssb_release_dev;
>  		dev->bus = &ssb_bustype;
> +		sdev->dev = dev;
>  		snprintf(dev->bus_id, sizeof(dev->bus_id),
>  			 "ssb%d:%d", bus->busnumber, dev_idx);
>  
> @@ -391,7 +392,6 @@ static int ssb_devices_register(struct ssb_bus *bus)
>  			kfree(devwrap);
>  			goto error;
>  		}
> -		sdev->dev = dev;
>  		dev_idx++;
>  	}
>  

-- 
Jiri Benc
SUSE Labs
