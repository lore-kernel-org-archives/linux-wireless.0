Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:41072 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYDGOIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 10:08:05 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2004885fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 07:08:02 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Date: Mon, 7 Apr 2008 16:10:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <200804051931.58895.IvDoorn@gmail.com> <200804071534.38526.IvDoorn@gmail.com> <1207576041.12481.21.camel@johannes.berg>
In-Reply-To: <1207576041.12481.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200804071610.47598.IvDoorn@gmail.com> (sfid-20080407_150823_309885_A82A3E69)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> For the TX path, I don't think a memmove() of the header further down=
 is
> really expensive, it should be within the CPU cache since we operate =
on
> the skb header a lot. However, you'd have to undo that too before TX
> status reporting to get radiotap working properly :/
>=20
> > I agree, but overall I think this would mean for rt2x00 it will be =
easier to stop
> > sending the skb->data directly to the USB host and use the prealloc=
ated DMA
> > instead.
> > Especially the RX path could benefit since otherwise it will be con=
tinuously using
> > memmove on the header and payload to insert the IV and have the pay=
load 4-byte aligned.
>=20
> How would you go about handling out-of-band IV in the RX path? In the=
 TX
> path, I can see how you could do that, but in RX?

I'm not sure if I understand completely what you mean but rt61pci/rt73u=
sb hardware does the following:

1) Receive frame
2) Determine key from register
3) Put IV/EIV into descriptor
4) Decrypt
5) Notifies driver about the frame +  decryption status

So the IV/EIV is only provided for information about the description. I=
t will require some testing
to see what happened to the IV/EIV when decryption failed...

Side-information:
rt2500pci and rt2500usb handle this differently because they require th=
e driver to set
the key before a frame can be decrypted.

> In any case, if you can make usable patches for out-of-band IV I'm no=
t
> totally against it, but I'd like to keep the overhead as low as
> possible. In particular, I was thinking of embedding tx_conf into
> skb->cb[] so you wouldn't have space in there for the IV.

Well as an alternative to adding it to tx_control, perhaps a callback f=
unction for drivers
could be provided? At the moment mac80211 calls:

ieee80211_tkip_add_iv(pos, key,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0(u8) (key->=
u.tkip.iv16 >> 8),
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0(u8) (((key=
->u.tkip.iv16 >> 8) | 0x20) &
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 =A0 =A00x7f),
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0(u8) key->u=
=2Etkip.iv16);

to insert the IV into the skb, if the driver could get a calback functi=
on that calls the above
function and writes the result into a char* buffer you get the same eff=
ect except that the
driver can put the iv wherever it wants.
That way rt2x00 doesn't have to set the IEEE80211_KEY_FLAG_GENERATE_IV =
flag, and
can request the IV manually from mac80211.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
