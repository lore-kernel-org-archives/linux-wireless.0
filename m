Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44664 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0FNHSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 03:18:00 -0400
Subject: Re: [PATCH 3/3] mac80211: remove BSS from cfg80211 list when
 leaving IBSS
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276497207.3926.9.camel@jlt3.sipsolutions.net>
References: <1276496145-5623-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276496145-5623-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276496145-5623-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276496145-5623-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276497207.3926.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 10:16:45 +0300
Message-Id: <1276499805.4314.16.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-14 at 08:33 +0200, ext Johannes Berg wrote:
> On Mon, 2010-06-14 at 09:15 +0300, Teemu Paasikivi wrote:
> > Remove BSS from cfg80211 BSS list if we are only member in IBSS when
> > leaving it.
> > 
> > Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> > ---
> >  net/mac80211/ibss.c |   33 +++++++++++++++++++++++++++++++++
> >  1 files changed, 33 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> > index ff91265..6d5489b 100644
> > --- a/net/mac80211/ibss.c
> > +++ b/net/mac80211/ibss.c
> > @@ -969,6 +969,39 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
> >  {
> >  	struct sk_buff *skb;
> >  
> > +	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
> 
> remove that empty live please
> 
> > +	struct ieee80211_local *local = sdata->local;
> > +	struct cfg80211_bss *cbss;
> > +	struct ieee80211_channel *chan = NULL;
> > +	const u8 *bssid = NULL;
> > +	u16 capability;
> > +	int active_ibss = 0;
> > +
> > +
> > +	active_ibss = ieee80211_sta_active_ibss(sdata);
> > +
> > +	if (!active_ibss) {
> > +		capability = WLAN_CAPABILITY_IBSS;
> > +		if (ifibss->privacy)
> > +			capability |= WLAN_CAPABILITY_PRIVACY;
> > +		if (ifibss->fixed_bssid)
> > +			bssid = ifibss->bssid;
> 
> Don't we update ifibss->bssid even if it's not fixed?
> 
> > +		if (ifibss->fixed_channel)
> > +			chan = ifibss->channel;
> 
> > +		if (!is_zero_ether_addr(ifibss->bssid))
> > +			bssid = ifibss->bssid;
> 
> I guess we do, but can it really ever be zeroed? Or does that happen
> when we haven't even joined yet? But in that case you'd pass a NULL
> bssid into get_bss() which would return a random one ... shouldn't you
> rather not do anything in that case? Like making the first condition
> 
> if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
> 
> 
> and then never worry about the bssid again?
> 
> johannes
> 

Valid points. Back to the drawing board. I'll rework this a little bit.


Teemu


