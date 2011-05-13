Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab1EMKw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:52:56 -0400
Subject: Re: [PATCH v3 1/3] cfg80211/nl80211: add support for scheduled
 scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Luciano Coelho <coelho@ti.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, eliad@wizery.com
In-Reply-To: <20110513104524.GA14971@redhat.com>
References: <1305122977-6740-1-git-send-email-coelho@ti.com>
	 <1305122977-6740-2-git-send-email-coelho@ti.com>
	 <20110512150530.GB2171@redhat.com> <1305217201.12586.949.camel@cumari>
	 <20110513104524.GA14971@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 12:52:43 +0200
Message-ID: <1305283963.3487.12.camel@jlt3.sipsolutions.net> (sfid-20110513_125300_254670_23FF1FCE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 12:45 +0200, Stanislaw Gruszka wrote:

> > because the scheduled scan is a long-term operation and the normal scan
> > is done for a very short time (and the rest of the stack assumes it will
> > complete quickly enough as not to interfere with the connection.
> 
> Hmm, is this drawback of implementation or can not be done technically
> (question to myself :-) ? I can image that in ideal case hardware scanning
> will not affect normal operation, no matter how long it will take.
> Software scan is much worse, since we have to change channels manually.
> We currently share code between software scan and hardware scan in
> mac80211. Perhaps separating hw and sw scan code, would be a good idea
> and allow to consolidate hw scan and sched scan. I planning to look
> at this more closely.

Well, it's also a semantic question. If you trigger a scan, you expect a
result (or an abort) after a while. It could of course be extended with
a new attribute, but the error checking for that gets complicated,
especially if you consider older kernels that would simply ignore that
new attribute.

So basically, the only difference between "trigger scan (scheduled=1)"
and "trigger scheduled scan" (which this implements) would be in
nl80211. Everything else would have to separate them, since there are a
lot of internal things that behave differently depending on whether a
scan is running or not. Add the error checking, and I think we've got a
good case for new API :)

Also, you don't want to implement the scheduled scan in mac80211. This
is a powersaving feature, so that doesn't make sense, and if some
application _really_ needs to emulate it then it can do that itself, it
doesn't need mac80211 to do it for it.

johannes

