Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41648 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab1EXSHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 14:07:43 -0400
Received: by yia27 with SMTP id 27so2688858yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 11:07:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105241627.49201.helmut.schaa@googlemail.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
	<201105241627.49201.helmut.schaa@googlemail.com>
Date: Tue, 24 May 2011 11:07:42 -0700
Message-ID: <BANLkTi=o5XFTK8d3B-PsKh95ELbWMuVPwA@mail.gmail.com> (sfid-20110524_200805_710769_C85EA6EC)
Subject: Re: Initial automatic channel selection implementation
From: Eduard GV <eduardgv@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Matt Smith <Matt.Smith@atheros.com>, hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

>> II - Load check:
>>
>>   * In addition to the above take into consideration some metric for
>> load on the channel: frame count observed
>
> Sounds similar to the busy time information some drivers already report
> via "iw wlan0 survey dump", no? Counting frames sounds like a lot of
> overhead to me.

I don't know to what extent is 802.11k supported so far (anyone?), but
it'd provides useful radio measurements, e.g.:

* Frame Count Report: The STA that performs such a measurement
observes the traffic on a given channel and makes a summary for each
different transmitter detected during the measurement. Similar to the
Beacon Report, for each transmitter, the requested STA informs of
received power, SNR, etc.

* Channel Load Report: provides the load metric of a given channel
based on the measurement of busy time. More precisely, channel busy
time is defined as the proportion of the time during which either the
physical carrier sense, the virtual carrier sense (NAV) or both
indicate that the channel is busy. This measurement is similar,
although not identical, to the CCA report added by the IEEE 802.11h.

* Noise Histogram Report presents a measurement of received power
detected while the carrier sense mechanism indicates a free medium.
The histogram consists of ten different levels (between -92 and -55
dBm) and is drawn by taking into account the portion of time in which
noise is detected in each of the ten levels. This measurement is
similar in conception to the 802.11h’s RPI Histogram, but besides the
power densities, the Noise Histogram Report shall include the average
noise plus interference power on the measured
channel at the antenna connector during the measurement duration.

> Speaking of channels, I think only some channels should be eligible for
> automatic selection (that would be 1, 6 and 11 in the 2.4 GHz range).

I disagree. Sometimes it is better to have adjacent channel
interference (from partially overlapping channels) than co-channel
interference. I could provide some references if you're interested.

Regards
