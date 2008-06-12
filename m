Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45206 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYFLFeI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 01:34:08 -0400
Date: Thu, 12 Jun 2008 08:33:24 +0300
From: Jouni Malinen <j@w1.fi>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, shemminger@linux-foundation.org,
	johannes@sipsolutions.net, bridge@linux-foundation.org
Subject: Re: [RFC] Do not activate promiscuous mode on wlan interfaces for
	bridging.
Message-ID: <20080612053323.GC4919@jm.kir.nu> (sfid-20080612_073412_575723_94578AB6)
References: <1213232760.6645.24.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213232760.6645.24.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 06:06:00PM -0700, Luis Carlos Cobo wrote:

> It seems that it is not really necessary to activate promiscuous mode when
> attaching a wlan interface to a bridge, and it causes unnecessary processing
> overhead to any wlan device.

Yes, agreed, IEEE 802.11 interfaces should not be changed into "monitor
mode" that receives all frames on the channel for normal bridging.
Whether the "promiscuous mode" is really a suitable name for this mode
is another question, though, since there are more ways to be
promiscuous in wireless networks than wired.. ;-)

> Please let me know what you think of this patch and whether it could interfere
> with any functionality.

Its desired goal sounds reasonable. I'm not sure whether
dev->ieee80211_ptr is guaranteed to be set with all drivers and all
configurations, though. Anyway, this should not break normal IEEE 802.11
bridging cases.

> +	 * 802.11 interfaces working as Access Points do not need to be set to
> +	 * promiscuous mode for bridging, as every frame is addressed to them.
> +	 *
> +	 * Bridging of 802.11 interfaces which are not in AP mode is not
> +	 * supported.

This is not strictly speaking correct. 4-address frame format (WDS) can
be used in other (non-AP) modes, too. Anyway, they do not require the
interface to be in promiscuous mode since addr1 of the frames is the
unicast address of the receiving device regardless of the original
destination address.

-- 
Jouni Malinen                                            PGP id EFC895FA
