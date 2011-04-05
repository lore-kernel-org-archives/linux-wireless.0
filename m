Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39980 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DESFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 14:05:47 -0400
Received: by gyd10 with SMTP id 10so253900gyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 11:05:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301987234.3831.2.camel@jlt3.sipsolutions.net>
References: <1301969218-9878-1-git-send-email-javier@cozybit.com> <1301987234.3831.2.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 5 Apr 2011 11:05:26 -0700
Message-ID: <BANLkTinLaWXVVQLnjr=UuoNpOQ5QmioM_Q@mail.gmail.com>
Subject: Re: [RFC] cfg80211: Let mgmt_tx accept frames destined for its own stack.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 5, 2011 at 12:07 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-04-04 at 19:06 -0700, Javier Cardona wrote:
>> This is useful for implementing frame protection in userspace. The kernel may
>> request a userspace daemon to verify a frame (sent to userspace via
>> cfg80211_rx_mgmt()).  The userspace daemon can then pass back the
>> verified/unprotected frame to the stack for further processing (via a
>> self-addressed frame sent with cfg80211_mlme_mgmt_tx())
>>
>> We are using this for our implementation authenticated peering.  11s defines
>> two versions of mesh peering, the non-secure mesh peering management (MPM) and
>> the Authenticated Mesh Peering Exchange (AMPE).  The latter is based on the
>> exact same state machine as MPM.  It is really convenient to use the in-kernel
>> MPM with a minimal userspace daemon to add the security bits introduced by
>> AMPE.  This way both secured and open mesh networks can use exact same peering
>> code.
>>
>> What do you think... will this fly?
>
> Seems very strange to me. I guess if you're after unification in my mind
> it makes more sense to declare the in-kernel state machine legacy, copy
> it into the userspace tool and use it even for unprotected MPM?


We would like to preserve the ability to join an open mesh without a
daemon, in the same way that a station can associate with an AP
without one.  With that goal in mind, the alternatives are to
duplicate the MPM in userspace or to reuse the in-kernel MPM with only
AMPE in userspace.  Considering that AMPE uses MPM frames and state
machines, reusing the in-kernel MPM is a significantly lower effort
alternative.  Furthermore, while working on AMPE we can also bring the
in-kernel MPM up to spec.
Of course this requires agreeing on a suitable API between MPM and
AMPE.  If you don't like the generic one I proposed we can try to
define a mesh-specific alternative.  But first, setting aside the API change
proposal, do you object to this AMPE-in-userspace/MPM-in-kernel partition?

Cheers,

Javier
