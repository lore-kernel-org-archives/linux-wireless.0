Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55999 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZBPSCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 13:02:38 -0500
Subject: Re: NetworkManager and mac80211_hwsim
From: Dan Williams <dcbw@redhat.com>
To: Daniel Wagner <wagi@monom.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, networkmanager-list@gnome.org
In-Reply-To: <20090216172528.GB29509@toronto053.server4you.de>
References: <20090216160016.GA29509@toronto053.server4you.de>
	 <1234800284.4219.136.camel@johannes.local>
	 <20090216172528.GB29509@toronto053.server4you.de>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 13:00:51 -0500
Message-Id: <1234807251.1666.9.camel@localhost.localdomain> (sfid-20090216_190242_601729_F5E24D38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-02-16 at 18:25 +0100, Daniel Wagner wrote:
> On Mon, Feb 16, 2009 at 05:04:44PM +0100, Johannes Berg wrote:
> > On Mon, 2009-02-16 at 17:00 +0100, Daniel Wagner wrote:
> > 
> > > hotplug_event_begin_add_dev (..., parent_dev = NULL, ...)
> > >   net_add(..., parent_dev = NULL, ...)
> > >   {
> > >   	if (parent_dev == NULL)
> > > 		goto error;
> > >   }
> > > 
> > > Before I go deeper into that thing, does someone has
> > > an idea what could go wrong here with mac80211_hwsim?
> > 
> > hwsim phys have no parents in sysfs since they're virtual.
> 
> Do you propose to patch hald to handle this situation then?

The patch (for now) would have to go in hal, since obviously if HAL
can't see it, NM won't.  Until we port over to DeviceKit of course.

dan


