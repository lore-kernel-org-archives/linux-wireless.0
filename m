Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1322 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbYCaRs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 13:48:56 -0400
Date: Mon, 31 Mar 2008 10:47:56 -0700
To: bruno randolf <bruno@thinktube.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	Ivan Seskar <Seskar@winlab.rutgers.edu>,
	Haris Kremo <harisk@winlab.rutgers.edu>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Message-ID: <20080331174756.GA9882@bougret.hpl.hp.com> (sfid-20080331_184900_635078_5B34E7A5)
Reply-To: jt@hpl.hp.com
References: <20080326123042.11233.80949.stgit@localhost> <200803271147.56272.bruno@thinktube.com> <20080327165237.GA28553@bougret.hpl.hp.com> <200803311532.44969.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803311532.44969.bruno@thinktube.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 31, 2008 at 03:32:44PM +0900, bruno randolf wrote:
> 
> there are actually two types of noise calibration for atheros hardware: one is 
> for the internal circuit noise, which is done by detaching the antennas and 
> another one for the environment noise (interference) on the channel, which is 
> measured during silent times of the MAC protocol (SIFS for example). at least 
> that's my understanding of what is described in an atheros patent:
> 
> http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2FPTO%2Fsearch-bool.html&r=1&f=G&l=50&co1=AND&d=PTXT&s1=%22Method+system+noise+floor+calibration+receive+signal+strength+detection%22.TI.&OS=TTL/
> 

	Patents are hard to read. And you don't even know if the
patent apply to the current hardware.
	Reading the patent, the intention is good. They want to
calculate dBm. Because their hardware does not have a fixed offset,
they do all kind of tricks to calibrate the offset.
	Now, the problem of their method is that they need to
determine the channel noise floor. And this is where it falls apart,
as there is no guarantee that you can measure the noise floor, because
there is no guarantee that you can measure a time where there is no
transmission and no interference. With all the cordless phones,
BlueTooth, adjacent cell, channel overlap and so on, the 2.4 GHz band
tend to be quite busy.
	What the patent seem to advocate is to measure the noise over
a long period of time and use the lowest measurement. The patent seems
to say that this channel noise vary little by temperature, so you
could actually measure it once and store it. They also seem to say
that it could be the same for all units.

> i think that's what is happening. that seems to be consistent with both your 
> collegues experimental results, the patent and the way we interpret 
> the "RSSI" as SNR in madwifi and ath5k.
> 
> of course lacking any documentation from atheros this all mostly
> speculations.

	Yes, I don't want to claim anything, because I've not used
this hardware, we have only hearsay and I belive those kind of things
need to be verified in details.
	From the patent, it looks like you could measure dBm this way
but you would need more care in managing the channel noise
measurement.

	Note that's the trouble with doing things bottom up. Very
often, hardware does it some specific way because it was easier to
implement or because the designer made some choices. Unfortunately,
applications may have other needs.
	I've also seen Atheros based AP where the Tx power is relative
(dB to max) instead of absolute (dBm). And in the case, the max did
depend on various things, such as the band (2.4 GHx vs. 5GHz) and the
type of antenna (internal/external). Very messy.

> The problems came mostly from the fact 
> that devices used completely different methods of reporting these values and 
> not much was know about the devices sometimes.
> 
> now that have a mac80211 stack which unifies different drivers i would like to 
> improve that situation by also unifying the way we report signal and noise 
> across most devices. most modern cards support dBm so this is probably the 
> way to go for the future. 

	I think you are in a way better position. We now have 10 year
of experience, there are way more people concerned about it and
application are finally starting to pay attention to those APIs.

> but the remaining question is how do we deal with devices where we
> don't know how to map RSSI to dBm.
> 
> i take your suggestion that we should remove the "linear"
> requirement from the definition.

	I believe most devices will have a "sort of dBm" measurement
(i.e. log scale), because that's what you need to perform CSMA-CA,
roaming and bit-rate adaptation.

> do you think it would be feasible
> to require the drivers to normalize their RSSI to a range of 0-100,
> so we would have at least some consistency between devices? (of
> course their steps within this percentage would be different and it
> would still be impossible to compare these values across different
> devices).

	If the measurement is not linear or log, it does not make
sense mandating the 0-100, because 50 won't be the mid-point. And we
assume that devices are not consistent to start with...
	Anyway, to avoid quantisation errors, I prefer to defer
normalisation to the end software. For example, if the app use a 64
pixel window to show the RSSI, it wants a value 0-63, not 0-100.

> best regards,
> bruno

	Have fun...

	Jean
