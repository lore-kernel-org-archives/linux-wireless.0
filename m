Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:52718 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932AbXI1BkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 21:40:12 -0400
Date: Thu, 27 Sep 2007 18:39:56 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: A-MSDU deaggregation support
Message-ID: <20070928013956.GK27241@jm.kir.nu>
References: <1189354526.4506.25.camel@johannes.berg> <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com> <1190747966.18521.320.camel@johannes.berg> <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com> <1190792394.18521.354.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190792394.18521.354.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 26, 2007 at 09:39:54AM +0200, Johannes Berg wrote:

> So any STA can actually send EAPOL frames with an arbitrary destination
> MAC address except our own into our 802.3 interface. Hence, it looks
> like the first case above is only for having eapol on mgmt iface.

EAPOL ethertype is not supposed to be bridged, so it would be perfectly
fine dropping these wherever it is most convenient to do.

> The only problem I see with not doing this is that hostapd will have to
> listen for EAPOL frames on all VLAN interfaces but I suppose that is
> doable.

That's fine. This should be doable with just one packet socket that is
not bound to any interface or alternatively with multiple sockets (one
per interface). I wouldn't be too concerned about the extra cost here as
long as the other EAPOL related silliness (e.g., the difference in
encryption of re-keying packets in 802.1X with dynamic WEP vs. WPA).

-- 
Jouni Malinen                                            PGP id EFC895FA
