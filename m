Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:39579 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYHOXSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 19:18:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so784460nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Aug 2008 16:18:09 -0700 (PDT)
To: Mikko =?utf-8?q?Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>
Subject: Re: mac80211 interprets missing TX_ACK flag as tx fail
Date: Sat, 16 Aug 2008 01:18:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
References: <1218813764.22679.11.camel@virkkmi-linux> <200808151958.46302.IvDoorn@gmail.com> <1218823716.22679.78.camel@virkkmi-linux>
In-Reply-To: <1218823716.22679.78.camel@virkkmi-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200808160118.06439.IvDoorn@gmail.com> (sfid-20080816_011815_867008_0DF008A5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 August 2008, Mikko Virkkil=C3=A4 wrote:
> On Fri, 2008-08-15 at 19:58 +0200, Ivo van Doorn wrote:
> > On Friday 15 August 2008, Mikko Virkkil=C3=A4 wrote:
> > > I'm moving the conversation over from rt2400-devel to linux-wirel=
ess.
> > > The last message (as of this writing) from the earlier conversati=
on at
> > > rt2400-devel can be found at http://tinyurl.com/6p9n7g with some =
more
> > > details.
> > >=20
> > > So to summarize the situation:=20
> > >=20
> > > - the rt73usb driver (in rt2x00) doesn't set IEEE80211_TX_STAT_AC=
K
> > >   because "frames which are uploaded to the hardware are not guar=
enteed
> > >   to be acked".
> >=20
> > rt2500usb suffers from the same issue.
> >=20
> > > - The mac80211 layer will set the IEEE80211_RADIOTAP_F_TX_FAIL if=
 the=20
> > >   IEEE80211_TX_STAT_ACK flag is missing.=20
> > > - hostapd will interpret the IEEE80211_RADIOTAP_F_TX_FAIL as a fa=
ilure
> > >   to send
> > >=20
> > > This all results in hostapd reporting "MGMT (TX callback) fail" a=
nd
> > > making rt73usb not work in AP mode.=20
> > >=20
> > > I'm hoping that some decision can be reached on how to fix this s=
o that
> > > AP mode will work with the rt73.=20
> > >=20
> > > Just off the top of my head, one way of fixing this would be to m=
ake
> > > IEEE80211_TX_CTL_NO_ACK also work the other way around: Now it is=
 used
> > > to tell the lower level not to wait for an ACK. Perhaps it could =
also be
> > > used by the lower level to tell higher levels that no ACK is ever=
 going
> > > to come e.g. because the hardware is incapable of supplying TX AC=
Ks. The
> > > mac80211 layer would be changed to check for IEEE80211_TX_CTL_NO_=
ACK. If
> > > the flag was set it would skip setting IEEE80211_RADIOTAP_F_TX_FA=
IL even
> > > when the IEEE80211_TX_STAT_ACK is missing.
> >=20
> > Actually this isn't the complete picture, what you might need is a =
new flag
> > IEEE80211_TX_CTL_UNKNOWN which then informs mac80211 that the
> > frame has an unknown status, and that is something that could be pa=
ssed on to
> > userspace through radiotap later.
> >=20
> > This is better then setting a global "supports ACK reporting" flag,=
 because in case
> > of rt61 one every x frames also has an unknown status because the t=
xdone interrupt
> > isn't happening for that frame. So that means you definately need a=
 per-frame flag
> > to tell if the frame was acked, not-acked or if the status was unkn=
own.
> >=20
> > Ivo
>=20
> >From what I understand the IEEE80211_TX_CTL_NO_ACK which is in the
> flags of the ieee80211_tx_info struct, could be set from the driver f=
or
> each frame just as currently (not) done with the IEEE80211_TX_STAT_AC=
K
> flag.=20

Yes, but my comment was regarding your proposal regarding the
"driver is incapable of supplying TX Acks to upper layer" which would
suggest it would be a global setting instead of a per-frame setting.
And my point was that you want this to be a per-frame setting similar
to IEEE80211_TX_CTL_NO_ACK

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
