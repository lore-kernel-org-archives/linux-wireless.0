Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:54048 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbXIMF4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 01:56:10 -0400
Date: Thu, 13 Sep 2007 07:56:08 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: zd-mac80211: Fix TX status reports.
Message-ID: <20070913055608.GA8297@deine-taler.de>
References: <200709082341.31720.mb@bu3sch.de> <200709111220.31700.mb@bu3sch.de> <1189506596.6161.14.camel@johannes.berg> <200709111252.30291.mb@bu3sch.de> <1189508230.6161.18.camel@johannes.berg> <20070911223258.GA31400@deine-taler.de> <1ba2fa240709120140l56c21269p8254c790edda42b1@mail.gmail.com> <1189587273.6161.36.camel@johannes.berg> <1189587391.6161.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1189587391.6161.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> On Wed, 2007-09-12 at 10:54 +0200, Johannes Berg wrote:
> > On Wed, 2007-09-12 at 11:40 +0300, Tomas Winkler wrote:
> > 
> > > > Sending only one packet until the timeout period is over is
> > > > certainly doable and could be used for critical activity like
> > > > association and authentication, but for normal mode the driver
> > > > should only be required to provide statistics.
> > 
> > > That was my suggestion as well.
> > 
> > The only question is how we know which packets we need to be careful
> > with. Right now, it seems that is only packets from hostapd?
> 
> Also, do we really want to basically stop the whole AP when a new
> station is trying to associate? Maybe zd1211 is just not suitable for
> running an AP.

This is a valid point. However stopping the whole AP would not be
necessary, because the stop is only required for a particular
destination address. The destination address is available from the
TX retry failed interrupt.

I will try to experiment with a TX implementatation without
screening for ACKs for zd1211rw-mac80211 using Michael's timeout
idea by ensuring  that only one packet per destination address is
transferred at a time to the device and positively acknowledge the
packet after a timeout if no failure interrupt has been received.

I would however still recommend to verify, whether rate-selection
algorithms could work with statistics only. The mac80211 stack
should require only ACKs, when they are in fact needed to support
ieee80211 protocols.

-- 
Uli Kunitz
