Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNKMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:12:39 -0500
Subject: Re: [RFC] mac80211: reply to directed probes in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
References: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimEDvmp2RbLXdOf8vRrjzBKd+rLwqoreX+x3EdB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:12:37 +0100
Message-ID: <1297678357.3785.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 16:41 +0530, Mohammed Shafi wrote:
> On Tue, Feb 1, 2011 at 6:19 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > At least the WMM spec says we should reply to
> > unicast probe request frames that go to us.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/mac80211/ibss.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- wireless-testing.orig/net/mac80211/ibss.c   2011-02-01 12:58:16.000000000 +0100
> > +++ wireless-testing/net/mac80211/ibss.c        2011-02-01 13:47:44.000000000 +0100
> > @@ -689,7 +689,7 @@ static void ieee80211_rx_mgmt_probe_req(
> >               mgmt->bssid, tx_last_beacon);
> >  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
> >
> > -       if (!tx_last_beacon)
> > +       if (!tx_last_beacon && !(status->rx_flags & IEEE80211_RX_RA_MATCH))
> >                return;
> >
> >        if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
> 
> Hi Johannes,
>              tested with the same thing (in addition of passing the
> rx_status structure) and it is working fine.

Yeah, I clearly missed that, guess I wasn't paying attention.

The real question though is -- do we want/need this? I can only find
reference to this behaviour in the WMM spec.

johannes

