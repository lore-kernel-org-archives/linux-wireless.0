Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2IGQOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 12:14:44 -0400
Message-ID: <1347034503.4256.31.camel@jlt4.sipsolutions.net> (sfid-20120907_181448_507646_CB59D4DD)
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Date: Fri, 07 Sep 2012 18:15:03 +0200
In-Reply-To: <201209071810.18821.chunkeey@googlemail.com> (sfid-20120907_181023_591417_EF39566A)
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
	 <201209071747.09666.chunkeey@googlemail.com>
	 <1347033342.4256.28.camel@jlt4.sipsolutions.net>
	 <201209071810.18821.chunkeey@googlemail.com>
	 (sfid-20120907_181023_591417_EF39566A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 18:10 +0200, Christian Lamparter wrote:
> On Friday 07 September 2012 17:55:42 Johannes Berg wrote:
> > On Fri, 2012-09-07 at 17:47 +0200, Christian Lamparter wrote:
> > > On Friday 07 September 2012 14:17:14 Johannes Berg wrote:
> > > > On Tue, 2012-09-04 at 16:54 +0200, Johannes Berg wrote:
> > > >
> > > > If you want this for your driver, I'll commit this:
> > > > 
> > > > http://p.sipsolutions.net/ea2e3dbe980f5db8.txt
> > > 
> > > Won't this totally disable the crypto offload
> > > capabilities in AP mode?
> > 
> > Yes, though we could add an nl80211 attribute that
> > allows hostapd to tell us, and then if it did tell
> > us we could know and do the right thing here.
> 
> Well, if we want to do the right thing here, then I
> guess we should go for another alternative: a rxkey
> manager of some sorts. So, we delete keys from the
> firmware context once MFP comes into the game.

That's kinda what I do though, the flag tells you (at key installation)
whether MFP will be used or not. It's just that in the AP case, mac80211
doesn't actually know.

johannes

