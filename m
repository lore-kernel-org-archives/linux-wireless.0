Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51161 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYLRPpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 10:45:15 -0500
Date: Thu, 18 Dec 2008 10:30:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	mabbaswireless@gmail.com
Subject: Re: [PATCH v2 1/3] cfg80211: add PM hooks
Message-ID: <20081218153042.GD4121@tuxdriver.com> (sfid-20081218_164522_043842_FF80B154)
References: <1229313039-5544-2-git-send-email-me@bobcopeland.com> <20081217153524.GA3539@tuxdriver.com> <1229537449.4268.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229537449.4268.10.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 07:10:49PM +0100, Johannes Berg wrote:
> On Wed, 2008-12-17 at 10:35 -0500, John W. Linville wrote:
> > On Sun, Dec 14, 2008 at 10:50:37PM -0500, Bob Copeland wrote:
> > > From: Johannes Berg <johannes@sipsolutions.net>
> > > 
> > > This should help implement suspend/resume in mac80211, these
> > > hooks will be run before the device is suspended and after it
> > > resumes. Therefore, they can touch the hardware as much as
> > > they want to.
> > > 
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> > Is cfg80211 the right place for these?  Is it likely that any
> > non-mac80211 users of cfg80211 will ever want to use these hooks?
> 
> That's a good question. But even if non-mac80211 won't use this, I don't
> see how to get notifications in mac80211 w/o involving cfg80211, since
> mac80211 doesn't really have a way to get at the ops there without this,
> does it?

No, I suppose not.

I'm not too familiar with the internals of the PM stuff.  Is there
any guarantee that the cfg80211 suspend stuff will run before the
bus-specific suspend stuff?  Is this a concern?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
