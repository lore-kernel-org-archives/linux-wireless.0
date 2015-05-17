Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:47489 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbbEQQNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 12:13:36 -0400
Date: Sun, 17 May 2015 19:05:13 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 drops packet with old IV after rekeying
Message-ID: <20150517160513.GA13175@w1.fi> (sfid-20150517_181341_378721_1F3F7277)
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
 <1431674716.2426.2.camel@sipsolutions.net>
 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
 <1431714949.2117.0.camel@sipsolutions.net>
 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
 <1431806229.2120.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431806229.2120.6.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 16, 2015 at 09:57:09PM +0200, Johannes Berg wrote:
> The key index is used for GTK rekeying. The spec makes no provision for
> seamless PTK rekeying, it's simply not supported.
> 
> There was/is work in progress to actually change that, but I haven't
> seen anything definitive. Jouni might know more.

It was added in IEEE Std 802.11-2012. Search for Extended Key ID for
Individually Addressed Frames subfield of the RSN Capabilities field (a
field within RSN element).

I'm not sure whether anyone has implemented this, but anyway, we could
relatively easily add support for this with mac80211 + hostapd +
wpa_supplicant combination. Though, probably that would end up depending
on a new driver capability flag, so only with some drivers.

> As I said, I believe at this point the only way to fix this bug is to
> try to drop *old* key packets immediately, but it's difficult to ensure
> this. Effectively, it would require synchronising RX vs. key
> installation.

I did not look at the details of the reported issue. Was this an issue
in a received frame with old key being processed by mac80211 after key
change and while doing that, ending up configuring incorrect (way too
large) RX PN for the new key?

Dropping the frames with the old key would be one option, but not really
ideal. A somewhat nicer option would be to add a concept of generation
to the key (i.e., the 1st, 2nd, ... key using key index N) and with the
help of drivers (that can do this), indicate which generation of the key
was used for RX decryption. This would allow proper replay protection
for both keys if we were to store copies of the RX counters for both the
previous and current key in mac80211.

-- 
Jouni Malinen                                            PGP id EFC895FA
