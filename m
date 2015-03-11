Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56748 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbbCKVFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 17:05:23 -0400
Message-ID: <5500AE12.6040103@candelatech.com> (sfid-20150311_220526_704884_B7ADAA35)
Date: Wed, 11 Mar 2015 14:05:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com> 	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net> 	 <54EB66CC.1030800@candelatech.com>  <1424772714.2192.16.camel@sipsolutions.net>  <54EC8C5D.5090400@candelatech.com> <1424788834.2192.34.camel@sipsolutions.net>
In-Reply-To: <1424788834.2192.34.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2015 06:40 AM, Johannes Berg wrote:
> On Tue, 2015-02-24 at 06:36 -0800, Ben Greear wrote:
> 
>> We could push more and more of this to user-space and let it decide whether and
>> how to forward or accept frames for particular radios.
> 
> Sure, no objection to that. However, just arbitrarily adding a "change
> channel" call, without thinking about the realities of the code already
> supporting multi-channel concurrency, remain-on-channel and hw-scan
> operations won't get us very far and just lead to issues with the API.

I took a look at the hw-scan code a bit...I guess we might could do additional
info calls to user-space as we iterate through the channels while scanning?

A real driver would be causing the NIC to change channels at these junctures,
either by directly setting registers or sending some message off to the
target NIC's cpu, right?

I would assume that off-channel work could do similar logic.

Is that the sort of thing you had in mind?

Thanks,
Ben


>> But, to do that, we need the low-level settings sent to user-space
>> (such as current channel).  Encryption keys could be a future enhancement
>> here, so that we can do 'hardware' encryption in hwsim (and handle encrypt/decrypt
>> logic however we want in user-space).
> 
> Sure. I'd just like to ask that the API is actually useful in more than
> the default single-channel support BSS-only case :)
> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

