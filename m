Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:34631 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdC1OOj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 10:14:39 -0400
Received: by mail-wr0-f179.google.com with SMTP id l43so106995409wre.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 07:13:38 -0700 (PDT)
Subject: Re: [PATCH for-4.11 2/2] cfg80211: check rdev resume callback only
 for registered wiphy
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
 <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com>
 <1490704473.18052.1.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0ad46312-df78-4d80-8526-1a33e1e86acf@broadcom.com> (sfid-20170328_161846_917187_8CEB7220)
Date: Tue, 28 Mar 2017 16:13:11 +0200
MIME-Version: 1.0
In-Reply-To: <1490704473.18052.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-3-2017 14:34, Johannes Berg wrote:
>> Changing the checks in
>> wiphy_resume() to only access the struct
>> cfg80211_registered_device::ops
>> when the wiphy instance is registered.
> 
> [...]
> 
>> +++ b/net/wireless/sysfs.c
>> @@ -132,12 +132,10 @@ static int wiphy_resume(struct device *dev)
>>  	/* Age scan results with time spent in suspend */
>>  	cfg80211_bss_age(rdev, get_seconds() - rdev->suspend_at);
>>  
>> -	if (rdev->ops->resume) {
>> -		rtnl_lock();
>> -		if (rdev->wiphy.registered)
>> -			ret = rdev_resume(rdev);
>> -		rtnl_unlock();
>> -	}
>> +	rtnl_lock();
>> +	if (rdev->wiphy.registered && rdev->ops->resume)
>> +		ret = rdev_resume(rdev);
>> +	rtnl_unlock();
> 
> Hmm? Commit message seems ... old perhaps?

Hmmm, why? Before the patch rdev->ops was accessed before checking
rdev->wiphy.registered. When rdev->wiphy.registers is false we no longer
access rdev->ops after the patch. So a driver doing a wiphy_unregister()
can safely kfree() the callback struct after it.

Regards,
Arend
