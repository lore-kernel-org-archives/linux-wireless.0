Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:54799 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990AbYDBX4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 19:56:33 -0400
Date: Wed, 2 Apr 2008 16:56:08 -0700
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bruno Randolf <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz,
	Ivan Seskar <Seskar@winlab.rutgers.edu>,
	Haris Kremo <harisk@winlab.rutgers.edu>,
	Kishore Ramachandran <kishore@winlab.rutgers.edu>,
	Sanjit Kaul <sanjitkaul@gmail.com>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Message-ID: <20080402235607.GA24968@bougret.hpl.hp.com> (sfid-20080403_005642_802749_F1B7B2FE)
Reply-To: jt@hpl.hp.com
References: <20080326123042.11233.80949.stgit@localhost> <43e72e890803261559keb944a1g48d93645db2f2e73@mail.gmail.com> <20080327001909.GA17555@bougret.hpl.hp.com> <43e72e890804021619k4e8fea71i152c5dafe010ddfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890804021619k4e8fea71i152c5dafe010ddfc@mail.gmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 02, 2008 at 07:19:07PM -0400, Luis R. Rodriguez wrote:
> 
> I'm very well aware you did not define what went into mac80211.h. Also
> I'm not blaming anyone for anything, I just wanted to ask you some
> details of intentions behind a value used in WE so we can better
> implement things moving forward.

	Understood, this is why I took my time answering you.

> >         The most common unit for the RSSI is dBm, but I see that IEEE
> >  is using RCPTI.
> 
> I think you meant RCPI, and it seems to be well defined actually.

	Yes, I "misspoke". Note that RCPI is implemented in WT-29. If
iwconfig sees a RCPI value over WE, it converts it to dBm.

> >         Now, we would like all hardware to report RSSI in dBm, and get
> >  done with it. However, some hardware (Atheros) can not do it, because
> >  their RSSI hardware is uncalibrated. So, what do you do with those
> >  hardware ? Reporting a "relative" signal strength is probably better
> >  than nothing.
> 
> What 802.11 hardware does report exact dbm signal strength
> measurements?

	Cisco Aironet 350 (later firmware using calibration
table). That's probably the best I can think off.

> At least for Atheros AR5212 hardware there seems to be
> an offset value between the actual signal strength and the measured
> signal stregth. At Orbit we use a lot of Atheros hardware (800
> wireless cards on the grid) and at one point it seems there was a big
> concern over the value of signal strength reported and how it differed
> amongst cards compared to a real controlled value. I just tried to
> gather together a bit of the experience so far and it seems that in
> general the offset was small and didn't vary too much. So actually,
> unless I am misrepresenting the experience explained so far Atheros
> hardware seems provide reliable results, across different experiments,
> across different cards. An offset exists but it seems to be
> negligible. If you want to be surgically precise you do have to
> account for it but it seems it close enough for our purposes.

	As I explained in other parts of this thread, I have no
experience of Atheros. Some coworker has been using NetBSD and has
seen inconsistency over time due to noise recalibration. Note that we
operate in an environment with noise.

> >         Note that it could be uncalibrated in two way. One way is the
> >  offset (like the Atheros), the other is the slope (older hardware). It
> >  means that for some hardware, it does not even follow a dB
> >  curve. Uncalibrated usually means that every instance of the hardware
> >  is different and you can't have a global correction factor.
> 
> Is there standard 802.11 hardware out there that is not calibrated
> under this definition?

	On top of my head, I don't remember. It affected mostly
pre-802.11 devices. There is a Raylink which is a 802.11 FH device,
but that probably does not count. Then, a lot of devices are "sort of
calibrated", and I don't know where you want to draw the line.

> >         For the Atheros, there is another issue, the offset changes
> >  over time and is not constant for the card.
> 
> I wouldn't be surprised if the offset changes over time but I doubt
> its by a lot. How much have you seen the offset change over time? I do
> not think we have tested this. I will check.

	My coworker was complaining a significant change. Enough to
impact is interference measurements. It was related to noise
recalibration that occur at periodic intervals. Note that it was with
NetBSD, the driver may be different.

> >         This additional value would be cases where only the offset is
> >  uncalibrated and the slope is correct, like the Atheros. What it would
> >  allow is to calculate SNR in dB, which a "unspec" would not allow. If
> >  the offset is constant (as specified above, but not the case for
> >  Atheros), you could compare different value over time and make a
> >  difference in dB.
> 
> In Atheros' case we want to use dbm as we also know the noise, so we
> can just work with signal. Is there hardware where we might have SNR
> but not noise?

	Don't think so, but I did not look at all design. And nowadays
