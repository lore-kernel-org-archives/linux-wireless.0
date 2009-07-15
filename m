Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n24.bullet.mail.mud.yahoo.com ([68.142.206.163]:26203 "HELO
	n24.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750730AbZGOEE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 00:04:28 -0400
Date: Tue, 14 Jul 2009 21:04:26 -0700
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Bennyam Malavazi <Bennyam.Malavazi@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"Vasanth@venema.h4ckr.net" <Vasanth@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix enabling OFDM weak signal detection
Message-ID: <20090715040426.GA14415@steven676.net>
References: <20090709211221.GA4854@steven676.net> <43e72e890907101102i29352c6bq9e511663e2c3a986@mail.gmail.com> <20090714180348.GD25788@mosca> <20090714181148.GE25788@mosca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090714181148.GE25788@mosca>
From: steven@steven676.net (Steven Luo)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 14, 2009 at 11:11:48AM -0700, Luis R. Rodriguez wrote:
> On Tue, Jul 14, 2009 at 11:03:48AM -0700, Luis Rodriguez wrote:
> > Please try this patch instead, I've only compile tested this.

Yeah, this works too.  Thanks!

-Steven Luo

> Now without the double AP check :)
> 
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: [PATCH] ath9k: Tune ANI function processing on AP mode during ANI reset
> 
> For AP mode we must tune ANI specially for 2 GHz and
> for 5 GHz. We mask in only the flags we want to toggle
> on ath9k_hw_ani_control() through the ah->ani_function
> bitmask, this will take care of ignoring changes during
> ANI reset which we were disabling before.
> 
> Reported-by: Steven Luo <steven@steven676.net>
> Cc: Bennyam Malavazi <Bennyam.Malavazi@Atheros.com
> Cc: Jouni Malinen <Jouni.Malinen@Atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ani.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
> --- a/drivers/net/wireless/ath/ath9k/ani.c
> +++ b/drivers/net/wireless/ath/ath9k/ani.c
> @@ -478,6 +478,18 @@ void ath9k_ani_reset(struct ath_hw *ah)
>  			"Reset ANI state opmode %u\n", ah->opmode);
>  		ah->stats.ast_ani_reset++;
>  
> +		if (ah->opmode == NL80211_IFTYPE_AP) {
> +			/*
> +			 * ath9k_hw_ani_control() will only process items set on
> +			 * ah->ani_function
> +			 */
> +			if (IS_CHAN_2GHZ(chan))
> +				ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
> +						    ATH9K_ANI_FIRSTEP_LEVEL);
> +			else
> +				ah->ani_function = 0;
> +		}
> +
>  		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL, 0);
>  		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
>  		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, 0);
> -- 
> 1.6.3.3

