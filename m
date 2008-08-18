Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43123 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYHRJvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 05:51:00 -0400
Date: Mon, 18 Aug 2008 12:50:08 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211/cfg80211: Add vif configuration options
Message-ID: <20080818095008.GM7998@jm.kir.nu> (sfid-20080818_115104_910213_CEB44D84)
References: <20080815193324.GH7998@jm.kir.nu> <1218829424.3197.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1218829424.3197.2.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 15, 2008 at 09:43:44PM +0200, Johannes Berg wrote:
> On Fri, 2008-08-15 at 22:33 +0300, Jouni Malinen wrote:

> >   * @change_bss: Modify parameters for a given BSS.
> > + *
> > + * @change_vif: Modify parameters for a given virtual interface.
> 
> That reminds me, we should probably include the "bridge packets" thing
> in the BSS parameters (or here?)

Yes.. Since it is AP only feature, I would add it to change_bss. This
variable is currently per-radio, but it might be reasonable to move it
to sdata. Though, it may be needed for IEEE80211_IF_TYPE_VLAN, too, and
change_bss is now IEEE80211_IF_TYPE_AP-only.. change_vif allows any type
to go through, so maybe that would be easier after all (and then either
just ignore the value for other iface types or make the configuration
attempt fail if this particular attribute is changed for non-AP/VLAN
iftype).

-- 
Jouni Malinen                                            PGP id EFC895FA
