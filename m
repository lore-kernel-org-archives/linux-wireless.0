Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0125.outbound.protection.outlook.com ([104.47.0.125]:42976
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755084AbeBOIw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:52:58 -0500
From: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
To: "quozl@laptop.org" <quozl@laptop.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Subject: RE: [PATCH v2] ath9k: mark RSSI as invalid if frame received during
 channel setup
Date: Thu, 15 Feb 2018 08:52:53 +0000
Message-ID: <AM4PR0101MB2305806FCA1CC031A49C5B7DE4F40@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180215_095302_132082_B0C8EB39)
References: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <20180214213025.GB17837@us.netrek.org>
 <87mv0a6brz.fsf@kamboji.qca.qualcomm.com>
 <20180215072118.GG17837@us.netrek.org>
In-Reply-To: <20180215072118.GG17837@us.netrek.org>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Message d'origine-----
> De=A0: quozl@laptop.org [mailto:quozl@laptop.org]
> Envoy=E9=A0: jeudi 15 f=E9vrier 2018 08:21
> =C0=A0: Kalle Valo
> Cc=A0: Jean Pierre TOSONI; linux-wireless@vger.kernel.org; ath9k-
> devel@qca.qualcomm.com
> Objet=A0: Re: [PATCH v2] ath9k: mark RSSI as invalid if frame received
> during channel setup
>=20
> On Thu, Feb 15, 2018 at 07:51:28AM +0200, Kalle Valo wrote:
> > James Cameron <quozl@laptop.org> writes:
> >
> >> On Wed, Feb 14, 2018 at 04:26:42PM +0000, Jean Pierre TOSONI
> wrote:
> >>> ath9k returns a wrong RSSI value for frames received
> >>> in a 30ms time window after a channel change. The
> >>> correct value is typically 10dB below the returned value.
> >>
> >> How was your correct value determined?
> >>

1) test setup:
Connecting the AP through coax and attenuators, then making 500 passive sca=
ns off-channel, then drawing an histogram of the beacon signals found by th=
e chip. The off-channel period is 108 ms. The probability of being in the 3=
0 ms window is 28%. The histogram shows 2 spikes, one large with the expect=
ed value, one small at around +10dB above.

2) value determination
Adjust the delay (CONFIG_HZ=3D250) by trial and error. 25ms was not enough =
to completely absorb the +10dB spike in the histogram, while 30ms was enoug=
h.

Do you think of a better approach? Maybe the guys at Qualcomm know the corr=
ect value?=20

> >>> This was found with a Atheros AR9300 Rev:3 chip (WLE350NX /
> >>> JWX6083 cards), during offchannel scans.
> >>>
> >>> Mark the signal value as invalid in this case.
> >>
> >> Why not adjust by 10dB?

I considered that also. But,=20
1) during how much time should I do this adjustment? Around 30 ms after cha=
nnel switch?
2) The histogram shows a scattering of the measures in a +/- 3dB range arou=
nd the mean value.
So I could not decide for sure if it needed -9dB, -10dB or -11dB?

> >>
> >> Speculating: in a typical card, RSSI is calculated by firmware
> from
> >> readings of ADCs attached to the receiver.  Firmware may average
> >> several readings.  Firmware may apply other offsets or
> calibrations,
> >> based on frequency and temperature.  This sounds like a firmware
> >> problem.
> >
> > ath9k does not have firmware, only ath9k_htc has it.
>=20
> Heh.  s/firmware/silicon implementation/g

Oh well, if it's silicon problem, then it's a hardware problem, and
I am right to correct it that way, since there is no other way :-)

>=20
> --
> James Cameron
> http://quozl.netrek.org/
