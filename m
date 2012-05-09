Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:53302 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab2EIMSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 08:18:31 -0400
Date: Wed, 9 May 2012 14:18:27 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120509121827.GD5472@yumi.tdiedrich.de> (sfid-20120509_141836_304930_E3F2762B)
References: <20120509105719.GA24457@yumi.tdiedrich.de>
 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336564773.4323.19.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-05-09 at 12:57 +0200, Tobias Diedrich wrote:
> 
> > I've bisected a problem with running rt3052-based APs on recent
> > OpenWRT down to this commit: 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63
> > "mac80211: manage AP netdev carrier state"
> > 
> > If I revert this commit (and also fix the max_power issue), AP-mode
> > works fine, but if I leave it in, association to the AP times out.
> > 
> > (The AP-side hostapd claims WPA authentication was successful, but
> > the client never connects)
> > 
> > (Note: I haven't gotten around to testing a non-rt28xx based AP yet,
> > so I'm only assuming this affects only rt28xx, maybe it does affect
> > other chipsets as well)
> 
> Works fine here, but I don't see how that patch could affect rt2x00
> only.
> 
> You're going to have to give us more details about the failure, like the
> version of hostapd at least. The output of "ip monitor" would also be
> helpful.

The hostapd package Makefile says:

PKG_NAME:=hostapd
PKG_VERSION:=20120428
PKG_RELEASE:=1
PKG_REV:=1f0cc27eb98f7d1af9c64d0752238184cbdb9a24

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=git://w1.fi/srv/git/hostap.git

Can't look at ip output right now as I'm still at work and the
AP is switched off.

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