I can't be bothered to check it.

> Its a good point but for those who want precise results and if we
> *can* provide better and more accurate results I don't see why not.
> Ultimately I'd like to see RCPI embraced but we have to yet see
> hardware who can fit its definition on accuracy.

	I like RCPI for the accuracy expectation. But I would rather
present a dBm value to the user (in floating point, obviously).

> >         Noise only defined in dBm ? Some older devices have noise in
> >  "unspec". I also don't know what Atheros does here.
> 
> We don't have documentation for this but we can see what was *done* on
> MadWifi. On MadWifi the noise is obtained during interrupts on
> incoming set of frames and this is saved on a variable. This noise is
> is subtracted from the SNR (rssi) to get the signal. I guess this
> assumes that if there is a static noise during SIFs then you should
> subtract that noise as well. I cannot say we have measured this
> method's accuracy but hope its better than assuming a static noise as
> its what we use in ath5k as well.

	Well, check my other e-mail in this thread. Measuring channel
noise is, I believe, much more tricky than it looks.

> >  > Jean, if range->max_qual.level is set to -110 does this mean signal
> >  > level can be set only from -110 up to 0 ? Is max_qual.level supposed
> >  > to be the weakest signal possibly detected?
> >
> >         Yes. This is what make most sense.
> 
> How so? I think I must still be seriously misunderstanding something
> then. If the weakest signal possibly detected is -110 dbm it does not
> imply the strongest signal will be 0 dbm. On the contrary, I expect to
> be able to receive frames with positive dbm values. For example, if I
> hook up a card's antenna which is transmitting at 20dbm to another
> card's antenna directly with cables with 10 dbm attenuator in the
> middle I expect to see 10 dbm on the reception side. Therefore
> shouldn't the max be close the max allowed, or at least expected,
> EIRP?

	Initially, dBm did not had a "max", and the max_qual value was
zero (there are probably drivers still like that). With dBm, you know
the min and max if you know the frequency and the band. So, I did not
bother with it.
	When we went with multi band and multi rate, I failed to
properly extend the API, and retrofited the noise floor in the
max. That was the most expedient at the time.
	Ideally, we should have a true "min and max". The most
important value to know if the min, as you want to know in marginal
condition how close you are from the limit. For the max, there is no
way of knowing, as it mostly depend on the transmitter (power, gain,
etc...). I believe 0 is close enough to a good value.
	Note also that most receiver will saturate if the received
signal is too strong and won't measure accurately dBm in those range.

> >         Remember we also have "avg_qual".
> >         The idea is that if we want to graphically represent the value
> >  on a graph, we need to know the bounds. Think about a
> >  thermometer. Most thermometers show a range of temperature from -20C
> >  to +100C.
> >         Usually, level and noise will have the same range [-110;0],
> 
> I expect noise to have the range [minimal possibly detected signal
> ---- max expected EIRP ]
> The same applies to signal, which you seem to have labeled as "level".

	Yes.
	In my API, I have : signal quality, signal level and
noise. Therefore, in my API, "signal" is ambiguous.

> Again, I think I'm probably just really not understanding this so
> please clarify a bit more.

	No, I think you get it.

> >         Remember, what we care most here is to give a range so that
> >  graphical applications know the bound of the value. We don't need to
> >  be absolutely accurate here. Think about the thermometer example.
> 
> Point taken. In that case representation-wise we should take the
> lowest number for the lowest possible value. For 802.11 though it
> seems the lowest value should be -101 (20 MHz bandwidth) as I
> illustrated but some funky hardware (Atheros) allows even for 5 MHz
> channel widths so because of that this comes down to 107:
> 
> ; -174 + (10 * log(5 * 10^6))
>         ~-107.01029995663981195219
> 
> For 1MHz we get a clean -114:
> 
> ; -174 + (10 * log(1 * 10^6))
>         -114
> 
> Whatever, I guess -110 or -114 is OK then :) I see your point though.

	At 1 and 2 Mb/s using Direct Sequence, you have a processing
gain. In other words, you should consider the DS signal to be 1 or 2
MHz, not 20 MHz.
	I think I also did some measurements with the Orinoco to see
what values were reported. People hate when it shows values out of
bounds ;-)

> >         But yeah, please use whatever value make sense and give good
> >  result in userspace applications.
> 
> Sure.
> 
>   Luis

	Have fun...

	Jean
