Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:41725 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757533AbYCGAdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 19:33:14 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] RCPI support in radiotap and in our wireless subsystems
Date: Fri, 7 Mar 2008 09:32:50 +0900
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@mail.ojctech.com,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Simon Barber" <simon@devicescape.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	"Javier Cardona" <javier@cozybit.com>,
	"Sam Leffler" <sam@errno.com>, "Jean Tourrilhes" <jt@hpl.hp.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com>
In-Reply-To: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803070932.51396.bruno@thinktube.com> (sfid-20080307_003318_806945_088B8FC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 March 2008 05:38:45 Luis R. Rodriguez wrote:
> I've been reviewing use or RSSI value, signal strength and noise on
> several Linux drivers, namely MadWifi, ath5k, ipw2200 and b43, and how
> these are populated using radiotap headers. It quickly became clear we
> should probably abandon RSSI's use in radiotap and slowly move to
> using RCPI [1] for both radiotap and for later use on our wireless
> subsystems. Reasons for doing so is:

i think it's worth the effort to try to clean up this mess and get some 
standardisation between the devices as far as possible but i'm afraid we are 
at the mercy of the values the hardware gives us and the information we get 
from hardware vendors about the meaning of these values.

> a. Currently Radiotap's definition and use of
> IEEE80211_RADIOTAP_DB_ANTSIGNAL and IEEE80211_RADIOTAP_DBM_ANTSIGNAL
> is not so clear

i think it's quite clear, except that it does not state when this signal is 
supposed to be measured.

if all devices could use this in the same way that would already be great!

> For Atheros hardware:
>
> RSSI is defined to be equivalent to the Signal To Noise (SNR) [3] and
>
> SNR = Signal - Noise
>
> Now, this is great, however the next question is what Signal is and
> what Noise is. Is Signal or SNR here the "measure by the PHY sublayer
> of the received RF power in the channel measured over the entire
> received frame"?

no, according to the information we have from madwifi it is not:

/*
 * rx_rssi is in units of dbm above the noise floor.  This value
 * is measured during the preamble and PLCP; i.e. with the initial
 * 4us of detection.
 */
(this is copied from a comment in hal/ah_desc.h)

> So I propose IEEE80211_RADIOTAP_RCPI, defined as above, and hopefully
> we can start figuring out what exactly RSSI values are in the
> different cards we support to compute this. Comments?

it's good to extend radiotap to include this possibility, but at least for 
atheros hardware we know we can't supply this value (unless newer devices 
allow us to get a RCPI value somehow, but we probably would need atheros 
support to know that).

it would already be an important step to better define the variables inside 
mac80211, so drivers can report what they support (and mac80211 can make the 
translations to the weird values iwconfig uses).

right now the variable names inside mac80211 are really ambigous and not very 
well defined. in struct ieee80211_rx_status we have:

 * @ssi: signal strength when receiving this frame
 * @signal: used as 'qual' in statistics reporting
 * @noise: PHY noise when receiving this frame

it could be changed to something like:

 * @signal: signal strength in dBm above noise or RCPI according to flag
 * @noise: PHY noise in dBm when receiving this frame
 (remove ssi)

bruno
