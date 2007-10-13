Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:64453 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbXJMVvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 17:51:16 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1374630mue
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 14:51:14 -0700 (PDT)
Message-ID: <47113DCE.5020609@gmail.com> (sfid-20071013_225122_791533_B91CADA8)
Date: Sat, 13 Oct 2007 23:51:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath5k: Fix and clean mode initialization, prefer
 G	for AR5212
References: <20071012150438.GC9407@pogo> <20071012150543.GD9407@pogo> <20071012150709.GE9407@pogo> <20071012150745.GF9407@pogo> <4af2d03a0710121433r1f32aaabt4bb8d50c61ef12d5@mail.gmail.com> <20071012223757.GA4994@pogo> <40f31dec0710130221o4b38d5fcld4239b48d24e8206@mail.gmail.com> <40f31dec0710130230xa5d4869x814ccdfad10802be@mail.gmail.com> <47109214.3030409@gmail.com> <20071013200829.GA8951@pogo>
In-Reply-To: <20071013200829.GA8951@pogo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/13/2007 10:08 PM, Luis R. Rodriguez wrote:
> [PATCH 5/5] ath5k: Fix and clean mode initialization, prefer G for AR5212
[...]
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 18ee995..db37ceb 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1896,7 +1896,7 @@ static void ath_dump_modes(struct ieee80211_hw_mode *modes)
>  {
>  	unsigned int m, i;
>  
> -	for (m = 0; m < NUM_IEEE80211_MODES; m++) {
> +	for (m = 0; m < NUM_DRIVER_MODES; m++) {
>  		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
>  				modes[m].num_channels, modes[m].num_rates);
>  		printk(KERN_DEBUG " channels:\n");
> @@ -1919,71 +1919,92 @@ static void ath_dump_modes(struct ieee80211_hw_mode *modes)
>  static inline void ath_dump_modes(struct ieee80211_hw_mode *modes) {}
>  #endif
>  
> +static inline int ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
> +{
> +	struct ath_softc *sc = hw->priv;
> +	struct ieee80211_hw_mode *modes = sc->modes;
> +	int i, ret;

unsigned is usually used for positive iterators, it generates better code almost
for all platforms.

> +
> +	for (i = 0; i < NUM_DRIVER_MODES; i++) {
> +		if (modes[i].mode != m || !modes[i].num_channels)
> +			continue;
> +		ret = ieee80211_register_hwmode(hw, &modes[i]);
> +		if (ret) {
> +			printk(KERN_ERR "can't register hwmode %u\n", m);
> +			return ret;
> +		}
> +		return 0;
> +	}

Maybe we should oops here, since it is a bug to get that far. I think, you
should put BUG() here to not mess userspace with positive retvals.

> +	return 1;
> +}
> +
> +/* Only tries to register modes our EEPROM says it can support */
> +#define REGISTER_MODE(m) do { \
> +	if (test_bit(m, ah->ah_capabilities.cap_mode)) { \
> +		ret = ath5k_register_mode(hw, m); \
> +		if (ret) \
> +			return ret; \
> +	} \

I though you will put the test inside the new ath5k_register_mode function too
(and return 0 in the case when unsupported) and get rid of the macro. But ok,
not global macro we can tolerate return-ing from it :).

knowing to be a pain in the ass,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
