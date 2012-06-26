Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55711 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750799Ab2FZFYA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 01:24:00 -0400
Message-ID: <1340688238.3359.31.camel@joe2Laptop> (sfid-20120626_072416_980169_1105BB59)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 25 Jun 2012 22:23:58 -0700
In-Reply-To: <20120625212904.GA9245@redhat.com>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
	 <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
	 <1340438536.2274.9.camel@joe2Laptop>
	 <1340456697.4636.1.camel@jlt3.sipsolutions.net>
	 <1340466044.7758.4.camel@joe2Laptop>
	 <1340530258.4577.4.camel@jlt3.sipsolutions.net>
	 <20120625212904.GA9245@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 17:29 -0400, Jason Baron wrote:
> On Sun, Jun 24, 2012 at 11:30:58AM +0200, Johannes Berg wrote:
> > On Sat, 2012-06-23 at 08:40 -0700, Joe Perches wrote:
> > 
> > > > FWIW, I would definitely prefer named rather than bitmap selectors :-)
> > > 
> > > (Added Jason and Jim)
> > > 
> > > Given it's a debug-only facility, I think bitmap
> > > selectors sufficient, Maybe adding an external
> > > utility to map names to bits would be enough to
> > > not need that feature in the kernel.
> > 
> I've been thinking about that too - given that we can control each
> individual statement from userspace, perhaps most of the implementation
> for level/bitmap support could and should be done in userspace.

Maybe, but I think not.  There are configs where DEBUG
is defined, dyn_debug is not used and debugging levels
are checked against a constant that allows various debug
tests to be compiled away completely.

I'd prefer to keep the control mechanism the same for
pr_debug uses with and without dynamic_debug.

Doing "echo foo > bar" is pretty simple and might be best
if was kept the same.

There does need to be a u32 for the mask/level and a bit
or 2 for determining if mask or level is used or nothing.

> > I think it would be good to use the jump_label mechanism to
> > implement it -- I do realise that still has runtime overhead for the
> > argument preparation, but still.
> > 
> > Looking at the history, it seems that jump labels were at one point used
> > by reverted to fix gcc 3.3, I'm sure that could be resolved?
> 
> Yes, there were some circular header dependencies issues - but they can
> be resolved. I will re-post this work.

I just did that here.  What I've done is kind of messy
as I've moved a lot of kernel.h content around.

Hope yours is cleaner.

