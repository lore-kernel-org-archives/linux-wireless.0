Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:31434 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab0I1SJ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 14:09:56 -0400
Subject: Re: [PATCH] wl12xx: fix non-wl12xx build scenarios
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1285692853-28248-1-git-send-email-ohad@wizery.com>
References: <1285692853-28248-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 21:09:43 +0300
Message-ID: <1285697383.4728.10.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 18:54 +0200, ext Ohad Ben-Cohen wrote:
> After a linux-next discussion with John, I realized that building
> configs like:

This kind of comment in the commit log looks a bit odd.  It should be a
bit more technical and direct to the point (ie. real life shouldn't be
included here ;)

If you want to include this kind of comments, you can use a cover-letter
or you can put the comments after the --- that comes after the
signed-off-by tag.  Those comments won't be included in the git log.


> CONFIG_MACH_OMAP_ZOOM3=y
> CONFIG_WL12XX is not set
> 
> will currently break.
> 
> The general problem is building configs for wl1271-equipped boards
> without building the wl1271 driver itself.
> 
> This patch fix this.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Reported-by: John W. Linville <linville@tuxdriver.com>
> ---

Usually this order is the other way around.  I think it makes sense to
keep the tags in chronological ordeer (ie. John reported first, then you
signed-off the patch that fixes it).


>  include/linux/wl12xx.h |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
> index 95deae3..e1d758d 100644
> --- a/include/linux/wl12xx.h
> +++ b/include/linux/wl12xx.h
> @@ -32,7 +32,20 @@ struct wl12xx_platform_data {
>  	int board_ref_clock;
>  };
>  
> +#ifdef CONFIG_WL12XX_PLATFORM_DATA
> +
>  int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
> +
> +#else /* !CONFIG_WL12XX_PLATFORM_DATA */

This is so small that I think the /* !CONFIG... */ is unnecessary.

> +
> +static inline int wl12xx_set_platform_data(const struct wl12xx_platform_data *
> +									data)

It looks nicer if you break the line after static inline, like this:

static inline
int wl12xx_set_platform_data(const struct wl12xx platform_data *data)


> +{
> +	return -ENOSYS;
> +}
> +
> +#endif /* !CONFIG_WL12XX_PLATFORM_DATA */

Comment unnecessary here too.


>  const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
>  
>  #endif

Otherwise it looks good and makes sense. :)


-- 
Cheers,
Luca.

