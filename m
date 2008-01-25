Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2353 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761152AbYAYXDq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 18:03:46 -0500
Date: Fri, 25 Jan 2008 17:46:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080125224631.GH14687@tuxdriver.com> (sfid-20080125_230350_972499_7B4D6EEF)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de> <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080125194807.GD14687@tuxdriver.com> <20080125195037.GE14687@tuxdriver.com> <20080125211815.GF14687@tuxdriver.com> <alpine.LFD.1.00.0801251354350.5056@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LFD.1.00.0801251354350.5056@hp.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2008 at 01:56:15PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 25 Jan 2008, John W. Linville wrote:
> > 
> > Anyway, this is mostly just so we can scope the driver change required
> > in absence of a firmware change.  Persumably the changes required if
> > we were to put such code in mac80211 would be similar.
> 
> Make this conditional on archictures that need it, please.
> 
> And why is it suddenly smart to do this in three drivers rather than one 
> upper layer?

Two drivers, FWIW... :-)

Given that we don't have a CONFIG_MUST_ALIGN at present, I'm not sure
it is worth adding one for either an iwlwifi fix or a mac80211 one.
Or are there other issues that might be resolved or aided by such
a definition?  It doesn't seem to have been needed so far.

Maybe it would be easier to add a CONFIG_MAC80211_ALIGN_PAYLOAD option
around some code in mac80211 to fix-up alignments?  Then users of
alignment-sensitive arches could turn-on that option, and the rest
of us would leave it off.  Another (non-exclusive) option would be
to put CONFIG_MAC80211_DEBUG around the alignment warning so that
most people would never see it.

Thoughts?  I'm just looking for a resolution... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
