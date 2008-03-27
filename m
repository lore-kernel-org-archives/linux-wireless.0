Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41463 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbYC0Qwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 12:52:43 -0400
Date: Thu, 27 Mar 2008 09:52:37 -0700
To: bruno randolf <bruno@thinktube.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	Ivan Seskar <Seskar@winlab.rutgers.edu>,
	Haris Kremo <harisk@winlab.rutgers.edu>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Message-ID: <20080327165237.GA28553@bougret.hpl.hp.com> (sfid-20080327_165249_675587_0415D4D5)
Reply-To: jt@hpl.hp.com
References: <20080326123042.11233.80949.stgit@localhost> <43e72e890803261559keb944a1g48d93645db2f2e73@mail.gmail.com> <20080327001909.GA17555@bougret.hpl.hp.com> <200803271147.56272.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803271147.56272.bruno@thinktube.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 27, 2008 at 11:47:56AM +0900, bruno randolf wrote:
> hi jean!
> 
> i really appreciate your input based on your experiences with the wireless 
> extensions!

	My pleasure, always glad to help ;-)

> > However, some hardware (Atheros) can not do it, because 
> > their RSSI hardware is uncalibrated. So, what do you do with those
> > hardware ? Reporting a "relative" signal strength is probably better
> > than nothing.
> 
> can you explain why you think atheros HW is "relative"? 
> 
> in the past in madwifi RSSI was said to be measured against a fixed noise 
> value of -95dBm (which should be expressed by using _SIGNAL_DB in my patch) 
> but now we have a periodic noise floor calibration and we assume RSSI to be 
> relative to that, so we believe to be able to provide dBm for both values. 
> that's how it is currently reported in madwifi and ath5k and what we believe  
> to be correct (without having much documentation from atheros, however) - if 
> that's not correct we have to modify the drivers.

	One of my coworkers was doing experiments on interference
measurements. For that, we need to measure the signal strength of
various packets. Those recalibrations throw havoc in our
measurements. In other words, the RSSI we measure is consistent
between recalibration points, but not across those recalibration.
	This co-worker was using some NetBSD and not MadWifi, and I
don't know which version, so I can not say for sure if this affect the
current version of MadWifi.

	You have to look at what the application wants. The
application wants consistent measurements. You can *NOT* define
properly APIs unless you understand how application will use it.
	I don't understand enough about the Atheros hardware (I
haven't used it), but I don't see why you would need to recalibrate
the noise floor and how you could acheive that. Any "noise" you
measure on the channel would be subject to interference and
fading. The only way you could measure some noise with some certainty
would be to ground the antenna and measure.
	If you calibrate your RSSI using the noise on the channel, I
believe you are measuring SNR, not signal strength. Of course, I may
be wrong.

> > 	Note also that many hardware are not truly calibrated, but
> > "sort of" calibrated (Orinoco, HostAP). Good measurement is expensive,
> > that's why most implementation do measurement on the cheap. It means
> > the value will be correct within some few percents for a large part
> > range. Up to now, we pretented that those devices report dBm
> > properly. That's why RCPTI talk of expected accuracy of measurement.
> 
> hmm, accuracy is another question. i think at the moment as long as the device 
> tries to report dBm i would say it's dBm no matter what the accuracy is. in 
> the future, when we know more about the devices we can add some hw flags or 
> variables which can state that accuracy of the signal/noise measurements.

	Yes, that's the practical and sane way to do it.

> again, please tell us more about atheros. we believe RSSI to be relative to 
> the noise floor, which we can measure. therefore we have dBm for both.

	RSSI is absolute, like transmit power. Anything relative to
the noise floor is SNR, in dB.
		http://en.wikipedia.org/wiki/DBm

> sorry jean, no offense, but the usage of these values in WE was really 
> confusing and the lack of knowing what the values acutally mean made it 
> really hard for applications to work with them.

	Everybody is entitled to their opinion. Those values were
clearly documenteed but nobody bothered to read the documentation.

> > 	Note also that you may need an agregate measure of how good
> > the link is, but that would be best generated by the stack itself. I
> > guess for most devices, the bitrate in use will tell you that kind of
> > information.
> 
> once we have the signal units properly specified by the HW we can and should 
> do things like this in mac80211 - i think we should move the "qual" link 
> quality calculation up into mac80211 so it will be the same for all devices.

	Ideally, qual should aggregate as many measurements as
possible, such as RSSI, noise, packet loss, beacon loss, etc... I
think Bill Moss did some work in that direction in the ipw2*00
drivers.
	As I said above, I agree that it should probably be deal in
the stack.

> > Anyway, what does linear means, is it linear on a log/dBm 
> > scale or on a power/mW scale ?
> 
> linear would mean linar on whatever units the device uses (might be a power/mW 
> scale). log/dBM i would call "logarithmic". but anyhow, as you said not all 
> devices can do linear, so i would tend to remove that from the definition and 
> just say "totally unspecified".

	For most of those systems, linear measurement is not very
useful, and I believe most measurements are "sort of dB", i.e. closer
to log scale than linear.

> > 	Noise only defined in dBm ? Some older devices have noise in
> > "unspec". I also don't know what Atheros does here.
> 
> so far as far as i can see drivers either know the noise in dBm or don't know 
> it at all. if there is HW which has "unspec" we can add that.

	Anyway, those old harware that did not do dBm are going the
way of dinausors, so we probably should not care that much about them.

> bruno

	Regards,

	Jean
