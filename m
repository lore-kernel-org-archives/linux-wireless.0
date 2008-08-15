Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluegiga.fi ([194.100.31.45]:56571 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYHOSIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 14:08:39 -0400
Subject: Re: mac80211 interprets missing TX_ACK flag as tx fail
From: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
In-Reply-To: <200808151958.46302.IvDoorn@gmail.com>
References: <1218813764.22679.11.camel@virkkmi-linux>
	 <200808151844.13657.IvDoorn@gmail.com>
	 <1218822632.22679.73.camel@virkkmi-linux>
	 <200808151958.46302.IvDoorn@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 15 Aug 2008 21:08:36 +0300
Message-Id: <1218823716.22679.78.camel@virkkmi-linux> (sfid-20080815_200841_871622_C0DD7DCB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-15 at 19:58 +0200, Ivo van Doorn wrote:
> On Friday 15 August 2008, Mikko Virkkil=C3=A4 wrote:
> > I'm moving the conversation over from rt2400-devel to linux-wireles=
s.
> > The last message (as of this writing) from the earlier conversation=
 at
> > rt2400-devel can be found at http://tinyurl.com/6p9n7g with some mo=
re
> > details.
> >=20
> > So to summarize the situation:=20
> >=20
> > - the rt73usb driver (in rt2x00) doesn't set IEEE80211_TX_STAT_ACK
> >   because "frames which are uploaded to the hardware are not guaren=
teed
> >   to be acked".
>=20
> rt2500usb suffers from the same issue.
>=20
> > - The mac80211 layer will set the IEEE80211_RADIOTAP_F_TX_FAIL if t=
he=20
> >   IEEE80211_TX_STAT_ACK flag is missing.=20
> > - hostapd will interpret the IEEE80211_RADIOTAP_F_TX_FAIL as a fail=
ure
> >   to send
> >=20
> > This all results in hostapd reporting "MGMT (TX callback) fail" and
> > making rt73usb not work in AP mode.=20
> >=20
> > I'm hoping that some decision can be reached on how to fix this so =
that
> > AP mode will work with the rt73.=20
> >=20
> > Just off the top of my head, one way of fixing this would be to mak=
e
> > IEEE80211_TX_CTL_NO_ACK also work the other way around: Now it is u=
sed
> > to tell the lower level not to wait for an ACK. Perhaps it could al=
so be
> > used by the lower level to tell higher levels that no ACK is ever g=
oing
> > to come e.g. because the hardware is incapable of supplying TX ACKs=
=2E The
> > mac80211 layer would be changed to check for IEEE80211_TX_CTL_NO_AC=
K. If
> > the flag was set it would skip setting IEEE80211_RADIOTAP_F_TX_FAIL=
 even
> > when the IEEE80211_TX_STAT_ACK is missing.
>=20
> Actually this isn't the complete picture, what you might need is a ne=
w flag
> IEEE80211_TX_CTL_UNKNOWN which then informs mac80211 that the
> frame has an unknown status, and that is something that could be pass=
ed on to
> userspace through radiotap later.
>=20
> This is better then setting a global "supports ACK reporting" flag, b=
ecause in case
> of rt61 one every x frames also has an unknown status because the txd=
one interrupt
> isn't happening for that frame. So that means you definately need a p=
er-frame flag
> to tell if the frame was acked, not-acked or if the status was unknow=
n.
>=20
> Ivo

>From what I understand the IEEE80211_TX_CTL_NO_ACK which is in the
flags of the ieee80211_tx_info struct, could be set from the driver for
each frame just as currently (not) done with the IEEE80211_TX_STAT_ACK
flag.=20

- Mikko
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
