Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:8181 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYGIN4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:56:02 -0400
Received: by nf-out-0910.google.com with SMTP id d3so909474nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 06:56:00 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 16:04:50 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200807091511.14288.IvDoorn@gmail.com> <200807091511.45779.IvDoorn@gmail.com> <200807091538.09387.mb@bu3sch.de>
In-Reply-To: <200807091538.09387.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807091604.50199.IvDoorn@gmail.com> (sfid-20080709_155609_180215_845D7756)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Michael Buesch wrote:
> On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > Currently only beacons generated in AP mode have the software
> > sequence number inserted. This means IBSS and Mesh mode are broken
> > for all hardware that require software sequence numbers.
> 
> Does software seq numbering even work at all?
> What about packets that get sent between the driver requested the
> beacon and the driver does actually queue it?

For rt2x00 the beacon is requested and queued within interrupt context
or during resume when it doesn't allow mac80211 to send any frames yet.

The problem would be when the config_interface() is called, if during that
call mac80211 also sends out TX frames, then you get problems in the
sequence counting.

Ivo

> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> >  net/mac80211/tx.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index 359cb36..0e7e1f3 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -1876,6 +1876,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
> >  		hdr->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
> >  						  IEEE80211_STYPE_BEACON);
> >  
> > +		ieee80211_include_sequence(sdata, hdr);
> > +
> >  		num_beacons = &ifsta->num_beacons;
> >  	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
> >  		/* headroom, head length, tail length and maximum TIM length */
> > @@ -1896,6 +1898,9 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
> >  			cpu_to_le16(local->hw.conf.beacon_int);
> >  		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
> >  
> > +		ieee80211_include_sequence(sdata,
> > +					   (struct ieee80211_hdr *)skb->data);
> > +
> >  		pos = skb_put(skb, 2);
> >  		*pos++ = WLAN_EID_SSID;
> >  		*pos++ = 0x0;
> 
> 
> 


