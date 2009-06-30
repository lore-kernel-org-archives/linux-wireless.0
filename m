Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56425 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZF3Nxl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 09:53:41 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 06:53:45 -0700
Date: Tue, 30 Jun 2009 19:22:07 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 8/8 v3] mac80211: re-add HT disabling
Message-ID: <20090630135207.GC24667@vasanth-laptop>
References: <20090630115245.675553951@sipsolutions.net> <20090630115303.111250594@sipsolutions.net> <20090630132547.GB24667@vasanth-laptop> <1246369077.16643.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1246369077.16643.10.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 07:07:57PM +0530, Johannes Berg wrote:
> On Tue, 2009-06-30 at 18:55 +0530, Vasanthakumar Thiagarajan wrote:
> > On Tue, Jun 30, 2009 at 05:22:53PM +0530, Johannes Berg wrote:
> > > The IEEE80211_STA_TKIP_WEP_USED flag is used internally to
> > > disable HT when WEP or TKIP are used. Now that cfg80211 is
> > > giving us the required information, we can set the flag
> > > appropriately again.
> > > 
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > > ---
> > >  net/mac80211/cfg.c |   15 ++++++++++++++-
> > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > 
> > > --- wireless-testing.orig/net/mac80211/cfg.c    2009-06-30 13:25:43.000000000 +0200
> > > +++ wireless-testing/net/mac80211/cfg.c 2009-06-30 13:25:45.000000000 +0200
> > > @@ -1228,7 +1228,7 @@ static int ieee80211_assoc(struct wiphy
> > >                            struct cfg80211_assoc_request *req)
> > >  {
> > >         struct ieee80211_sub_if_data *sdata;
> > > -       int ret;
> > > +       int ret, i;
> > > 
> > >         sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > > 
> > > @@ -1236,6 +1236,19 @@ static int ieee80211_assoc(struct wiphy
> > >             !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
> > >                 return -ENOLINK; /* not authenticated */
> > > 
> > > +       sdata->u.mgd.flags &= ~IEEE80211_STA_TKIP_WEP_USED;
> > > +
> > > +       if (req->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40 ||
> > > +           req->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP ||
> > > +           req->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)
> > > +               sdata->u.mgd.flags |= IEEE80211_STA_TKIP_WEP_USED;
> > 
> > No, we have to disable HT only when WEP/TKIP is used as pairwise,
> > not used as group cipher.
> 
> I thought it was both, but I guess group doesn't actually matter. OTOH,
> this seems to match the standard better (HT STA is not allowed to use
> TKIP/WEP)?

Section 8.1.5 of 11n draft-8.0 says
"An HT STA shall not use either of the pairwise cipher suite
selectors: "Use group cipher suite" or TKIP to communicate
with another HT STA".

That seems to only talk about pairwise, I'm missing something here?.

Vasanth


