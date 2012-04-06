Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13895 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2DFPK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 11:10:58 -0400
Message-ID: <4F7F077C.1060409@qca.qualcomm.com> (sfid-20120406_171102_575955_60AA4236)
Date: Fri, 6 Apr 2012 20:40:52 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Configure htcap in fw based on the channel
 type in AP mode
References: <1333721235-16025-1-git-send-email-vthiagar@qca.qualcomm.com>  <1333721235-16025-2-git-send-email-vthiagar@qca.qualcomm.com> <1333724066.8565.6.camel@joe2Laptop>
In-Reply-To: <1333724066.8565.6.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Friday 06 April 2012 08:24 PM, Joe Perches wrote:
> On Fri, 2012-04-06 at 19:37 +0530, Vasanthakumar Thiagarajan wrote:
>> This patch disables HT in start_ap if the type of the channel on
>> which the AP mode is going to be operating is non-HT. HT is enabled
>> with default ht cap setting if the operating channel is going to be
>> 11n.
> []
>> diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
> []
>> @@ -477,6 +477,12 @@ struct ath6kl_mc_filter {
>>   	char hw_addr[ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE];
>>   };
>>
>> +struct ath6kl_htcap {
>> +	bool ht_enable;
>> +	unsigned short cap_info;
>> +	u8 ampdu_factor;
>> +};
>
> Probably better to rearrange this as:
>
> struct ath6kl_htcap {
> 	unsigned short cap_info;
> 	u8 ampdu_factor;
> 	bool ht_enable;
> };

You are right, there are couple bytes getting padded, i'll address this. 
Thanks for reviewing!

Vasanth
