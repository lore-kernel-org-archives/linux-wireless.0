Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0LCMxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 07:53:08 -0500
Subject: Re: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>, Greg KH <greg@kroah.com>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
References: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 13:53:00 +0100
Message-ID: <1291380780.3499.119.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 17:31 -0800, Bing Zhao wrote:
> The mwifiex driver for Marvell 802.11n chipset SD8787 is available at
> git://git.marvell.com/mwifiex.git. Both STA mode and Mobile hotspot
> mode are supported.
> 
> git pull git://git.marvell.com/mwifiex.git master

Please post patches, not git trees.

But since John is holding us somewhat hostage by saying he'll consider
merging this, and apparently you don't have the taste to even consider
the review comments you have gotten before, I took a brief look to
*prove* that this driver cannot be merged as is.


Here's a short list of things to fix:
 * __packed
 * ENTER/LEAVE must go
 * enum mwifiex_status must go -- use errno
 * private ioctls were grandfathered in,
   but aren't allowed in new drivers
 * do you really need your own crypto mode definitions?
 * your pseudo-kerneldoc comments "/**" don't conform
   to the right format
 * private locking wrappers are not allowed (mwifiex_spin_lock etc)
 * private debugging like PRINTM is not allowed
 * there's exactly one space after "#include"
 * struct eth_803_hdr? are you serious? and you even have
   it twice: struct eth_II_hdr
 * enum ieee_types_elementid_e must go
 * similarly, almost all of ieee.h
 * no bitfields and BIG_ENDIAN_BITFIELD allowed
 * not all allocations are GFP_ATOMIC, use wisely and
   GFP_KERNEL in most places
 * a wifi driver that's doing stuff with sockets (nl_sk, sk_socket)?
   explain, in MUCH detail (or preferably just get rid of it)
 * there's debugfs_remove_recursive
 * some functions like mwifiex_is_network_compatible need to be broken
   into smaller ones to avoid the crap indentation they have
 * mwifiex_uap_ap_cfg_parse_data. Must I say more?
 * struct mwifiex_buffer *mbuf? Is this a BSD driver? We have SKBs, get
   rid of this. (Oh and skbs have a CB)
 * mwifiex_init_lock/mwifiex_free_lock -- I'd laugh in your general
   direction if it wasn't so sad
 * mwifiex_util_peek_list etc.: learn about list.h
 * mwifiex_init_timer -- still sad, dynamically allocating timers? just
   like spinlocks, they can be embedded and make your code simpler

Ok good enough, that should keep you busy for a while...

The above is might be a good basis for a TODO file for staging...

johannes

