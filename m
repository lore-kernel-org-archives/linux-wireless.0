Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:43276 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbbCKU3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 16:29:07 -0400
Received: by labge10 with SMTP id ge10so10996994lab.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 13:29:06 -0700 (PDT)
Message-ID: <5500A58F.3040904@cogentembedded.com> (sfid-20150311_212931_259395_EC9791C9)
Date: Wed, 11 Mar 2015 23:29:03 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Nicholas Mc Guire <hofrat@osadl.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: Valdis.Kletnieks@vt.edu, Bj??rn Mork <bjorn@mork.no>,
	Jeff Haran <Jeff.Haran@citrix.com>,
	Pat Erley <pat-lkml@erley.org>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] ath10k: move code from parameter list into a function
References: <1426100519-20636-1-git-send-email-hofrat@osadl.org>
In-Reply-To: <1426100519-20636-1-git-send-email-hofrat@osadl.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 03/11/2015 10:01 PM, Nicholas Mc Guire wrote:

> Putting code into the parameter list of wait_event_timeout() might be
> legal C-code but not really readable - the "inline" code is simply
> moved into a function and that passed to wait_event_timeout() as the
> condition. As wait_event_timeout will always return >= 0 the following
> timeout check is fixed up to  ret == 0 .

> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
[...]

> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index e8cc19f..a7a12cc 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4463,11 +4463,25 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
>   	return ret;
>   }
>
> +static bool check_htt_state(struct ath10k *ar, bool *skip)
> +{
> +	bool empty;
> +
> +	spin_lock_bh(&ar->htt.tx_lock);
> +	empty = (ar->htt.num_pending_tx == 0);
> +	spin_unlock_bh(&ar->htt.tx_lock);
> +
> +	*skip = (ar->state == ATH10K_STATE_WEDGED) ||
> +		test_bit(ATH10K_FLAG_CRASH_FLUSH,
> +			 &ar->dev_flags);
> +	return (empty || *skip);

    Parens not needed here.

[...]

WBR, Sergei

