Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30329 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab1KUQ4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 11:56:39 -0500
Message-ID: <4ECA826F.8010605@qca.qualcomm.com> (sfid-20111121_175654_016453_1FA16D91)
Date: Mon, 21 Nov 2011 18:55:11 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] ath6kl: use a larger buffer for debug output
References: <20111118140906.GA9685@elgon.mountain>	 (sfid-20111118_150942_354029_4789F63D) <1321625461.10266.57.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321625461.10266.57.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2011 04:11 PM, Johannes Berg wrote:
> On Fri, 2011-11-18 at 17:09 +0300, Dan Carpenter wrote:
>> This function makes the static checkers grumble.  The return value of
>> snprintf() is the number of bytes which would have been copied if
>> there was enough space.  In theory, a %u can take take 10 digits so
>> len could be larger than 16 and it would be a small information
>> leak.
>>
>> We may as well make the buffer larger as well since that is very
>> easy to do.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
>> index 9eff0d0..e632008 100644
>> --- a/drivers/net/wireless/ath/ath6kl/debug.c
>> +++ b/drivers/net/wireless/ath/ath6kl/debug.c
>> @@ -1551,11 +1551,12 @@ static ssize_t ath6kl_listen_int_read(struct file *file,
>>  						size_t count, loff_t *ppos)
>>  {
>>  	struct ath6kl *ar = file->private_data;
>> -	char buf[16];
>> +	char buf[32];
>>  	int len;
>>  
>>  	len = snprintf(buf, sizeof(buf), "%u %u\n", ar->listen_intvl_t,
>>  					ar->listen_intvl_b);
>> +	len = min(sizeof(buf), len);
> 
> Maybe that should be scnprintf instead then?

Yeah, I agree. And most likely debug.c has even more cases where
scnprintf() is needed.

Kalle
