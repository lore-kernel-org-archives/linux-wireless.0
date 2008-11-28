Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:39489 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYK1RQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 12:16:27 -0500
In-Reply-To: <1227864737.3883.0.camel@johannes.berg>
Date: Fri, 28 Nov 2008 18:16:15 +0100 (CET)
Cc: linux-wireless@vger.kernel.org
To: linville@tuxdriver.com
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?Different=20TX=20power=20settings=20depending=20on=20actual=20regdomain=20and=20auto=20TX=20power=20settings?=
Mime-Version: 1.0
Message-Id: <813.1440-27707-911506856-1227892575@seznam.cz> (sfid-20081128_181631_448868_9391DE93)
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Od: Johannes Berg <johannes@sipsolutions.net>
> P=F8edm=ECt: Re: [PATCH] wireless-regdb: Update regulatory rules for =
Czech Republic
> (CZ) on 5GHz
> Datum: 28.11.2008 11:09:02
> On Fri, 2008-11-28 at 01:11 +0100, Carlos Lau=E9 wrote:
>=20
> > OK, I thought we cannot guarantee the automatic power regulation,
> > using lower values for now, it would be nice to implement the requi=
red
> > mechanism to assure tx power regulation, but then how to define the
> > two values? two tables, or a flag like "NO-APC -3" indicating that,
> > without tx power regulation, there is a lower limit for tx power?=20
>=20
> No, it's not that trivial, needs more thought and a db change.
>
> johannes

Yes, I'm aware of it.=20

To make things clear and simple, I'll resume why we need such a feature=
:
In Czech Republic, and maybe on other countries, one can transmit twice=
 more eirp on 5GHz (on some frequencies) with automatic TX power manage=
ment enabled than without such feature. For the Czech Republic,the limi=
t is 3dB lower for devices without such feature(ie. half the output pow=
er). So it would be nice if users could use all available TX power, wit=
hout breaking the law, and without having to bother.
I'm using APC for automatic TX power management (as if one sets "iwconf=
ig wlan0 txpower auto") on the text below.

Perhaps the first thing we have to do is to change a little the DB and =
the parser. Adding a entry telling that, for the desired frequency, the=
re can be "n" dB more TX power with APC enabled than without APC, or to=
 define a second limit.
=20
The right thing to do would be to start at lower TX power settings, aft=
erwards CRDA would check if the driver is capable of APC, and if it is,=
 and it is enabled, than it could rise the TX power settings. That woul=
d assure that a driver unaware of APC "feature-enabled-feedback" won't =
 get the higher tx power settings than is legal to use.

Problems could arise when userspace tools i.e. iwconfig are used to dis=
able APC, then the card should start transmitting with less power. We c=
ould just warn users about that, but to make things automatic would be =
nice. Maybe even the drivers will need a little touch to have them gene=
rating a udev event when APC settings changes, and then let CRDA make t=
he right choice of max TX power setting.

It seems that iwtxpower setting are now handled by mac80211. It would b=
e nice to see this feature when it gets to cfg80211....=20

I'm downloading the wireless-testing git tree right now, but it will ta=
ke a while at 18KB/s...

Carlos Lau=E9
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
