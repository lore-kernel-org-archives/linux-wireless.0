Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:19299 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753153Ab1AZJVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 04:21:18 -0500
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0635023675
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 18:21:16 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 6/6] ath: Fix WEP hardware encryption
Date: Wed, 26 Jan 2011 18:21:09 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6> <201101261138.53169.br1@einfach.org> <1296030588.3635.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296030588.3635.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101261821.09481.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed January 26 2011 17:29:48 Johannes Berg wrote:
> On Wed, 2011-01-26 at 11:38 +0900, Bruno Randolf wrote:
> > Even without my patch, WEP does not work with multiple vifs.
> > (As far as i understand it, with WEP the lookup is just done based on the
> > key index in the WLAN header field. mac80211 (or is it hostapd?) sets up
> > both keys for both interfaces with a key index of 0, which causes the
> > lookup to go to the same key for both vifs. I guess mac80211 or hostapd
> > would need to be changed to use different key indices for different vif
> > WEP keys, but then of course we can only use 4 different WEP keys in
> > sum, and not 4 different WEP keys per vif. No big deal imho.)
> 
> Are you saying software WEP in mac80211 is broken with multiple VIFs? I
> find that hard to believe :-)

No, i'm talking about the combination of HW encryption in ath5k and mac80211. 
I never tested mac80211 software WEP alone with multiple VIFs.

bruno
