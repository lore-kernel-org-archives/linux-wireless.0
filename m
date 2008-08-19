Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:45038 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYHSUhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 16:37:43 -0400
Received: by nf-out-0910.google.com with SMTP id d3so67355nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 13:37:42 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [Rt2400-devel] rt2x00 tx acknowledgements
Date: Tue, 19 Aug 2008 22:37:39 +0200
Cc: Mikko =?iso-8859-1?q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net
References: <1219039209.22679.101.camel@virkkmi-linux> <200808191906.11727.IvDoorn@gmail.com> <20080819194100.GA24180@tuxdriver.com>
In-Reply-To: <20080819194100.GA24180@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200808192237.39235.IvDoorn@gmail.com> (sfid-20080819_223748_522029_2B1DF1A7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ Added linux-wireless to CC ]

On Tuesday 19 August 2008, John W. Linville wrote:
> On Tue, Aug 19, 2008 at 07:06:11PM +0200, Ivo van Doorn wrote:
> > On Tuesday 19 August 2008, Mikko Virkkil=E4 wrote:
> > > On Mon, 2008-08-18 at 10:00 +0200, Ivo van Doorn wrote:
> > > > On Monday 18 August 2008, Mikko Virkkil=E4 wrote:
>=20
> > > > > I had a quick look at their driver and it seems they solved i=
t by having
> > > > > a "waiting for acks" queue and each time a message is receive=
d it is
> > > > > check if it was an ack to one of the messages in the queue. I=
f it was,
> > > > > then the status message is sent in to the mac80211 stack.=20
> > > > >=20
> > > > > Could this same strategy be used with the rt2x00 driver?=20
>=20
> > > > That would only work when the ACK is received and passed to the=
 driver by
> > > > the USB stick. and as far as I know rt2500usb and rt73usb do no=
t pass the ACK
> > > > to the driver.
>=20
> > > When I cleared the DROP_CONTROL and DROP_ACK_CTS flags in the TXR=
X_CSR0
> > > register, I started receiving ACK frames. I tested by simply prin=
ting a
> > > debug message each time ieee80211_is_ack() was true for a frame.
> >=20
> > Ok, well if there is a volunteer for coding the ack handling, that =
would be great,
> > but you probably do need a timeout for each frame as well to report=
 the non-acked
> > frames.
>=20
> If anyone does this, it might be nice if you could find a way to
> generalize the implementation and share it between rt2x00 and zd1211r=
w
> (and possibly other drivers in the future).
>=20
> Just a thought...

That would be very nice, mac80211 could probably handle it very nicely =
when
the driver just reports the "unknown" status and mac80211 can sort out =
how it
wants to handle such frames.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
