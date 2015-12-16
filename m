Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37904 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965747AbbLPPwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 10:52:38 -0500
Message-ID: <567188C6.20006@candelatech.com> (sfid-20151216_165241_358295_C32CDC6E)
Date: Wed, 16 Dec 2015 07:52:38 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com> <1450257464.3159.1.camel@sipsolutions.net> <56716386.4070107@candelatech.com> <1450272308.8247.11.camel@sipsolutions.net> <567168AF.4060804@candelatech.com> <1450273362.8247.15.camel@sipsolutions.net> <56717119.1040701@candelatech.com> <1450275340.8247.18.camel@sipsolutions.net> <20151216145933.GE4073@localhost>
In-Reply-To: <20151216145933.GE4073@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 06:59 AM, Bob Copeland wrote:
> On Wed, Dec 16, 2015 at 03:15:40PM +0100, Johannes Berg wrote:
>> On Wed, 2015-12-16 at 06:11 -0800, Ben Greear wrote:
>>
>>> My code expected that the key was the MAC of the radio, not the
>>> MAC of a vif.  It set up mappings accordingly in the user-space
>>> program.
>>
>> I guess you were trying to be much smarter than wmediumd :)
>>
>> Bob, any thoughts?
>
> So, now that I understand the argument, I see the value in having
> an unchanging key for each phy.  I'm also pretty sure that it was by
> accident that it used to work that way.  If we were designing the ABI
> from scratch, radio id would probably be better than a mac address for
> that purpose.
>
> Anyway, in the interest of not breaking userspace, I'm not opposed to
> reverting that patch, and perhaps adding some documentation on top to make
> it clear that the addr attributes have nothing to do with any mac addresses
> actually in use.
>
> For wmediumd users that would mean going back to the way it was previously,
> in which only the 42:xx mac addresses will work, until I can work out another
> way to do it.  I think that would break the test_wmediumd.py in hostapd
> test suite in the meantime though.
>

Ok, thanks.

I'm fine with waiting a bit before reverting..its easy enough for me to carry
a private patch for a while.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

