Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47156 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1DFXh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 19:37:57 -0400
Received: by iyb14 with SMTP id 14so1921350iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 16:37:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302100683.4090.9.camel@jlt3.sipsolutions.net>
References: <1301969218-9878-1-git-send-email-javier@cozybit.com>
 <1301987234.3831.2.camel@jlt3.sipsolutions.net> <BANLkTinLaWXVVQLnjr=UuoNpOQ5QmioM_Q@mail.gmail.com>
 <1302035332.4968.11.camel@jlt3.sipsolutions.net> <BANLkTinG4b9bzGhamHuF0zi0V=OQT5uBWQ@mail.gmail.com>
 <1302100683.4090.9.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 6 Apr 2011 16:37:37 -0700
Message-ID: <BANLkTino+eaE_YG2ETvfX2W=7EmtxUYE-w@mail.gmail.com>
Subject: Re: [RFC] cfg80211: Let mgmt_tx accept frames destined for its own stack.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 6, 2011 at 7:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-04-05 at 15:04 -0700, Javier Cardona wrote:
>
>> > After thinking about this more, yes, I think I do object. Not only is
>> > the design strange with passing frames back and forth, but also it seems
>> > like a rather slippery slope, at some point I fear somebody will attempt
>> > to "fake" MPM to take advantage of that kernel code even when it's not
>> > really fitting.
>>
>> The above seem to be concerns with the API itself and not with
>> partitioning.  We could make the API specific for mesh peering frames
>> in a way that cannot be used for any other purpose other than
>> protecting mesh peering frames.
>
> Well, it's a bit of both. I can just see somebody trying to implement a
> new protocol and making it look like MPM in order to be able to feed it
> back into the kernel, or something like that. More generally, I don't
> much like the looping back of things.
>
>> I know of a few mesh use cases where wpa_supplicant is not required,
>> such as resource constrained embedded platforms like the ones used in
>> sensor networks.  But hey, we'll re-evaluate the wpa_supplicant route
>> and see if it is doable.
>
> I think in that case it'd make some sense to make the code in the kernel
> configurable? Can't be all that much overhead to have essentially the
> same code outside the kernel?

We are analyzing how hard it would be to do MPM in userspace while
keeping (default) path selection in the kernel.  In this approach
userspace would not only authenticate but also establish peer links
and (in-kernel) stations would represent only established peer links.
It's probably not that hard after all, but definitely some overhead
compared to leaving it as it is :)

Javier
