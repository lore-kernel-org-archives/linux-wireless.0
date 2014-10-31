Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51586 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 11:12:42 -0400
Message-ID: <1414768360.8048.4.camel@umadbro> (sfid-20141031_161259_078593_BE450D0E)
Subject: Re: [PATCH 1/2] cfg80211: 802.11p OCB mode handling
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
	Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
	laszlo.virag@commsignia.com,
	Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Fri, 31 Oct 2014 16:12:40 +0100
In-Reply-To: <1414761237.3014.27.camel@jlt4.sipsolutions.net>
References: <1414665771-8371-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1414665771-8371-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141030_114322_295525_C7C629F8) <1414761237.3014.27.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-31 at 14:13 +0100, Johannes Berg wrote:
> On Thu, 2014-10-30 at 11:42 +0100, Rostislav Lisovy wrote:
> > @@ -2093,6 +2102,7 @@ enum nl80211_iftype {
> >  	NL80211_IFTYPE_P2P_CLIENT,
> >  	NL80211_IFTYPE_P2P_GO,
> >  	NL80211_IFTYPE_P2P_DEVICE,
> > +	NL80211_IFTYPE_OCB,
> 
> This is causing a bunch of compiler warnings (warning: enumeration value
> ‘NL80211_IFTYPE_OCB’ not handled in switch, e.g. in mac80211/iface.c)
> which I think you should address in this patch. That'll mean that you
> modify even mac80211 and potentially some drivers, but I think that's
> the right thing to do in this patch since it's the one changing the API
> to introduce the new value.

I was aware of the warnings but thought this is the chicken-egg problem
which can't be solved properly.
Fortunately there is no driver affected.

> I think there's one thing you forgot in this patch, namely
> __cfg80211_leave() which you also need to make the __ version of the
> leave function non-static for due to locking.

Correct. Adding to the next version of the patchset.

Thank you;
Rostislav

