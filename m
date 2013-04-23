Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36491 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3DWWGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 18:06:37 -0400
Message-ID: <517705E0.4070304@candelatech.com> (sfid-20130424_000645_677333_CE149D50)
Date: Tue, 23 Apr 2013 15:06:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] mac80211:  Add vif hash for multi-station RX performance.
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>   (sfid-20130403_184908_772897_29241D1E) <1365501478.8465.17.camel@jlt4.sipsolutions.net>  <516455CA.6070504@candelatech.com> <1365671968.8272.35.camel@jlt4.sipsolutions.net> <5176E442.7070907@candelatech.com>
In-Reply-To: <5176E442.7070907@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2013 12:42 PM, Ben Greear wrote:
> On 04/11/2013 02:19 AM, Johannes Berg wrote:

>> Another question: Have you thought about hashing the virtual interfaces
>> instead of the stations, and then hashing the stations inside each
>> virtual interface? That would make it a bit of a two-level thing:
>>
>> A1 (in the frame) -> virtual interface
>>      A2 (frame) -> station
>>
>> But it would address the TX side efficiently without "some_sta" since
>> you know the virtual interface there already, and could potentially have
>> less impact on the code? On TX it'd actually even be more efficient if
>> you have more than 1 station per interface (right now you don't though)
>
> This idea suddenly looks a lot more interesting.  The ieee80211_tx_status method needs
> to find the remote station & sdata, but in the AP case, the station hash works best,
> and in my many-sta-vif case, the VIF hash works best.  I don't see any way to guess
> which hash to use in this case.
>
> But, if we first hashed to find sdata, and then had a vif hash in the sdata
> object, the lookup should be fast for cases where the hash function works
> well.
>
> I'll give this a try...

Seems to mostly be working, but I've a few questions.

First, if we are hashing sdata on sdata->vif.addr, then we must
assume that everything in that hash has a unique MAC.  I'm
thinking that I would just never put monitor devices in
the hash.  Is there anything else that would cause problems
with this?

Second, the sta_info_get_bss call is found fairly often.  It
talks about finding a station on sdata or associated vlan.
Does this indicate that the there are VLAN sdata objects
with duplicate MACs?

I was hoping I could replace at least most calls to sta_info_get_bss
with one that just searched the new sdata->sta_hash hash table...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

