Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:57590 "EHLO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXHEXQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 19:16:32 -0400
Message-ID: <20070805230908.19435.qmail@cdy.org>
Date: Mon, 6 Aug 2007 01:09:08 +0200
From: Peter Stuge <stuge-rt2400@cdy.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] suspend/resume support in mac80211
References: <1186343417.8459.23.camel@localhost> <200708052344.12673.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200708052344.12673.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 05, 2007 at 11:44:12PM +0200, Michael Buesch wrote:
> > we have recently been struggling with getting suspend/resume
> > working in rt2x00. A few questions:
> 
> There is no suspend/resume support in mac80211.

Wow, that's really bad news.

Are there plans for it?


> > 3. Shouldn't mac80211 be made suspend/resume-aware
> 
> I think we should have a API call to mac80211 that suspends the
> stack (saves the state etc..)

Would it be enough to add a suspended state and functions for
entering/exiting the state? On transitions, the appropriate driver
level functions are called of course.


> and a call the resumes (reassociates, re-handshakes...).
> But that's probably not that easy to implement, as parts of this
> does happen in userspace.

Shouldn't that be handled by hotplugging then?


(I'm not on linux-wireless, but rt2400-devel, no need to cc if you
crosspost.)

//Peter
