Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2FSQxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 12:53:17 -0400
Message-ID: <1340124795.4482.16.camel@jlt3.sipsolutions.net> (sfid-20120619_185320_152884_9129B5BB)
Subject: Re: [RFC 13/17] nl80211: move scan API to wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Jun 2012 18:53:15 +0200
In-Reply-To: <4FE0ADB6.5080105@broadcom.com>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	 <1340117456-10154-14-git-send-email-johannes@sipsolutions.net>
	 <4FE0ADB6.5080105@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 18:49 +0200, Arend van Spriel wrote:
> On 06/19/2012 04:50 PM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The new P2P Device will have to be able to scan for
> > P2P search, so move scanning to use struct wireless_dev
> > instead of struct net_device.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> > diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > index 404e87c..a507b6e 100644
> > --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > @@ -908,11 +908,11 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
> >  	return 0;
> >  }
> >  
> > -static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
> > +static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
> >  				struct cfg80211_scan_request *request)
> 
> Lot of indent issues in this variety of drivers. Do you care to fix that
> as well or leave it to .... whom it may concern.

I think the maintainers of the respective drivers should fix those. I'm
just making their drivers continue to compile, not pretty :-)

johannes

