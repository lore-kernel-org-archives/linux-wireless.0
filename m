Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41538 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZBORVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:21:25 -0500
Received: by ewy14 with SMTP id 14so1616308ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 09:21:23 -0800 (PST)
Message-ID: <49984F0F.3090401@gmail.com> (sfid-20090215_182140_550090_4CEB840F)
Date: Sun, 15 Feb 2009 17:21:19 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH] orinoco: firmware: consistently compile out fw cache
 support if not requested
References: <20090215100902.7895.2670.stgit@cooker.net>
In-Reply-To: <20090215100902.7895.2670.stgit@cooker.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> Currently part of support for FW caching is unconditionally compiled
> in even if it is never used. Consistently remove caching support if
> not requested by user.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

I don't see much point, but...

> diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
> index 7d2292d..842834e 100644
> --- a/drivers/net/wireless/orinoco/fw.c
> +++ b/drivers/net/wireless/orinoco/fw.c
> @@ -79,7 +79,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
>  	if (err)
>  		goto free;
>  
> -	if (!priv->cached_fw) {
> +	if (!orinoco_cached_fw_get(priv)) {
>  		err = request_firmware(&fw_entry, firmware, priv->dev);
>  
>  		if (err) {
> @@ -89,7 +89,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
>  			goto free;
>  		}
>  	} else
> -		fw_entry = priv->cached_fw;
> +		fw_entry = orinoco_cached_fw_get(priv);

Rather than fiddling with how we access the pointers, I think it would
be better to refactor these if..elses into function calls like

fw_entry = orinoco_get_pri_fw(...);

#if CACHING
struct firmware *orinoco_get_pri_fw(...) {
    priv->cached_fw;
}
#else
struct firmware *orinoco_get_pri_fw(...) {
    return request_firmware(..);
}
#endif


> --- a/drivers/net/wireless/orinoco/fw.h
> +++ b/drivers/net/wireless/orinoco/fw.h
> @@ -5,12 +5,52 @@
>  #ifndef _ORINOCO_FW_H_
>  #define _ORINOCO_FW_H_
>  
> -/* Forward declations */
> -struct orinoco_private;
> -

Don't remove the forward declaration, you introduce a dependency of this
header on orinoco.h, which is otherwise unnecessary.

>  int orinoco_download(struct orinoco_private *priv);
>  
> -void orinoco_cache_fw(struct orinoco_private *priv, int ap);
> -void orinoco_uncache_fw(struct orinoco_private *priv);
> +#if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
> +static inline const struct firmware *
> +orinoco_cached_fw_get(struct orinoco_private *priv)
> +{
> +	return priv->cached_fw;
> +}
> +
> +static inline const struct firmware *
> +orinoco_cached_pri_fw_get(struct orinoco_private *priv)
> +{
> +	return priv->cached_pri_fw;
> +}
> +
> +static inline void
> +orinoco_cached_fw_set(struct orinoco_private *priv, struct firmware *fw)
> +{
> +	priv->cached_fw = fw;
> +}
> +
> +static inline void
> +orinoco_cached_pri_fw_set(struct orinoco_private *priv, struct firmware *fw)
> +{
> +	priv->cached_pri_fw = fw;
> +}

Ick. Only fw.c needs the _get calls so they should not be in the header.
Because the _set makes the other half of the pair I would argue they
don't want to be there either. I'd suggest adding orinoco_fw_init
instead, which cleared both elements.

> +extern void orinoco_cache_fw(struct orinoco_private *priv, int ap);
> +extern void orinoco_uncache_fw(struct orinoco_private *priv);

Why do we want to make the extern explicit?

> diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
> index f953059..2afab2a 100644
> --- a/drivers/net/wireless/orinoco/main.c
> +++ b/drivers/net/wireless/orinoco/main.c
> @@ -89,6 +89,8 @@
>  #include <linux/ieee80211.h>
>  #include <net/iw_handler.h>
>  
> +#include "orinoco.h"
> +
>  #include "hermes_rid.h"
>  #include "hermes_dld.h"
>  #include "hw.h"
> @@ -98,8 +100,6 @@
>  #include "wext.h"
>  #include "main.h"
>  
> -#include "orinoco.h"
> -

Suggest you don't move the inclusion forward. I don't know if it's just
me, but I always keep the header which declares what the compilation
unit exports as the final include. In this case that's orinoco.h.

If you really want to, do it in a separate patch so it isn't hidden away.




Dave.
