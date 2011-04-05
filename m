Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45239 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1DEWEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 18:04:41 -0400
Received: by iwn34 with SMTP id 34so828738iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 15:04:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302035332.4968.11.camel@jlt3.sipsolutions.net>
References: <1301969218-9878-1-git-send-email-javier@cozybit.com>
 <1301987234.3831.2.camel@jlt3.sipsolutions.net> <BANLkTinLaWXVVQLnjr=UuoNpOQ5QmioM_Q@mail.gmail.com>
 <1302035332.4968.11.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 5 Apr 2011 15:04:21 -0700
Message-ID: <BANLkTinG4b9bzGhamHuF0zi0V=OQT5uBWQ@mail.gmail.com>
Subject: Re: [RFC] cfg80211: Let mgmt_tx accept frames destined for its own stack.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 5, 2011 at 1:28 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-04-05 at 11:05 -0700, Javier Cardona wrote:
>
>> We would like to preserve the ability to join an open mesh without a
>> daemon, in the same way that a station can associate with an AP
>> without one.
>
> Keep in mind that even the station case on an open or WEP network is
> pretty useless since it will not reconnect if the connection drops, or
> do any sort of roaming.
>
>> With that goal in mind, the alternatives are to
>> duplicate the MPM in userspace or to reuse the in-kernel MPM with only
>> AMPE in userspace.  Considering that AMPE uses MPM frames and state
>> machines, reusing the in-kernel MPM is a significantly lower effort
>> alternative.  Furthermore, while working on AMPE we can also bring the
>> in-kernel MPM up to spec.
>> Of course this requires agreeing on a suitable API between MPM and
>> AMPE.  If you don't like the generic one I proposed we can try to
>> define a mesh-specific alternative.  But first, setting aside the API change
>> proposal, do you object to this AMPE-in-userspace/MPM-in-kernel partition?
>
> After thinking about this more, yes, I think I do object. Not only is
> the design strange with passing frames back and forth, but also it seems
> like a rather slippery slope, at some point I fear somebody will attempt
> to "fake" MPM to take advantage of that kernel code even when it's not
> really fitting.

The above seem to be concerns with the API itself and not with
partitioning.  We could make the API specific for mesh peering frames
in a way that cannot be used for any other purpose other than
protecting mesh peering frames.

> Since practically speaking, wpa_supplicant is already required for
> almost everything, I don't see any real disadvantages to duplicating the
> MPM state machine there, and starting to deprecate the one in the kernel
> over time with new features only available in userspace one, maybe even
> removing it at some point. I realise this is a little more short-term
> effort, but I think the long-term benefit probably outweighs it.

I know of a few mesh use cases where wpa_supplicant is not required,
such as resource constrained embedded platforms like the ones used in
sensor networks.  But hey, we'll re-evaluate the wpa_supplicant route
and see if it is doable.

Thanks for the comments,

Javier
