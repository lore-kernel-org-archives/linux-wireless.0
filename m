Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33715 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbbJ1Ngc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 09:36:32 -0400
Received: by lbbec13 with SMTP id ec13so5912407lbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 06:36:31 -0700 (PDT)
Subject: Re: [RESEND PATCH 07/10] net: wireless: iwlegacy: Remove unneeded
 variable ret
To: Punit Vara <punitvara@gmail.com>, kvalo@qca.qualcomm.com
References: <1445972565-14963-1-git-send-email-punitvara@gmail.com>
 <1445972565-14963-7-git-send-email-punitvara@gmail.com>
 <5630CF11.8080504@cogentembedded.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <5630CF5E.1030801@cogentembedded.com> (sfid-20151028_143704_329579_6E534042)
Date: Wed, 28 Oct 2015 16:36:30 +0300
MIME-Version: 1.0
In-Reply-To: <5630CF11.8080504@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2015 4:35 PM, Sergei Shtylyov wrote:

>> This patch is to the 3945-mac.c file that fixes up following warning
>> by coccicheck:
>>
>> drivers/net/wireless/iwlegacy/3945-mac.c:247:5-8: Unneeded variable:
>> "ret". Return "- EOPNOTSUPP" on line 249
>>
>> Return -EOPNOTSUPP directly instead of return using ret
>>
>> Signed-off-by: Punit Vara <punitvara@gmail.com>
>> ---
>>   drivers/net/wireless/iwlegacy/3945-mac.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c
>> b/drivers/net/wireless/iwlegacy/3945-mac.c
>> index af1b3e6..ff4dc44 100644
>> --- a/drivers/net/wireless/iwlegacy/3945-mac.c
>> +++ b/drivers/net/wireless/iwlegacy/3945-mac.c
>> @@ -244,9 +244,7 @@ il3945_set_dynamic_key(struct il_priv *il, struct
>> ieee80211_key_conf *keyconf,
>>   static int
>>   il3945_remove_static_key(struct il_priv *il)
>>   {
>> -    int ret = -EOPNOTSUPP;
>> -
>> -    return ret;
>> +    return -EOPNOTSUPP;
>>   }
>>
>>   static int
>> @@ -529,7 +527,6 @@ il3945_tx_skb(struct il_priv *il,
>>           if (unlikely(tid >= MAX_TID_COUNT))
>>               goto drop;
>>       }
>> -
>
>     Unrelated white space change.

    And I've already complained about it! Please remove this hunk.

MBR, Sergei

