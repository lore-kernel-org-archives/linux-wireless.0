Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43009 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbYFQSTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:19:08 -0400
Date: Tue, 17 Jun 2008 21:18:05 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 7/7] 802.11w: Configuration of MFP
	disabled/optional/required
Message-ID: <20080617181805.GE4974@jm.kir.nu> (sfid-20080617_201911_310955_3ED2316F)
References: <20080617154008.883383150@localhost> <20080617160027.897662688@localhost> <1213722570.3803.92.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213722570.3803.92.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 17, 2008 at 07:09:30PM +0200, Johannes Berg wrote:

> > +#define IEEE80211_MFP_DISABLED 0
> > +#define IEEE80211_MFP_OPTIONAL 1
> > +#define IEEE80211_MFP_REQUIRED 2
> > +	int mfp; /* management frame protection */
> 
> Maybe an enum would be good?

Sure.

> > --- wireless-testing.orig/net/mac80211/wext.c
> > +++ wireless-testing/net/mac80211/wext.c
> > +	case IW_AUTH_MFP:
> > +		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
> > +		    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
> > +			sdata->u.sta.mfp = data->value;
> 
> and shouldn't that be used somewhere?

Well, yes. This is still somewhat unclear area to me and in particular,
I'm not sure whether the IW_AUTH_MFP parameter will end up being used in
mac80211. It would be used if the kernel code (or firmware in fullmac
designs) would select the AP. mac80211 may need another configuration
item to set whether MFP was actually negotiated during association. This
has changed a bit in the latest 802.11w draft and I haven't yet updated
my implementation to use the new mechanism. For the time being,
sdata->u.sta.mfp is more or less a placeholder for something that may
disappear or change to something else..

-- 
Jouni Malinen                                            PGP id EFC895FA
