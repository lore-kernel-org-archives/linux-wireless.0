Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:40929 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbYDCQyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 12:54:05 -0400
Date: Thu, 3 Apr 2008 19:52:55 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Miles Lane <miles.lane@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX
	non-WEP frame, but expected encryption"
Message-ID: <20080403165255.GI2025@jm.kir.nu> (sfid-20080403_175408_862538_7DFFEDCB)
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com> <1207226756.3636.66.camel@johannes.berg> <1207231313.3636.100.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1207231313.3636.100.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 03, 2008 at 04:01:53PM +0200, Johannes Berg wrote:

> > > My log files are filling up with these messages:
> > >        [ 8722.198929] wlan0: RX non-WEP frame, but expected encry=
ption
> > >        [ 8726.506345] __ratelimit: 14 messages suppressed

Is the network using WEP or TKIP/CCMP?

> Ok, I got packets from Miles, and this is what I found:
>=20
> IEEE 802.11 Data, Flags: ......F.
>     Type/Subtype: Data (0x20)
>     Frame Control: 0x0208 (Normal)
>     Duration: 44
>     Destination address: <his STA MAC>
>     BSS Id: <his Netgear AP>
>     Source address: <his Netgear AP>
>     Fragment number: 0
>     Sequence number: 3874
> Logical-Link Control
>     DSAP: NULL LSAP (0x00)
> Data (1472 bytes)
> 0000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   .............=
=2E..
> * all zeroes

> Note how the LLC header is also all-zeroes. =EF=BB=BFAlso note how th=
e duration
> field is totally bogus. The sequence number is actually correct.

What's wrong with the duration field value? The dump here does not
indicate which transmit rate was used, so I don't know what TX rate the
ACK would use, but 44 sounds like a reasonable duration value for
802.11g rates..

> Does anybody have an explanation for that except that the AP software=
 is
> messing it up?

Looks like an interesting AP behavior to me..

> In any case, I suppose the message in question isn't actually necessa=
ry.
> I'll make it depend on verbose debugging maybe.

Yes, that sounds reasonable. The AP should not be sending this kind of
crap, but well, what can you do if it does.. In theory, this could also
be showing up in multi-SSID configuration when another SSID is
configured to use unencrypted frames (though, that would cause interop
issues in association for number of clients..).

--=20
Jouni Malinen                                            PGP id EFC895F=
A
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
