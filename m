Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2FSOi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:38:29 -0400
Message-ID: <1340116707.4482.11.camel@jlt3.sipsolutions.net> (sfid-20120619_163847_998586_FB627AE2)
Subject: Re: [RFC 0/5] bind filters and multicast list to subif
From: Johannes Berg <johannes@sipsolutions.net>
To: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 19 Jun 2012 16:38:27 +0200
In-Reply-To: <4FE08D6F.30105@tieto.com>
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
	 <1340019946.4615.3.camel@jlt3.sipsolutions.net> <4FE08D6F.30105@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 16:32 +0200, Lukasz Kucharczyk wrote:
> On 06/18/2012 01:45 PM, Johannes Berg wrote:
> > On Mon, 2012-06-18 at 12:57 +0200, Lukasz Kucharczyk wrote:
> >> Hi,
> >>
> >> Following patches enables configuring filters and multicast list for
> >> specific interface. That probably might be useful in implementation
> >> of multi-channel operation.
> >
> > "Might be useful"?
> >
> > I guess I can see that, but we need
> >   a) driver updates
> >   b) to keep a global filter setting for drivers that don't have
> >      per-interface settings
> >
> 
> Ok, so I will need indication from driver what it supports.
> Do you think adding single flag to ieee80211_hw_flags (like 
> IEEE80211_HW_SUPPORTS_IFCE_FILTERS) would be sufficient for that purpose?

I'm not sure that's needed? We'll have to maintain both a global and a
per-interface list anyway, so you could just add new per-interface
callbacks or so instead of changing the existing ones, and then the
driver can pick which ones it wants?

johannes

