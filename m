Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab0L2QqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 11:46:19 -0500
Received: by fxm20 with SMTP id 20so10592483fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 08:46:18 -0800 (PST)
Message-ID: <4D1B65D7.8090103@lwfinger.net>
Date: Wed, 29 Dec 2010 10:46:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christoph Paasch <christoph.paasch@uclouvain.be>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	chunkeey@googlemail.com
Subject: Re: [PATCH] p54: fix compiler-warning when no P54_LEDS are configured
References: <1293635679-9783-1-git-send-email-christoph.paasch@uclouvain.be>
In-Reply-To: <1293635679-9783-1-git-send-email-christoph.paasch@uclouvain.be>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/29/2010 09:14 AM, Christoph Paasch wrote:
> The priv-variable is unused when compiling without CONFIG_P54_LEDS.
> 
> Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
> ---
>  drivers/net/wireless/p54/main.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
> index 622d27b..a6802f5 100644
> --- a/drivers/net/wireless/p54/main.c
> +++ b/drivers/net/wireless/p54/main.c
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
> @@ -653,9 +655,9 @@ EXPORT_SYMBOL_GPL(p54_free_common);
>  
>  void p54_unregister_common(struct ieee80211_hw *dev)
>  {
> +#ifdef CONFIG_P54_LEDS
>  	struct p54_common *priv = dev->priv;
>  
> -#ifdef CONFIG_P54_LEDS
>  	p54_unregister_leds(priv);
>  #endif /* CONFIG_P54_LEDS */
>  

I was too quick to ACK this. The second hunk causes a compiler ERROR as priv is
needed in the mutex_destroy() calls.

NACK

Larry

