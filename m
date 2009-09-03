Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:63184 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZICS45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 14:56:57 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1550114fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 11:56:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH v2] ar9170: added phy register initialisation from eeprom values
Date: Thu, 3 Sep 2009 20:56:55 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1789900589@web.de> <22ee4e770908311437y4954a79eje48976a0203f1806@mail.gmail.com> <4A9EF9A3.1020904@gmx.de>
In-Reply-To: <4A9EF9A3.1020904@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909032056.56245.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 September 2009 01:02:59 Joerg Albert wrote:
> 
> This patch adds the initialisation of some PHY registers
> from the modal_header[] values in the EEPROM
> (see otus/hal/hpmain.c, line 333 ff.)
> 
> Signed-off-by: Joerg Albert <jal2@gmx.de>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

> ---
> 
>  Compared to v1 I've included Christian's suggestions and removed
>  three unnecessary defval assignments for "ant * control".
> 
>  This patch seems to depend on Christian's
>  "[RFT] ar9170: use eeprom's frequency calibration values"
>  (2009-08-21), I get a poor throughput here without it (1-stage fw,
>  802.11g AP).
Good work!

with both patches applied, my WNDA is finally able to pick up some
speed. But, it's still a mbit slower than the two-stage fw.
  
>  drivers/net/wireless/ath/ar9170/phy.c |  136 ++++++++++++++++++++++++++++++++-
>  1 files changed, 135 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
> index df86f70..8fb1fa8 100644
> --- a/drivers/net/wireless/ath/ar9170/phy.c
> +++ b/drivers/net/wireless/ath/ar9170/phy.c
> @@ -396,6 +396,138 @@ static struct ar9170_phy_init ar5416_phy_init[] = {
>  	{ 0x1c9384, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, }
>  };
>  
> +/*
> + * look up a certain register in ar5416_phy_init[] and return the init. value
> + * for the band and bandwidth given. Return 0 if register address not found.
> + */
> +static u32 ar9170_get_default_phy_reg_val(u32 reg, bool is_2ghz, bool is_40mhz)
[...]
> +	/* xpd gain mask (index 14) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c6258, is_2ghz, is_40mhz);
> +	newval = (defval & ~0xf0000) | (xpd2pd[m->xpdGain & 0xf] << 16);
> +	ar9170_regwrite(0x1c6258, newval);
> +
> +
John, can you please nuke those two empty lines?

> +	ar9170_regwrite_finish();
> +
> +	return ar9170_regwrite_result();
> +}
> +
>  int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
>  {
>  	int i, err;
> @@ -426,7 +558,9 @@ int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
>  	if (err)
>  		return err;
>  
> -	/* XXX: use EEPROM data here! */
uh, I think we're still missing the heavy clip/conformance?
(otus/hal/hpmain.c, line 3723 ff.).

It should be modified to say something like:
	/* TODO: (heavy clip) regulatory domain power level fine-tuning. */

> +	err = ar9170_init_phy_from_eeprom(ar, is_2ghz, is_40mhz);
> +	if (err)
> +		return err;
>  
>  	err = ar9170_init_power_cal(ar);
>  	if (err)

Regards,
	Chr
