Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1GNQlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 12:41:20 -0400
Date: Thu, 14 Jul 2011 22:11:24 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/3] wireless: Add 40MHz Intolerance support to HT
 capablities.
Message-ID: <20110714164123.GA25573@vmraj-lnx.users.atheros.com> (sfid-20110714_184124_385792_23E706C1)
References: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1310559873-10314-2-git-send-email-rmanohar@qca.qualcomm.com>
 <1310638284.3874.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1310638284.3874.8.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 12:11:24PM +0200, Johannes Berg wrote:
> On Wed, 2011-07-13 at 17:54 +0530, Rajkumar Manoharan wrote:
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> More description would be nice. I don't think I get it.
> 
> > +++ b/include/net/cfg80211.h
> > @@ -128,6 +128,8 @@ enum ieee80211_channel_flags {
> >   * @beacon_found: helper to regulatory code to indicate when a beacon
> >   *	has been found on this channel. Use regulatory_hint_found_beacon()
> >   *	to enable this, this is useful only on 5 GHz band.
> > + * @is_40mhz_intolerant: one of the bss in this channel disallows the use of
> > + *	20/40 MHz BSS. this will be used by Intolerant Channel Report.
> 
> I'm not convinced this should a channel thing here?
> 
> > @@ -1746,6 +1749,7 @@ struct wiphy_wowlan_support {
> >   *	add to probe request frames transmitted during a scan, must not
> >   *	include fixed IEs like supported rates
> >   * @coverage_class: current coverage class
> > + * @dot11FortyMHzIntolerant: Enable/Disable Forty MHz Intolerance
> 
> that variable name is ... highly unusual. please make it match its
> surroundings better.
>
OK
> > @@ -1806,6 +1810,7 @@ struct wiphy {
> >  	u32 frag_threshold;
> >  	u32 rts_threshold;
> >  	u8 coverage_class;
> > +	bool dot11FortyMHzIntolerant;
>  
> Ok so in struct wiphy, to me means that the *driver* said it was 40MHz
> intolerant? That makes no sense, why would the driver want to say that
> *statically*? I can see maybe dynamically, but statically?
>
Yes. I should be set dynamically. As of now, this field is not configurable.
Will send the followup patch for nl80211 support.
> > @@ -412,6 +412,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
> >  	rdev->wiphy.frag_threshold = (u32) -1;
> >  	rdev->wiphy.rts_threshold = (u32) -1;
> >  	rdev->wiphy.coverage_class = 0;
> > +	rdev->wiphy.dot11FortyMHzIntolerant = false;
> 
> not really necessary, but I guess it's ok.
>  
> > @@ -532,6 +533,8 @@ int wiphy_register(struct wiphy *wiphy)
> >  			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> >  			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
> >  		}
> > +		if (wiphy->dot11FortyMHzIntolerant)
> > +			sband->ht_cap.cap |= IEEE80211_HT_CAP_40MHZ_INTOLERANT;
> 
> I don't get this. All you use this variable for is setting a
> variable ... that the driver could already have set. Seems completely
> pointless.
>
I agree.

--
Rajkumar

