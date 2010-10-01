Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60444 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0JAVVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 17:21:47 -0400
MIME-Version: 1.0
In-Reply-To: <1285965236-17907-1-git-send-email-gadiyar@ti.com>
References: <1285965236-17907-1-git-send-email-gadiyar@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 1 Oct 2010 23:21:27 +0200
Message-ID: <AANLkTi=+dtqdZLb8rfu8NZRU5GceUL5+S3B=MeW1xF=M@mail.gmail.com>
Subject: Re: [PATCH] omap: zoom2: fix build break when CONFIG_WL12XX_PLATFORM_DATA=n
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 1, 2010 at 10:33 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> Fix this build break when CONFIG_WL12XX_PLATFORM_DATA is not set.

A similar fix was already submitted and is pending to be merged
(http://permalink.gmane.org/gmane.linux.kernel.wireless.general/56595)

> There are still many warnings about the function wl12xx_set_platform_data
> being unused. Haven't fixed those. Ohad, care to take a look?

Sure. Which warnings do you refer to (I haven't seen any) ?

Thanks,
Ohad.

>
>  include/linux/wl12xx.h |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> Index: linux-2.6/include/linux/wl12xx.h
> ===================================================================
> --- linux-2.6.orig/include/linux/wl12xx.h
> +++ linux-2.6/include/linux/wl12xx.h
> @@ -32,7 +32,14 @@ struct wl12xx_platform_data {
>        int board_ref_clock;
>  };
>
> +#ifdef CONFIG_WL12XX_PLATFORM_DATA
>  int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
> +#else
> +static int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
> +{
> +       return 0;
> +}
> +#endif
>  const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
>
>  #endif
>
