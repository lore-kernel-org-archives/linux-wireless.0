Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55894 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3KNOWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:22:45 -0500
Received: by mail-pb0-f51.google.com with SMTP id xa7so2068260pbc.24
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 06:22:44 -0800 (PST)
Date: Thu, 14 Nov 2013 06:33:25 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 5/5] cfg80211: DFS check dfs_region before usage
Message-ID: <20131114143323.GD19070@garbanzo.do-not-panic.com> (sfid-20131114_152248_446720_7C296A2F)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com>
 <1384378173.28806.22.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384378173.28806.22.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 13, 2013 at 10:29:33PM +0100, Johannes Berg wrote:
> On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> > Check the DFS region before channel availability check
> > or declaring a channel as DFS usable.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> > ---
> >  net/wireless/chan.c    | 8 ++++++++
> >  net/wireless/nl80211.c | 5 +++++
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> > index 78559b5..4e6eaa0 100644
> > --- a/net/wireless/chan.c
> > +++ b/net/wireless/chan.c
> > @@ -517,10 +517,18 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
> >  	struct ieee80211_sta_ht_cap *ht_cap;
> >  	struct ieee80211_sta_vht_cap *vht_cap;
> >  	u32 width, control_freq;
> > +	enum nl80211_dfs_regions dfs_region;
> >  
> >  	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> >  		return false;
> >  
> > +	rtnl_lock();
> > +	dfs_region = reg_get_dfs_region(wiphy);
> > +	rtnl_unlock();
> 
> This I'm fairly sure will just deadlock.

OK :D

Januz seems to note this may not be required anyway too, so
hopefully that's true.

> Anyway, this and patch 4 together can be done MUCH simpler by just
> having the driver advertise the bitmap of what it supports before
> registration, and then not using it if CERTIFICATION_ONUS isn't enabled
> or something.

OK, good idea.

 Luis
