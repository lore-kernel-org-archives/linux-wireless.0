Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:48367 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXHUDHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 23:07:14 -0400
Date: Mon, 20 Aug 2007 20:05:59 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Volker Braun <volker.braun@physik.hu-berlin.de>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCHv3] mac80211: dynamic wep
Message-ID: <20070821030559.GL1415@jm.kir.nu>
References: <1187151162.3253.18.camel@thinkpad> <1187308221.23489.91.camel@johannes.berg> <1187360200.4417.32.camel@thinkpad> <1187363345.6090.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187363345.6090.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 17, 2007 at 05:09:05PM +0200, Johannes Berg wrote:
> On Fri, 2007-08-17 at 10:16 -0400, Volker Braun wrote:
> > Now granted, Cisco also violates it, but in a way
> > that is never visible to standards-compliant STAs. We must set the
> > keyindex to zero on outgoing pairwise key-encrypted data, but that is
> > kind of irrelevant since the AP is forced to ignore that key index on
> > receive.
> 
> But then I don't understand why we try to set a non-zero key index for
> the key.

If I remember correctly, Cisco APs in IEEE 802.1X/dynamic WEP
configuration rotate between key indexes 0 and 1 for broadcast/multicast
keys and indexes 2 and 3 for unicast. In standard IEEE 802.1X, doing
rekeying for broadcast keys by using two key indexes can be used to
allow the change to happen without any packets being lost (send the new
key first to all clients and only after that start using the new key).

I would assume that Cisco is trying to do the same kind of smooth
rekeying for unicast here (not that I have verified that this is the
case, but that sounds semi-logical). Consequently, we would actually
need to configure two pairwise keys at the same time and not only set
the non-zero key index but to actually use these keys when decrypting
frames.. My guess would be that this is expected to work by using
broadcast WEP keys instead of unicast keymapping keys, but it is
somewhat broken design. Anyway, that is what has been deployed in number
of networks. Eventually, this will hopefully go away once the networks
are updated to WPA/WPA2, but some organizations take long time to change
this kind of things..

wpa_supplicant is just blindly following what the AP tells it to when
setting keys (EAPOL-Key frames include the key index). Consequently, the
driver/mac80211 ends up being told to use this non-zero key indexes for
unicast keys.

-- 
Jouni Malinen                                            PGP id EFC895FA
