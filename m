Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8420 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2CGLzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 06:55:51 -0500
Message-ID: <4F574CC1.5060901@qca.qualcomm.com> (sfid-20120307_125555_261359_D83DCF12)
Date: Wed, 7 Mar 2012 17:25:45 +0530
From: bkamatch <bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] cfg80211: Add background scan period attribute.
References: <1330583965-8415-1-git-send-email-bkamatch@qca.qualcomm.com>	 (sfid-20120301_073937_156683_BFB54260) <1330611829.3623.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330611829.3623.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2012 07:53 PM, Johannes Berg wrote:
> On Thu, 2012-03-01 at 12:09 +0530, Bala Shanmugam wrote:
>> Receive background scan period as part of connect
>> command and pass the same to driver.
>>
>> Signed-off-by: Bala Shanmugam<bkamatch@qca.qualcomm.com>
>> ---
>>   include/linux/nl80211.h |    9 +++++++++
>>   include/net/cfg80211.h  |    3 +++
>>   net/wireless/nl80211.c  |    7 +++++++
>>   net/wireless/wext-sme.c |    3 +++
>>   4 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> index be35a68..e81d327 100644
>> --- a/include/linux/nl80211.h
>> +++ b/include/linux/nl80211.h
>> @@ -369,6 +369,10 @@
>>    *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
>>    *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
>>    *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
>> + *	Background scan period can optionally be
>> + *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
>> + *	if not specified default background scan configuration
>> + *	in driver is used and if period value is 0, bg scan will be disabled.
> Maybe this should also indicate that the value is ignored unless the
> device advertises roaming support with NL80211_ATTR_ROAM_SUPPORT?
>
> I'm not sure I like the whole default value thing since it's kinda
> magic, but I guess I can live with it.
>
> johannes
>

Thats true.  Thanks for pointing it.

Regards,
Bala.
