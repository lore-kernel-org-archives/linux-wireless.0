Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-5.exch022.serverdata.net ([64.78.56.50]:38865 "EHLO
	HUB022-ca-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763309Ab3DDG1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 02:27:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Date: Thu, 4 Apr 2013 11:57:07 +0530
From: <vivekanandah@posedge.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, <nbd@openwrt.org>
Subject: RFC: SMPS for AP mode
In-Reply-To: <1364978764.8351.6.camel@jlt4.sipsolutions.net>
References: <fbef7a2278fe739a398430949087c950@posedge.com>
 (sfid-20130403_093709_189406_740B7438)
 <1364976319.8351.2.camel@jlt4.sipsolutions.net>
 <7a1a483e9382db42e8f648c3933bc2cd@posedge.com>
 <1364978764.8351.6.camel@jlt4.sipsolutions.net>
Message-ID: <021a065e3ab402466e8049b2f4cd3fdd@posedge.com> (sfid-20130404_082715_519434_D816AE8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

based on the discussion, i have come out with an RFC for SMPS support 
for AP in minstrel_ht. kindly see the explanation below and indicate to 
me, if this okay or any changes are required?

RFC To send out RTS for AP connected to a dynamic SMPS station

This code change addresses the AP requirement of sending out a
RTS frame when dynamic SMPS is enabled at the station

the minstrel_ht rate module needs to provide the lower driver layer
an indication of enabling RTS frame transmission for an AP connected
to a dynamic SMPS station.

the SMPS state of the station is stored in the ieee80211_sta 
structure's ht_cap variable.

the minstrel_ht_get_rate function can be modified to check if the 
station is a dynamic SMPS
station and a new flag can be incorporated for the ieee80211_tx_info 
flags (e.g. IEEE80211_TX_CTL_SMPS_SET_RTS)
that indicates to the lower layer that the station is a dynamic SMPS 
enabled station.

the lower AP driver can then enable RTS before the first frame 
transmission to the station by checking for the above flag.

thanks and regards
Vivek




On Wed, 03 Apr 2013 10:46:04 +0200, Johannes Berg wrote:
>> i see that the rate_control_rate_update is called with the
>> IEEE80211_RC_SMPS_CHANGED flag. however, i see that the minstrel_ht 
>> code
>> does not check for SMPS with respect to RTS.
>
> It's very well possible that minstrel doesn't implement this 
> correctly.
> I don't care all that much right now about minstrel, so it's up to 
> those
> who do :)
>
>> Also, the code - rate_control_rate_update calls - sta_rc_update
>> mac80211 op. i was first thinking that i could use this for the AP 
>> side
>> notification to driver layer. however, a comment for sta_rc_update
>> indicates that it is to be used only when 
>> IEEE80211_HW_HAS_RATE_CONTROL
>> is true.
>> this led to the confusion.
>>
>> Can this op be used to update the driver about change in station's 
>> SMPS
>> mode for AP ?
>
> Well, in theory it could be, but it doesn't make sense. If you have a
> rate control algorithm in software (like minstrel) then that should
> likely configure the RTS, and rate control is updated via the rate
> control rate_update() callback instead of via the driver.
>
> johannes
