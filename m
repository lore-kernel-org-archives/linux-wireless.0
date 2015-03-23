Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33778 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbCWQBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 12:01:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: share board file loading code across FW APIs
References: <1427114301-18886-1-git-send-email-michal.kazior@tieto.com>
	<1427114301-18886-2-git-send-email-michal.kazior@tieto.com>
Date: Mon, 23 Mar 2015 18:01:08 +0200
In-Reply-To: <1427114301-18886-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 23 Mar 2015 12:38:20 +0000")
Message-ID: <87lhind7p7.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_170120_805392_DFA54E2C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There's no need to implement the same thing twice.
> Reduce code duplication.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -730,6 +716,12 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
>  	/* calibration file is optional, don't check for any errors */
>  	ath10k_fetch_cal_file(ar);
>  
> +	ret = ath10k_core_fetch_board_file(ar);
> +	if (ret) {
> +		ath10k_err(ar, "failed to fetch board file: %d\n", ret);
> +		return ret;
> +	}
> +
>  	ar->fw_api = 4;
>  	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);

There was a conflict here, please check the resolution in the pending
branch.

-- 
Kalle Valo
