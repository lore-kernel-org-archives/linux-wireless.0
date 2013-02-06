Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3BFWaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 17:30:07 -0500
Message-ID: <1360189829.7910.84.camel@jlt4.sipsolutions.net> (sfid-20130206_233012_099949_B3AFA079)
Subject: Re: [PATCH 3/4] mac80211: Improve error handling for off-channel
 operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 06 Feb 2013 23:30:29 +0100
In-Reply-To: <1360189602.7910.81.camel@jlt4.sipsolutions.net> (sfid-20130206_232625_612621_A4E2339D)
References: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
	 <1360162873-17240-4-git-send-email-seth.forshee@canonical.com>
	 <1360187077.7910.78.camel@jlt4.sipsolutions.net>
	 <20130206220517.GC6280@thinkpad-t410>
	 <1360188651.7910.80.camel@jlt4.sipsolutions.net>
	 <20130206222051.GD6280@thinkpad-t410>
	 <1360189602.7910.81.camel@jlt4.sipsolutions.net>
	 (sfid-20130206_232625_612621_A4E2339D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 23:26 +0100, Johannes Berg wrote:
> On Wed, 2013-02-06 at 16:20 -0600, Seth Forshee wrote:
> 
> > > > I'd considered trying to expand this to check whether or not the frame
> > > > was acked -- in fact just today I captured a trace where the AP didn't
> > > > ack the frame but the STA went off-channel anyway. I'm not sure how to
> > > > implement that yet, and haven't found time to look into it.
> > > 
> > > It means waiting for the TX status from the driver, which might not
> > > really come with all drivers at all, making it somewhat tricky in
> > > general.
> > > 
> > > Anyway my point is that this doesn't really help all that much, and
> > > patch 1 and 3 together is a lot of churn ...
> > 
> > Fair enough. If you want I can drop those and resend 2 and 4, because
> > they do fix real problems.
> 
> Please. I'll quickly go over them for comments first. I was going to say
> I can apply them but I don't think they'll compile :)

Actually they look fine. I thought the purge queue thing was weird but
it's necessary, just wasn't obvious to me right now.

johannes

