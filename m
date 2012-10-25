Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2JYX6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 19:58:21 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2371910pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 16:58:21 -0700 (PDT)
Date: Thu, 25 Oct 2012 16:58:16 -0700
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/3] mac80211: verify that skb data is present
Message-ID: <20121025235816.GE20609@shredder> (sfid-20121026_015826_185796_8A47607B)
References: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net>
 <1351205200-18094-3-git-send-email-johannes@sipsolutions.net>
 <20121025230505.GD20609@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121025230505.GD20609@shredder>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 25, 2012 at 04:05:05PM -0700, Thomas Pedersen wrote:
> On Fri, Oct 26, 2012 at 12:46:39AM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > A number of places in the mesh code don't check that
> > the frame data is present and in the skb header when
> > trying to access. Add those checks and the necessary
> > pskb_may_pull() calls. This prevents accessing data
> > that doesn't actually exist.
> > 
> > To do this, export ieee80211_get_mesh_hdrlen() to be
> > able to use it in mac80211.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  include/net/cfg80211.h |    9 +++++++++
> >  net/mac80211/rx.c      |   43 +++++++++++++++++++++++++++++++++++++++----
> >  net/wireless/util.c    |    3 ++-
> >  3 files changed, 50 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > index f8cd4cf..7d5b600 100644
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -2652,6 +2652,15 @@ unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
> >  unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc);
> >  
> >  /**
> > + * ieee80211_get_mesh_hdrlen - get mesh extension header length
> > + * @meshhdr: the mesh extension header, only the flags field
> > + *	(first byte) will be accessed
> > + * Returns the length of the extension header, which is always at
> > + * least 6 bytes and at most 18 if address 5 and 6 are present.
> > + */
> > +unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
> > +
> > +/**
> >   * DOC: Data path helpers
> >   *
> >   * In addition to generic utilities, cfg80211 also offers
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 99cdee1..6d1fd39 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -531,6 +531,11 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
> >  
> >  		if (ieee80211_is_action(hdr->frame_control)) {
> >  			u8 category;
> > +
> > +			/* make sure category field is present */
> > +			if (rx->skb->len < IEEE80211_MIN_ACTION_SIZE)
> > +				return RX_DROP_MONITOR;
> > +
> >  			mgmt = (struct ieee80211_mgmt *)hdr;
> >  			category = mgmt->u.action.category;
> >  			if (category != WLAN_CATEGORY_MESH_ACTION &&
> > @@ -1892,6 +1897,20 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
> >  
> >  	hdr = (struct ieee80211_hdr *) skb->data;
> >  	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> > +
> > +	/* make sure fixed part of mesh header is there, also checks skb len */
> > +	if (!pskb_may_pull(rx->skb, hdrlen + 6))
> > +		return RX_DROP_MONITOR;
> > +
> > +	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
> > +
> > +	/* make sure full mesh header is there, also checks skb len */
> > +	if (!pskb_may_pull(rx->skb,
> > +			   hdrlen + ieee80211_get_mesh_hdrlen(mesh_hdr)))
> > +		return RX_DROP_MONITOR;
> > +
> > +	/* reload pointers */
> > +	hdr = (struct ieee80211_hdr *) skb->data;
> >  	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
> >  
> >  	/* frame is in RMC, don't forward */
> > @@ -1913,11 +1932,19 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
> >  		char *mpp_addr;
> >  
> >  		if (is_multicast_ether_addr(hdr->addr1)) {
> > -			mpp_addr = hdr->addr3;
> > -			proxied_addr = mesh_hdr->eaddr1;
> > +			if (mesh_hdr->flags & MESH_FLAGS_AE_A4) {
> > +				mpp_addr = hdr->addr3;
> > +				proxied_addr = mesh_hdr->eaddr1;
> > +			} else {
> > +				return RX_DROP_MONITOR;
> > +			}
> >  		} else {
> > -			mpp_addr = hdr->addr4;
> > -			proxied_addr = mesh_hdr->eaddr2;
> > +			if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
> > +				mpp_addr = hdr->addr4;
> > +				proxied_addr = mesh_hdr->eaddr2;
> > +			} else {
> > +				return RX_DROP_MONITOR;
> > +			}
> 
> This will drop all non-proxied mcast or unicast data frames :)
> 
> It looks like this was already incorrect, but what if you only read the
> eaddrs if the right flag is set? Like:
> 
>  		if (is_multicast_ether_addr(hdr->addr1) &&
> 		    mesh_hdr->flags & MESH_FLAGS_AE_A4) {
> 			mpp_addr = hdr->addr3;
> 			proxied_addr = mesh_hdr->eaddr1;
>  		} else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
> 			mpp_addr = hdr->addr4;
> 			proxied_addr = mesh_hdr->eaddr2;
> 		}

Or even just:

  		if (mesh_hdr->flags & MESH_FLAGS_AE_A4) {
 			mpp_addr = hdr->addr3;
 			proxied_addr = mesh_hdr->eaddr1;
  		} else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
 			mpp_addr = hdr->addr4;
 			proxied_addr = mesh_hdr->eaddr2;
 		}

Should be sufficient since according to table 8-14, those bits are only
used for proxied mcast and unicast data frames, respectively.

Thomas
