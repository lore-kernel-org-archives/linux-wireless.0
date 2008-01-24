Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:48532 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752434AbYAXFnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 00:43:49 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Thu, 24 Jan 2008 14:43:39 +0900
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <20080118125252.6455.41047.stgit@one> <1201099729.3454.17.camel@johannes.berg>
In-Reply-To: <1201099729.3454.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801241443.40067.bruno@thinktube.com> (sfid-20080124_054352_257425_5261E97C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello johannes!

i appreciate your feedback, but on a second thought, let me question this:

On Wednesday 23 January 2008 23:48:49 Johannes Berg wrote:
> Comments on the code now.
>
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -80,6 +80,9 @@ static void ieee80211_rx_bss_put(struct net_device
> > *dev, struct ieee80211_sta_bss *bss); static int
> > ieee80211_sta_find_ibss(struct net_device *dev,
> >                                    struct ieee80211_if_sta *ifsta);
> > +static int ieee80211_sta_join_ibss(struct net_device *dev,
> > +                                  struct ieee80211_if_sta *ifsta,
> > +                                  struct ieee80211_sta_bss *bss);
>
> No way, order the code properly, this mess needs to be cleaned up not
> added to.

do you care to explain what's so bad about function declarations?

> > +	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
> > +	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
> > +	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> > +	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0)
> > {
>
> I think that needs a check "&& ssid_len" or something. Someone's bound
> to try making an IBSS with a hidden SSID and we really don't want that
> to work.

why? i know, hidden SSIDs are pretty useless but if somedody wants them... why 
would you want to make extra effort so it does not work?

> > +			printk(KERN_DEBUG "%s: beacon TSF higher than local TSF"
> > +				" -> IBSS merge with BSSID %s\n",
> > +				dev->name, print_mac(mac, mgmt->bssid));
>
> No way. At the very least you need to ratelimit this.

well, it should not happen very often, and for debugging i would like to see 
this case. would

 			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
				printk(KERN_DEBUG "%s: beacon TSF higher than "

be ok with you?

regards,
bruno
