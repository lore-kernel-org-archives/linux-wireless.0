Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:43050 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760182AbYD2SKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 14:10:34 -0400
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: make rx radiotap header more flexible
Date: Tue, 29 Apr 2008 20:10:21 +0200
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
References: <20080407042541.9026.59360.stgit@localhost> <20080407042549.9026.81997.stgit@localhost> <1209243111.10943.61.camel@johannes.berg>
In-Reply-To: <1209243111.10943.61.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200804292010.21367.bruno@thinktube.com> (sfid-20080429_201052_234684_7576D01B)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 April 2008 22:51:50 Johannes Berg wrote:
> > +static void
> > +ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
> > +				 struct sk_buff *skb,
> > +				 struct ieee80211_rx_status *status,
> > +				 struct ieee80211_rate *rate,
> > +				 int rtap_len)
> > +{
> > +	struct ieee80211_radiotap_header *rthdr;
> > +	unsigned char *pos;
> > +
> > +	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
> > +	memset(rthdr, 0, rtap_len);
> > +
> > +	/* radiotap header, set always present flags */
> > +	rthdr->it_present =
> > +		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
> > +			    (1 << IEEE80211_RADIOTAP_RATE) |
> > +			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
> > +			    (1 << IEEE80211_RADIOTAP_ANTENNA) |
> > +			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
>
> Is all this alignment-safe now? Not sure it was before but it'd be nice
> if we could fix it up.
>
> Radiotap explicitly allows you to have a longer length than you need so
> maybe we should just make sure to align things?

are you talking about the alignment of the radiotap header itself? no, i just 
took care about the alignment requirements of the radiotap fields, relative 
to the start of radiotap. but it would be easy to add some additional length 
in ieee80211_rx_radiotap_len() and just leave that empty at the end.

i think i don't understand all alignment requirements though...

bruno
