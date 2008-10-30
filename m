Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54907 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbYJ3MPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 08:15:41 -0400
Date: Thu, 30 Oct 2008 14:15:38 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/10] ath9k: add block braces to match indentation
In-Reply-To: <1225367129.3690.40.camel@johannes.berg>
Message-ID: <Pine.LNX.4.64.0810301410420.7072@wrl-59.cs.helsinki.fi> (sfid-20081030_131546_985684_10911895)
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
 <Pine.LNX.4.64.0810301339550.7072@wrl-59.cs.helsinki.fi>
 (sfid-20081030_124200_919823_8E5E3369) <1225367129.3690.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-885134069-1225368938=:7072"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-885134069-1225368938=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 30 Oct 2008, Johannes Berg wrote:

> On Thu, 2008-10-30 at 13:41 +0200, Ilpo Järvinen wrote:
> > This isn't a behavior problem as is, and fixing indentation
> > inconsistency either way would be fine (reindent or braces).
> > 
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> > ---
> >  drivers/net/wireless/ath9k/main.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> > index f05f584..0f67b1b 100644
> > --- a/drivers/net/wireless/ath9k/main.c
> > +++ b/drivers/net/wireless/ath9k/main.c
> > @@ -467,9 +467,10 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
> >  	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
> >  		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
> >  		/* free driver's private data area of tx_info */
> > -		if (tx_info->driver_data[0] != NULL)
> > +		if (tx_info->driver_data[0] != NULL) {
> >  			kfree(tx_info->driver_data[0]);
> >  			tx_info->driver_data[0] = NULL;
> > +		}
> 
> Since kfree(NULL) is fine, how about just removing the if?

Agreed. I had perhaps done too many of these already when I came to this 
one and failed to notice such obviousness... :-)

> Also, this code has been removed in a recent change in the wireless 
> tree, I think (the rate control revamp)

Ok. A bit hard for me to track all the upcoming changes tree wide, I once 
did this kind of things in -next but since it had the break recently I 
didn't remember to return to it.

-- 
 i.
---696208474-885134069-1225368938=:7072--
