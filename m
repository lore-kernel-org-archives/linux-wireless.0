Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56932 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbbKMHiD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 02:38:03 -0500
Message-ID: <1447400275.3271.2.camel@sipsolutions.net> (sfid-20151113_083859_246954_8A8917FD)
Subject: Re: [PATCH v2] cfg80211: add VHT support for Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Nov 2015 08:37:55 +0100
In-Reply-To: <56451B2F.3060704@codeaurora.org>
References: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com>
		 <1447358605.2131.3.camel@sipsolutions.net>
		 <564505A6.9030001@codeaurora.org>
		 <1447364413.2131.5.camel@sipsolutions.net>
		 <56451294.9060205@codeaurora.org>
	 <1447367523.2131.6.camel@sipsolutions.net>
	 <56451B2F.3060704@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-12 at 15:05 -0800, Peter Oh wrote:
> On 11/12/2015 02:32 PM, Johannes Berg wrote:
> > On Thu, 2015-11-12 at 14:28 -0800, Peter Oh wrote:
> > >   
> > > Exactly the same communication mechanism and purpose are used
> > > with
> > > NL80211_EXT_FEATURE_VHT_IBSS which is already a part of NL80211
> > > feature
> > > flag.
> > > The new feature flag, NL80211_EXT_FEATURE_VHT_MESH, follows the
> > > same
> > > purpose and usage.
> > No, it doesn't. Check how the _IBSS one is used in the code to
> > actually
> > *do* something.
> that's right. so take a look reset of explanation for this patch.
> 

Still not making sense.

I *suspect* that you think that the existing code is broken, and can't
use VHT mesh and requires driver changes for it, but that's not what
your ath10k change shows since it also does nothing at all.

Right now, I see no reason whatsoever to apply either one of those two
patches. There are no functional changes, so wpa_supplicant could
enable VHT mesh by checking VHT capabilities or so instead of a special
feature flag.

I also suspect that perhaps mesh *should* be checking like IBSS does,
although I also would actually *prefer* that we can assume VHT mesh
works if the driver advertises VHT support and mesh support separately,
i.e. a new feature flag really isn't necessary.

In any case, the arguments for this patch haven't convinced me. I'm not
going to apply this without much better ones.

johannes
