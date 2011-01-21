Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43852 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1AUKBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 05:01:05 -0500
Received: by iyj18 with SMTP id 18so1502121iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 02:01:05 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19769.22827.129895.302810@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 15:30:11 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [RFC/WIP 23/33] ath9k_htc: Enable AP mode
In-Reply-To: <1295599422.3831.0.camel@jlt3.sipsolutions.net>
References: <19768.63310.121728.324735@gargle.gargle.HOWL>
	<1295599422.3831.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2011-01-21 at 08:32 +0530, Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> > index dc96c06..b4ae719 100644
> > --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> > +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> > @@ -753,7 +753,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
> >  
> >  	hw->wiphy->interface_modes =
> >  		BIT(NL80211_IFTYPE_STATION) |
> > -		BIT(NL80211_IFTYPE_ADHOC);
> > +		BIT(NL80211_IFTYPE_ADHOC) |
> > +		BIT(NL80211_IFTYPE_AP);
> 
> It'd be kinda nice if that could be made dependent on firmware
> capability bits or version since otherwise everybody will think they
> have it ... and it will not work?

Well, the current firmware has no version mechanism and this series requires
the new FW for non-AP modes too. I am aware that breaking compatibilty with existing FW
is frowned upon, but unfortunately this is required since the command layout has
been cleaned up. I'll add a check to bail out at driver load time when the old FW is used.

Sujith
