Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54833 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1HVN4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 09:56:18 -0400
Message-ID: <4E525FF7.6070904@qca.qualcomm.com> (sfid-20110822_155625_902340_F0E7399E)
Date: Mon, 22 Aug 2011 19:26:07 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<rodrigue@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>,
	<rmanohar@qca.qualcomm.com>, <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ath9k_htc: Fix few possible memory leaks
References: <1313942085-6238-1-git-send-email-mohammed@qca.qualcomm.com> <20110822052918.GA30951@vasanth-laptop>
In-Reply-To: <20110822052918.GA30951@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 August 2011 10:59 AM, Vasanthakumar Thiagarajan wrote:
> On Sun, Aug 21, 2011 at 09:24:45PM +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> still there are few other memory leaks which will be fixed
>> very soon
>>
>> Cc: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> ---
>>   drivers/net/wireless/ath/ath9k/htc_hst.c |   13 ++++++++-----
>>   drivers/net/wireless/ath/ath9k/wmi.c     |    3 ++-
>>   2 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
>> index 1b90ed8..e435c9b 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
>> @@ -169,13 +169,14 @@ static int htc_config_pipe_credits(struct htc_target *target)
>>   	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
>>   	if (!time_left) {
>>   		dev_err(target->dev, "HTC credit config timeout\n");
>> -		return -ETIMEDOUT;
>> +		ret = -ETIMEDOUT;
>> +		goto err;
>
> Are you sure we have to free the skb upon timeout?. It looks like
> it is already taken care in ath9k_htc_txcompletion_cb(). The same
> may apply to your other changes as well.


Vasanth thanks for your review, I haven't and not aware of that code 
flow/callback. I will check into that.

thanks,
shafi

>
> Vasanth

