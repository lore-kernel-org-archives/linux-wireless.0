Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:52943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbXJLVdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 17:33:07 -0400
Received: by ug-out-1314.google.com with SMTP id z38so674366ugc
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 14:33:05 -0700 (PDT)
Message-ID: <4af2d03a0710121433r1f32aaabt4bb8d50c61ef12d5@mail.gmail.com> (sfid-20071012_223313_868392_B56109A0)
Date: Fri, 12 Oct 2007 23:33:05 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 5/5] ath5k: Fix and clean mode initialization, prefer G for AR5212
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <20071012150745.GF9407@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071012150438.GC9407@pogo> <20071012150543.GD9407@pogo>
	 <20071012150709.GE9407@pogo> <20071012150745.GF9407@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I didn't sleep too much due to travelling, maybe I'm wrong in some
cases, some comments follows.

On 10/12/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Currently you get locked on B mode with AR5212s. This could be partly
> mac80211's fault with a recent regression introduced but ath5k mode
> initialization right now is pretty sloppy. For AR5212s we also currently
> start scanning in 5GHz. I've made the mode initialization on ath5k a bit
> clearer and only am registering G mode now instead of both B and G for
> AR5212s. 11Mbps is still the only stable rate but at least now we can
> work and test the other rates again.
>
> Note: mac80211 simple rate algo throws us to 1Mbps after assoc, this is by
>         design. I recommend users to set rate to 11M for now after assoc.
>
> Changes-licensed-under: 3-clause-BSD
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |  104 +++++++++++++++++++-----------------
>  1 files changed, 55 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 18ee995..5cb48d4 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1919,67 +1919,73 @@ static void ath_dump_modes(struct ieee80211_hw_mode *modes)
>  static inline void ath_dump_modes(struct ieee80211_hw_mode *modes) {}
>  #endif
>
> +#define REGISTER_MODE(mode) do { \
> +       if (modes[mode].num_channels) { \
> +               ret = ieee80211_register_hwmode(hw, &modes[mode]); \
> +               if (ret) { \
> +                       printk(KERN_ERR "can't register hwmode %u\n", mode); \
> +                       goto err; \
> +               } \
> +       } \
> +} while (0)
> +
>  static int ath_getchannels(struct ieee80211_hw *hw)
>  {
>         struct ath_softc *sc = hw->priv;
>         struct ath_hw *ah = sc->ah;
>         struct ieee80211_hw_mode *modes = sc->modes;
> -       unsigned int i, max;
> +       unsigned int i, max_r, max_c;
>         int ret;
> -       enum {
> -               A = MODE_IEEE80211A,
> -               B = MODE_IEEE80211G, /* this is not a typo, but workaround */
> -               G = MODE_IEEE80211B, /* to prefer g over b */
> -               T = MODE_ATHEROS_TURBO,
> -               TG = MODE_ATHEROS_TURBOG,
> -       };
>
>         BUILD_BUG_ON(ARRAY_SIZE(sc->modes) < 3);
>
>         ah->ah_country_code = countrycode;
>
> -       modes[A].mode = MODE_IEEE80211A;
> -       modes[B].mode = MODE_IEEE80211B;
> -       modes[G].mode = MODE_IEEE80211G;
> -
> -       max = ARRAY_SIZE(sc->rates);
> -       modes[A].rates = sc->rates;
> -       max -= modes[A].num_rates = ath_copy_rates(modes[A].rates,
> -                       ath5k_hw_get_rate_table(ah, MODE_IEEE80211A), max);
> -       modes[B].rates = &modes[A].rates[modes[A].num_rates];
> -       max -= modes[B].num_rates = ath_copy_rates(modes[B].rates,
> -                       ath5k_hw_get_rate_table(ah, MODE_IEEE80211B), max);
> -       modes[G].rates = &modes[B].rates[modes[B].num_rates];
> -       max -= modes[G].num_rates = ath_copy_rates(modes[G].rates,
> -                       ath5k_hw_get_rate_table(ah, MODE_IEEE80211G), max);
> -
> -       if (!max)
> -               printk(KERN_WARNING "yet another rates found, but there is not "
> -                               "sufficient space to store them\n");
> -
> -       max = ARRAY_SIZE(sc->channels);
> -       modes[A].channels = sc->channels;
> -       max -= modes[A].num_channels = ath_copy_channels(ah, modes[A].channels,
> -                       MODE_IEEE80211A, max);
> -       modes[B].channels = &modes[A].channels[modes[A].num_channels];
> -       max -= modes[B].num_channels = ath_copy_channels(ah, modes[B].channels,
> -                       MODE_IEEE80211B, max);
> -       modes[G].channels = &modes[B].channels[modes[B].num_channels];
> -       max -= modes[G].num_channels = ath_copy_channels(ah, modes[G].channels,
> -                       MODE_IEEE80211G, max);
> -
> -       if (!max)
> -               printk(KERN_WARNING "yet another modes found, but there is not "
> -                               "sufficient space to store them\n");
> -
> -       for (i = 0; i < ARRAY_SIZE(sc->modes); i++)
> -               if (modes[i].num_channels) {
> -                       ret = ieee80211_register_hwmode(hw, &modes[i]);
> -                       if (ret) {
> -                               printk(KERN_ERR "can't register hwmode %u\n",i);
> -                               goto err;
> -                       }
> +       modes[0].mode = MODE_IEEE80211G;
> +       modes[1].mode = MODE_IEEE80211B;
> +       modes[2].mode = MODE_IEEE80211A;
> +
> +       max_r = ARRAY_SIZE(sc->rates);
> +       max_c = ARRAY_SIZE(sc->channels);
> +       modes[0].rates = sc->rates;
> +
> +       for (i = 0; i <= 2; i++) {
> +               struct ieee80211_hw_mode *mode = &modes[i];
> +               const struct ath5k_rate_table *hw_rates;
> +
> +               if (i == 0) {
> +                       mode->rates     = sc->rates;
> +                       modes->channels = sc->channels;

mode/modes, it's doesn't matter here, but it doesn't look well

> +               } else {
> +                       struct ieee80211_hw_mode *prev_mode = &modes[i-1];
> +                       int prev_num_r  = prev_mode->num_rates;
> +                       int prev_num_c  = prev_mode->num_channels;
> +                       mode->rates     = &prev_mode->rates[prev_num_r];
> +                       mode->channels  = &prev_mode->channels[prev_num_c];
>                 }
> +
> +               hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
> +               mode->num_rates    = ath_copy_rates(mode->rates, hw_rates,
> +                       max_r);
> +               mode->num_channels = ath_copy_channels(ah, mode->channels,
> +                       mode->mode, max_c);
> +               max_r -= modes->num_rates;

modes? but here it matters...

> +               max_c -= mode->num_channels;
> +       }
> +
> +       switch (ah->ah_version) {
> +       case AR5K_AR5210:
> +               REGISTER_MODE(MODE_IEEE80211A);
> +               break;
> +       case AR5K_AR5211:
> +               REGISTER_MODE(MODE_IEEE80211B);
> +               break;
> +       case AR5K_AR5212:
> +               if (!ah->ah_single_chip)
> +                       REGISTER_MODE(MODE_IEEE80211A);
> +               REGISTER_MODE(MODE_IEEE80211G);

And this seems totally wrong. you use 0, 1, 2 indexes above and here
you index it by mac80211 integers. That's exactly why the enum was
there (a shortcut like in intel drivers) -- to not get into it.

> +               break;
> +       }
>         ath_dump_modes(modes);
>
>         return 0;
