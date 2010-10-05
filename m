Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab0JEUZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 16:25:41 -0400
Subject: Re: [PATCH v3] mac80211: Add WME information element for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201010051024.56936.br1@einfach.org>
References: <20101004021730.3870.14677.stgit@tt-desk>
	 <1286191300.3620.2.camel@jlt3.sipsolutions.net>
	 <201010051024.56936.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 22:25:40 +0200
Message-ID: <1286310340.3641.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 10:24 +0900, Bruno Randolf wrote:
> On Mon October 4 2010 20:21:40 Johannes Berg wrote:
> > On Mon, 2010-10-04 at 11:17 +0900, Bruno Randolf wrote:
> > > Enable WME QoS in IBSS mode by adding a WME information element to
> > > beacons and probe respones and by checking for it and marking stations
> > > as WME capable if it is present.
> > > 
> > > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > > 
> > > ---
> > > v3: use GFP_ATOMIC and re-organize nesting of "if" statements. allthough
> > > in practice we would probaby always have the rates element i think it's
> > > more correct to code it like this.
> > 
> > You're probably right, but shouldn't that be a separate patch? It
> > doesn't relate to WME at all, afaict.
> 
> it does. before we only looked at elems->supp_rates, so it was o.k. to combine 
> that check into the first if (adhoc mode && bssid matches). now we also check 
> elems->wmm_info so we should make separate cases for each. as i noted, it 
> probably does not matter much in practice, since elems->supp_rates should be 
> present in all proper beacons and probe responses.

Fair enough, looks fine to me.

johannes

