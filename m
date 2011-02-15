Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38426 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1BOPPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 10:15:34 -0500
Date: Tue, 15 Feb 2011 10:12:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix compile warning
Message-ID: <20110215151251.GB2557@tuxdriver.com>
References: <4d5a00d2./P3aAY/moiXTWkG7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4d5a00d2./P3aAY/moiXTWkG7%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 10:28:02PM -0600, Larry Finger wrote:
> If any of the p54-based drivers are built with CONFIG_P54_LEDS not
> defined, the following warning is generated:
> 
>   CC [M]  drivers/net/wireless/p54/main.o
> drivers/net/wireless/p54/main.c: In function ‘p54_register_common’:
> drivers/net/wireless/p54/main.c:614:21: warning: unused variable ‘priv’
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> 
> Index: wireless-testing/drivers/net/wireless/p54/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/p54/main.c
> +++ wireless-testing/drivers/net/wireless/p54/main.c
> @@ -611,7 +611,9 @@ EXPORT_SYMBOL_GPL(p54_init_common);
>  
>  int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
>  {
> +#ifdef CONFIG_P54_LEDS
>  	struct p54_common *priv = dev->priv;
> +#endif /* CONFIG_P54_LEDS */
>  	int err;
>  
>  	err = ieee80211_register_hw(dev);
> 

Use __maybe_unused instead?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
