Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:52158 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYHGOPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 10:15:53 -0400
Date: Thu, 7 Aug 2008 17:15:08 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
Message-ID: <20080807141508.GB5138@jm.kir.nu> (sfid-20080807_161557_895127_C122021C)
References: <20080807134043.GA5138@jm.kir.nu> <1218116906.23048.179.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1218116906.23048.179.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 07, 2008 at 03:48:26PM +0200, Johannes Berg wrote:

> I used to have a patch to move the short-slot stuff in mac80211 to the
> BSS info struct so that drivers that support different slot timing for
> each frame can use it for different virtual BSSes. It no longer applies
> though:
> 
> http://johannes.sipsolutions.net/patches/kernel/all/2008-08-04-12%3a26/013-BROKEN-mac80211-bss-slot-time.patch

I'll take a look at this. I hoped I would not need to go through all
drivers to update the API ;-), but let's see.

> I think you may need to handle the case where dev is a VLAN? Or do we
> want to have these settings per VLAN too? And should we reject them for
> other modes than AP where the AP controls the settings?

I was thinking about this a bit, but since ieee80211_sub_if_data had
them shared for all types on interfaces and there might be some testing
uses for these even outside AP mode, I did not bother adding extra
validation here. At least the three parameters added here won't be
per-VLAN since they are advertised in Beacon frames. Though, maybe the
easiest option would be to limit this for IEEE80211_IF_TYPE_AP for now..

> > + * @NL80211_CMD_SET_BSS: Set BSS attributes for BSS identified by
> > + *	%NL80211_ATTR_IFINDEX.
> 
> Maybe we should have a way to retrieve the settings as well, and that
> could even work in STA mode to see what the AP asked us to do.

I did not see any normal use case for this, i.e., this would be more
like debug information. CTS protection is already exported via debugfs
and the other parameters could fit in there better, too.

> Other than that, looks good to me.

Thanks!

-- 
Jouni Malinen                                            PGP id EFC895FA
