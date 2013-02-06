Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab3BFWK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 17:10:28 -0500
Message-ID: <1360188651.7910.80.camel@jlt4.sipsolutions.net> (sfid-20130206_231031_585207_E5BB62C7)
Subject: Re: [PATCH 3/4] mac80211: Improve error handling for off-channel
 operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 06 Feb 2013 23:10:51 +0100
In-Reply-To: <20130206220517.GC6280@thinkpad-t410>
References: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
	 <1360162873-17240-4-git-send-email-seth.forshee@canonical.com>
	 <1360187077.7910.78.camel@jlt4.sipsolutions.net>
	 <20130206220517.GC6280@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 16:05 -0600, Seth Forshee wrote:
> On Wed, Feb 06, 2013 at 10:44:37PM +0100, Johannes Berg wrote:
> > On Wed, 2013-02-06 at 09:01 -0600, Seth Forshee wrote:
> > > Errors in sending the nullfunc frame to set powersave at the AP for
> > > off-channel operation can lead to high packet loss. Add error handling
> > > to fail going off-channel when this happens, and return an error to
> > > userspace.
> > 
> > With the flushes in place, have you ever seen this fail? This and patch
> > ones seems like a lot of churn for only half of what you'd want -- what
> > you really want is to know if the AP ACKed the frame...
> 
> That's a good point. I've seen iw fail to initiate scans, but I can't
> say whether or not any of them was due to the queues being stopped for
> some reason. When I was testing NetworkManager was still managing the
> interface, so at least some failures were undobtedly because another
> scan was ongoing.

Yeah you'd expect that. I think you could tell the difference -- EBUSY
vs. whatever other error code you chose?

> I'd considered trying to expand this to check whether or not the frame
> was acked -- in fact just today I captured a trace where the AP didn't
> ack the frame but the STA went off-channel anyway. I'm not sure how to
> implement that yet, and haven't found time to look into it.

It means waiting for the TX status from the driver, which might not
really come with all drivers at all, making it somewhat tricky in
general.

Anyway my point is that this doesn't really help all that much, and
patch 1 and 3 together is a lot of churn ...

johannes

