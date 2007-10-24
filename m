Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbXJXPLl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 11:11:41 -0400
Subject: Re: Proc usage (was: Re: [ath5k-devel] [PATCH 3/3] consistently
	use ath5k in printks)
From: Dan Williams <dcbw@redhat.com>
To: Eric W Anderson <Eric.Anderson@Colorado.EDU>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <471EC944.2010700@colorado.edu>
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
	 <1192619652.8841.13.camel@johannes.berg>
	 <1192630172.10567.29.camel@localhost.localdomain>
	 <43e72e890710170719o120f9dbak34f33d8218038dfc@mail.gmail.com>
	 <40f31dec0710170926p3847b796gdf52f80297b7c117@mail.gmail.com>
	 <471EC944.2010700@colorado.edu>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 11:10:01 -0400
Message-Id: <1193238601.2557.43.camel@localhost.localdomain> (sfid-20071024_161209_594456_3F4CD70D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-23 at 22:25 -0600, Eric W Anderson wrote:
> I realize that primary role of the driver is for actual use, rather than for
> research, but...  It's very useful in experiments to have /proc entries for all
> the settings that you don't normally think of as tunable.  (e.g. turning off
> antenna diversity, or ACKs, or changing the CCA thresholds). I'd really hate for
> knobs to go away because someone things they're not "really" needed, or because
> they're not worth merging into the new configuration framework.

debugfs is one answer here.  The point is to make it 110% crystal clear
what options are long-term supportable as API/ABI and which ones are
not.

> -Eric
> 
> Nick Kossifidis wrote:
> > 2007/10/17, Luis R. Rodriguez <mcgrof@gmail.com>:
> >> On 10/17/07, Dan Williams <dcbw@redhat.com> wrote:
> >>> On Wed, 2007-10-17 at 13:14 +0200, Johannes Berg wrote:
> >>>> On Tue, 2007-10-16 at 22:20 +0900, Bruno Randolf wrote:
> >>>>
> >>>>> the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys/dev/ath5k/
> >>>> Ok, and why exactly is there a proc interface at all?
> >>> Yeah, it needs to die, we're not adding new proc interfaces to the
> >>> kernel.  Stuff should be evaluated to see whether it's _really_ needed,
> >>> and if for some reason it is, merged into mac80211 or cfg80211, and then
> >>> if that doesn't work,
> >> Agreed 200%. Die proc usage!
> >>
> >>> then maybe something in sysfs.
> >> Nah, configfs for generic configuration of kernel objects. I already
> >> have such module but it just had regdomain support. I plan on adding
> >> add/remove iface.
> >>
> >>   Luis
> >> -
> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > I've already removed the whole proc stuff along with debug stuff in
> > base.c in madwifi-svn, i'll port patch here asap.
> > 
> 

