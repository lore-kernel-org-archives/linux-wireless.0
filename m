Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-9.dex002.intermedia.net ([64.78.21.63]:26365 "EHLO
	dhost002-9.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbXCEQzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 11:55:14 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 5 Mar 2007 08:55:12 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
Subject: Re: Question about PRISM2 header rate field
Message-ID: <20070305165512.GB10947@devicescape.com>
References: <45EA9E39.6080706@warmcat.com> <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com> <200703042210.52534.flamingice@sourmilk.net> <1173094447.6131.56.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173094447.6131.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 05, 2007 at 12:34:07PM +0100, Johannes Berg wrote:

> But if you want to do injection over monitor interfaces we'll need to
> have the stupid mgmt interface hack around forever for the userspace
> MLME so it can receive only management traffic (even the non-promisc
> monitor iface we should have gets *far* too much traffic for a userspace
> MLME)

I'm probably fine with this with Linux socket filter. I haven't verified
this, but I would assume it can match on the 802.11 header frace control
field to select only management frames. I don't think I would like to
see variable length pseudo-header before the 802.11 header, though, in
this case.. It might be possible to parse that in the filter byte code,
but it would certainly be easier if the filter code can just refer to
the beginning of the 802.11 header.

It has been too long since I last used LSF and I think it was only for
matching things in the IP header, so I don't remember what exactly can
be matched in the headers before the IP headert and how easy this would
be in case of monitoring headers. Before throughing away the management
interface, someone would need to verify that this can indeed be done
reasonably.

> Besides, to userspace, this is almost identical. In both cases it opens
> a socket, binds to something (either raw socket bound to netdev or
> netlink socket bound to nl80211) and then stuffs frames into that socket
> with some fixed header format (for most apps anyway)

Well, almost identical still means a change to the kernel-user space
interface.. Though, I think I would be willing to live with the
consequencies in this case assuming we come up with a solution that is
likely to stick for next several years without incompatible changes.

-- 
Jouni Malinen                                            PGP id EFC895FA
