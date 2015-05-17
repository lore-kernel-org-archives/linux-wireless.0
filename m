Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49183 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbbEQUWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 16:22:24 -0400
Message-ID: <1431894140.2129.20.camel@sipsolutions.net> (sfid-20150517_222229_452527_494DD3B1)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: alexander.wetzel@web.de, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 17 May 2015 22:22:20 +0200
In-Reply-To: <CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com> (sfid-20150517_221304_420222_D8022C07)
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	 <1431674716.2426.2.camel@sipsolutions.net>
	 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	 <1431714949.2117.0.camel@sipsolutions.net>
	 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
	 <1431806229.2120.6.camel@sipsolutions.net> <20150517160513.GA13175@w1.fi>
	 <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>
	 <1431890756.2129.13.camel@sipsolutions.net>
	 <CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com>
	 <1431893157.2129.18.camel@sipsolutions.net>
	 <CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com>
	 (sfid-20150517_221304_420222_D8022C07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-17 at 23:13 +0300, Emmanuel Grumbach wrote:

> >> Yeah - ok. But how come we *already* set the pointer to the new key
> >> while the HW is still successfully decrypting with the old key. This
> >> is the point I can' figure out. I'd expect the transmitting side to
> >> stop using the old key prior to sending the EAPOL (which #triggers the
> >> set key pointer line). So those 2 lines don't make sense to me:
> >>
> >> >  # set key pointer to new key
> >> >  * data RX in HW, decrypt w/ old key, PN=999
> >>
> >> After all, the Rx path is serialized all the way through from the air
> >> to mac80211. The only thing I can think about is that the sending side
> >> is still using the old key *after* it already sent its EAPOL frames.
> >
> > Not sure, isn't the key only installed on EAPOL acknowledgement or so?
> > With PTK rekeying, I'm not really sure what the timing is, and there's
> > not really any way it can be correct (without extended key ID support.)
> 
> Whatever the timing is, since the Rx path is serialized, there
> shouldn't be any timing issues. Or at least, I can't figure out how
> these lines above could be in the order you put them.

I agree that it'll depend on how the key is installed on the sender,
however, I have no idea how that's done and how much potential delay
there is between sending the EAPOL frame and installing the key there.
If you're looking at RX path synchronisation only then you're assuming a
perfect sender, but that clearly cannot be the case.

> > Actually, yes, this *could* happen, in exactly the same way as on the
> > receiver, with hardware crypto that does PN generation in software. Not
> > on iwlwifi, because we copy the key material into the TX command, but on
> > any hardware that uses hw_key_idx to identify the key, and could replace
> > the key:
> >
> >  * mac80211: encrypt TX frame - assign PN, ((tx_info
> > *)skb->cb)->hw_key_idx = 7
> >  * mac80211: replace key with new key
> >    * driver: remove old key from hw accel (hw_key_idx 7)
> >    * driver: insert new key to hw accel (reusing hw_key_idx 7)
> >
> 
> This seems to be exactly what the submitter is mentioning: new key old PN.
> I don't really know how we can determine what key was used though.
> Maybe by just trying to decrypt in wireshark with the new key and
> check.

Then it'd actually be more of a sender problem, not sure how to solve it
there.

johannes

