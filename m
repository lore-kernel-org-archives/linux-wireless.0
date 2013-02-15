Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55206 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3BOL0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 06:26:55 -0500
Message-ID: <511E1B7A.60505@qca.qualcomm.com> (sfid-20130215_122659_397961_4903B079)
Date: Fri, 15 Feb 2013 16:56:50 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>
Subject: Re: [PATCH 5/6] ath6kl: Fix a debugfs crash for USB devices
References: <1360834689-11187-1-git-send-email-mohammed@qca.qualcomm.com> <871uchamyh.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871uchamyh.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 02/15/2013 04:00 PM, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:
>
>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>
>> Credit distribution stats is currently implemented
>> only for SDIO. This fixes a crash in debugfs for
>> USB interface.
>>
>> BUG: unable to handle kernel NULL pointer dereference at   (null)
>> IP: [<f91c2048>] read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
>> *pde = b62bd067
>> Oops: 0000 [#1] SMP
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath6kl/debug.c
>> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
>> @@ -658,6 +658,9 @@ static ssize_t read_file_credit_dist_stats(struct file *file,
>>   	unsigned int buf_len, len = 0;
>>   	ssize_t ret_cnt;
>>
>> +	if (ar->hif_type != ATH6KL_HIF_TYPE_SDIO)
>> +		return -EINVAL;
>
> Actually I think it would be better not to even create the debugfs when
> using sdio.

agreed, but looks bit ugly right ? thoughts.

>


-- 
thanks,
shafi
