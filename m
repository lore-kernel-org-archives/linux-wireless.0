Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab2CEUEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:04:49 -0500
Subject: Re: [PATCH 3.3] iwlwifi: always monitor for stuck queues
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20120305194644.GF18128@tuxdriver.com> (sfid-20120305_210211_266165_46802003)
References: <1330879846-30311-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20120305194644.GF18128@tuxdriver.com>
	 (sfid-20120305_210211_266165_46802003)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 21:04:32 +0100
Message-ID: <1330977872.3545.11.camel@jlt3.sipsolutions.net> (sfid-20120305_210453_362702_9BB4FEF0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-05 at 14:46 -0500, John W. Linville wrote:
> On Sun, Mar 04, 2012 at 08:50:46AM -0800, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > If we only monitor while associated, the following
> > can happen:
> >  - we're associated, and the queue stuck check
> >    runs, setting the queue "touch" time to X
> >  - we disassociate, stopping the monitoring,
> >    which leaves the time set to X
> >  - almost 2s later, we associate, and enqueue
> >    a frame
> >  - before the frame is transmitted, we monitor
> >    for stuck queues, and find the time set to
> >    X, although it is now later than X + 2000ms,
> >    so we decide that the queue is stuck and
> >    erroneously restart the device
> > 
> > It happens more with P2P because there we can
> > go between associated/unassociated frequently.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Ben Cahill <ben.m.cahill@intel.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> 
> So what is the effect of this bug?  An unnecessary firmware restart?  How often does this happen?

Oh, guess I forgot that. The effect is essentially that the firmware
restarts unnecessarily, which causes strange things to happen.

> It is very late in the 3.3 cycle.  Fixes should be for regressions, crashes, etc.

Since unfortunately P2P isn't really stable yet and before P2P hardly
anyone saw this I suppose it doesn't matter all that much ...

johannes

