Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-2.exch022.serverdata.net ([64.78.56.54]:21454 "EHLO
	HUB022-ca-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762034Ab3DCIgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 04:36:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Date: Wed, 3 Apr 2013 01:36:20 -0700
From: <vivekanandah@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: question on SMPS for AP
In-Reply-To: <1364976319.8351.2.camel@jlt4.sipsolutions.net>
References: <fbef7a2278fe739a398430949087c950@posedge.com>
 (sfid-20130403_093709_189406_740B7438)
 <1364976319.8351.2.camel@jlt4.sipsolutions.net>
Message-ID: <7a1a483e9382db42e8f648c3933bc2cd@posedge.com> (sfid-20130403_103627_128567_CECF6040)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Johannes,

thanks for the response.

for the below statement:

Yes this is implemented, it starts in ieee80211_rx_h_action(),
> WLAN_CATEGORY_HT, WLAN_HT_ACTION_SMPS and ends by calling
> rate_control_rate_update(). The driver or rate control algorithm has 
> to
> take this into account, I'm not certain that all drivers and 
> algorithms
> do this correctly (yet).


i see that the rate_control_rate_update is called with the 
IEEE80211_RC_SMPS_CHANGED flag. however, i see that the minstrel_ht code 
does not check for SMPS with respect to RTS.

Also, the code - rate_control_rate_update calls - sta_rc_update 
mac80211 op. i was first thinking that i could use this for the AP side 
notification to driver layer. however, a comment for sta_rc_update 
indicates that it is to be used only when IEEE80211_HW_HAS_RATE_CONTROL 
is true.
this led to the confusion.

Can this op be used to update the driver about change in station's SMPS 
mode for AP ?

thanks and regards
Vivek


On Wed, 03 Apr 2013 10:05:19 +0200, Johannes Berg wrote:
> Hi Vivek,
>
>> i was looking into the MAC80211 code for Spatial multiplexing Power
>> Save handling.
>>
>> i see that for the station side, the code seems to be handled.
>> is the same true for an AP interface as well? this is my current
>> understanding and i do not see any code handling for AP for SMPS.
>
> Which part? There are two sides to SMPS handling:
>  1) changing our own SMPS mode
>  2) handling stations changing their SMPS mode
>
> 1) is implemented only for station mode, 2) is implemented for both 
> AP
> and station mode (though is less relevant for station mode)
>
>>  From the perspective of an AP, the only thing it needs to do, is to
>> monitor the station for change to dynamic SMPS mode and if the 
>> station
>> is in dynamic SMPS mode, set the RTS flag for the first packet to be
>> sent out to the station so that an RTS/CTS mechanism is employed 
>> before
>> the packet transfer. this will make the station to wake up its 
>> receive
>> chains for the impending packet tranfer.
>>
>> can anyone provide any inputs for the same and direct me to any code
>> that will help in understanding SMPS for AP?
>
> Yes this is implemented, it starts in ieee80211_rx_h_action(),
> WLAN_CATEGORY_HT, WLAN_HT_ACTION_SMPS and ends by calling
> rate_control_rate_update(). The driver or rate control algorithm has 
> to
> take this into account, I'm not certain that all drivers and 
> algorithms
> do this correctly (yet).
>
> johannes
