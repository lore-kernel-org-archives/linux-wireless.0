Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:47635 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab0JHLAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 07:00:38 -0400
Message-ID: <4CAEF760.5040204@gmx.com>
Date: Fri, 8 Oct 2010 12:50:08 +0200
From: Bjoern Czybik <wlfw@gmx.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	<linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: Re: Vendor specific data within a beacon frame
References: <4CAD9368.70608@gmx.com>	 <AANLkTimTLEShJ3HcBqHaU5U5nFq1UywczC=G7oiHx=as@mail.gmail.com>	 <1286475342.20974.23.camel@jlt3.sipsolutions.net>	 <AANLkTimzwhBCVKFnx1vhM4A939_kgixEpw5RLTe8JJb0@mail.gmail.com> <1286476522.20974.27.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286476522.20974.27.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I'm sorry I didn't epress myself well.

There is the struct 80211_gmt in the ieee80211_mgmt module in the 
ieeee80211_defs.h, but there is no field for vendor specific data (of 
course it will be set by the hostapd).

 From the hostapd the function ieee802_11_set_beacon(...) calls the 
wpa_driver_nl80211_set_beacon function in driver_nl80211.c (we are using 
the hostapd-0.7.3).
In wpa_driver_nl80211_set_beacon fct. the macro NLA_PUT and NLA_PUT_32 
is used to set the header and tail of a mgmt frame.

If I am right, I have to use the attribute NL80211_ATTR_IE to set 
information elements data with %NL80211_CMD_SET_MGMT_EXTRA_IE (in 
nl80211.h). But in the enum nl80211_commands is written:
     NL80211_CMD_SET_MGMT_EXTRA_IE /* reserved; not used */,

Does somebody knows how to fix it?

Björn

On 07.10.2010 20:35, Johannes Berg wrote:
> On Thu, 2010-10-07 at 11:31 -0700, Luis R. Rodriguez wrote:
>    
>> On Thu, Oct 7, 2010 at 11:15 AM, Johannes Berg
>> <johannes@sipsolutions.net>  wrote:
>>      
>>> On Thu, 2010-10-07 at 11:11 -0700, Luis R. Rodriguez wrote:
>>>
>>> Let me quote what you wrote, but just partially:
>>>
>>>        
>>>> This can be done from userspace. This is from nl80211.h:
>>>>          
>>>        
>>>>   *      Note: This command has been removed and it is only reserved at this
>>>>   *      point to avoid re-using existing command number. The functionality this
>>>>   *      command was planned for has been provided with cleaner design with the
>>>>   *      option to specify additional IEs in NL80211_CMD_TRIGGER_SCAN,
>>>>   *      NL80211_CMD_AUTHENTICATE, NL80211_CMD_ASSOCIATE,
>>>>   *      NL80211_CMD_DEAUTHENTICATE, and NL80211_CMD_DISASSOCIATE.
>>>>          
>>> :P
>>>        
>> Yeah just noticed *after* I pasted it and sent it. Does hostapd use
>> this currently?
>>      
> No, hostapd transmits frames via injection and the data it puts into the
> beacon is conveyed with the beacon cmd -- it has never used this
> command.
>
> Really, what the OP is looking for is the annotated hostapd
> configuration file or the hostapd source code -- he should be able to
> figure that out for himself.
>
> johannes
>    

