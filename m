Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48459 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1KCGE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 02:04:28 -0400
Message-ID: <4EB22EE6.3030100@candelatech.com> (sfid-20111103_070431_831429_0CCBD97C)
Date: Wed, 02 Nov 2011 23:04:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>  <4EAAFAA7.8090403@candelatech.com>  (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>  <4EB17103.70506@candelatech.com> <1320256263.7846.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320256263.7846.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 10:51 AM, Johannes Berg wrote:
> On Wed, 2011-11-02 at 09:34 -0700, Ben Greear wrote:
>
>>> You misunderstood -- I said fullmac drivers, not differences between
>>> ath9k, iwlwifi etc. Other cfg80211 drivers, not other mac80211 drivers.
>>
>> Can you at least point me to some existing code that does a similar
>> check?  I have no idea of what a fullmac driver even does.  I can test
>> and eventually somewhat understand the paths for ath9k, but I have no
>> ability to test fullmac (as far as I know).
>
> Well ideally you have two patches -- one for cfg80211, and one for
> mac80211. Then you can test the cfg80211 one w/o mac80211 patches, so it
> behaves as though it didn't support it, and with the mac80211 patch it
> sets the flag to support it. Just think about drivers like ath6kl.

I think I made at least most of the other changes you were asking
for, but I'm still baffled about what to do about fullmac drivers.

Based on the comment above, if I simply left out the mac80211 stuff
then the new values passed in to the associate/connect logic will just
be ignored.

So, I suppose the fullmac drivers will just silently ignore the new
variables as well.  I looked, but didn't figure out where fullmac
connects into the cfg80211 logic.  If I can find it, then I could
add explicit checks for the new variables and return failure if
they are set..but I'm not sure that is any better than just silently
ignoring them anyway.

Anyway, hopefully the 3 v3 patches are closer to what you are
looking for.  They seem to test out fine for me, though I never
see AMSDU go to max value.  Maybe ath9k just doesn't support
that by default, as I didn't see it on the stock wireless-testing
code either...or maybe my AP or something else is weird.

I'll post the hostap patches when the kernel side is resolved.
They are a lot smaller now that everything goes through
the connect/associate logic.

Thanks,
Ben


>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
