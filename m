Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:13701 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752055AbYAYGQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 01:16:13 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Fri, 25 Jan 2008 15:16:13 +0900
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <20080118125252.6455.41047.stgit@one> <200801241443.40067.bruno@thinktube.com> <1201185002.3454.90.camel@johannes.berg>
In-Reply-To: <1201185002.3454.90.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801251516.13743.bruno@thinktube.com> (sfid-20080125_061617_056512_2CF7AE8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 23:30:02 Johannes Berg wrote:
> > > I think that needs a check "&& ssid_len" or something. Someone's bound
> > > to try making an IBSS with a hidden SSID and we really don't want that
> > > to work.
> >
> > why? i know, hidden SSIDs are pretty useless but if somedody wants
> > them... why would you want to make extra effort so it does not work?
>
> Uh, I think you should rethink your question. Consider two different
> hidden-SSID IBSSes.

that's the same case as two different IBSS with the same non-zero ESSID.

> > > > +			printk(KERN_DEBUG "%s: beacon TSF higher than local TSF"
> > > > +				" -> IBSS merge with BSSID %s\n",
> > > > +				dev->name, print_mac(mac, mgmt->bssid));
> > >
> > > No way. At the very least you need to ratelimit this.
> >
> > well, it should not happen very often, and for debugging i would like to
> > see this case. would
>
> Well, "should" is pretty soft. It can also be trivially triggered as a
> DOS attack by sending beacons with fake timestamps.

ok, i agree that a ratelimit is necessary.

> >  			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> > 				printk(KERN_DEBUG "%s: beacon TSF higher than "
> >
> > be ok with you?
>
> Maybe && would be better?

well, i would like to see every merge when debugging IBSS, hence the OR.
if you want i can remove that message when IBSS debugging is disabled.

bruno



