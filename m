Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYCKQ7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:59:12 -0400
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
In-Reply-To: <1205252287.6387.54.camel@johannes.berg>
References: <20080311130630.0AF0.40F06B3A@sm.sony.co.jp>
	 (sfid-20080311_051712_368863_0E0A4ECC)  <1205252287.6387.54.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 12:50:37 -0400
Message-Id: <1205254237.8774.0.camel@localhost.localdomain> (sfid-20080311_165919_163294_FB56907D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-11 at 17:18 +0100, Johannes Berg wrote:
> On Tue, 2008-03-11 at 13:15 +0900, Masakazu Mokuno wrote:
> > Some implementations of the hidden SSID APs emit beacons which have the zero
> > length SSID information element instead of SSID padded by null (\0) characters.
> > If the firmware of the PS3 wireless hardware meets these beacons, it abandons parsing
> > IEs. Thus guest OSes get the invalid scan information for the AP.
> > 
> > To work around this, ignore these scan informations from the list.
> 
> I'm not sure this is a good idea. Is there any way to get at decent
> information from those beacons?

Yeah, there are quite a few of these out there.  Ideally the firmware
wouldn't puke on it...

Dan


