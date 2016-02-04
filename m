Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47365 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbcBDRwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 12:52:18 -0500
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
 <1453807009.2759.23.camel@sipsolutions.net>
 <56A78E8F.1080505@candelatech.com> <1454576521.2564.6.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56B38FD1.40902@candelatech.com> (sfid-20160204_185221_783353_26152837)
Date: Thu, 4 Feb 2016 09:52:17 -0800
MIME-Version: 1.0
In-Reply-To: <1454576521.2564.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2016 01:02 AM, Johannes Berg wrote:
> On Tue, 2016-01-26 at 07:19 -0800, Ben Greear wrote:
>
>> As far as I can tell, that will not work, because I want to have
>> multiple station devices per radio, and have each of them be able to
>> use a different configuration.  So, one station may be /g, and
>> another /n and another /AC.  Same with APs.  In addition, some
>> stations may want to use all available rates for their mode, and
>> others may want to use a fixed rate or subset of available rates.
>
> So let's agree that we're splitting the *used* rates (which we have
> today) and the *advertised* rates/modes/...

Yes, I think that will work well, and unless I mis-understand, that
is basically what I implemented so far.

> Even if we can't modify the wiphy capabilities, perhaps we could still
> handle it more consistently at mac80211 level, e.g. by introducing and
> using "sdata->capa.bands" (and similar for all the other wiphy
> capabilities you want to manipulate), and then allowing that to point
> to something modified?

Copied state might be tricky.  I think if we hold any copies of capabilities data in
the sdata, then it should be logically compared with a mask and then treated as an AND with whatever the wiphy
has.  I'm reluctant to propose any serious mac80211 change at this point, though perhaps
as more of this type of features are added, then it will become more obvious how
to nicely consolidate things in mac80211.

To be honest, I thought my -v2 patches were fairly non-invasive compared to my
normal hackings :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

