Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50234 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab2FBP2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 11:28:11 -0400
Message-ID: <4FCA30DE.4080805@qca.qualcomm.com> (sfid-20120602_172847_470702_F3C986C3)
Date: Sat, 2 Jun 2012 20:57:26 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <stable@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Fix a WARNING in suspend/resume with IBSS
References: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com>		 (sfid-20120601_083956_399882_A3D65832) <1338533070.4884.4.camel@jlt3.sipsolutions.net>	 <4FC86AB4.9020602@qca.qualcomm.com> <1338534832.4884.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338534832.4884.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2012 12:43 PM, Johannes Berg wrote:
> On Fri, 2012-06-01 at 12:39 +0530, Mohammed Shafi Shajakhan wrote:
>> Hi Johannes,
>>
>> On Friday 01 June 2012 12:14 PM, Johannes Berg wrote:
>>> On Fri, 2012-06-01 at 12:09 +0530, Mohammed Shafi Shajakhan wrote:
>>>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>>>
>>>> In ath9k we make sure the following two things
>>>> *if the first interface is ADHOC we cannot have any other interface.
>>>> *we cannot add an ADHOC interface if there is already an interface
>>>> is present.
>>>
>>>> -	if ((ah->opmode == NL80211_IFTYPE_ADHOC) ||
>>>> -	    ((vif->type == NL80211_IFTYPE_ADHOC)&&
>>>> -	     sc->nvifs>   0)) {
>>>> -		ath_err(common, "Cannot create ADHOC interface when other"
>>>> -			" interfaces already exist.\n");
>>>> +	if ((ah->opmode == NL80211_IFTYPE_ADHOC)&&   (sc->nvifs>   0)) {
>>>> +		ath_err(common, "Cannot create any other interface when an ADHOC interface already exists.\n");
>>>> +		ret = -EINVAL;
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	if ((vif->type == NL80211_IFTYPE_ADHOC)&&   (sc->nvifs>   0)) {
>>>> +		ath_err(common, "Cannot create ADHOC interface when other interfaces already exist.\n");
>>>
>>> You could just remove the entire check since the interface combinations
>>> you advertise don't allow it, I think? Or just fix those
>>> combinations :-)
>>
>> i did not check this before, thanks a lot for your inputs. will send a
>> proper v2 after checking this out.
>
> If this is needed for stable, you might want to keep this patch&  send
> another one to remove it.

thanks Johannes.
i was looking at how to fix this properly in iface combination 
advertised to mac80211.  got few doubts regarding this

*if an interface type is not all advertised in the 
ieee80211_iface_combination then it cannot it be co-existing with any 
other interfaces ?
please let me know is there some other way do that.

if we advertise something like this

static const struct ieee80211_iface_limit if_limits[] = {
	{set1
     	.... },
	{set 2
	.... },
};

then interface types in set1 and set2 co-exist as per the logic in 
cfg80211_can_change_interface. is there already a way we can make
set1 and set2 interface types mutually exclusive ? thanks!



-- 
thanks,
shafi
