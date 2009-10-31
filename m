Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:61366 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZJaJqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 05:46:21 -0400
Received: by fg-out-1718.google.com with SMTP id d23so165974fga.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 02:46:25 -0700 (PDT)
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256967782.3555.69.camel@johannes.local>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939549.31271.14.camel@maxim-laptop>
	 <1256967782.3555.69.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 11:46:21 +0200
Message-ID: <1256982381.3089.10.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-10-31 at 06:43 +0100, Johannes Berg wrote: 
> On Fri, 2009-10-30 at 23:52 +0200, Maxim Levitsky wrote:
> > >From 1d13f997f652c7e632d4ddb053df3f3fad78da23 Mon Sep 17 00:00:00 2001
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Fri, 30 Oct 2009 23:36:20 +0200
> > Subject: [PATCH 1/2] Allow scanning while in authenticated only state
> > 
> > Since ifmgd->work_list is {ab}used as a storage for authenticated,
> > but not associated access points (this is done using idle work items),
> > allow scanning if all work items are in this state.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> I don't think this is needed. While not _strictly_ wrong, I still
> dislike the additional complexity.
> 
> I think you just need this wpa_supplicant patch:
> http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59/deauth-on-disassoc.patch

Nope, this patch doesn't help.

if I remove the bssid_changed, then it seems to work when connecting to
same AP, but still scan hangs when connecting to different.

The problem is that wpa_supplicant doesn't do deauthentication
explicitly, and I was told that this is right thing to do. This confuses
all the nl80211 and mac80211...


I also think that its best just to do both deauthentication and
disassociation in same time.

Yet, I think this path is ok, that is, when you disallow scanning, you
can be sure that wifi will be dead, and this patch catches the situation
when it for sure will disallowed  forever.


Best regards,
Maxim Levitsky


> 
> johannes
> 
> > ---
> >  net/mac80211/scan.c |   12 +++++++++---
> >  1 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> > index c46ac01..c932765 100644
> > --- a/net/mac80211/scan.c
> > +++ b/net/mac80211/scan.c
> > @@ -418,6 +418,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
> >  {
> >  	struct ieee80211_local *local = sdata->local;
> >  	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> > +	struct ieee80211_mgd_work *wk, *tmp;
> >  	int rc;
> >  
> >  	if (local->scan_req)
> > @@ -450,9 +451,14 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
> >  	if (req != local->int_scan_req &&
> >  	    sdata->vif.type == NL80211_IFTYPE_STATION &&
> >  	    !list_empty(&ifmgd->work_list)) {
> > -		/* actually wait for the work it's doing to finish/time out */
> > -		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
> > -		return 0;
> > +
> > +		/* actually wait for the work it's doing to finish/time out*/
> > +		list_for_each_entry_safe(wk, tmp, &ifmgd->work_list, list) {
> > +			if (wk->state != IEEE80211_MGD_STATE_IDLE) {
> > +				set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
> > +				return 0;
> > +			}
> > +		}
> >  	}
> >  
> >  	if (local->ops->hw_scan)
> 


