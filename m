Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:38218 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130Ab1JXMQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 08:16:10 -0400
Date: Mon, 24 Oct 2011 15:15:59 +0300
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Fix STA supported rate configuration with dummy
 entry
Message-ID: <20111024121559.GA4821@jm.kir.nu> (sfid-20111024_141613_906231_551596A0)
References: <20111023194059.GA18385@jm.kir.nu>
 <CA+XVXfdP5VjMLaYxh6Saa+SM+cDUG+h18L0ixheQmaAo+yQX+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfdP5VjMLaYxh6Saa+SM+cDUG+h18L0ixheQmaAo+yQX+Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 24, 2011 at 01:59:45PM +0200, Arik Nemtsov wrote:
> Note that the sta-rates are not really required before second addition
> (which also sets them). Initially the STA is not authorized for direct
> Tx (as determined by the WLAN_STA_TDLS_PEER_AUTH bit).
> We don't expect direct frames during link setup.

OK.. Though, there can still be some direct frames like TDLS Discovery
Response.

> The STA is added to let us know we should drop all non-setup packets
> between TDLS peers currently in link setup. We could have used a
> different indication, but the STA entry is make the most sense here
> since it is automatically cleaned up when we are disconnected from the
> AP (as all TDLS state should be).

When you say "drop", I hope you mean "buffer for later delivery" and
when you say "non-setup packets", I hope you mean "non-setup Data
frames" ;-).

> How about this one instead (tested hwsim with it):
> Subject: [RFC] mac80211: init rate-control for TDLS sta when supp-rates are
>  known
> 
> Initialize rate control algorithms only when supported rates are known
> for a TDLS peer sta. Direct Tx between peers is not allowed before the
> link is enabled. In turn, this only occurs after a change_station()
> call that sets supported rates.

I guess this could be fine, too, assuming TDLS is the only use case for
this type of changing of STA supported rates.

-- 
Jouni Malinen                                            PGP id EFC895FA
