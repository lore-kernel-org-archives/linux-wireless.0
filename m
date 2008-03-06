Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:44357 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbYCFUit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 15:38:49 -0500
Received: by wx-out-0506.google.com with SMTP id h31so70779wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 12:38:46 -0800 (PST)
Message-ID: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com> (sfid-20080306_203853_977656_3EF4B3C6)
Date: Thu, 6 Mar 2008 15:38:45 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@mail.ojctech.com
Subject: [RFC] RCPI support in radiotap and in our wireless subsystems
Cc: "Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Simon Barber" <simon@devicescape.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	"Javier Cardona" <javier@cozybit.com>,
	"Sam Leffler" <sam@errno.com>, "Jean Tourrilhes" <jt@hpl.hp.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been reviewing use or RSSI value, signal strength and noise on
several Linux drivers, namely MadWifi, ath5k, ipw2200 and b43, and how
these are populated using radiotap headers. It quickly became clear we
should probably abandon RSSI's use in radiotap and slowly move to
using RCPI [1] for both radiotap and for later use on our wireless
subsystems. Reasons for doing so is:

a. Currently Radiotap's definition and use of
IEEE80211_RADIOTAP_DB_ANTSIGNAL and IEEE80211_RADIOTAP_DBM_ANTSIGNAL
is not so clear and it seems different drivers set it to different
values. MadWifi uses DB_ANTSIGNAL for RSSI, ath5k uses DB_ANTSIGNAL as
RSSI + noise, ipw2200 doesn't set it despite it having a value which
can be used for it. The b43 driver, although like ath5k is a mac80211
driver, uses DB_ANTSIGNAL as:

        status.ssi = b43_rssi_postprocess(dev, jssi,
                                          (phystat0 & B43_RX_PHYST0_OFDM),
                                          (phystat0 & B43_RX_PHYST0_GAINCTL),
                                          (phystat3 & B43_RX_PHYST3_TRSTATE));

We have no clue what jssi is, nor what this yields, yet we use it.

b. For roaming purposes we need to standardize on a value so that the
upper layers can reliably count on for signal strength and I believe
RCPI was defined for just that purpose

c. For strong subsystem rate control algorithms we need to count on
reliable signal strength values. Right now mac80211's PID rate control
algorithm [2] doesn't make use of signal strength, it just uses
non-acked frames and re-transmission counters. I would think using
signal strength here might help somehow.

However, to support RCPI it seems you need to rely on a way to
accurately compute signal strength, but more accurately "received RF
power in the selected channel for a received frame. This parameter
shall be a measure by the PHY sublayer of the received RF power in the
channel measured over the entire received frame or by other equivalent
means which meet the specified accuracy". I've tried reviewing RSSI
value for a few hardware out there to see if we can easily start
adding support for this in our drivers but I am not confident in the
exact value that RSSI represents as it varies on hardware and there is
an obvious the lack of documentation in that area.

---

For Atheros hardware:

RSSI is defined to be equivalent to the Signal To Noise (SNR) [3] and

SNR = Signal - Noise

Now, this is great, however the next question is what Signal is and
what Noise is. Is Signal or SNR here the "measure by the PHY sublayer
of the received RF power in the channel measured over the entire
received frame"? Noise is computed upon noise calibration time, and I
think its computed during SIFS time, but I haven't yet finished
reading the patent that describes this stuff yet [4] so not too sure.
I guess its not important as long as we can rely on the value.

---

For ipw2200:

s8 antsignal = frame->rssi_dbm - IPW_RSSI_TO_DBM;

and IPW_RSSI_TO_DBM is set to 112.

Is antsignal above the "measure by the PHY sublayer of the received RF
power in the channel measured over the entire received frame"?

----

For Broadcom:

We have something called jssi and then get what we think is an RSSI
value. We don't know what either of them are.

        status.ssi = b43_rssi_postprocess(dev, jssi,
                                          (phystat0 & B43_RX_PHYST0_OFDM),
                                          (phystat0 & B43_RX_PHYST0_GAINCTL),
                                          (phystat3 & B43_RX_PHYST3_TRSTATE));

---

At least RCPI seems to be well defined, and I think we can add it to
radiotap for those drivers that can reliably compute this value.

Quoting from Simon's post:

"The allowed values for the Received Channel Power Indicator (RCPI) parameter
shall be an 8 bit value in the range from 0 through 220, with indicated
values rounded to the nearest 0.5 dB as follows:

0: Power < -110 dBm
1: Power = -109.5 dBm
2: Power = -109.0 dBm

and so on where

RCPI = int{(Power in dBm +110)*2} for 0dbm > Power > -110dBm

220: Power > -0 dBm
221-254: reserved
255: Measurement not available

RCPI shall equal the received RF power within an accuracy of +/-5 dB
(95% confidence interval) within the specified dynamic range of the
receiver. The received RF power shall be determined assuming a receiver
noise equivalent bandwidth equal to the channel bandwidth multiplied by
1.1."

So I propose IEEE80211_RADIOTAP_RCPI, defined as above, and hopefully
we can start figuring out what exactly RSSI values are in the
different cards we support to compute this. Comments?

  Luis

[1] http://www.mail-archive.com/netdev@vger.kernel.org/msg19487.html
[2] http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
[3] http://madwifi.org/wiki/UserDocs/RSSI
[4] http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL&p=1&u=%2Fnetahtml%2FPTO%2Fsrchnum.htm&r=1&f=G&l=50&s1=7245893.PN.&OS=PN/7
