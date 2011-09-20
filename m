Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1ITR6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 13:58:54 -0400
Subject: Re: [PATCH] mac80211: fix AP/VLAN PS buffer race
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAB=NE6UEo5C-+KrS+Bvqb2wj5NDcZu5ODqm_a4eSXW9ANU0xxw@mail.gmail.com> (sfid-20110920_194935_279893_128F9050)
References: <1316533251.3953.46.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UEo5C-+KrS+Bvqb2wj5NDcZu5ODqm_a4eSXW9ANU0xxw@mail.gmail.com>
	 (sfid-20110920_194935_279893_128F9050)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 19:58:49 +0200
Message-ID: <1316541529.3953.50.camel@jlt3.sipsolutions.net> (sfid-20110920_195858_826491_631A7B73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-20 at 10:48 -0700, Luis R. Rodriguez wrote:
> On Tue, Sep 20, 2011 at 8:40 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > When an AP interface is removed without the
> > AP/VLAN interfaces having been removed before
> > already, the AP-VLAN interface might still
> > have sleeping stations and buffer multicast
> > frames which will happen on the AP interface.
> > Thus, we need to remove AP/VLAN interfaces
> > before purging buffered broadcast frames.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Curious, what was happening with the inverse?

I never ran into this -- purely by code inspection. What could've
happened is that frames are still queued for an interface that's dead,
probably just causing skb leaks.

johannes

