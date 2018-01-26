Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:50513 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752095AbeAZOYY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 09:24:24 -0500
Subject: Re: [PATCH] ath9k: Fix get channel default noise floor
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
References: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <6666e006-614b-bb26-2e28-260f3af0d512@dd-wrt.com> (sfid-20180126_152440_287830_24C28E0F)
Date: Fri, 26 Jan 2018 15:24:21 +0100
MIME-Version: 1.0
In-Reply-To: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

let me check

Am 26.01.2018 um 15:20 schrieb Wojciech Dubowik:
> Commit 8da58553cc63 ("ath9k: Use calibrated noise floor value
> when available") introduced regression in ath9k_hw_getchan_noise
> where per chain nominal noise floor has been taken instead default
> for channel.
> Revert to original default channel noise floor.
>
> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> ---
>   drivers/net/wireless/ath/ath9k/calib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
> index 3d9447e..695c779 100644
> --- a/drivers/net/wireless/ath/ath9k/calib.c
> +++ b/drivers/net/wireless/ath/ath9k/calib.c
> @@ -72,7 +72,7 @@ static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
>   s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan,
>   			   s16 nf)
>   {
> -	s8 noise = ath9k_hw_get_default_nf(ah, chan, 0);
> +	s8 noise = ATH_DEFAULT_NOISE_FLOOR;
>   
>   	if (nf) {
>   		s8 delta = nf - ATH9K_NF_CAL_NOISE_THRESH -


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
