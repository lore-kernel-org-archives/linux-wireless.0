Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:60514 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXIECtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 22:49:45 -0400
Date: Tue, 4 Sep 2007 19:49:30 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
Message-ID: <20070905024930.GG5273@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg> <20070904011648.GX1835@jm.kir.nu> <1188913335.9942.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188913335.9942.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2007 at 03:42:15PM +0200, Johannes Berg wrote:
> On Mon, 2007-09-03 at 18:16 -0700, Jouni Malinen wrote:
> > Where are things like NL80211_ATTR_IFNAME and
> > NL80211_CMD_ADD_VIRTUAL_INTERFACE defined? I would assume these are from
> > linux/nl80211.h, but where should I get the version that includes these?
> 
> You have to use the one from wireless-dev as we don't ship it from
> mainline yet.

I was trying to use wireless-dev.. Which branch includes the values
shown above? I don't see them in either master or even everything..
(git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git)

> > This is making it a bit difficult to build driver_devicescape.c and same
> > goes for the requirement for svn trunk version of libnl.. Any idea how
> > much code from libnl is needed here? Would it be major effort to do the
> > needed calls without having to rely on libnl at or (or at least not on
> > an unreleased svn trunk version)?
> 
> There's a whole bunch of code in libnl I use, all the generic netlink
> family resolving etc. Maybe Thomas can prerelease a libnl with generic
> netlink support?

OK. If there were a pre-release version, that would likely make this
quite a bit easier. Gentoo actually includes 1.0-pre6 which is the
latest pre-release and as such, I was kind of hoping for it to be new
enough. Then again, once I looked at the release date, I noticed it's
already a year old.. I don't really want to depend on this unless there
is a good likelyhood of there being a proper release with the needed
functionality in somewhat near future.

-- 
Jouni Malinen                                            PGP id EFC895FA
