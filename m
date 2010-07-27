Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46747 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0G0QUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 12:20:19 -0400
Message-ID: <4C4F0731.9080607@candelatech.com>
Date: Tue, 27 Jul 2010 09:20:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k: /proc/net/wireless always shows status of 0
References: <4C4DE6B5.5080307@candelatech.com> <4C4E0580.3060404@candelatech.com> 	<AANLkTi=qJXCxtMZcEm3VQT1s7ioJsdhj2kJzkgGSf3ND@mail.gmail.com> 	<4C4E1784.3030702@candelatech.com> <AANLkTimnZ9pSfVLsEPgiDPyc=_eUnyLj89RHCC6rsaX8@mail.gmail.com> 	<4C4E1C0B.9040608@candelatech.com> <1280213303.19098.3.camel@jlt3.sipsolutions.net> <AANLkTinh7JvGmx0s-A1ZKgGY+2WDPnptqt53=73PRzHD@mail.gmail.com>
In-Reply-To: <AANLkTinh7JvGmx0s-A1ZKgGY+2WDPnptqt53=73PRzHD@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2010 11:54 PM, Luis R. Rodriguez wrote:
> On Mon, Jul 26, 2010 at 11:48 PM, Johannes Berg
> <johannes@sipsolutions.net>  wrote:
>> On Mon, 2010-07-26 at 16:36 -0700, Ben Greear wrote:
>>
>>>> You can use nl28011 and register for netlink multicast messages which
>>>> broadcast device state changes like the ones you mentioned. These come
>>>> in on iw via event.c, see print_event() and see the case statements
>>>> for NL80211_CMD_ASSOCIATE, NL80211_CMD_DEAUTHENTICATE,
>>>> NL80211_CMD_DISASSOCIATE, etc, you even get reason codes parsed for
>>>> you too.
>>>
>>> Ahhh, that is the kind of thing I'm looking for.  I'll check out that
>>> code in detail tomorrow.
>>
>> Keep in mind though that not all drivers can give you the difference
>> between AUTH and ASSOC, and will ONLY report "CONNECTED" events. This is
>> those drivers that do roaming and all that in firmware rather than in
>> mac80211. Therefore, generally speaking, you cannot get the states
>> you're after.
>
> FWIW I think he's on ath9k.

My real goal is to support lots (128+ hopefully) of
virtual stations on ath5k and ath9k.  We had this working
for ath5k in .31 kernel, but too much has changed to make it
a straight-forward upgrade to .34.

As soon as I can get the management logic fixed up (ie, libnl
to listen to wireless events, etc), we should be able to start
on the virtualization work in earnest.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

