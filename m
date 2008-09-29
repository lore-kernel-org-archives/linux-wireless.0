Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37812 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYI2Tvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 15:51:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Increase loop tries in do_dummy_tx
Date: Mon, 29 Sep 2008 21:51:12 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48e12a41.fSr2FmkheZiPQYjZ%Larry.Finger@lwfinger.net>
In-Reply-To: <48e12a41.fSr2FmkheZiPQYjZ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809292151.12279.mb@bu3sch.de> (sfid-20080929_215143_558150_9CAAA2CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 September 2008 21:19:29 Larry Finger wrote:
> One of the spin-on-condition loops in routine do_dummy_tx always exits before
> the condition is satisfied. The hardware might be left in an inconsistent
> state that might be the cause of the PHY transmission errors seen by some
> users.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

> ---
> 
> John,
> 
> This is 2.6.28 material.
> 
> Larry
> ---
> 
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 7205a93..af60122 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -814,7 +814,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
>  			break;
>  		udelay(10);
>  	}
> -	for (i = 0x00; i < 0x0A; i++) {
> +	for (i = 0x00; i < 0x19; i++) {
>  		value = b43_read16(dev, 0x0690);
>  		if (!(value & 0x0100))
>  			break;

-- 
Greetings Michael.
