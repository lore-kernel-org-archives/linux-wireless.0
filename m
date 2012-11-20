Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33591 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2KTILw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:11:52 -0500
Message-ID: <50AB3AFF.2000001@phrozen.org> (sfid-20121120_091156_303734_FBDA123F)
Date: Tue, 20 Nov 2012 09:10:39 +0100
From: John Crispin <john@phrozen.org>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org,
	zajec5@gmail.com, m@bues.ch
Subject: Re: [PATCH 1/8] bcma: add locking around GPIO register accesses
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de> <1353365877-11131-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1353365877-11131-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke

> u32 bcma_chipco_gpio_in(struct bcma_drv_cc *cc, u32 mask)
>   {
> -	return bcma_cc_read32(cc, BCMA_CC_GPIOIN)&  mask;
> +	unsigned long flags;
> +	u32 res;
> +
> +	spin_lock_irqsave(&cc->gpio_lock, flags);
> +	res = bcma_cc_read32(cc, BCMA_CC_GPIOIN)&  mask;
> +	spin_unlock_irqrestore(&cc->gpio_lock, flags);
> +
> +	return res;
>   }
>

Hi Hauke,

do you need to lock the read access ?

if bcma_cc_read32() is a simple memory read wrapper you most likely wont 
need the lock

	John
