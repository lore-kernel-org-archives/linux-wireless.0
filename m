Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:56693 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbZJZUbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:31:41 -0400
Received: by ewy4 with SMTP id 4so4010232ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 13:31:45 -0700 (PDT)
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 2/4] ath9k_hw: distinguish single-chip solutions on initial probe print
References: <1256575447-4591-1-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 26 Oct 2009 22:31:44 +0200
In-Reply-To: <1256575447-4591-1-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Mon\, 26 Oct 2009 12\:44\:07 -0400")
Message-ID: <87d449hp73.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> Devices with external radios have revisions which we can count on.
> On single chip solutions these EEPROM values for these radio revision
> also exist but are not meaningful as the radios are embedded onto the
> same chip. Each single-chip device evolves together as one device.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>
> Changes hw_name to 60 bytes.

Thanks, much better now.

Another minor comment, sorry that I didn't notice it earlier:

> +void ath9k_hw_name(struct ath_hw *ah, char *hw_name)
> +{
> +	/* chipsets >= AR9280 are single-chip */
> +	if (AR_SREV_9280_10_OR_LATER(ah)) {
> +		sprintf(hw_name,
> +			"Atheros single-chip AR%s Rev:%x",
> +			ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
> +			ah->hw_version.macRev);
> +	}
> +	else {
> +		sprintf(hw_name,
> +			"Atheros AR%s MAC/BB Rev:%x AR%s RF Rev:%x: ",
> +			ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
> +			ah->hw_version.macRev,
> +			ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
> +					 AR_RADIO_SREV_MAJOR)),
> +			ah->hw_version.phyRev);
> +	}
> +}

I think you should provide the size of hw_name to this function and
use snprintf() to avoid writing out of bounds.

-- 
Kalle Valo
