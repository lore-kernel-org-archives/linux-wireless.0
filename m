Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab0LUOjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 09:39:07 -0500
Subject: Re: Wireless channel stuck to -1 on mon0 (fix patch submission)
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	CalimeroTeknik <calimeroteknik@free.fr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101220141134.GA10104@tuxdriver.com>
References: <4D0DE870.2050503@free.fr>
	 <AANLkTik5uML3gSD5aJE8CPwew8G5shp9BJgGUK608jTp@mail.gmail.com>
	 <1292794572.8422.0.camel@jlt3.sipsolutions.net>
	 <20101220141134.GA10104@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 15:39:04 +0100
Message-ID: <1292942344.3563.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-20 at 09:11 -0500, John W. Linville wrote:
> On Sun, Dec 19, 2010 at 10:36:12PM +0100, Johannes Berg wrote:
> > On Sun, 2010-12-19 at 21:58 +0100, Gábor Stefanik wrote:
> > > This is a known problem, that has basically been WONTFIXed a while
> > > ago. I highly disagree with the reasoning, but the decision ultimately
> > > rests on Johannes. In the meantime, check patches.aircrack-ng.org for
> > > a workaround.
> > > 
> > > Johannes: I know that you consider reporting the actual channel of the
> > > PHY to be "confusing to users" when running with multiple virtual
> > > PHYs, but apparently this is what most users expect. Perhaps it
> > > *should* be implemented after all.
> > 
> > In which case it should be implemented properly, not half-baked like all
> > the patches we've seen so far.
> 
> This does continue to pop-up.  Do you have a link to a description
> of a proper implementation?

I don't think so -- I don't recall anyone ever asking before ;-)

FWIW, I think right now we need to simply query mac80211's oper_channel
somehow -- that'll be good enough until that goes away for real
multi-channel operation.

Using the channel that was set on the monitor interfaces like these
patches have done is obviously flawed because monitor interfaces have
absolutely no influence on the channel unless that's all there is.

johannes

