Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53324 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759261AbZEKTio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 15:38:44 -0400
Date: Mon, 11 May 2009 22:38:29 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] nl80211/mac80211: Fix station mode key setup issues
Message-ID: <20090511193829.GA7236@jm.kir.nu>
References: <20090511185754.653711567@atheros.com> <1242070018.3873.47.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242070018.3873.47.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 09:26:58PM +0200, Johannes Berg wrote:

> Looks good to me, thanks. One thing I'm not sure about though, is there
> no need to push the RSC to hardware for some hw crypto designs? But even
> if needed that can always be a separate patch.

There probably would be for drivers that take care of replay protection
(which should be identifiable by searching for RX_FLAG_IV_STRIPPED). It
looks like we have couple of such drivers. However, I'm not familiar
with any of those, so someone more familiar with the driver code and
hardware/firmware design should take a look.

As an example, drivers/net/wireless/wl12xx/acx.h seems to define a
set_key structure (struct acx_set_key) that includes fields for RSC.
However, the values seem to be defined based on TKIP, so I don't know
how they would be used for CCMP (and not even the byte order that would
be used for TKIP). In other words, this type of cases will require
proper testing to make sure that we do not break frame reception
completely.

Anyway, it sounds reasonable to add rsc into struct ieee80211_key_conf
to provide this information for the driver. That should be a relatively
simple patch to add the RSC field into struct ieee80211_key_conf and
fill it with the initial value in ieee80211_key_alloc(). This will waste
some memory per key, but is likely the simplest way of implementing
this.

-- 
Jouni Malinen                                            PGP id EFC895FA
