Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2683 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbbGAKWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 06:22:16 -0400
Message-ID: <5593BF46.8010108@qti.qualcomm.com> (sfid-20150701_122220_626665_9DA514FC)
Date: Wed, 1 Jul 2015 15:51:58 +0530
From: rmani <rmani@qti.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/8] ath10k: enhance swba event handler to adapt different
 size tim bitmap
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com> <1434984747-24294-2-git-send-email-rmani@qti.qualcomm.com> <87h9poxjvs.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87h9poxjvs.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/01/2015 03:46 PM, Kalle Valo wrote:
> Raja Mani <rmani@qti.qualcomm.com> writes:
>
>> Due to 512 client support in 10.4 firmware, size of tim ie is going
>> to be slightly higher than non 10.4 firmware. So, size of tim_bitmap
>> what is carried in swba event from 10.4 firmware is bit higher.
>>
>> The only bottle neck to reuse existing swba handler
>> ath10k_wmi_event_host_swba() for 10.4 is that code designed to deal
>> with fixed size tim bitmap(ie, tim_info[].tim_bitmap in wmi_swba_ev_arg).
>> This patch removes such size limitation and makes it more suitable
>> to handle swba event which has different size tim bitmap.
>>
>> All existing swba event parsing functions are changed to adapt this
>> change. Actual support to handle 10.4 swba event is added in next patch.
>> Only preparation is made in this patch.
>>
>> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
>
[..]
>> -		BUILD_BUG_ON(sizeof(arvif->u.ap.tim_bitmap) !=
>> -			     sizeof(tim_info->tim_bitmap));
>> +		WARN_ON(sizeof(arvif->u.ap.tim_bitmap) < tim_len);
>
> I'm worried that this WARN_ON() spams too much so I changed it to:
>
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2893,7 +2893,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
>          if (__le32_to_cpu(tim_info->tim_changed)) {
>                  int i;
>
> -               WARN_ON(sizeof(arvif->u.ap.tim_bitmap) < tim_len);
> +               WARN_ON_ONCE(sizeof(arvif->u.ap.tim_bitmap) < tim_len);
>
>                  for (i = 0; i < tim_len; i++) {
>                          t = tim_info->tim_bitmap[i / 4];
>
>

The change looks good to me.

--
Raja


