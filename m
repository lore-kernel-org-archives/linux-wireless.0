Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47011 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751623AbaJ0Rer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 13:34:47 -0400
Message-ID: <1414431250.27833.9.camel@coelho.fi> (sfid-20141027_183452_018441_29C10FD8)
From: Luca Coelho <luca@coelho.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jukka Rissanen <jukka.rissanen@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 27 Oct 2014 19:34:10 +0200
In-Reply-To: <1D755566-F088-454B-AEC5-C635FFCB488A@holtmann.org>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1414408856.3836.3.camel@jlt4.sipsolutions.net>
	 <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com>
	 <1414409485.3836.5.camel@jlt4.sipsolutions.net>
	 <1414410917.2705.201.camel@jrissane-mobl.ger.corp.intel.com>
	 <1414411714.3836.7.camel@jlt4.sipsolutions.net>
	 <1D755566-F088-454B-AEC5-C635FFCB488A@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and
 removed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 07:19 -0700, Marcel Holtmann wrote:
> Hi Johannes,
> 
> >>> That's not particularly hard to figure out, for example by looking at
> >>> sysfs.
> >>> 
> >>> Is this really so time-constrained/important/... that you can't do that?
> >> 
> >> It does not seem very practical to dig this information from sysfs as
> >> the same information can be easily get via netlink as this patch shows.
> > 
> > Well, that's a slippery slope. I'd consider it more practical to use
> > existing APIs instead of (gratuitously) inventing new ones. It'll even
> > work on older kernels as an added benefit.
> 
> I see that different. The component that handles the emulation of the new wireless device should be independent from the component driving it. I prefer to have a race free way of obtaining the needed information without having to monitor nl80211 and sysfs for this. Especially with the use cases that we have in mind it has no business with these other interfaces.
> 
> We have been down this route with the bridge interface where people had to dig out information from sysfs and it did not work out nicely. So now everything moves to netlink.

Why does hwsim have to be treated differently from any other device?
Unlike bridging, HW emulation doesn't seem to be a real life use case.

But I'm probably missing something. ;)

--
Luca.

