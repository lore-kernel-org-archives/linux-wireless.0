Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:61609 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbXJMHef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 03:34:35 -0400
Received: by fk-out-0910.google.com with SMTP id z23so969479fkz
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 00:34:34 -0700 (PDT)
Message-ID: <47107506.3080303@gmail.com> (sfid-20071013_083440_166959_FE789F60)
Date: Sat, 13 Oct 2007 09:34:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/5] ath5k: Fix and clean mode initialization, prefer
 G	for AR5212
References: <20071012150438.GC9407@pogo> <20071012150543.GD9407@pogo> <20071012150709.GE9407@pogo> <20071012150745.GF9407@pogo> <4af2d03a0710121433r1f32aaabt4bb8d50c61ef12d5@mail.gmail.com> <20071012223757.GA4994@pogo>
In-Reply-To: <20071012223757.GA4994@pogo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/13/2007 12:37 AM, Luis R. Rodriguez wrote:
> [PATCH 5/5] ath5k: Fix and clean mode initialization, prefer G for AR5212
> 
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

Acked-by: Jiri Slaby <jirislaby@gmail.com>

> ---
>  drivers/net/wireless/ath5k/base.c |  106 ++++++++++++++++++++-----------------
>  net/mac80211/ieee80211_ioctl.c    |    5 ++-
>  2 files changed, 61 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 18ee995..8413950 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
[...]
> +	modes[0].mode = MODE_IEEE80211G;
> +	modes[1].mode = MODE_IEEE80211B;
> +	modes[2].mode = MODE_IEEE80211A;
> +
> +	max_r = ARRAY_SIZE(sc->rates);
> +	max_c = ARRAY_SIZE(sc->channels);
> +
> +	for (i = 0; i <= 2; i++) {
> +		struct ieee80211_hw_mode *mode = &modes[i];
> +		const struct ath5k_rate_table *hw_rates;
> +
> +		if (i == 0) {
> +			modes[0].rates	= sc->rates;
> +			modes->channels	= sc->channels;

:) some kind of personal diversity :D

>  	ath_dump_modes(modes);

BTW. have you tried to compare outputs from this function before the change and
after it?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
