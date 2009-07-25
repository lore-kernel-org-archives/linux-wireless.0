Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34107 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZGYVoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 17:44:05 -0400
Subject: Re: [PATCH] mac80211: fix oops in
 ieee80211_scan_state_set_channel()
From: Pavel Roskin <proski@gnu.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200907252015.07010.helmut.schaa@googlemail.com>
References: <20090725051801.2965.76768.stgit@ct.roinet.com>
	 <200907251506.34943.helmut.schaa@googlemail.com>
	 <1248541636.2554.12.camel@ct>
	 <200907252015.07010.helmut.schaa@googlemail.com>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 17:44:02 -0400
Message-Id: <1248558242.11389.13.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 20:15 +0200, Helmut Schaa wrote:

> > Lack of SCAN_DONE in mac80211_scan_state.  We exit scanning through the
> > "entry point".
> 
> I also thought of a separate state SCAN_DONE or something similar but
> dropped that idea as the only thing this state would have to do is the
> call to ieee80211_scan_completed. So, once the scan is finished we
> just stay in SCAN_DECISION as long as the scan state machine gets poked
> again by a start_scan call.

It's just an idea.  I only touched that code because it was failing for
me.

There is some duplication of information between local->scanning and
local->next_scan_state, but it's probably hard to avoid.

> > Use of "unsigned long" for bitwise fields, such as queue_stop_reasons
> > and scanning.  This reminds me of the good old days where long was
> > always 32 bit, but int wasn't.  I think "unsigned int" should be enough,
> > and you can annotate it with __bitwise to make sparse catch some
> > misuses.
> 
> No objections :)

Sorry, it turns out test_bit() wants unsigned long.  I don't quite like
what it does, but I'm not going to rewrite it.

-- 
Regards,
Pavel Roskin
