Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab3EYIvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 04:51:12 -0400
Date: Sat, 25 May 2013 10:53:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jake Edge <jake@lwn.net>
Subject: Re: [RFT/RFC 0/4] iwlegacy: workaround for firmware frame tx
 rejection
Message-ID: <20130525085259.GB1599@redhat.com> (sfid-20130525_105119_291835_2C9B0F3C)
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
 <1369427208.8290.35.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369427208.8290.35.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 24, 2013 at 10:26:48PM +0200, Johannes Berg wrote:
> On Thu, 2013-05-23 at 14:20 +0200, Stanislaw Gruszka wrote:
> > Jake, please test this set and check if it not cause association
> > problems you reported earlier this month.
> > 
> > Please apply it together with this mac80211 patch:
> > http://marc.info/?l=linux-wireless&m=136879090123023&w=2 
> > which I already posted and is queued to upstream. Not having
> > it may cause troubles and influence negatively this set test.
> > 
> > Johannes, is need to check beacon bssid or even if rx frame
> > is a beacon to unblock queues? I think if we receive any frame
> > (not necessary beacon or our bssid beacon) on passive channel,
> > that mean we can use that channel. But that depend how firmware
> > is implemented, if firmware require our bssid beacon to unblock
> > channel, driver of course need that too.
> 
> I _think_ any frame with good CRC will do, but I'm not entirely sure for
> 3945/4965.

I prefer to unblock queues on any frame, as this allow to start
operating quickly.  Let's see if this will also work on Jake environment,
I'll add patch 5/4 which implement that.

Stanislaw
