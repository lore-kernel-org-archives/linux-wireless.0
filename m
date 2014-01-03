Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54323 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaACVak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 16:30:40 -0500
Message-ID: <639efbd4cc1a2cf8a93953dc037ed52e.squirrel@www.codeaurora.org> (sfid-20140103_223049_651887_33A57F02)
Date: Fri, 3 Jan 2014 21:30:39 -0000
Subject: Re: [PATCH 1/2 V3] nl80211/cfg80211: Add support for drivers with AP
 SME that require PMF SA Query assistance
From: clanctot@codeaurora.org
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Chet Lanctot" <clanctot@codeaurora.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Thanks for your comments regarding these changes.  See my responses below.

-	Chet

> On Tue, 2013-12-10 at 14:11 -0800, Chet Lanctot wrote:
>> This adds support for drivers that have AP SME integrated but do not
implement the SA Query procedure that is part of Protected
>> Management Frames (PMF, 802.11w).
>> Instead, hostapd can be used to assist drivers that lack SA Query
Procedure handling on their own by allowing them to specify this as a
device capability flag.
>> Also, a station flag is added to let hostapd indicate to the driver
that the SA Query procedure is complete and the driver can process
association requests from the station normally.
> How will this work? If the device is processing the auth/assoc request
frames, then how can hostapd know this? Is the device expected to then
pass up the frame?
Yes, the device will detect the case of an unprotected Assoc Request from
a station where there is already a PMF connection and, in this case, will
pass up the frame to hostapd.  hostapd already has code to handle this
case and will initiate the SA Query procedure.  This has been tested and
it works correctly.

The station flag is added for hostapd to signal back to the device that SA
Query has timed out (completed) and that the device should process Assoc
Request frames from that station normally.

> Also, which (upstream) driver is going to use this?
These changes are of general utility for any device that implements AP SME
and will also implement PMF.  We will be up-steaming a driver that will
use these extensions in the future.

>> + * @NL80211_ATTR_AP_SME_NO_SA_QUERY: The driver for this device +
*	implments the AP SME but lacks support for doing the MFP SA
> typo: implements
I will fix this typo.

>> + *	Query procedure.  This flag is used to express the need for + *	a
userspace helper (hostapd) to do this procedure and notifiy
> typo: notify
I will fix this typo.

>> + *	the driver through cfg80211 when it is complete.
> Should probably say how the driver is notified (via the station flag)?
I will clarify this comment.

>> @@ -3689,7 +3689,7 @@ int cfg80211_check_station_change(struct wiphy
*wiphy,
>>  		return -EINVAL;
>>  	/* When you run into this, adjust the code below for the new flag */
>> -	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
>> +	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
>>  	switch (statype) {
>>  	case CFG80211_STA_MESH_PEER_KERNEL:
>> @@ -3766,7 +3766,8 @@ int cfg80211_check_station_change(struct wiphy
*wiphy,
>>  				  BIT(NL80211_STA_FLAG_ASSOCIATED) |
>>  				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
>>  				  BIT(NL80211_STA_FLAG_WME) |
>> -				  BIT(NL80211_STA_FLAG_MFP)))
>> +				  BIT(NL80211_STA_FLAG_MFP) |
>> +				  BIT(NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED)))
>>  			return -EINVAL;
>>  		/* but authenticated/associated only if driver handles it */
> Maybe we should also check if the driver supports the flag?
For existing PMF (MFP) code, there is no check for driver support of PMF.
wpa_supplicant and hostapd just pass PMF information to the driver.  The
driver just ignores the information if it does not support PMF.

>> @@ -4090,7 +4091,7 @@ static int nl80211_new_station(struct sk_buff
*skb, struct genl_info *info)
>>  		return -EINVAL;
>>  	/* When you run into this, adjust the code below for the new flag */
>> -	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 7);
>> +	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
>>  	switch (dev->ieee80211_ptr->iftype) {
>>  	case NL80211_IFTYPE_AP:
> Can this really be right? Is it simply invalid on a new station? Why
does this even make sense - this is done for AP SME where this is never
invoked?
> Anyway you need to reject adding TDLS peers with this flag, for example,
afaict.
The idea here was that this new flag is used to signal a state transition
for stations for which the SA Query procedure has already started.  So,
yes, it is invalid for a “new station” operation.

But when the driver detects that an SA Query procedure is needed for an
associated station, it passes the Association Request up to hostapd and
remembers that the SA Query is in progress for that station.

This new flag allows hostapd to signal to the driver that SA Query has
completed and the driver can clear the state for that station indicating
that SA Query is in progress.  So this flag is only used in the “station
change” operation.

Perhaps there is a cleaner way to do this?  What we are trying to
accomplish is to allow hostapd to signal to the driver that SA Query has
completed and do this using an already existing nl80211/cfg80211 interface
(and just adding a new flag).

> johannes




