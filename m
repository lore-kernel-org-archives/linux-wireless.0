Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2GFN0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 09:26:22 -0400
Message-ID: <1341581180.16893.2.camel@jlt3.sipsolutions.net> (sfid-20120706_152626_196582_D096A2EC)
Subject: Re: [PATCH] mac80211: fix crash with single-queue drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2012 15:26:20 +0200
In-Reply-To: <4FF6E50B.4090205@lwfinger.net> (sfid-20120706_151601_313202_4A7FB65B)
References: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net>
	 <4FF6E50B.4090205@lwfinger.net> (sfid-20120706_151601_313202_4A7FB65B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-06 at 08:15 -0500, Larry Finger wrote:
> On 07/04/2012 05:53 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Larry (and some others I think) reported that with
> > single-queue drivers mac80211 crashes when waking
> > the queues. This happens because we allocate just
> > a single queue for each virtual interface in case
> > the driver doesn't have at least 4 queues, but the
> > code stopping/waking the virtual interface queues
> > wasn't taking this into account.
> >
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >   net/mac80211/util.c |   12 ++++++++++--
> >   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> This patch fixes the problem for drivers that always report a single queue such 
> as at76c503-usb.

Thanks, I'll merge this.

>  There is still a problem for b43 with open-source firmware 
> where the number of queues changes from 4 to 1. As that only affects b43, do you 
> agree that the problem should be fixed there?

Yes, b43 confuses me a bit. We were looking at this a few weeks ago, but
I couldn't figure out how to solve it.

I think for b43 the solution should be to check if it's proprietary or
free firmware before registering with mac80211, then to mac80211 it's
really just either 1 or 4, not changing.

johannes

