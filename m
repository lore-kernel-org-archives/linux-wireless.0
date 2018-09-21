Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36597 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391251AbeIVCAk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 22:00:40 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1-v6so6528748pgo.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 13:10:13 -0700 (PDT)
Date: Fri, 21 Sep 2018 13:10:09 -0700
From: Brian Norris <briannorris@chromium.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: download firmware via diag Copy Engine for
 QCA6174 and QCA9377.
Message-ID: <20180921201008.GA233689@ban.mtv.corp.google.com> (sfid-20180921_221018_850082_4C1C96C0)
References: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
 <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I see this patch is already merged, but some small comments. Might be
worth a follow-up patch eventually.

On Thu, Aug 30, 2018 at 10:29:42AM +0800, Carl Huang wrote:
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index c40cd12..78a0515 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c

...

> @@ -1135,14 +1149,24 @@ static int ath10k_download_fw(struct ath10k *ar)
>  		   "boot uploading firmware image %pK len %d\n",
>  		   data, data_len);
>  
> -	ret = ath10k_bmi_fast_download(ar, address, data, data_len);
> -	if (ret) {
> -		ath10k_err(ar, "failed to download firmware: %d\n",
> -			   ret);
> -		return ret;
> +	/* Check if device supports to download firmware via
> +	 * diag copy engine. Downloading firmware via diag CE
> +	 * greatly reduces the time to download firmware.
> +	 */
> +	if (ar->hw_params.fw_diag_ce_download) {
> +		ret = ath10k_hw_diag_fast_download(ar, address,
> +						   data, data_len);
> +		if (ret == 0)
> +			/* firmware upload via diag ce was successful */
> +			return 0;
> +
> +		ath10k_warn(ar,
> +			    "failed to upload firmware via diag ce, trying BMI: %d",

I believe ath10k_*() logging is still supposed to have '\n' newlines at
the end. But then, the omission occurs all over the place, and it seems
printk() still tends to give you newlines anyway. Seems like we should
still be consistent though.

> +			    ret);
>  	}
>  
> -	return ret;
> +	return ath10k_bmi_fast_download(ar, address,
> +					data, data_len);

You no longer have an error message for BMI failures here (you used to).

>  }
>  
>  static void ath10k_core_free_board_files(struct ath10k *ar)

Brian
