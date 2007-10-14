Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59061
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXJNTLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 15:11:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] Fix a null pointer check in ssb mipscore init
Date: Sun, 14 Oct 2007 21:10:27 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <47126836.5000906@openwrt.org>
In-Reply-To: <47126836.5000906@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710142110.28074.mb@bu3sch.de> (sfid-20071014_201146_097052_67948C68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 14 October 2007 21:04:22 Felix Fietkau wrote:
> Fix a null pointer check in ssb mipscore init
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Acked-by: Michael Buesch <mb@bu3sch.de>

> --- a/drivers/ssb/driver_mipscore.c
> +++ b/drivers/ssb/driver_mipscore.c
> @@ -171,20 +171,21 @@ u32 ssb_cpu_clock(struct ssb_mipscore *mcore)
>  	return rate;
>  }
> 
>  void ssb_mipscore_init(struct ssb_mipscore *mcore)
>  {
> -	struct ssb_bus *bus = mcore->dev->bus;
> +	struct ssb_bus *bus;
>  	struct ssb_device *dev;
>  	unsigned long hz, ns;
>  	unsigned int irq, i;
> 
>  	if (!mcore->dev)
>  		return; /* We don't have a MIPS core */
> 
>  	ssb_dprintk(KERN_INFO PFX "Initializing MIPS core...\n");
> 
> +	bus = mcore->dev->bus;
>  	hz = ssb_clockspeed(bus);
>  	if (!hz)
>  		hz = 100000000;
>  	ns = 1000000000 / hz;
> 
> 
> 
> 



-- 
Greetings Michael.
