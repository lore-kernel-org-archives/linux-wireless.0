Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:7914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbZHOMJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 08:09:29 -0400
Received: by fg-out-1718.google.com with SMTP id e21so457233fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2009 05:09:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250281559-13041-11-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	<1250281559-13041-11-git-send-email-lrodriguez@atheros.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 15 Aug 2009 14:09:10 +0200
Message-ID: <69e28c910908150509i158bf2a6r33de5899cdc8bd13@mail.gmail.com>
Subject: Re: [PATCH v4 10/34] wireless: group Broadcom drivers on kconfig
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 10:25 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> This moves Broadcom wireless drivers into their own menu.
> There are only 2 Broadcom specific drivers so we group
> them into a menu which can expand. Although rndis_wlan
> also supports Broadcom devices, RNDIS is a spec and other
> vendors could technically implement solutions with it
> as well so we keep that separate as users most likely
> won't look for those devices under a Broadcom tag.
>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Gábor Stefanik <netrolller.3d@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/Kconfig |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index c2e88dc..150565d 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -561,8 +561,21 @@ source "drivers/net/wireless/iwmc3200wifi/Kconfig"
>  endif # INTEL_80211
>
>  source "drivers/net/wireless/hostap/Kconfig"
> +
> +config BROADCOM_80211
> +       bool "Broadcom"
> +       depends on WLAN_80211
> +       ---help---
> +         This will enable the support for Broadcom wireless drivers. This
> +         includes b43 driver, b43legacy driver and the rndis_wlan driver.

NAK. Again, rndis_wlan is Microsoft, not Broadcom.

> +
> +if BROADCOM_80211
> +
>  source "drivers/net/wireless/b43/Kconfig"
>  source "drivers/net/wireless/b43legacy/Kconfig"
> +
> +endif # BROADCOM_80211
> +
>  source "drivers/net/wireless/rt2x00/Kconfig"
>  source "drivers/net/wireless/orinoco/Kconfig"
>  source "drivers/net/wireless/wl12xx/Kconfig"
> --
> 1.6.2.5
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
