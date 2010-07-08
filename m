Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39393 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0GHV2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 17:28:41 -0400
Received: by pwi5 with SMTP id 5so483003pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jul 2010 14:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278623628-25477-1-git-send-email-hauke@hauke-m.de>
References: <1278623628-25477-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 8 Jul 2010 14:28:20 -0700
Message-ID: <AANLkTim9AMJv8BKyjLKxHn6nlz7jqlDbu8nR-mR_0pcu@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat-wireless: activate CONFIG_CFG80211_WEXT if
	possible
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 8, 2010 at 2:13 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> CONFIG_CFG80211_WEXT depends on CONFIG_WIRELESS_EXT for every kernel
> version,

This can't be true since CONFIG_WIRELESS_EXT is gone on recent kernels.

> because we use the wireless_handlers attribute.
> CONFIG_CFG80211_WEXT should be set here every time it will be set in
> config.mk.
> The build was failing for kernel > 2.6.32 with CONFIG_WIRELESS_EXT=y
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  scripts/gen-compat-autoconf.sh |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
> index 1e3002e..277467f 100755
> --- a/scripts/gen-compat-autoconf.sh
> +++ b/scripts/gen-compat-autoconf.sh
> @@ -191,10 +191,7 @@ if [ -f $KLIB_BUILD/Makefile ]; then
>                echo CONFIG_NETDEVICES_MULTIQUEUE >> $MULT_DEP_FILE
>                define_config_multiple_deps CONFIG_MAC80211_QOS y $ALL_DEPS
>                rm -f $MULT_DEP_FILE
> -               # Kernels >= 2.6.32 can disable WEXT :D
> -               if [ $SUBLEVEL -le 32 ]; then
> -                       define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
> -               fi
> +               define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
>        fi
>  fi
>  echo "#endif /* COMPAT_AUTOCONF_INCLUDED */"

What this is expressing is we need CONFIG_WIRELESS_EXT if we are <
2.6.32 and want CONFIG_CFG80211_WEXT. What happened on 2.6.32 is we
allowed for CONFIG_WIRELESS_EXT to be disabled on the kernel, but this
same config option was renamed on future kernels or removed, I forget
which.

Your patch would not allow kernels to use compat-wireless that have
wireless extensions disabled, so there seems to be another way we need
to address this.

  Luis
