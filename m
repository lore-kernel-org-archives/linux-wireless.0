Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:42979 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752148AbYCaGc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 02:32:56 -0400
From: bruno randolf <bruno@thinktube.com>
To: jt@hpl.hp.com
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Date: Mon, 31 Mar 2008 15:32:44 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	Ivan Seskar <Seskar@winlab.rutgers.edu>,
	Haris Kremo <harisk@winlab.rutgers.edu>
References: <20080326123042.11233.80949.stgit@localhost> <200803271147.56272.bruno@thinktube.com> <20080327165237.GA28553@bougret.hpl.hp.com>
In-Reply-To: <20080327165237.GA28553@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803311532.44969.bruno@thinktube.com> (sfid-20080331_073310_667404_1277AED1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 March 2008 01:52:37 Jean Tourrilhes wrote:
> > can you explain why you think atheros HW is "relative"?
> >
> > in the past in madwifi RSSI was said to be measured against a fixed noise
> > value of -95dBm (which should be expressed by using _SIGNAL_DB in my
> > patch) but now we have a periodic noise floor calibration and we assume
> > RSSI to be relative to that, so we believe to be able to provide dBm for
> > both values. that's how it is currently reported in madwifi and ath5k and
> > what we believe to be correct (without having much documentation from
> > atheros, however) - if that's not correct we have to modify the drivers.
>
> 	One of my coworkers was doing experiments on interference
> measurements. For that, we need to measure the signal strength of
> various packets. Those recalibrations throw havoc in our
> measurements. In other words, the RSSI we measure is consistent
> between recalibration points, but not across those recalibration.
> 	This co-worker was using some NetBSD and not MadWifi, and I
> don't know which version, so I can not say for sure if this affect the
> current version of MadWifi.
>
> 	You have to look at what the application wants. The
> application wants consistent measurements. You can *NOT* define
> properly APIs unless you understand how application will use it.
> 	I don't understand enough about the Atheros hardware (I
> haven't used it), but I don't see why you would need to recalibrate
> the noise floor and how you could acheive that. Any "noise" you
> measure on the channel would be subject to interference and
> fading. The only way you could measure some noise with some certainty
> would be to ground the antenna and measure.

there are actually two types of noise calibration for atheros hardware: one is 
for the internal circuit noise, which is done by detaching the antennas and 
another one for the environment noise (interference) on the channel, which is 
measured during silent times of the MAC protocol (SIFS for example). at least 
that's my understanding of what is described in an atheros patent:

http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2FPTO%2Fsearch-bool.html&r=1&f=G&l=50&co1=AND&d=PTXT&s1=%22Method+system+noise+floor+calibration+receive+signal+strength+detection%22.TI.&OS=TTL/

> 	If you calibrate your RSSI using the noise on the channel, I
> believe you are measuring SNR, not signal strength. Of course, I may
> be wrong.

i think that's what is happening. that seems to be consistent with both your 
collegues experimental results, the patent and the way we interpret 
the "RSSI" as SNR in madwifi and ath5k.

of course lacking any documentation from atheros this all mostly speculations.

> > sorry jean, no offense, but the usage of these values in WE was really
> > confusing and the lack of knowing what the values acutally mean made it
> > really hard for applications to work with them.
>
> 	Everybody is entitled to their opinion. Those values were
> clearly documenteed but nobody bothered to read the documentation.

true. it's unfair to blame WE for that. the problems came mostly from the fact 
that devices used completely different methods of reporting these values and 
not much was know about the devices sometimes.

now that have a mac80211 stack which unifies different drivers i would like to 
improve that situation by also unifying the way we report signal and noise 
across most devices. most modern cards support dBm so this is probably the 
way to go for the future. 

but the remaining question is how do we deal with devices where we don't know 
how to map RSSI to dBm.

i take your suggestion that we should remove the "linear" requirement from the 
definition. do you think it would be feasible to require the drivers to 
normalize their RSSI to a range of 0-100, so we would have at least some 
consistency between devices? (of course their steps within this percentage 
would be different and it would still be impossible to compare these values 
across different devices).

best regards,
bruno
