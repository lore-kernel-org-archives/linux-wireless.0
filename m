Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36480 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946959Ab3BHUqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:46:37 -0500
Date: Fri, 8 Feb 2013 14:46:32 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
Message-ID: <20130208204632.GE2622@thinkpad-t410> (sfid-20130208_215344_121471_5AF8B4F5)
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
 <1360314212.29851.4.camel@jlt4.sipsolutions.net>
 <20130208171155.GC2622@thinkpad-t410>
 <1360343852.29851.26.camel@jlt4.sipsolutions.net>
 <20130208181002.GD2622@thinkpad-t410>
 <1360350359.29851.27.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360350359.29851.27.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 08:05:59PM +0100, Johannes Berg wrote:
> On Fri, 2013-02-08 at 12:10 -0600, Seth Forshee wrote:
> 
> > Well, I think the way that will be simplest with the fewest code changes
> > would be to use a tx control flag. Of course then we've gobbled up one
> > of the last available flags.
> 
> Let's do that anyway then. I still think we need to do the
> PS/scan/offchannel thing I described in another mail anyway, so that'd
> be a better interim step than changing all the prototypes...

When I originally looked at using a tx control flag I didn't think that
using IEEE80211_TX_CTL_TX_OFFCHAN would work, but now I'm not sure why.
Is there any reason not to do this?

Seth

