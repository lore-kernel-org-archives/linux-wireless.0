Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3654 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbXHQOQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 10:16:05 -0400
Date: Fri, 17 Aug 2007 09:49:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, jbenc@suse.cz,
	Michael Buesch <mb@bu3sch.de>, Daniel Drake <dsd@gentoo.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: mac80211 IPv6 problems
Message-ID: <20070817134941.GB6090@tuxdriver.com>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <1186094778.6701.6.camel@shinybook.infradead.org> <20070803005517.GA4261@tuxdriver.com> <200708030102.17358.flamingice@sourmilk.net> <20070806170500.GE6442@tuxdriver.com> <1187311977.23489.93.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187311977.23489.93.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 17, 2007 at 02:52:56AM +0200, Johannes Berg wrote:
> On Mon, 2007-08-06 at 13:05 -0400, John W. Linville wrote:
> 
> > --- a/net/mac80211/ieee80211.c
> > +++ b/net/mac80211/ieee80211.c
> > @@ -3030,9 +3030,10 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
> >  		memcpy(dst, hdr->addr1, ETH_ALEN);
> >  		memcpy(src, hdr->addr3, ETH_ALEN);
> >  
> > -		if (sdata->type != IEEE80211_IF_TYPE_STA) {
> > +		if (sdata->type != IEEE80211_IF_TYPE_STA ||
> > +		    (is_multicast_ether_addr(dst) &&
> > +		     !compare_ether_addr(src, dev->dev_addr)))
> >  			return TXRX_DROP;
> 
> I can confirm that this works (applies if you s/ieee80211.c/rx.c/) for
> IPv6 link local addresses, and it's definitely the right thing to do
> here.

Yes, seems so.  FWIW, this patch is in later Fedora kernels.

Unfortunately (due to the ieee80211.c -> rx.c issue you mentioned)
applying this to 2.6.23 conflicts with patches already queued for
2.6.24.  Since my experiments show that git doesn't help much in this
instance, I'll need to work something out with Dave M. if we are to
get this into 2.6.23.

If nothing else, I suppose we can just wait for 2.6.23 and send this
patch to -stable.  Would that burn anyone's biscuits?

John
-- 
John W. Linville
linville@tuxdriver.com
