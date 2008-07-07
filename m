Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37890 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbYGGRD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 13:03:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/1 V2] mac80211: Fix ieee80211_rx_reorder_ampdu: ignore QoS null packets
Date: Mon, 7 Jul 2008 19:02:51 +0200
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
References: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com> <1215447824.14247.2.camel@brick>
In-Reply-To: <1215447824.14247.2.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807071902.51683.mb@bu3sch.de> (sfid-20080707_190329_073001_4BB30CAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 July 2008 18:23:44 Harvey Harrison wrote:
> On Mon, 2008-07-07 at 15:48 +0300, Tomas Winkler wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > This patch fixes the check at the entrance to ieee80211_rx_reorder_ampdu.
> > This check has been broken by 511fe3f3c4ba0b5b77421336f64a19b6cd00e65f
> > 'mac80211: rx.c use new helpers'
> > 
> Actually, do we want something like this instead:
> 
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 6a88e8f..a6e8214 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -2052,7 +2052,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
> >  	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
> >  
> >  	/* null data frames are excluded */
> > -	if (unlikely(ieee80211_is_nullfunc(hdr->frame_control)))
> > +	if (unlikely(ieee80211_is_qos_nullfunc(hdr->frame_control)))
> >  		goto end_reorder;
> >  
> >  	/* new un-ordered ampdu frame - process it */
> 
> 	if (unlikely(ieee80211_is_data(hdr->frame_control) && (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC))))
> 
> Or wrap the above in a ieee80211_is_data_has_nullfunc() helper?

I think this helper naming is becoming a bit weird and obfuscating.
I'd say just opencode it, if it's only used in a few places.


-- 
Greetings Michael.
