Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:46381 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZHOMOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 08:14:08 -0400
Received: by fg-out-1718.google.com with SMTP id e21so457547fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2009 05:14:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250281559-13041-24-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	<1250281559-13041-24-git-send-email-lrodriguez@atheros.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 15 Aug 2009 14:13:49 +0200
Message-ID: <69e28c910908150513v10a4ad8dh8f40fe8fbff2a533@mail.gmail.com>
Subject: Re: [PATCH v4 23/34] wireless: downgrade TI driver from menuconfig to
	config
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 10:25 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> There's only a few options here so let this expand upon
> selection.
>
> Cc: Kalle Valo <kalle.valo@nokia.com>
> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/wl12xx/Kconfig |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
> index 1818e45..78029fd 100644
> --- a/drivers/net/wireless/wl12xx/Kconfig
> +++ b/drivers/net/wireless/wl12xx/Kconfig
> @@ -1,10 +1,12 @@
> -menuconfig WL12XX
> +config WL12XX
>        boolean "TI wl12xx driver support"
>        depends on MAC80211 && EXPERIMENTAL
>        ---help---
>          This will enable TI wl12xx driver support. The drivers make
>          use of the mac80211 stack.
>
> +if WL12XX
> +
>  config WL1251
>        tristate "TI wl1251 support"
>        depends on WL12XX && GENERIC_HARDIRQS

If "if WL12XX", then no need to depend on WL12XX.

> @@ -50,3 +52,5 @@ config WL1271
>
>          If you choose to build a module, it'll be called wl1271. Say N if
>          unsure.
> +
> +endif # WL12XX
> --
> 1.6.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
