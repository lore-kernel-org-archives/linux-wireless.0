Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52592 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbbCCR7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 12:59:21 -0500
Message-ID: <54F5F678.7030202@candelatech.com> (sfid-20150303_185934_405351_8E45E6D8)
Date: Tue, 03 Mar 2015 09:59:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: increase station kickout threshold
References: <1425385230-25308-1-git-send-email-rmanohar@qti.qualcomm.com> <1425385230-25308-2-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1425385230-25308-2-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/03/2015 04:20 AM, Rajkumar Manoharan wrote:
> Since the station kickout threshold is also counting software
> reries (Default sw count in firmware is 16), increasing the threshold
> to try with already 20 data frames before kicking out the station.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/core.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 7cba781..5a0b7cb 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -50,8 +50,8 @@
>
>   #define ATH10K_MAX_NUM_MGMT_PENDING 128
>
> -/* number of failed packets */
> -#define ATH10K_KICKOUT_THRESHOLD 50
> +/* number of failed packets (includes sw reties) */
> +#define ATH10K_KICKOUT_THRESHOLD (20 * 16)

Maybe add comment about '20 packets with 16 retries each', so that users know what
number is what?

Thanks,
Ben

>
>   /*
>    * Use insanely high numbers to make sure that the firmware implementation
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

