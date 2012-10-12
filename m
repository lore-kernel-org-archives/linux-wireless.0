Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47953 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab2JLRwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 13:52:47 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so5162518iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 10:52:47 -0700 (PDT)
Message-ID: <507858EB.10403@lwfinger.net> (sfid-20121012_195251_829741_58A43F55)
Date: Fri, 12 Oct 2012 12:52:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH NEXT 2/2] rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192se:
 rtl8192de: Shorten some variable names
References: <1350057128-16969-1-git-send-email-Larry.Finger@lwfinger.net>  <1350057128-16969-3-git-send-email-Larry.Finger@lwfinger.net> <1350060043.2243.28.camel@joe-AO722>
In-Reply-To: <1350060043.2243.28.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2012 11:40 AM, Joe Perches wrote:
> On Fri, 2012-10-12 at 10:52 -0500, Larry Finger wrote:
>> The private data areas for these drivers contain some very long variable
>> names that cause difficulty in fitting source lines to an 80-character
>> limit.
>
> []
>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> []
>> @@ -177,8 +177,8 @@ static void rtl92c_dm_diginit(struct ieee80211_hw *hw)
>>   	dm_digtable->rx_gain_range_max = DM_DIG_MAX;
>>   	dm_digtable->rx_gain_range_min = DM_DIG_MIN;
>>   	dm_digtable->backoff_val = DM_DIG_BACKOFF_DEFAULT;
>> -	dm_digtable->backoff_val_range_max = DM_DIG_BACKOFF_MAX;
>> -	dm_digtable->backoff_val_range_min = DM_DIG_BACKOFF_MIN;
>> +	dm_digtable->back_range_max = DM_DIG_BACKOFF_MAX;
>> +	dm_digtable->back_range_min = DM_DIG_BACKOFF_MIN;
>
> Hi Larry, good idea but it looks like maybe you grepped
> for long variable names with something like "\w{20,}".
>
> Please try to convert all the similarly grouped names at
> the same time.
>
> iow: backoff_val should probably be changed too.
>
> I didn't read any further.  cheers, Joe

Actually, I changed the ones that caused problems for line wrapping in the 
drivers, rather than searching for a particular length.

I will make the change.

Larry


