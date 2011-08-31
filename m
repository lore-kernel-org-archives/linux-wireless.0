Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23966 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1HaLFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:05:37 -0400
Message-ID: <4E5E157A.3070704@qca.qualcomm.com> (sfid-20110831_130554_714329_D8A36BF9)
Date: Wed, 31 Aug 2011 14:05:30 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: cleanup diagnose window read and write	functions
References: <20110830134432.21543.89808.stgit@localhost6.localdomain6> <20110830134450.21543.40524.stgit@localhost6.localdomain6> <20110830150006.GA32378@vasanth-laptop>
In-Reply-To: <20110830150006.GA32378@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2011 06:00 PM, Vasanthakumar Thiagarajan wrote:
> On Tue, Aug 30, 2011 at 04:44:50PM +0300, Kalle Valo wrote:
>
>> +int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length)
>> +{
>> +	u32 count, *buf = data;
>> +	int ret;
>> +
>> +	if (WARN_ON(length % 4))
>> +		return -EINVAL;
>> +
>> +	for (count = 0; count < length / 4; count++, address += 4) {
>> +		ret = ath6kl_diag_write32(ar, address, buf[count]);
>> +		if (ret)
>> +			return ret;
>>  	}
>>  
>> -	return status;
>> +	return ret;
> 
> drivers/net/wireless/ath/ath6kl/main.c: In function ‘ath6kl_diag_write’:
> drivers/net/wireless/ath/ath6kl/main.c:297: warning: ‘ret’ may be
> used uninitialized in this function

Strange, my compiler didn't warn about this. Fixed in v2.

Thanks,
Kalle
