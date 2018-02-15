Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:54757 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967843AbeBOL54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 06:57:56 -0500
Date: Thu, 15 Feb 2018 22:57:48 +1100
From: James Cameron <quozl@laptop.org>
To: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath9k: mark RSSI as invalid if frame received during
 channel setup
Message-ID: <20180215115748.GL17837@us.netrek.org> (sfid-20180215_125802_793900_0BB9CC88)
References: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <20180214213025.GB17837@us.netrek.org>
 <87mv0a6brz.fsf@kamboji.qca.qualcomm.com>
 <20180215072118.GG17837@us.netrek.org>
 <AM4PR0101MB2305806FCA1CC031A49C5B7DE4F40@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AM4PR0101MB2305806FCA1CC031A49C5B7DE4F40@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2018 at 08:52:53AM +0000, Jean Pierre TOSONI wrote:
> > -----Message d'origine-----
> > De : quozl@laptop.org [mailto:quozl@laptop.org]
> > Envoyé : jeudi 15 février 2018 08:21
> > À : Kalle Valo
> > Cc : Jean Pierre TOSONI; linux-wireless@vger.kernel.org; ath9k-
> > devel@qca.qualcomm.com
> > Objet : Re: [PATCH v2] ath9k: mark RSSI as invalid if frame received
> > during channel setup
> > 
> > On Thu, Feb 15, 2018 at 07:51:28AM +0200, Kalle Valo wrote:
> > > James Cameron <quozl@laptop.org> writes:
> > >
> > >> On Wed, Feb 14, 2018 at 04:26:42PM +0000, Jean Pierre TOSONI
> > wrote:
> > >>> ath9k returns a wrong RSSI value for frames received
> > >>> in a 30ms time window after a channel change. The
> > >>> correct value is typically 10dB below the returned value.
> > >>
> > >> How was your correct value determined?
> > >>
> 
> 1) test setup:
> Connecting the AP through coax and attenuators, then making 500 passive scans off-channel, then drawing an histogram of the beacon signals found by the chip. The off-channel period is 108 ms. The probability of being in the 30 ms window is 28%. The histogram shows 2 spikes, one large with the expected value, one small at around +10dB above.
> 
> 2) value determination
> Adjust the delay (CONFIG_HZ=250) by trial and error. 25ms was not enough to completely absorb the +10dB spike in the histogram, while 30ms was enough.
> 
> Do you think of a better approach?

No, I think your approach is fine.  I was curious.  Thanks for explaining.

> Maybe the guys at Qualcomm know the correct value?

Yes, that seems likely.

> > >>> This was found with a Atheros AR9300 Rev:3 chip (WLE350NX /
> > >>> JWX6083 cards), during offchannel scans.
> > >>>
> > >>> Mark the signal value as invalid in this case.
> > >>
> > >> Why not adjust by 10dB?
> 
> I considered that also. But, 
> 1) during how much time should I do this adjustment? Around 30 ms after channel switch?

Yes.  If RSSI is so critical for your application, you'll do what you
can to get a real RSSI rather than drop it.

> 2) The histogram shows a scattering of the measures in a +/- 3dB range around the mean value.

Perhaps a sampling error by the device.

> So I could not decide for sure if it needed -9dB, -10dB or -11dB?
> 
> > >>
> > >> Speculating: in a typical card, RSSI is calculated by firmware
> > from
> > >> readings of ADCs attached to the receiver.  Firmware may average
> > >> several readings.  Firmware may apply other offsets or
> > calibrations,
> > >> based on frequency and temperature.  This sounds like a firmware
> > >> problem.
> > >
> > > ath9k does not have firmware, only ath9k_htc has it.
> > 
> > Heh.  s/firmware/silicon implementation/g
> 
> Oh well, if it's silicon problem, then it's a hardware problem, and
> I am right to correct it that way, since there is no other way :-)

Yes, if it can be reproduced by every ath9k.

-- 
James Cameron
http://quozl.netrek.org/
