Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48605 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZKSUNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 15:13:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb: Unconditionally log results of core scans
Date: Thu, 19 Nov 2009 21:13:33 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4b059ffa.0PbmHUedj2WTwpAO%Larry.Finger@lwfinger.net>
In-Reply-To: <4b059ffa.0PbmHUedj2WTwpAO%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911192113.35757.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 November 2009 20:43:54 Larry Finger wrote:
> At present, the results of an SSB core scan are only logged when
> CONFIG_SSB_DEBUG is "y". As this may not be set in a distro kernel,
> it is difficult interpret many problems posted in bug reports or in
> help forums.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing/drivers/ssb/scan.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/scan.c
> +++ wireless-testing/drivers/ssb/scan.c
> @@ -354,7 +354,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
>  		dev->bus = bus;
>  		dev->ops = bus->ops;
>  
> -		ssb_dprintk(KERN_INFO PFX
> +		printk(KERN_INFO PFX
>  			    "Core %d found: %s "
>  			    "(cc 0x%03X, rev 0x%02X, vendor 0x%04X)\n",
>  			    i, ssb_core_name(dev->id.coreid),
> 
> 

Please use KERN_DEBUG

-- 
Greetings, Michael.
