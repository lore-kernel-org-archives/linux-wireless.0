Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60163 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbZBKSE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 13:04:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 10:04:28 -0800
Date: Wed, 11 Feb 2009 23:34:17 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Make sure non-HT connection when
	IEEE80211_STA_TKIP_WEP_USED is set
Message-ID: <20090211180417.GA21695@vasanth-laptop> (sfid-20090211_190433_281044_AD380535)
References: <1234370929-19519-1-git-send-email-vasanth@atheros.com> <1234371464.16004.11.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234371464.16004.11.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 10:27:44PM +0530, Johannes Berg wrote:
> On Wed, 2009-02-11 at 22:18 +0530, Vasanthakumar Thiagarajan wrote:
> > It is possible that some broken AP might send HT IEs in it's
> > assoc response even though the STA has not sent them in assoc req
> > when WEP/TKIP is used as pairwise cipher suite. Also it is important
> > to check this bit before enabling ht mode in beacon receive path.
> > 
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  net/mac80211/mlme.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 169f10c..e7aafb0 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -1532,7 +1532,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
> >  					 elems.wmm_param_len);
> >  
> >  	if (elems.ht_info_elem && elems.wmm_param &&
> > -	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED))
> > +	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
> > +	    !(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED))
> 
> Maybe we should have a separate flag for _REQUESTED_HT? I'm thinking
> here that possibly we might be adding more conditions under which we do
> not request HT?
> 
> Otherwise, looks ok to me.

That's right. We can even remove IEEE80211_STA_TKIP_WEP_USED if we
introduce a generic flag to enable ht, but this cleanup can be in a
separate patch. Thanks for the comments.

Vasanth


