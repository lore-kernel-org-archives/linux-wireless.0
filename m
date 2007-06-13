Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-71.dex002.intermedia.net ([64.78.20.99]:17123 "EHLO
	dhost002-71.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbXFMDnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 23:43:46 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Tue, 12 Jun 2007 20:44:31 -0700
To: David Lamparter <lists@diac24.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Atheros Turbo modes / API [was: nl80211]
Message-ID: <20070613034431.GE895@devicescape.com>
References: <1181380044.3566.11.camel@johannes.berg> <20070609114907.GC10836@charon.n2.diac24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070609114907.GC10836@charon.n2.diac24.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 09, 2007 at 01:49:07PM +0200, David Lamparter wrote:
> > +               case MODE_ATHEROS_TURBO:

> > Are those Atheros Turbo modes actually useful these days in mac80211? If
> > so we probably should support them in nl80211 too, but I don't really
> > know, I guess Jouni is the only one who ever used them?

> Jouni? Is this (a) still in use, and (b) how should it be made available to
> userspace? We could either add additional modes to nl80211_phymode -or- add
> a NL80211_ATTR_ATHEROS_TURBO as boolean tag -or- plunge it into debugfs...

Well, some people may use Atheros Turbo mode, but taken into account
that this is a vendor specific extension and 802.11n will take care of
similar enhancements in a standard way, I don't think there is much
point in trying to maintain any level of support for these in mac80211.

For this reason, most of the Atheros specific stuff was already removed
and only some references to the special channels remained. I haven't
bothered importing support for these into hostapd either. Consequently,
I would just go ahead and remove all references to MODE_ATHEROS_TURBO,
MODE_ATHEROS_TURBOG, and related functionality and comments from
mac80211.

-- 
Jouni Malinen                                            PGP id EFC895FA
