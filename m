Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:42700 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbYHGQc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 12:32:59 -0400
Date: Thu, 7 Aug 2008 19:32:13 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
Message-ID: <20080807163213.GA6602@jm.kir.nu> (sfid-20080807_183302_111266_3E10F272)
References: <20080807134043.GA5138@jm.kir.nu> <1218116906.23048.179.camel@johannes.berg> <20080807141508.GB5138@jm.kir.nu> <1218118732.23048.183.camel@johannes.berg> <20080807142732.GC5138@jm.kir.nu> <1218120388.23048.189.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1218120388.23048.189.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 07, 2008 at 04:46:28PM +0200, Johannes Berg wrote:
> On Thu, 2008-08-07 at 17:27 +0300, Jouni Malinen wrote:
> > Well, I don't actually need it per-BSS for hardware that I'm most likely
> > to work with ;-), but yeah, this is a per-BSS parameter, so in that
> > sense your patch is doing the correct thing.
> 
> Yeah, ok, I guess I don't really care, do whichever way you want. It'd
> be a bit strange to set it with cfg80211 per BSS and have it show up on
> different BSSes, but that's about it, and a little strangeness hasn't
> hurt anyone ;)

It looks like it is easiest to make this a per-BSS parameter now and use
bss_info_changed() for it. However, I'm planning on leaving the other
parts of your patch out from the initial version. In other words, I will
not remove IEEE80211_CONF_SHORT_SLOT_TIME now (I just added a TODO note
to get it removed once drivers have been converted; mac80211 was never
actually setting this, anyway). This avoids the need to modify all
drivers with this change. In addition, I'm leaving out the client MLME
stuff for now, but the notification part will be available for it once
the MLME code is added.

-- 
Jouni Malinen                                            PGP id EFC895FA
