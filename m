Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbXINShF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 14:37:05 -0400
Subject: Re: iwlist and network-manager bug report
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: jt@hpl.hp.com, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1189794311.3974.49.camel@johannes.berg>
References: <1189526874.6161.30.camel@johannes.berg>
	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
	 <20070912170153.GA25785@bougret.hpl.hp.com>
	 <1189667496.6161.77.camel@johannes.berg>
	 <1189707493.1329.1.camel@johannes.berg>
	 <1189793380.2508.2.camel@xo-3E-67-34.localdomain>
	 <1189794311.3974.49.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 14:33:40 -0400
Message-Id: <1189794820.2508.22.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-09-14 at 20:25 +0200, Johannes Berg wrote:
> On Fri, 2007-09-14 at 14:09 -0400, Dan Williams wrote:
> 
> > I've been burning the midnight oil on it for the past few weeks, check
> > NM and applet changelogs.  Still not quite there yet, there's some core
> > work left to do getting NM to talk to the settings daemons (ie,
> > nm-client or knetworkmanager) correctly, getting GUI bits for Connection
> > editing in the applet, and making sure the relevant settings are
> > honored.
> 
> Great, good to know. There are various quirks in 0.6.5, my brother tells
> me for example that it's impossible to log on to an _open_ network at
> the university where he currently is while it works fine with iwconfig.
> Some other things too, my wpa network at home never works with nm and I
> was never able to determine why...

For whatever reason, driving wpa_supplicant with D-Bus is a lot more
reliable than talking to it over the unix domain socket.  I've long
suspected that's part of the issue with random failures of
wpa_supplicant in situations where the results between NM-driven and
plain wpa_supplicant are different.

Would be interesting to see some wpa_supplicant debug output from Ben's
machine though to see where it's failing and what info NM is pushing to
it.

Dan


