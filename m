Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:57337 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab2FTJLT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:11:19 -0400
Message-ID: <4FE193B2.6020000@tieto.com> (sfid-20120620_111131_475709_8C2513B0)
Date: Wed, 20 Jun 2012 11:11:14 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFCv2 05/13] cfg80211: introduce cfg80211_get_chan_state
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>  <1340172859-18146-6-git-send-email-michal.kazior@tieto.com> <1340180381.4655.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340180381.4655.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
>> Helper function for finding out which channel is
>> used by a given interface.
>>
>> An exclusive channel can be used only by a single
>> interface. This is mainly for non-fixed channel
>> IBSS handling.
>>
>> Signed-off-by: Michal Kazior<michal.kazior@tieto.com>
>> ---
>>   net/wireless/chan.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   net/wireless/core.h |   12 ++++++++++++
>>   2 files changed, 63 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> index c1999e4..167e7cb 100644
>> --- a/net/wireless/chan.c
>> +++ b/net/wireless/chan.c
>> @@ -92,3 +92,54 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
>>
>>   	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
>>   }
>> +
>> +void
>> +cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
>> +		        struct wireless_dev *wdev,
>> +		        struct ieee80211_channel **chan,
>> +		        enum cfg80211_chan_mode *chanmode)
>
> Why not return the mode rather than void&  pointer?

I think returning the mode would be ambiguous - the function name isn't 
"get_chan_mode". chan_mode isn't a result on its own. But then again, 
it's just a matter of preference.


-- 
Pozdrawiam / Best regards, Michal Kazior.
