Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753437AbcLGR7L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 12:59:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 07 Dec 2016 23:29:08 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to
 support BTCOEX
In-Reply-To: <1480949353.31788.27.camel@sipsolutions.net>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
 <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
 <1480949353.31788.27.camel@sipsolutions.net>
Message-ID: <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org> (sfid-20161207_185927_111454_E99B78D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the comments.

On 2016-12-05 20:19, Johannes Berg wrote:
> On Tue, 2016-11-08 at 18:45 +0530, c_traja@qti.qualcomm.com wrote:
>>  
>> + * struct cfg80211_btcoex_priority - BTCOEX support frame type
>> + *
>> + * This structure defines the driver supporting frame types for
>> BTCOEX
>> + *
>> + * @wlan_be_preferred: best effort frames preferred over bt traffic
>> + * @wlan_bk_preferred: background frames preferred over bt traffic
>> + * @wlan_vi_preferred: video frames preferred over bt traffic
>> + * @wlan_vo_preferred: voice frames preferred over bt traffic
>> + * @wlan_beacon_preferred: beacon preferred over bt traffic
>> + * @wlan_mgmt_preferred: management frames preferred ovet bt traffic
> 
> typo: over
> 
Okay
>>  
>>  /**
>> + * wiphy_btcoex_support_flags
>> + *	This enum has the driver supported frame types for BTCOEX.
>> + * @WIPHY_WLAN_BE_PREFERRED - Supports Best Effort frame for BTCOEX
>> + * @WIPHY_WLAN_BK_PREFERRED - supports Background frame for BTCOEX
>> + * @WIPHY_WLAN_VI_PREFERRED - supports Video frame for BTCOEX
>> + * @WIPHY_WLAN_VO_PREFERRED - supports Voice frame for BTCOEX
>> + * @WIPHY_WLAN_BEACON_PREFERRED - supports Beacon frame for BTCOEX
>> + * @WIPHY_WLAN_MGMT_PREFERRED - supports Management frames for
>> BTCOEX.
>> + */
> 
> That's not making much sense to me?
> 

is it fine to have as WIPHY_BTCOEX_BE_PREFERRED ?

>> +/**
>> + * enum wiphy_btcoex_priority - BTCOEX priority level
>> + *	This enum defines priority level for BTCOEX
>> + * WIPHY_WLAN_PREFERRED_LOW - low priority frames over BT traffic
>> + * WIPHY_WLAN_PREFERRED_HIGH - high priority frames over BT traffic
>> + */
>> +
>> +enum wiphy_btcoex_priority {
>> +	WIPHY_WLAN_PREFERRED_LOW = false,
>> +	WIPHY_WLAN_PREFERRED_HIGH = true,
>> +};
> 
> That false/true seems just strange.
> 

I will just use as a enum without assigning false/true.

>> + * @btcoex_support_flags: This will have the driver supported
>> + *	frame types for BTCOEX. This value filled by using
>> + *	%enum wiphy_btcoex_support_flags while driver
>> + *	initialization.
> 
> The whole "will have" isn't really clear.
> 
>> + * @NL80211_ATTR_SET_BTCOEX_PRIORITY: nested attribute for driver
>> supporting
>> + *	the BTCOEX. When used with
>> %NL80211_CMD_SET_BTCOEX_PRIORITY it contains
>> + *	attributes according &enum nl80211_btcoex_priority to
>> indicate
>> + *	which frame has high priority over BT.
> 
> There should be no "SET" in there.
> 
Okay sure.

>>  /**
>> + * enum nl80211_btcoex_priority - BTCOEX parameter attributes
>> + *	This strcuture has enum values for driver supported wlan
>> + *	frame type for BTCOEX.
>> + * @NL80211_WLAN_BE_PREFERRED - Best Effort frame
>> + * @NL80211_WLAN_BK_PREFERRED - Background frame
>> + * @NL80211_WLAN_VI_PREFERRED - Video frame
>> + * @NL80211_WLAN_VO_PREFERRED - Voice frame
>> + * @NL80211_WLAN_BEACON_PREFERRED - BEACON frame
>> + * @NL80211_WLAN_MGMT_PREFERRED - MGMT frame
>> + */
>> +
>> +enum nl80211_btcoex_priority {
>> +	__NL80211_WLAN_PREFERRED_INVALID,
>> +	NL80211_WLAN_BE_PREFERRED,
>> +	NL80211_WLAN_BK_PREFERRED,
>> +	NL80211_WLAN_VI_PREFERRED,
>> +	NL80211_WLAN_VO_PREFERRED,
>> +	NL80211_WLAN_BEACON_PREFERRED,
>> +	NL80211_WLAN_MGMT_PREFERRED,
>> +	__NL80211_WLAN_PREFERRED_LAST,
>> +	NL80211_WLAN_PREFERRED_MAX =
>> +			__NL80211_WLAN_PREFERRED_LAST - 1,
>> +};
> 
> Wouldn't a bitmap be easier?
> 
since this is to distinguish between different btcoex priorities and we 
are not going to do any manipulations on these parameters.
It is just used as flag attribute.
