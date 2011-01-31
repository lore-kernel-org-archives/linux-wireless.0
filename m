Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49049 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab1AaLyc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:54:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:54:13 -0800
Date: Mon, 31 Jan 2011 17:23:41 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: disable ps if an AP type vif is present
Message-ID: <20110131115341.GB14176@vmraj-lnx.users.atheros.com>
References: <1296394571-3317-1-git-send-email-rmanoharan@atheros.com>
 <1296473558.3812.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1296473558.3812.15.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 05:02:38PM +0530, Johannes Berg wrote:
> On Sun, 2011-01-30 at 19:06 +0530, Rajkumar Manoharan wrote:
> > PS should be disabled for AP type. So while recalculating
> > PS, AP vif type should be taken into account.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> > ---
> >  net/mac80211/mlme.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 3221069..1fd6023 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -601,6 +601,12 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
> >  	list_for_each_entry(sdata, &local->interfaces, list) {
> >  		if (!ieee80211_sdata_running(sdata))
> >  			continue;
> > +		if (((sdata->vif.type == NL80211_IFTYPE_AP) ||
> > +		     (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) &&
> > +		    !sdata->vif.p2p) {
> > +			count = 0;
> > +			break;
> 
> I'd leave out the P2P check for now -- as soon as you have more than one
> interface we don't go to PS,
Not exactly. we are counting only station type, though we have multi vifs.
>and we don't have NoA things etc. yet.
the p2p check means that infra AP only.

> Also, the VLAN check can go, since if there's a VLAN then there must
> also be an AP.
> 
> Setting count to 0 is likely to be confusing to somebody trying to
> implement multi-interface PS though, a comment would be good.
Sure. 

--
Rajkumar
