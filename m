Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22933 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab0I1Jbg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 05:31:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 02:31:28 -0700
Message-ID: <4CA1B5F3.5090801@atheros.com>
Date: Tue, 28 Sep 2010 15:01:31 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: sets basic rate set parameter for IBSS creator
References: <1285662586-31646-1-git-send-email-mshajakhan@atheros.com> <1285664569.3885.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285664569.3885.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tuesday 28 September 2010 02:32 PM, Johannes Berg wrote:
> On Tue, 2010-09-28 at 13:59 +0530, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> This fix sets the basic rate set parameter for IBSS creator when the
>> basic rates are not explicitly specified in the user space.
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> ---
>>   net/mac80211/ibss.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
>> index 1a3aae5..e117155 100644
>> --- a/net/mac80211/ibss.c
>> +++ b/net/mac80211/ibss.c
>> @@ -541,6 +541,9 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
>>   		capability |= WLAN_CAPABILITY_PRIVACY;
>>   	else
>>   		sdata->drop_unencrypted = 0;
>> +	if (ifibss->basic_rates == 0)
>> +		ifibss->basic_rates = ieee80211_mandatory_rates(local,
>> +					local->hw.conf.channel->band);
>>      
> Shouldn't cfg80211 do this?
>
> johannes
>    
Hi Johannes ,

                       Thank you for your suggestion,just found out ,i 
think  its already there to configure basic rates (if the user had not 
expicitly specified the basic rates in user space) in the 
nl80211_join_ibss(nl80211.c) , but the basic rates does not seems to get 
set there.I had checked its status in mac80211 in function 
ieee80211_ibss_join function , its still zero and I thought of calling 
it there itself , but the basic rate was not properly set for 2Ghz, so 
called it here and  I had tested it ,and everything working fine.
Pleas correct me if I am wrong .

with thanks,

shafi

