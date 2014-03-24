Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57363 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaCXLZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 07:25:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k:  add otp and firmware boot error messages.
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
	<1395428150-31996-3-git-send-email-greearb@candelatech.com>
Date: Mon, 24 Mar 2014 13:25:09 +0200
In-Reply-To: <1395428150-31996-3-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Fri, 21 Mar 2014 11:55:50
	-0700")
Message-ID: <87siq76dpm.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_122519_611279_4363C5D3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> If OTP or firmware fails to load properly, print out some
> extra info in the kernel logs.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> @@ -597,12 +598,16 @@ static int ath10k_init_download_firmware(struct ath10k *ar)
>  		return ret;
>  
>  	ret = ath10k_download_and_run_otp(ar);
> -	if (ret)
> +	if (ret) {
> +		ath10k_err("boot otp execute result %d\n", ret);
>  		return ret;
> +	}

"failed to run otp: %d\n"

>  	ret = ath10k_download_fw(ar);
> -	if (ret)
> +	if (ret) {
> +		ath10k_err("boot download firmware result %d\n", ret);
>  		return ret;
> +	}

"failed to download firmware: %d\n"

And I think you should add the same for ath10k_download_board_data()
call before these two, it neither prints anything when an error happens.

-- 
Kalle Valo
