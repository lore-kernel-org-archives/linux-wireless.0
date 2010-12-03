Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54328 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0LCGgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 01:36:05 -0500
Received: by qwb7 with SMTP id 7so9254460qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 22:36:04 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101203041239.GF2988@makis.mantri>
References: <20101203041239.GF2988@makis.mantri>
Date: Fri, 3 Dec 2010 07:36:04 +0100
Message-ID: <AANLkTi=KnWvFRoBAvwnkQ82fggHWLLzOUZ=pj-GHYKV0@mail.gmail.com>
Subject: Re: [PATCH 6/6] ath5k: Include tx ack reporting on hw flags
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

On Fri, Dec 3, 2010 at 5:12 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * Since we report tx acks to the protocol stack, add the needed
>  flag to hw_flags. This way we'll also use the new AP probing mechanism.
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index e68f248..cb4ecfa 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2341,8 +2341,9 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
>        /* Initialize driver private data */
>        SET_IEEE80211_DEV(hw, sc->dev);
>        hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
> -                   IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> -                   IEEE80211_HW_SIGNAL_DBM;
> +                       IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> +                       IEEE80211_HW_SIGNAL_DBM |
> +                       IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>
>        hw->wiphy->interface_modes =
>                BIT(NL80211_IFTYPE_AP) |
>
