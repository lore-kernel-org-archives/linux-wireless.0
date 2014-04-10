Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbaDJH74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:59:56 -0400
Message-ID: <1397116783.4757.4.camel@jlt4.sipsolutions.net> (sfid-20140410_100007_697411_435A9509)
Subject: Re: [PATCH 2/2] cfg80211: ignore invalid BSSIDs when looking for
 BSSes
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org, stefan.pietsch@lsexperts.de
Date: Thu, 10 Apr 2014 09:59:43 +0200
In-Reply-To: <53464190.1030202@meshcoding.com>
References: <1397075965-2684-1-git-send-email-johannes@sipsolutions.net>
	 <1397075965-2684-2-git-send-email-johannes@sipsolutions.net>
	 <53464190.1030202@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-10 at 09:00 +0200, Antonio Quartulli wrote:
> On 09/04/14 22:39, Johannes Berg wrote:
> > diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> > index 7d09a712cb1f..746c56ebd66c 100644
> > --- a/net/wireless/scan.c
> > +++ b/net/wireless/scan.c
> > @@ -540,6 +540,8 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
> >  			continue;
> >  		if (channel && bss->pub.channel != channel)
> >  			continue;
> > +		if (!is_valid_ether_addr(bss->pub.bssid))
> > +			continue;
> 
> Wouldn't it be better to prevent such entry to end up in the bss list at
> all? (i.e. filtering during the scan?)

I thought about that, but I'm not so sure.

On the one hand, that would make sense since it's unusable, on the other
hand it could cause confusion if you don't see some other network that
you expect to show up ...

And then again, if you can click the network in the UI and then it won't
connect to it, that also causes confusion. I'm not sure what the best
way is ...

johannes

