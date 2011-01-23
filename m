Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1AWKMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 05:12:25 -0500
Subject: Re: [PATCH] mac80211: use DECLARE_EVENT_CLASS
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110121212447.GB7092@tuxdriver.com>
References: <1295437859.4685.4.camel@jlt3.sipsolutions.net>
	 <20110121212447.GB7092@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 11:12:23 +0100
Message-ID: <1295777543.3639.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 16:24 -0500, John W. Linville wrote:
> On Wed, Jan 19, 2011 at 12:50:59PM +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > For events that include only the local struct as
> > their parameter, we can use DECLARE_EVENT_CLASS
> > and save quite some binary size across segments
> > as well lines of code.
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >  375745	  19296	    916	 395957	  60ab5	mac80211.ko.before
> >  367473	  17888	    916	 386277	  5e4e5	mac80211.ko.after
> >   -8272   -1408       0   -9680   -25d0 delta
> > 
> > Some more tracepoints with identical arguments
> > could be combined like this but for now this is
> > the one that benefits most.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Is this patch complete?  It seems to break the build with undefined symbols...

Yes, I believe it is, I'll resend the version I just compile tested
against wireless-testing.

johannes

