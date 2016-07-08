Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56963 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbcGHHgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 03:36:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eduardo Abinader <eduardo.abinader@riverbed.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH V2] ath9k: consider return code on ar9300_eeprom_restore_flash
References: <57768ADC.6060103@riverbed.com>
Date: Fri, 08 Jul 2016 10:36:20 +0300
In-Reply-To: <57768ADC.6060103@riverbed.com> (Eduardo Abinader's message of
	"Fri, 1 Jul 2016 17:23:08 +0200")
Message-ID: <87vb0g1szv.fsf@kamboji.qca.qualcomm.com> (sfid-20160708_093634_520920_935596C2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eduardo Abinader <eduardo.abinader@riverbed.com> writes:

> just to comply with current ath9k_hw_nvram_read to return value, hence
> behaving reacting accordingly.
>
> Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Please always provide a changelog after the "---" line or in the cover
letter.

> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index 5bd2cba..b7dc08e 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -3252,7 +3252,8 @@ static int ar9300_eeprom_restore_flash(struct ath_hw *ah, u8 *mptr,
>  	int i;
>  
>  	for (i = 0; i < mdata_size / 2; i++, data++)
> -		ath9k_hw_nvram_read(ah, i, data);
> +		if (!ath9k_hw_nvram_read(ah, i, data))
> +			return -1;

Please use proper error codes, like -EIO or some other.

>  	return 0;
>  }
> @@ -3282,7 +3283,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
>  	if (ath9k_hw_use_flash(ah)) {
>  		u8 txrx;
>  
> -		ar9300_eeprom_restore_flash(ah, mptr, mdata_size);
> +		if (ar9300_eeprom_restore_flash(ah, mptr, mdata_size))
> +			return -1;

And here you can just return the error code:

	ret = ar9300_eeprom_restore_flash(ah, mptr, mdata_size);
	if (ret)
		return ret;

-- 
Kalle Valo
