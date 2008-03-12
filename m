Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:41063 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYCLCTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 22:19:52 -0400
Date: Wed, 12 Mar 2008 11:18:54 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
In-Reply-To: <20080311171024.GA18562@tuxdriver.com>
References: <1205254237.8774.0.camel@localhost.localdomain> <20080311171024.GA18562@tuxdriver.com>
Message-Id: <20080312102148.0B08.40F06B3A@sm.sony.co.jp> (sfid-20080312_021957_563782_FFEC598A)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 11 Mar 2008 13:10:24 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> On Tue, Mar 11, 2008 at 12:50:37PM -0400, Dan Williams wrote:
> > On Tue, 2008-03-11 at 17:18 +0100, Johannes Berg wrote:
> > > On Tue, 2008-03-11 at 13:15 +0900, Masakazu Mokuno wrote:
> > > > Some implementations of the hidden SSID APs emit beacons which have the zero
> > > > length SSID information element instead of SSID padded by null (\0) characters.
> > > > If the firmware of the PS3 wireless hardware meets these beacons, it abandons parsing
> > > > IEs. Thus guest OSes get the invalid scan information for the AP.
> > > > 
> > > > To work around this, ignore these scan informations from the list.
> > > 
> > > I'm not sure this is a good idea. Is there any way to get at decent
> > > information from those beacons?
> > 
> > Yeah, there are quite a few of these out there.  Ideally the firmware
> > wouldn't puke on it...
> 
> Is a firmware update a possibility?  We've had these discussions
> before.  I doubt Sony is any more excited about a firmware spin than
> Intel has been.

The fix is already scheduled and is under testing. The future update of
the system software for PS3 should have the fix.

> Does this problem apply to probe responses as well?  (Do probe
> responses from hidden SSID APs still exclude the SSID?  I would
> guess not.)

There has been a problem in parsing IEs, so if the received probe
responses include zero length IEs, they also suffer this bug.

> As long as you can still associate w/ hidden SSID APs, I don't see
> a big problem.  Even if you can't, no information for those APs is
> probably better than bad information, no?

I was anxious that the userland apps or the users may get confused.  Any
other thing harmful is not found.
OK, I withdraw this patch.

Thanks for the reviews.

-- 
Masakazu MOKUNO

