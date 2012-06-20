Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:63251 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FTPAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 11:00:14 -0400
Message-ID: <4FE1E579.3070307@opentechinstitute.org> (sfid-20120620_170019_370232_CA490681)
Date: Wed, 20 Jun 2012 11:00:09 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/3] mac80211: Track auth frame registrations on IBSS
 ifaces
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>   <88045ffa83c9b4defb7b5eca98bc389ed6c2c5c1.1340142553.git.hawkinsw@opentechinstitute.org>  <1340170374.4655.1.camel@jlt3.sipsolutions.net>  <4FE1E0DA.8010406@opentechinstitute.org> <1340203389.4655.71.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340203389.4655.71.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/20/2012 10:43 AM, Johannes Berg wrote:
> On Wed, 2012-06-20 at 10:40 -0400, Will Hawkins wrote:
>>
>> On 06/20/2012 01:32 AM, Johannes Berg wrote:
>>> On Tue, 2012-06-19 at 17:59 -0400, Will Hawkins wrote:
>>>> Track userspace registrations for authentication
>>>> frames received on an IBSS interface. This field
>>>> will be used to decide whether or not to send
>>>> "open system" authentication frames when a new
>>>> station joins an adhoc network.
>>>>
>>>> Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
>>>> ---
>>>>  net/mac80211/cfg.c         |   10 ++++++++++
>>>>  net/mac80211/ieee80211_i.h |    1 +
>>>>  2 files changed, 11 insertions(+)
>>>>
>>>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>>>> index 498c94e..e00a696 100644
>>>> --- a/net/mac80211/cfg.c
>>>> +++ b/net/mac80211/cfg.c
>>>> @@ -2486,6 +2486,16 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
>>>>  					  u16 frame_type, bool reg)
>>>>  {
>>>>  	struct ieee80211_local *local = wiphy_priv(wiphy);
>>>> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>>> +
>>>> +	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && 
>>>> +	    (frame_type == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH))) {
>>>> +		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
>>>> +		if (reg)
>>>> +			ifibss->auth_frame_registrations++;
>>>> +		else if (reg > 0)
>>>> +			ifibss->auth_frame_registrations--;
>>>
>>> The "if (reg > 0)" here doesn't seem to make sense?
>>
>> Just trying to make sure that it doesn't go negative. I am protecting
>> against unmatched unregisters.
> 
> reg is a bool, did you mean "if (ifibss->auth_frame_registrations > 0)"?

Yes, of course I did. :-) Not sure how I missed that.

> 
> in any case, you don't really have to care about unmatched unregisters
> as cfg80211 tracks all of them anyway.

I will take that check out entirely and resubmit.

Is it proper protocol to resubmit this particular part of the patch or
the entire set?

Thanks for your eagle eyes!

Will
> 
> johannes
> 
> 
