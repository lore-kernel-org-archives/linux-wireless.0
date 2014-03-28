Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaC1IhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 04:37:22 -0400
Message-ID: <1395995839.4175.5.camel@jlt4.sipsolutions.net> (sfid-20140328_093730_006847_962ED9FD)
Subject: Re: [PATCH] mac80211: protect AP VLAN list with local->mtx
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Mar 2014 09:37:19 +0100
In-Reply-To: <CA+BoTQnZGEYXT8nEvvr6iuX+r7aHU1mt6X58yWHja=W3jq+EGw@mail.gmail.com> (sfid-20140320_081256_908709_730DC511)
References: <1394021648-22605-1-git-send-email-michal.kazior@tieto.com>
	 <1395238008.4142.15.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnZGEYXT8nEvvr6iuX+r7aHU1mt6X58yWHja=W3jq+EGw@mail.gmail.com>
	 (sfid-20140320_081256_908709_730DC511)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-03-20 at 08:12 +0100, Michal Kazior wrote:
> On 19 March 2014 15:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-03-05 at 13:14 +0100, Michal Kazior wrote:
> >> It was impossible to change chanctx of master AP
> >> for AP VLANs because the copy function requires
> >> RTNL which can't be simply taken in mac80211 code
> >> due to possible deadlocks.
> >>
> >> This is required for future chanctx reservation
> >> that re-bind vifs to new chanctx. This requires
> >> safe AP VLAN iteration without RTNL.
> >>
> >> Now VLANs can be iterated while holding either
> >> RTNL or local->mtx because the list is modified
> >> while holding both of these locks.
> >
> > No objection really, but maybe it would make more sense to use
> > iflist_mtx?
> 
> I used local->mtx because it seemed easier at the time (the lock is
> already used on all related codepaths).
> 
> Using local->iflist_mtx would add another mutex to for
> csa/reservation. I think it shouldn't be hard to do it though. Should
> I re-spin? (this will probably need a re-spin of Luca's reservation
> patchset and my RFC).

No, it's fine, I was just curious.

johannes

