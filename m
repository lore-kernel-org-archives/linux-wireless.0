Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35014 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbDCVi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2015 17:38:57 -0400
Message-ID: <551F0871.3060906@candelatech.com> (sfid-20150403_233900_985639_F620AA09)
Date: Fri, 03 Apr 2015 14:38:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] mac80211-hwsim: remove dmesg spam about get-survey.
References: <1428095590-600-1-git-send-email-greearb@candelatech.com>  <1428095590-600-2-git-send-email-greearb@candelatech.com> <1428096542.29510.11.camel@perches.com>
In-Reply-To: <1428096542.29510.11.camel@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2015 02:29 PM, Joe Perches wrote:
> On Fri, 2015-04-03 at 14:13 -0700, greearb@candelatech.com wrote:
>> This message just fills up dmesg and/or kernel logs and does
>> not provide any useful information.
> []
>> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> []
>> @@ -1696,7 +1696,7 @@ static int mac80211_hwsim_get_survey(
>>  {
>>  	struct ieee80211_conf *conf = &hw->conf;
>>  
>> -	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
>> +	/* wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx); */
> 
> It's better, if it's really useless, to delete this
> than comment it out.
> 
> But it's not on by default anyway, so why it an issue?

It's on on my systems...rest of the wiphy debug is normally useful,
but this particular one is not and spams the logs.

I don't mind removing it entirely, but thought maybe someone would
want an easy way to enable it again for some reason.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

