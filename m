Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11296 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbbGAK24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 06:28:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 1/8] ath10k: enhance swba event handler to adapt different size tim bitmap
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
	<1434984747-24294-2-git-send-email-rmani@qti.qualcomm.com>
	<87h9poxjvs.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 1 Jul 2015 13:28:47 +0300
In-Reply-To: <87h9poxjvs.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Wed, 1 Jul 2015 13:16:55 +0300")
Message-ID: <87d20cxjc0.fsf@kamboji.qca.qualcomm.com> (sfid-20150701_122900_598638_29290547)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>>  	/* if next SWBA has no tim_changed the tim_bitmap is garbage.
>>  	 * we must copy the bitmap upon change and reuse it later */
>>  	if (__le32_to_cpu(tim_info->tim_changed)) {
>>  		int i;
>>  
>> -		BUILD_BUG_ON(sizeof(arvif->u.ap.tim_bitmap) !=
>> -			     sizeof(tim_info->tim_bitmap));
>> +		WARN_ON(sizeof(arvif->u.ap.tim_bitmap) < tim_len);
>
> I'm worried that this WARN_ON() spams too much so I changed it to:
>
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2893,7 +2893,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
>         if (__le32_to_cpu(tim_info->tim_changed)) {
>                 int i;
>  
> -               WARN_ON(sizeof(arvif->u.ap.tim_bitmap) < tim_len);
> +               WARN_ON_ONCE(sizeof(arvif->u.ap.tim_bitmap) < tim_len);
>  
>                 for (i = 0; i < tim_len; i++) {
>                         t = tim_info->tim_bitmap[i / 4];

Actually I got more worried about this. If tim_len >
sizeof(arvif->u.ap.tim_bitmap) don't we read out of bounds? So we should
actually add return for that case or am I missing something?

Full code:

		WARN_ON_ONCE(sizeof(arvif->u.ap.tim_bitmap) < tim_len);

		for (i = 0; i < tim_len; i++) {
			t = tim_info->tim_bitmap[i / 4];
			v = __le32_to_cpu(t);
			arvif->u.ap.tim_bitmap[i] = (v >> ((i % 4) * 8)) & 0xFF;
		}

-- 
Kalle Valo
