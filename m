Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55243 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbaCKRK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 13:10:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: check otp.bin result
References: <20140311153318.7148.47415.stgit@potku.adurom.net>
	<20140311153328.7148.50188.stgit@potku.adurom.net>
Date: Tue, 11 Mar 2014 19:10:54 +0200
In-Reply-To: <20140311153328.7148.50188.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 11 Mar 2014 17:33:28 +0200")
Message-ID: <877g80hd9d.fsf@kamboji.qca.qualcomm.com> (sfid-20140311_181110_351315_528D9C48)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> When we execute otp.bin in the target check that the result it returns doesn't
> contain an error. This is to make sure that we don't accidentally use invalid
> calibration data.
>
> While at it, remove the useless label in the function and add few debug messages.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 602fb9644cbf..e8f419144db6 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -254,23 +254,34 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
>  
>  	/* OTP is optional */
>  
> -	if (!ar->otp_data || !ar->otp_len)
> +	if (!ar->otp_data || !ar->otp_len) {
> +		ath10k_warn("Not running otp, calibration will be incorrect!\n");
>  		return 0;
> +	}
> +
> +	ath10k_dbg(ATH10K_DBG_BOOT, "boot upload otp to 0x%x len %d\n",
> +		   address, ar->otp_len);

This one introduces a warning:

>> drivers/net/wireless/ath/ath10k/core.c:263:6: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
         address, ar->otp_len);

I fixed it to this:

	ath10k_dbg(ATH10K_DBG_BOOT, "boot upload otp to 0x%x len %zd\n",
		   address, ar->otp_len);

-- 
Kalle Valo
