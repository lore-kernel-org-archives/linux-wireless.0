Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36028 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753933AbcKUM6j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 07:58:39 -0500
Received: by mail-pf0-f170.google.com with SMTP id 189so64656284pfz.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 04:58:39 -0800 (PST)
Subject: Re: [PATCH] nl80211: fix logic inversion in start_nan()
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20161121125548.4730-1-johannes@sipsolutions.net>
 <576a08f1-3246-4e59-57a1-704e429674bd@broadcom.com>
Cc: Johannes Berg <johannes.berg@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3abd1827-62aa-b274-ace1-859a9a225127@broadcom.com> (sfid-20161121_135843_330854_500354E4)
Date: Mon, 21 Nov 2016 13:58:35 +0100
MIME-Version: 1.0
In-Reply-To: <576a08f1-3246-4e59-57a1-704e429674bd@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-11-2016 13:57, Arend Van Spriel wrote:
> On 21-11-2016 13:55, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> Arend inadvertedly inverted the logic while converting to
>> wdev_running(), fix that.
> 
> It was indeed inadvertedly.

Actually spelling checker complains. Should be 'inadvertently'.

Regards,
Arend

> Thanks,
> Arend
> 
>> Fixes: 73c7da3dae1e ("cfg80211: add generic helper to check interface is running")
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>>  net/wireless/nl80211.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 4e9bda49e957..e4f718e956d7 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -10625,7 +10625,7 @@ static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
>>  	if (wdev->iftype != NL80211_IFTYPE_NAN)
>>  		return -EOPNOTSUPP;
>>  
>> -	if (!wdev_running(wdev))
>> +	if (wdev_running(wdev))
>>  		return -EEXIST;
>>  
>>  	if (rfkill_blocked(rdev->rfkill))
>>
