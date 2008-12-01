Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13204 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYLADQB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2008 22:16:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2008 19:16:01 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18739.22072.703735.202769@gargle.gargle.HOWL> (sfid-20081201_041608_585967_9DC8059B)
Date: Mon, 1 Dec 2008 08:42:56 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 4/5] ath9k: Add initial layout for an ath9k specific
	debugfs mechanism
In-Reply-To: <1227907682.3479.4.camel@johannes.berg>
References: <18736.8527.664371.487538@gargle.gargle.HOWL>
	<1227907682.3479.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2008-11-28 at 22:20 +0530, Sujith wrote:
> 
> > +	sc->sc_debug.debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
> > +	if (!sc->sc_debug.debugfs_root)
> > +		goto err;
> > +
> > +	sc->sc_debug.debugfs_phy = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
> > +						      sc->sc_debug.debugfs_root);
> 
> Any reason not to use /debug/ieee80211/<phyN>/<KBUILD_MODNAME>/...?
> Can't say I really care though.
> 

I figured that since most of the drivers create their root directory in /debug/,
I would do the same. But yeah, ieee80211/... makes sense too, I'll move it later on. :)

Sujith
