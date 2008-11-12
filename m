Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52429 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYKLRd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 12:33:29 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 09:33:29 -0800
Date: Wed, 12 Nov 2008 09:33:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211 dynamic powersave
Message-ID: <20081112173326.GA5886@tesla> (sfid-20081112_183344_464427_7A06F63E)
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com> <8e92b4100811102032j7698254ct7020879e4cd5af1d@mail.gmail.com> <1226399895.3890.8.camel@johannes.berg> <8e92b4100811112217p167f5f2ue5fa96475e6bdd44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <8e92b4100811112217p167f5f2ue5fa96475e6bdd44@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2008 at 10:17:54PM -0800, Vivek Natarajan wrote:
> Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > Vivek Natarajan wrote:
> >> 2) Do you intend to leave the NULL frame formation, waking up the =
chip
> >>      for TIM and modifying sleep/awake time according to  DTIM to
> >>     the driver since I did not see this in your TODO list?( I unde=
rstand from
> >>     the iwlwifi code that it just sends a request to the firmware =
for sending
> >>     NULL frame and the firmware takes care of the rest. But it may=
 not be
> >>     so in the case of other vendor drivers.)
> >
> > Can you elaborate on this? I don't think we're concerned with that =
in
> > dynPS.
>=20
> I'm listing  whatever I have understood about 'Power save'.
> It might be too basic but do correct me if I'm wrong somewhere.
>=20
> NULL DATA frame:
> a) A NULL data frame with PM bit ON is to be sent to the AP before
> going to sleep.
> b) After sending Null frame, the chip should not go to sleep before
> getting ack: move to sleep pending state
> c) In sleep pending state, wait for one more 'timeout' period before
> sending null frame again
> d) If ack is received, goto sleep.
>     This is to make sure that the AP buffers frames for us.
>  Sanity check:
> Check if the hw has been sleeping too long! It could imply that the
> sleep timers have gotten out of sync with the TSF. If so, force wake
> until the sleep timers get resynced.
>=20
> Tx:
> If there is a frame to transmit, send null data with PM bit off and s=
tart Tx.
> Rx:
> If there is any buffered frames, it is indicated in TIM.
> TIPS on TIM:
> Some hardware processes the TIM IE and fires an interrupt when the TI=
M
> bit is set.
> For hardware that doesn't,  we should process the TIM in software as
> part of processing the received Beacon
> =E2=86=92 A function to check if TIM bit is set based on the offset i=
n the beacon.
> =E2=86=92 A function to put the chip to awake(if TIM is set) and send=
 a null
> data with PM bit off.
>=20
> DTIM:
> The period after which multicast traffic may be transmitted. So be
> awake even if there is no unicast packets
> as indicated by TIM.
> There are some registers related to TIM and DTIM periods in ath5k
> registers.(Thanks Nick for pointing
> them out)Need to dig more to see if it is enough to program these
> registers to be awake for post-DTIM muticast traffic.

Also check out:

http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-=
savings

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
