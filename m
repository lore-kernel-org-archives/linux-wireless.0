Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48823 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbbEQTO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 15:14:58 -0400
Message-ID: <1431890093.2129.4.camel@sipsolutions.net> (sfid-20150517_211501_816671_D7F1F29E)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 17 May 2015 21:14:53 +0200
In-Reply-To: <20150517160513.GA13175@w1.fi>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	 <1431674716.2426.2.camel@sipsolutions.net>
	 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	 <1431714949.2117.0.camel@sipsolutions.net>
	 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
	 <1431806229.2120.6.camel@sipsolutions.net> <20150517160513.GA13175@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-17 at 19:05 +0300, Jouni Malinen wrote:
> On Sat, May 16, 2015 at 09:57:09PM +0200, Johannes Berg wrote:
> > The key index is used for GTK rekeying. The spec makes no provision for
> > seamless PTK rekeying, it's simply not supported.
> > 
> > There was/is work in progress to actually change that, but I haven't
> > seen anything definitive. Jouni might know more.
> 
> It was added in IEEE Std 802.11-2012. Search for Extended Key ID for
> Individually Addressed Frames subfield of the RSN Capabilities field (a
> field within RSN element).

Ah, I had searched for (very briefly) for key IV things but hadn't found
it. Good to know.

> I'm not sure whether anyone has implemented this, but anyway, we could
> relatively easily add support for this with mac80211 + hostapd +
> wpa_supplicant combination. Though, probably that would end up depending
> on a new driver capability flag, so only with some drivers.

Indeed, although for most drivers it could be implemented using SW
crypto in the transition period. Then again, the old key would probably
stick around for quite a while (practically forever, until the next
rekey) so that's not a good idea.

I guess we should consider that. I believe our device would support HW
crypto in this scenario as well, although I'm not completely sure and
would obviously have to test it.

> I did not look at the details of the reported issue. Was this an issue
> in a received frame with old key being processed by mac80211 after key
> change and while doing that, ending up configuring incorrect (way too
> large) RX PN for the new key?

Yes.

> Dropping the frames with the old key would be one option, but not really
> ideal. A somewhat nicer option would be to add a concept of generation
> to the key (i.e., the 1st, 2nd, ... key using key index N) and with the
> help of drivers (that can do this), indicate which generation of the key
> was used for RX decryption. This would allow proper replay protection
> for both keys if we were to store copies of the RX counters for both the
> previous and current key in mac80211.

That would be good, but I can't think of any driver that'd be able to
implement it. In software crypto we could (theoretically) try both keys,
i.e. structure the transition as having both keys valid in software, and
switch over once decrypting with the old one fails and succeeds with the
new one. However, that seems like a lot of effort for very little gain.

johannes

