Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2IDOxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:53:52 -0400
Message-ID: <1346770467.3737.32.camel@jlt4.sipsolutions.net> (sfid-20120904_165356_208297_322195F0)
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Tue, 04 Sep 2012 16:54:27 +0200
In-Reply-To: <1346769429.3737.30.camel@jlt4.sipsolutions.net> (sfid-20120904_163651_735748_490095D0)
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
	 <E1T8tYj-00051o-3z@debian64.localnet>
	 (sfid-20120904_155321_955424_2D6B3F4B) <1346768149.3737.29.camel@jlt4.sipsolutions.net>
	 <1346769184.26638.7.camel@dcbw.foobar.com>
	 <1346769429.3737.30.camel@jlt4.sipsolutions.net>
	 (sfid-20120904_163651_735748_490095D0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 16:37 +0200, Johannes Berg wrote:
> On Tue, 2012-09-04 at 09:33 -0500, Dan Williams wrote:
> > On Tue, 2012-09-04 at 16:15 +0200, Johannes Berg wrote:
> > > On Tue, 2012-09-04 at 15:19 +0200, Christian Lamparter wrote:
> > > 
> > > > As you feared: the firmware is corrupting incoming management
> > > > frames. However, it does so only when a rxkey was configured.
> > > > So as a possible trade-off, MFP will only be supported by p54,
> > > > when the firmware crypto offloading is relieved of his duties
> > > > (disabled). 
> > > > 
> > > > Note: Strictly speaking, it would be enough to no longer upload
> > > > any rx key which could affect management frames, as the firmware
> > > > does not decrypt any frames unless there is a fitting key candidate.
> > > 
> > > Right, however, that would kinda defeat the point. Unless ... maybe we
> > > can tell the driver if 11w is going to be used at all? If we did that,
> > > we could make it work in the set_key callback.
> > > 
> > > For now your patch looks good though.
> > 
> > We can't get this to happen without a module option?  Is there a way to
> > turn the crypto offloading off when we know we're connecting to a W
> > protected AP?
> 
> Yeah that's what I was thinking. I suppose we *could* somehow do this by
> setting some key flag in mac80211 that the driver can check.

Something like this perhaps:

http://p.sipsolutions.net/76d17d49f4685cda.txt

But I'd want somebody to check if the mesh code is right and maybe we
need to think about the AP case (have hostapd tell us whether it uses
MFP or not) ... and maybe docs should be improved

johannes

