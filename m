Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:48256 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757357AbaJ1GnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 02:43:08 -0400
Message-ID: <1414478575.27833.15.camel@coelho.fi> (sfid-20141028_074315_822763_7C054E69)
From: Luca Coelho <luca@coelho.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jukka Rissanen <jukka.rissanen@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 28 Oct 2014 08:42:55 +0200
In-Reply-To: <9C544CA4-42D3-4419-9BC7-C42DF2420CA4@holtmann.org>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1414408856.3836.3.camel@jlt4.sipsolutions.net>
	 <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com>
	 <1414409485.3836.5.camel@jlt4.sipsolutions.net>
	 <1414410917.2705.201.camel@jrissane-mobl.ger.corp.intel.com>
	 <1414411714.3836.7.camel@jlt4.sipsolutions.net>
	 <1D755566-F088-454B-AEC5-C635FFCB488A@holtmann.org>
	 <1414431250.27833.9.camel@coelho.fi>
	 <9C544CA4-42D3-4419-9BC7-C42DF2420CA4@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and
 removed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 16:14 -0700, Marcel Holtmann wrote:
> Hi Luca,

Hi Marcel,


> >>>>> That's not particularly hard to figure out, for example by looking at
> >>>>> sysfs.
> >>>>> 
> >>>>> Is this really so time-constrained/important/... that you can't do that?
> >>>> 
> >>>> It does not seem very practical to dig this information from sysfs as
> >>>> the same information can be easily get via netlink as this patch shows.
> >>> 
> >>> Well, that's a slippery slope. I'd consider it more practical to use
> >>> existing APIs instead of (gratuitously) inventing new ones. It'll even
> >>> work on older kernels as an added benefit.
> >> 
> >> I see that different. The component that handles the emulation of the new wireless device should be independent from the component driving it. I prefer to have a race free way of obtaining the needed information without having to monitor nl80211 and sysfs for this. Especially with the use cases that we have in mind it has no business with these other interfaces.
> >> 
> >> We have been down this route with the bridge interface where people had to dig out information from sysfs and it did not work out nicely. So now everything moves to netlink.
> > 
> > Why does hwsim have to be treated differently from any other device?
> > Unlike bridging, HW emulation doesn't seem to be a real life use case.
> > 
> > But I'm probably missing something. ;)
> 
> this is the controlling side. The thing that I call emulator. It is the component that creates/destroys the hwsim wiphy. It can also be the one that handles the packet processing similar to wmediumd.
> 
> The nl80211/cfg80211 is not treated differently here. This is purely for the MAC80211_HWSIM netlink family side of things. Makes sense?

Ah, okay, I was confused.  Makes total sense to me then, I don't see why
we shouldn't have this API to provide the needed information totally
independently from nl80211.

--
Luca.

