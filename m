Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52423 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZCXLFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 07:05:18 -0400
Received: by fxm2 with SMTP id 2so2211230fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 04:05:15 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
Date: Tue, 24 Mar 2009 12:05:05 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Mircea Gherzan <mgherzan@gmail.com>
References: <20090320215705.GE8120@tesla> <200903241115.29868.helmut.schaa@gmail.com> <200903241136.03991.hs4233@mail.mn-solutions.de>
In-Reply-To: <200903241136.03991.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903241205.06417.helmut.schaa@gmail.com> (sfid-20090324_120522_864702_943066E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 24. M=C3=A4rz 2009 schrieb Holger Schurig:
> > Hmm, quick example: AP1 - STA - AP2
> >
> > We cannot consider the signal strength as constant as it
> > varies over time even when neither the STA nor the AP are
> > moving. Assume a threshold value of t=3D40. Furthermore, the
> > signal strength of AP1 and AP2 might alter between 35-50 which
> > means we have an average signal strength of 42,5 > t.
> > Nevertheless that would result in ping-pongs between AP1 and
> > AP2 because the signal might drop below t on both APs, while
> > it would be better to stick to one AP as the signal is already
> > quite bad (but still good enough to do some communication).
>=20
> Yeah, but if the client is moving, you have to live with that,=20
> more or less.
>=20
> And if the client is not moving (and roaming is a loadable kernel=20
> module), then simply don't load it :-)

Ah, ok. I was more referring to an ordinary laptop user who sits at his
desk and once in a while starts moving (for example to a conference roo=
m).
While he sits at his desk the optimal solution shouldn't trigger a scan=
 as
the chance that a better AP pops up is relatively low. Once he starts
moving scanning is desired.

> My ad-hoc approach that I already implemented (for non-mac80211)=20
> shows a quite number of scannings. But that is ok for my=20
> use-case (e.g. telnet connection via WLAN). "Connection lost" is=20
> way worse than one scanning/reassociation too much, especially=20
> if the scanning/association is done intelligently.
>=20
> So for now I wouldn't optimize here, but make non-sucking roaming=20
> possible in the first place. We can build upon this anyway.

=46ine with me. But too aggressive scanning might lead to unstable or
intermittent connections, especially when WPA-EAP without PMKSA-caching
is used where roaming from one AP to another can take up to several
seconds ;)

And additionally if the connection is idle, repeated scanning will
increase the power consumption which is not desired on battery driven
devices.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
