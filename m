Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46797 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZGYRHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 13:07:48 -0400
Subject: Re: [PATCH] mac80211: fix oops in
 ieee80211_scan_state_set_channel()
From: Pavel Roskin <proski@gnu.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200907251506.34943.helmut.schaa@googlemail.com>
References: <20090725051801.2965.76768.stgit@ct.roinet.com>
	 <200907251506.34943.helmut.schaa@googlemail.com>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 13:07:16 -0400
Message-Id: <1248541636.2554.12.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 15:06 +0200, Helmut Schaa wrote:

> Hmm, I'd prefer to keep the decision state as entry and exit point to
> the scan state machine. The patch below should also fix this issue
> by returning back to the decision state after every skipped channel.

The patch is working and I'm fine with it.  We should fix that in the
tree as soon as possible, or it will stand in the way of bisection.

I forgot to mention that the oops was happening in x86_64 with rt61pci
and US regulatory domain.  The device only works in the 2.4 GHz range.

> In the long run I would like to move the channel selection also to
> the decision state in order to implement various improvements (like
> scanning multiple channels in a row or reordering the channel list).

I don't know the code enough, but two things surprised me:

Lack of SCAN_DONE in mac80211_scan_state.  We exit scanning through the
"entry point".

Use of "unsigned long" for bitwise fields, such as queue_stop_reasons
and scanning.  This reminds me of the good old days where long was
always 32 bit, but int wasn't.  I think "unsigned int" should be enough,
and you can annotate it with __bitwise to make sparse catch some
misuses.

-- 
Regards,
Pavel Roskin
