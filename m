Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39612 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaE1Nw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 09:52:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Frederic Danis <frederic.danis@linux.intel.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl@lists.infradead.org>
Subject: Re: [PATCH] ath6kl: Fix ath6kl_bmi_read_hi32 macro
References: <1400249504-23739-1-git-send-email-frederic.danis@linux.intel.com>
Date: Wed, 28 May 2014 16:52:21 +0300
In-Reply-To: <1400249504-23739-1-git-send-email-frederic.danis@linux.intel.com>
	(Frederic Danis's message of "Fri, 16 May 2014 16:11:44 +0200")
Message-ID: <87oayi6mei.fsf@kamboji.qca.qualcomm.com> (sfid-20140528_155231_397970_3ED11714)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frederic Danis <frederic.danis@linux.intel.com> writes:

> tmp may be used uninitialized if ath6kl_bmi_read() returns an error.
>
> Signed-off-by: Frederic Danis <frederic.danis@linux.intel.com>
> ---
>  drivers/net/wireless/ath/ath6kl/bmi.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
> index 18fdd69..397a52f 100644
> --- a/drivers/net/wireless/ath/ath6kl/bmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/bmi.h
> @@ -242,7 +242,8 @@ struct ath6kl_bmi_target_info {
>  		(void) (check_type == val);				\
>  		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
>  		ret = ath6kl_bmi_read(ar, addr, (u8 *) &tmp, 4);	\
> -		*val = le32_to_cpu(tmp);				\
> +		if (!ret)						\
> +			*val = le32_to_cpu(tmp);			\
>  		ret;							\
>  	})

I see new warnings with this patch:

drivers/net/wireless/ath/ath6kl/init.c: In function '__ath6kl_init_hw_start.part.5':
drivers/net/wireless/ath/ath6kl/init.c:1196:13: warning: 'board_ext_address' may be used uninitialized in this function [-Wuninitialized]
drivers/net/wireless/ath/ath6kl/init.c:1147:21: note: 'board_ext_address' was declared here
drivers/net/wireless/ath/ath6kl/init.c:1224:6: warning: 'board_address' may be used uninitialized in this function [-Wuninitialized]
drivers/net/wireless/ath/ath6kl/init.c:1147:6: note: 'board_address' was declared here

-- 
Kalle Valo
