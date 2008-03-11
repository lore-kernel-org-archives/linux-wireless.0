Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3127 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYCKRXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 13:23:53 -0400
Date: Tue, 11 Mar 2008 13:10:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
Message-ID: <20080311171024.GA18562@tuxdriver.com> (sfid-20080311_172403_086765_3157540E)
References: <20080311130630.0AF0.40F06B3A@sm.sony.co.jp> <1205252287.6387.54.camel@johannes.berg> <1205254237.8774.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1205254237.8774.0.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2008 at 12:50:37PM -0400, Dan Williams wrote:
> On Tue, 2008-03-11 at 17:18 +0100, Johannes Berg wrote:
> > On Tue, 2008-03-11 at 13:15 +0900, Masakazu Mokuno wrote:
> > > Some implementations of the hidden SSID APs emit beacons which have the zero
> > > length SSID information element instead of SSID padded by null (\0) characters.
> > > If the firmware of the PS3 wireless hardware meets these beacons, it abandons parsing
> > > IEs. Thus guest OSes get the invalid scan information for the AP.
> > > 
> > > To work around this, ignore these scan informations from the list.
> > 
> > I'm not sure this is a good idea. Is there any way to get at decent
> > information from those beacons?
> 
> Yeah, there are quite a few of these out there.  Ideally the firmware
> wouldn't puke on it...

Is a firmware update a possibility?  We've had these discussions
before.  I doubt Sony is any more excited about a firmware spin than
Intel has been.

Does this problem apply to probe responses as well?  (Do probe
responses from hidden SSID APs still exclude the SSID?  I would
guess not.)

As long as you can still associate w/ hidden SSID APs, I don't see
a big problem.  Even if you can't, no information for those APs is
probably better than bad information, no?

John
-- 
John W. Linville
linville@tuxdriver.com
