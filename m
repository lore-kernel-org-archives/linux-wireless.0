Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:36786 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbYCGDEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 22:04:25 -0500
Received: by el-out-1112.google.com with SMTP id v27so333596ele.17
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 19:04:24 -0800 (PST)
Message-ID: <43e72e890803061904h742df37fuaa12977c45e457a@mail.gmail.com> (sfid-20080307_030430_088969_ADB2A094)
Date: Thu, 6 Mar 2008 22:04:24 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [RFC] RCPI support in radiotap and in our wireless subsystems
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
In-Reply-To: <200803070932.51396.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com>
	 <200803070932.51396.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 6, 2008 at 7:32 PM, bruno randolf <bruno@thinktube.com> wrote:
> On Friday 07 March 2008 05:38:45 Luis R. Rodriguez wrote:
>  > I've been reviewing use or RSSI value, signal strength and noise on
>  > several Linux drivers, namely MadWifi, ath5k, ipw2200 and b43, and how
>  > these are populated using radiotap headers. It quickly became clear we
>  > should probably abandon RSSI's use in radiotap and slowly move to
>  > using RCPI [1] for both radiotap and for later use on our wireless
>  > subsystems. Reasons for doing so is:
>
>  i think it's worth the effort to try to clean up this mess and get some
>  standardisation between the devices as far as possible but i'm afraid we are
>  at the mercy of the values the hardware gives us and the information we get
>  from hardware vendors about the meaning of these values.

Unfortunately, yeap.

>  > a. Currently Radiotap's definition and use of
>  > IEEE80211_RADIOTAP_DB_ANTSIGNAL and IEEE80211_RADIOTAP_DBM_ANTSIGNAL
>  > is not so clear
>
>  i think it's quite clear, except that it does not state when this signal is
>  supposed to be measured.

Precisely --  the lack of clarity on time of measurement is what I
don't think makes it clear. Without that being clear I'm afraid every
driver for each Operating System may have interpreted that to their
own meaning. Because we only have so much data available from wireless
hardware though and RSSI is usually exposed because its part of the
802.11 Service Parameter Lists my guess is that DB_ANTISIGNAL is
usually set to the hardware's RSSI (whatever that value may mean) and
DBM_ANTSIGNAL is usually set to the a converted factor *when
understood* to get a "dBm" value.

To better define IEEE80211_RADIOTAP_DB_ANTSIGNAL and
IEEE80211_RADIOTAP_DBM_ANTSIGNAL what I think we need is a better
understanding of what vendors tend to use for RSSI value and when they
compute it. We can then clarify the definition to match practice.

>  if all devices could use this in the same way that would already be great!
>
>
>  > For Atheros hardware:
>  >
>  > RSSI is defined to be equivalent to the Signal To Noise (SNR) [3] and
>  >
>  > SNR = Signal - Noise
>  >
>  > Now, this is great, however the next question is what Signal is and
>  > what Noise is. Is Signal or SNR here the "measure by the PHY sublayer
>  > of the received RF power in the channel measured over the entire
>  > received frame"?
>
>  no, according to the information we have from madwifi it is not:
>
>  /*
>   * rx_rssi is in units of dbm above the noise floor.  This value
>   * is measured during the preamble and PLCP; i.e. with the initial
>   * 4us of detection.
>   */
>  (this is copied from a comment in hal/ah_desc.h)

Nice, thanks for pointing that out! I wonder if this can be tweaked :)

>  > So I propose IEEE80211_RADIOTAP_RCPI, defined as above, and hopefully
>  > we can start figuring out what exactly RSSI values are in the
>  > different cards we support to compute this. Comments?
>
>  it's good to extend radiotap to include this possibility, but at least for
>  atheros hardware we know we can't supply this value (unless newer devices
>  allow us to get a RCPI value somehow, but we probably would need atheros
>  support to know that).

You're right.

>  it would already be an important step to better define the variables inside
>  mac80211, so drivers can report what they support (and mac80211 can make the
>  translations to the weird values iwconfig uses).

Agreed.

>  right now the variable names inside mac80211 are really ambigous and not very
>  well defined. in struct ieee80211_rx_status we have:
>
>   * @ssi: signal strength when receiving this frame

Right, ath5k sets this to RSSI + noise:

                /* signal level in dBm */
                rxs.ssi = rxs.noise + ds->ds_rxstat.rs_rssi;

b43 sets this to:

       status.ssi = b43_rssi_postprocess(dev, jssi,
                                         (phystat0 & B43_RX_PHYST0_OFDM),
                                         (phystat0 & B43_RX_PHYST0_GAINCTL),
                                         (phystat3 & B43_RX_PHYST3_TRSTATE));

>   * @signal: used as 'qual' in statistics reporting

ath5k sets this to:

                /*
                 * "signal" is actually displayed as Link Quality by iwconfig
                 * we provide a percentage based on rssi (assuming max rssi 64)
                 */
                rxs.signal = ds->ds_rxstat.rs_rssi * 100 / 64;


>   * @noise: PHY noise when receiving this frame

ath5k sets this to the noise floor we get through noise floor
calibration. There's a patent behind how this is computed but I think
it may be during SIFS. Not too sure though.

>  it could be changed to something like:
>
>   * @signal: signal strength in dBm above noise or RCPI according to flag

As it stands I don't think all drivers could populate this field under
that description. For example, ssi in b43 is set to some magical value
we have no clue what it means.

We *could* test this stuff and see if it matches RCPI for each device,
or just try to figure out at least what RSSI is wrt to the observed
signal through a spectrum analyser (and even jssi is for b43) but I
wonder how this will change upon hw revisions.

>   * @noise: PHY noise in dBm when receiving this frame
>   (remove ssi)

Again, the problem in clarifying this also puts a restriction on what
driver developers may know about their hardware.

Ah!

  Luis
