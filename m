Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZJXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 04:23:06 -0500
Subject: Re: [ath5k-devel] [PATCH 6/6] ath: Fix WEP hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net
In-Reply-To: <201101261821.09481.br1@einfach.org>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
	 <201101261138.53169.br1@einfach.org>
	 <1296030588.3635.12.camel@jlt3.sipsolutions.net>
	 <201101261821.09481.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 10:23:02 +0100
Message-ID: <1296033782.3635.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 18:21 +0900, Bruno Randolf wrote:
> On Wed January 26 2011 17:29:48 Johannes Berg wrote:
> > On Wed, 2011-01-26 at 11:38 +0900, Bruno Randolf wrote:
> > > Even without my patch, WEP does not work with multiple vifs.
> > > (As far as i understand it, with WEP the lookup is just done based on the
> > > key index in the WLAN header field. mac80211 (or is it hostapd?) sets up
> > > both keys for both interfaces with a key index of 0, which causes the
> > > lookup to go to the same key for both vifs. I guess mac80211 or hostapd
> > > would need to be changed to use different key indices for different vif
> > > WEP keys, but then of course we can only use 4 different WEP keys in
> > > sum, and not 4 different WEP keys per vif. No big deal imho.)
> > 
> > Are you saying software WEP in mac80211 is broken with multiple VIFs? I
> > find that hard to believe :-)
> 
> No, i'm talking about the combination of HW encryption in ath5k and mac80211. 
> I never tested mac80211 software WEP alone with multiple VIFs.

But wasn't Jouni saying that ath9k currently uses SW crypto so that it
doesn't have to worry about any of this -- and that that would be
broken?

johannes

