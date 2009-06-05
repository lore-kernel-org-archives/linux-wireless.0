Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:36200 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZFEWQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 18:16:53 -0400
Received: by bwz9 with SMTP id 9so1803544bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2009 15:16:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	<1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 6 Jun 2009 00:16:34 +0200
Message-ID: <69e28c910906051516t55e51136v42b43d67ece04c23@mail.gmail.com>
Subject: Re: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 5, 2009 at 7:41 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> Unfortunately locking the driver rate control private area
> doesn't resolve this issue and in fact causes some issues.
> The root cause is yet undetermined. For now instead of crashing
> lets just downgrades the ASSERT() and only show a trace when
> we are debugging with ATH_DBG_CONFIG enabled. That attempt
> and its results can be seen here:
>
> http://marc.info/?l=linux-wireless&m=124399166108295&w=1
>
> The ASSERT was happening because the rate control algorithm
> figures it should find at least one valid dual stream or
> single stream rate. *Something* is causing us to not find
> such rate. This happens after association and only when HT
> is enabled AFAICT. What we are doing by downgrading the assert
> is informing the driver to use the lowest rate index. When
> this happens lets disable multi rate retry and only try on
> the lowest supported rate.
>
> Traces of the ASSERT are available on this thread:
>
> http://marc.info/?l=linux-wireless&m=124277331319024
>
> At least one bug report (as side issue, mind you):
>
> https://bugzilla.redhat.com/show_bug.cgi?id=503285
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/debug.h |    1 +
>  drivers/net/wireless/ath/ath9k/rc.c    |   40 +++++++++++++++++++++++++++----
>  2 files changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
> index edda15b..9d72bc8 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.h
> +++ b/drivers/net/wireless/ath/ath9k/debug.h
> @@ -30,6 +30,7 @@ enum ATH_DEBUG {
>        ATH_DBG_CONFIG          = 0x00000200,
>        ATH_DBG_FATAL           = 0x00000400,
>        ATH_DBG_PS              = 0x00000800,
> +       ATH_DBG_RATE            = 0x00001000,
>        ATH_DBG_ANY             = 0xffffffff
>  };
>
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index ba06e78..abad86b 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -741,10 +741,24 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
>        if (rate > (ath_rc_priv->rate_table_size - 1))
>                rate = ath_rc_priv->rate_table_size - 1;
>
> -       ASSERT((rate_table->info[rate].valid &&
> -               (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
> -              (rate_table->info[rate].valid_single_stream &&
> -               !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
> +       if (rate_table->info[rate].valid &&
> +           (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
> +               return rate;
> +
> +       if (rate_table->info[rate].valid_single_stream &&
> +           !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG));
> +               return rate;
> +
> +       /*
> +        * This should not happen, but we know it does for now... This
> +        * needs a proper fix but we're still not sure how this is caused.
> +        * Its not *critical* though so lets just warn when debug is enabled
> +        * for configuration changes.
> +        */
> +       if (sc->debug.debug_mask & ATH_DBG_RATE)
> +               WARN_ON(1);

WARN_ON(sc->debug.debug_mask & ATH_DBG_RATE)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
