Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54255 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1JLCyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 22:54:31 -0400
Received: by iaek3 with SMTP id k3so282579iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 19:54:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.v27rufm9ya27un@edmitar>
References: <op.v27rufm9ya27un@edmitar>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 12 Oct 2011 13:54:11 +1100
Message-ID: <CAGRGNgUeLO3LmTO-hLCRsByWFRbawz1aN_hmbfqp_u10u9b8Qw@mail.gmail.com> (sfid-20111012_045435_518822_6C446645)
Subject: Re: [RFC 01/07] wireless-next: WAPI support for hardware-accelerated drivers
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Some minor comments on your patch:

Note that I'm not a maintainer and that these are comments on the
patch itself, not the code it adds.

On Wed, Oct 12, 2011 at 12:02, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Date: Wed, 1 Jun 2011 14:40:13 +0200
>
> This commit implements WAPI support for hardware-accelerated devices.
>
> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> ---
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 48363c3..bf86b0d 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1551,12 +1552,14 @@ enum ieee80211_sa_query_action {
>  #define WLAN_CIPHER_SUITE_CCMP         0x000FAC04
>  #define WLAN_CIPHER_SUITE_WEP104       0x000FAC05
>  #define WLAN_CIPHER_SUITE_AES_CMAC     0x000FAC06
> +#define WLAN_CIPHER_SUITE_SMS4         0x000FAC07
>
>  /* AKM suite selectors */
>  #define WLAN_AKM_SUITE_8021X           0x000FAC01
>  #define WLAN_AKM_SUITE_PSK             0x000FAC02
>  #define WLAN_AKM_SUITE_SAE                     0x000FAC08
>  #define WLAN_AKM_SUITE_FT_OVER_SAE     0x000FAC09
> +#define WLAN_AKM_SUITE_WAPI_PSK                0x000FAC03

Should these go in numerical order?

> diff --git a/net/mac80211/wapi.h b/net/mac80211/wapi.h
> new file mode 100644
> index 0000000..f06eee0
> --- /dev/null
> +++ b/net/mac80211/wapi.h
> @@ -0,0 +1,27 @@

[snip]

> +#ifndef ETH_P_WAPI
> +#define ETH_P_WAPI     0x88B4
> +#endif

Should this go somewhere else? Maybe where the other ETH_P_* #defines
are defined?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
