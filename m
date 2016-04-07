Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43719 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbcDGIxv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 04:53:51 -0400
Message-ID: <1460019225.27154.5.camel@sipsolutions.net> (sfid-20160407_105355_253016_DBCAB106)
Subject: Re: [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Taht <dave.taht@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Date: Thu, 07 Apr 2016 10:53:45 +0200
In-Reply-To: <CAA93jw5mTMndywTH7GRqKMPr24UhxN8m0i0ri4dXa4ZdCULEoQ@mail.gmail.com> (sfid-20160406_193938_584462_320BAA37)
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	 <1459864656.18188.60.camel@sipsolutions.net>
	 <CAA93jw4Swv9aOr=ZKoKeQyp9f1HnYJtiY7a1Lw2Ri89XjGiORQ@mail.gmail.com>
	 <1459927276.17504.6.camel@sipsolutions.net>
	 <CAA93jw5mTMndywTH7GRqKMPr24UhxN8m0i0ri4dXa4ZdCULEoQ@mail.gmail.com>
	 (sfid-20160406_193938_584462_320BAA37)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-06 at 10:39 -0700, Dave Taht wrote:

> > > The hope had been the original codel.h would have been reusable,
> > > which is not the case at present.
> > So what's the strategy for making it happen?
> Strategy? to meander towards a result that gives low latency to all
> stations, no matter their bandwidth, on several chipsets.

I meant "strategy for making the code reusable". Or something like that
anyway. I don't see the point in trying and then failing. Here we're
adding a completely different version of codel to the kernel - why?
What makes this version unusable for the original usage in
include/net/codel.h? Can't we replace that one with the newer version
and actually use the same file here?

Or - why bother with the header file to make it shareable, if we're not
even attempting to do that?

johannes
