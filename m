Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50290 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbZDPTL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 15:11:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Proposal]TX flags
Date: Thu, 16 Apr 2009 21:10:04 +0200
Cc: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	radiotap@radiotap.org,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com> <69e28c910904161147h5a68d3b5nd054b043d6ad2719@mail.gmail.com> <1239908374.26575.20.camel@johannes.local>
In-Reply-To: <1239908374.26575.20.camel@johannes.local>
MIME-Version: 1.0
Message-Id: <200904162110.05150.mb@bu3sch.de> (sfid-20090416_211203_069755_2A46AE06)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 16 April 2009 20:59:34 Johannes Berg wrote:
> On Thu, 2009-04-16 at 20:47 +0200, G=C3=A1bor Stefanik wrote:
>=20
> > Alternatively, the meanings of the {0,0} and {1,1} cases could be
> > switched around (making the {0,0} case more logical, at the expense=
 of
> > the {1,1} one):
> >=20
> > TX Flags absent: Use RTS & CTS as needed.
> > TX Flags present: {
> > RTS=3D0, CTS=3D0: Use RTS & CTS as needed.
> > RTS=3D0, CTS=3D1: Use CTS-to-self.
> > RTS=3D1, CTS=3D0: Use RTS/CTS-handshake.
> > RTS=3D1, CTS=3D1: Use neither RTS nor CTS.

The first and the last thing let my head explode, because it's not what=
 somebody
would expect from such bits. This kind of logic is also used in wext. A=
nd it's why I hate wext.
"bit0 means x, bit1 means y, buuuuuuuuuuuuuuuut iff both bits are set t=
he whole logic
is inverted and whatever..."
That complicates _every_ single test of the bit (always need if (bit0 i=
s set but not bit1))
It produces spaghetti code interpreting these bits with lots of branche=
s and special
conditions that nobody does understand by reading the code alone.
If you can't encode your functionality into a boolean, do _NOT_ use bit=
s to encode it.
Use integers to encode tristate or quadstate or whatever.
You essentially _did_ that already, if you look at your bits. You use t=
he two individual bits
as 2bit integer value. So why not spell it out and use an integer field=
 for that information?

--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
