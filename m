Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61851 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab2IUJeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 05:34:25 -0400
Message-ID: <505C3496.6090709@qca.qualcomm.com> (sfid-20120921_113430_006654_4566B478)
Date: Fri, 21 Sep 2012 15:04:14 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 3/3] ath6kl: Check for valid endpoint ID values in ath6kl_control_tx()
References: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com> <1348122068-24648-3-git-send-email-rmani@qca.qualcomm.com> <505C30E5.6080208@qca.qualcomm.com>
In-Reply-To: <505C30E5.6080208@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 September 2012 02:48 PM, Kalle Valo wrote:
> On 09/20/2012 09:21 AM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> It's safe to check endpoint id values before it get
>> really used. Found this on code review.
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath6kl/txrx.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
>> index e867193..4ea6559 100644
>> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
>> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
>> @@ -294,6 +294,12 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
>>   		return -EACCES;
>>   	}
>>
>> +	if (WARN_ON_ONCE(eid == ENDPOINT_UNUSED ||
>> +	    eid>= ENDPOINT_MAX)) {
>> +		status = -EINVAL;
>> +		goto fail_ctrl_tx;
>> +	}
>
> Indentation for the line starting with eid doesn't look right (or my
> thunderbird is corrupting it again). But I can fix it up when I commit
> the patch. (I assume you will send v2 of this patchset.)

Thanks for the review. I'll submit v2 with your review comments addressed.

>
> Kalle
