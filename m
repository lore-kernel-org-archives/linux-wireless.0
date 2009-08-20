Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c.painless.aaisp.net.uk ([81.187.30.53]:49164 "EHLO
	c.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZHTJD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 05:03:57 -0400
From: Simon Farnsworth <simon@farnz.org.uk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Regulatory problems with ath5k in AP mode
Date: Thu, 20 Aug 2009 09:23:39 +0100
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
References: <h6ced0$hoi$1@ger.gmane.org> <43e72e890908191720m6838e81ei853a27856288db8f@mail.gmail.com>
In-Reply-To: <43e72e890908191720m6838e81ei853a27856288db8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1888185.uDfLT9YcJn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200908200923.46741.simon@farnz.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1888185.uDfLT9YcJn
Content-Type: multipart/mixed;
  boundary="Boundary-01=_NgQjKdiNVAep9ll"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_NgQjKdiNVAep9ll
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 20 August 2009 01:20:58 Luis R. Rodriguez wrote:
> On Mon, Aug 17, 2009 at 1:27 PM, Simon Farnsworth<simon@farnz.org.uk> wro=
te:
> > As I'm trying to use the cards for AP mode, I cannot rely on beacons wi=
th
> > regulatory data being present;
>
> Regulatory questions are often and I try really hard to answer them
> first through documentation so it seems we need to improve
> documentation further. To be thorough though I'd first like to ask if
> you have read all this:
>
> Linux regulatory docs:
>
> http://wireless.kernel.org/en/developers/Regulatory
>
> Atheros shared module documentation (ath.ko):
>
> http://wireless.kernel.org/en/users/Drivers/ath
>
I've read both of those - they're why I'm not simply overriding the EEPROM
by hacking ath5k.ko around.

> > instead, I have modprobe configured to run
> > "iw reg set GB" after cfg80211 is loaded,
>
> How do you have modprove configured to do that? Are you using
> ieee80211_regdom module parameter? If so please consider just using
> 'iw' or hostapd configured as you have below.
>
In /etc/modprobe.d/regulatory, I have a line:
install cfg80211 /sbin/modprobe --ignore-install cfg80211 ; /usr/local/sbin=
/iw reg set GB

> > My cards both have a regdomain in the EEPROM of 0x0,
>
> This is something that the manufacturer would have decided on.
>
> > which my vendor assures
> > me is the correct regdomain for cards which don't claim any particular
> > regulatory compliance,
>
> Who exactly did you speak to?
>
> Atheros uses 0x0 for a default mapping to the US.
>
I spoke to Mikrotik, who manufactured the R52 card I'm using. They assured
me that EEPROM regdomain 0x0 was correct for a card with no knowledge of
what regulatory domain it would be sold in, and in any case, told me that
it works fine with the driver they have from Atheros, so it must be an
upstream kernel bug.

> > thus preventing legal
> > use of the WiFi bands, but allowing me illegal use.
>
> This is no different than considering the case of when you ship an
> access point from JP to the US and you start beaconing on channel 13.
> You are violating local US regulatory laws if your configuration was
> to beacon on channel 13. If you take a US AP to the JP you then are
> prevented from usage of the allowed channel 13.
>
> I realize it may seem silly, and in fact I agree, but that is the law.
> If you were to bring an AP from JP to the US *with* a regulatory
> domain which matches the JP SKUs and therefore are allowed to beacon
> on channel 13 we give you the flexibility in Linux to enhance
> compliance and indicate you are on in the US and disable channel 13.
> Now, as much as I would love for it to be the case that the other way
> around should be enabled it is not, and although technically it is
> feasible, it is just not something agreeable to current regulatory
> agencies. Maybe one day it will be for 802.11, who knows.
>
> Anyway in your case since the device sends a regulatory hint for "US"
> first, and then you say "GB" the card will *always* respect first
> "US", and "GB" is just used to further help compliance.
>
So, if I understand correctly, this is not considered a bug by you or the
card manufacturer, both of whom insist that the other one is wrong. Am I
right in thinking that the easiest way to resolve this is to stick with an
unmodified kernel, but to use my own regulatory database that treats US as
GB?

> > Secondly, I'm seeing different regulatory settings on each card. "iw
> > list" shows me that in the 2GHz band, phy1 is being allowed to use 27.0
> > dBm on channels 1-11, whereas I'm only allowed to use 20.0 dBm, but I'm
> > allowed channels 1-13.
>
> I did not understand the last part, can you rephrase this again?
>
Easiest to look at the full iw list output below, and remember that my
local regulatory domain is GB, which is also the domain the cards were sold
as having.

> > In the 5GHz band, phy1 is allowed 17.0 dBm on channels 36-48,
> > to my local regulation's 20.0 dBm, reduced power in the (unusable as yet
> > due to driver limitations) DFS-only channels between 5.490 GHz and 5.710
> > GHz, and 30 dBm in the illegal channels for my region of 149 to 165.
>
> OK, first lets review US and GB regulatory domain:
>
> country GB:
>         (2402 - 2482 @ 40), (N/A, 20)
>         (5170 - 5250 @ 40), (N/A, 20)
>         (5250 - 5330 @ 40), (N/A, 20), DFS
>         (5490 - 5710 @ 40), (N/A, 27), DFS
>
> country US:
>         (2402 - 2472 @ 40), (3, 27)
>         (5170 - 5250 @ 40), (3, 17)
>         (5250 - 5330 @ 40), (3, 20), DFS
>         (5490 - 5710 @ 40), (3, 20), DFS
>         (5735 - 5835 @ 40), (3, 30)
>
> Now here is what an intersection yields for me between US and GB:
>
> mcgrof@tux ~/devel/crda (git::master)$ sudo ./intersect
> ../wireless-regdb/regulatory.bin
> GB (4) intersect US (5) =3D=3D> 4 rules
> Only one intersection completed
> =3D=3D World regulatory domain: =3D=3D
> country 99:
> 	(2402.000 - 2472.000 @ 40.000), (N/A, 20.00)
> 	(5170.000 - 5250.000 @ 40.000), (N/A, 17.00)
> 	(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS
> 	(5490.000 - 5710.000 @ 40.000), (N/A, 20.00), DFS
>
> So since your card is programmed for the "US" that information is
> *always* respected. GB info is only used to further help compliance.
> This means whatever channels are not allowed by the "US" regulatory
> domain will never be allowed on your card even if you say you are in
> "GB".
>
> > On phy0, I see that I'm being permitted 20.0 dBm in the 2GHz band (but
> > still only channels 1-11, and no beaconing permitted in the 5GHz band.
>
> Interesting, consider that phy0 is the first device detected, its
> regulatory hint would have first listened to, since both devices have
> the same regulatory domain according to what you are indicating they
> would agree.
>
> And instead of reading your interpretation of what is allowed or not
> can you please instead provide the 'iw list' output?
>
iw list gives me:

$ sudo iw list                                        =20
Wiphy phy1                                                           =20
        Band 1:                                                      =20
                Frequencies:                                         =20
                        * 2412 MHz [1] (20.0 dBm)                    =20
                        * 2417 MHz [2] (20.0 dBm)                    =20
                        * 2422 MHz [3] (20.0 dBm)                    =20
                        * 2427 MHz [4] (20.0 dBm)                    =20
                        * 2432 MHz [5] (20.0 dBm)                    =20
                        * 2437 MHz [6] (20.0 dBm)                    =20
                        * 2442 MHz [7] (20.0 dBm)                    =20
                        * 2447 MHz [8] (20.0 dBm)                    =20
                        * 2452 MHz [9] (20.0 dBm)                    =20
                        * 2457 MHz [10] (20.0 dBm)                   =20
                        * 2462 MHz [11] (20.0 dBm)                   =20
                        * 2467 MHz [12] (20.0 dBm)                   =20
                        * 2472 MHz [13] (20.0 dBm)                   =20
                        * 2484 MHz [14] (disabled)                   =20
                Bitrates (non-HT):                                   =20
                        * 1.0 Mbps                                   =20
                        * 2.0 Mbps (short preamble supported)        =20
                        * 5.5 Mbps (short preamble supported)        =20
                        * 11.0 Mbps (short preamble supported)       =20
                        * 6.0 Mbps                                   =20
                        * 9.0 Mbps                                   =20
                        * 12.0 Mbps                                  =20
                        * 18.0 Mbps                                  =20
                        * 24.0 Mbps                                  =20
                        * 36.0 Mbps                                  =20
                        * 48.0 Mbps                                  =20
                        * 54.0 Mbps                                  =20
        Band 2:                                                      =20
                Frequencies:                                         =20
                        * 5180 MHz [36] (20.0 dBm)                   =20
                        * 5200 MHz [40] (20.0 dBm)                   =20
                        * 5220 MHz [44] (20.0 dBm)                   =20
                        * 5240 MHz [48] (20.0 dBm)                   =20
                        * 5260 MHz [52] (20.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5280 MHz [56] (20.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5300 MHz [60] (20.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5320 MHz [64] (20.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5500 MHz [100] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5520 MHz [104] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5540 MHz [108] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5560 MHz [112] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5580 MHz [116] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5600 MHz [120] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5620 MHz [124] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5640 MHz [128] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5660 MHz [132] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5680 MHz [136] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5700 MHz [140] (27.0 dBm) (passive scanning, no I=
BSS, radar detection)
                        * 5745 MHz [149] (disabled)                        =
                    =20
                        * 5765 MHz [153] (disabled)                        =
                    =20
                        * 5785 MHz [157] (disabled)                        =
                    =20
                        * 5805 MHz [161] (disabled)                        =
                    =20
                        * 5825 MHz [165] (disabled)                        =
                    =20
                Bitrates (non-HT):                                         =
                    =20
                        * 6.0 Mbps                                         =
                    =20
                        * 9.0 Mbps                                         =
                    =20
                        * 12.0 Mbps                                        =
                    =20
                        * 18.0 Mbps                                        =
                    =20
                        * 24.0 Mbps                                        =
                    =20
                        * 36.0 Mbps                                        =
                    =20
                        * 48.0 Mbps                                        =
                    =20
                        * 54.0 Mbps                                        =
                    =20
        max # scan SSIDs: 4                                                =
                    =20
        Supported interface modes:                                         =
                    =20
                 * IBSS                                                    =
                    =20
                 * managed                                                 =
                    =20
                 * AP                                                      =
                    =20
                 * AP/VLAN                                                 =
                    =20
                 * monitor                                                 =
                    =20
                 * mesh point                                              =
                    =20
Wiphy phy0                                                                 =
                    =20
        Band 1:                                                            =
                    =20
                Frequencies:                                               =
                    =20
                        * 2412 MHz [1] (20.0 dBm)                          =
                    =20
                        * 2417 MHz [2] (20.0 dBm)                          =
                    =20
                        * 2422 MHz [3] (20.0 dBm)                          =
                    =20
                        * 2427 MHz [4] (20.0 dBm)                          =
                    =20
                        * 2432 MHz [5] (20.0 dBm)                          =
                    =20
                        * 2437 MHz [6] (20.0 dBm)                          =
                    =20
                        * 2442 MHz [7] (20.0 dBm)                          =
                    =20
                        * 2447 MHz [8] (20.0 dBm)                          =
                    =20
                        * 2452 MHz [9] (20.0 dBm)                          =
                    =20
                        * 2457 MHz [10] (20.0 dBm)                         =
                    =20
                        * 2462 MHz [11] (20.0 dBm)                         =
                    =20
                        * 2467 MHz [12] (disabled)                         =
                    =20
                        * 2472 MHz [13] (disabled)                         =
                    =20
                        * 2484 MHz [14] (disabled)                         =
                    =20
                Bitrates (non-HT):                                         =
                    =20
                        * 1.0 Mbps                                         =
                    =20
                        * 2.0 Mbps (short preamble supported)              =
                    =20
                        * 5.5 Mbps (short preamble supported)              =
                    =20
                        * 11.0 Mbps (short preamble supported)             =
                    =20
                        * 6.0 Mbps                                         =
                    =20
                        * 9.0 Mbps                                         =
                    =20
                        * 12.0 Mbps                                        =
                    =20
                        * 18.0 Mbps                                        =
                    =20
                        * 24.0 Mbps                                        =
                    =20
                        * 36.0 Mbps                                        =
                    =20
                        * 48.0 Mbps                                        =
                    =20
                        * 54.0 Mbps                                        =
                    =20
        Band 2:                                                            =
                    =20
                Frequencies:
                        * 5180 MHz [36] (30.0 dBm) (passive scanning, no IB=
SS)
                        * 5200 MHz [40] (30.0 dBm) (passive scanning, no IB=
SS)
                        * 5220 MHz [44] (30.0 dBm) (passive scanning, no IB=
SS)
                        * 5240 MHz [48] (30.0 dBm) (passive scanning, no IB=
SS)
                        * 5260 MHz [52] (30.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5280 MHz [56] (30.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5300 MHz [60] (30.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5320 MHz [64] (30.0 dBm) (passive scanning, no IB=
SS, radar detection)
                        * 5500 MHz [100] (disabled)
                        * 5520 MHz [104] (disabled)
                        * 5540 MHz [108] (disabled)
                        * 5560 MHz [112] (disabled)
                        * 5580 MHz [116] (disabled)
                        * 5600 MHz [120] (disabled)
                        * 5620 MHz [124] (disabled)
                        * 5640 MHz [128] (disabled)
                        * 5660 MHz [132] (disabled)
                        * 5680 MHz [136] (disabled)
                        * 5700 MHz [140] (disabled)
                        * 5745 MHz [149] (30.0 dBm) (passive scanning, no I=
BSS)
                        * 5765 MHz [153] (30.0 dBm) (passive scanning, no I=
BSS)
                        * 5785 MHz [157] (30.0 dBm) (passive scanning, no I=
BSS)
                        * 5805 MHz [161] (30.0 dBm) (passive scanning, no I=
BSS)
                        * 5825 MHz [165] (30.0 dBm) (passive scanning, no I=
BSS)
                Bitrates (non-HT):
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * mesh point
$

> > How do I persuade the Atheros drivers that, since I'm using AP mode, the
> > user-set regulatory domain is correct,
>
> You cannot. But information from the user to help compliance is
> certainly welcomed.
>
> > and that the domain it selects for
> > EEPROM regdomain 0x0 is wrong?
>
> Its not wrong per se, it was designed that way and you do disagree
> with it. There is also a lot of historical and legal history behind
> how you ended up with a "US" card in "GB". I hope to have clarified
> that.
>
What I'm hearing from you is that my card is not fit for the purpose it was
sold for - can you point me to Atheros documentation that confirms that
EEPROM regdomain 0x0 is US, so that I can hammer on my vendor? The cards
were sold as suitable for using to create an access point in the GB
regulatory domain, and were bought on the grounds that ath5k exists upstrea=
m,
and I like to buy chips with upstream kernel support.

> > Ideally, I would expect both cards to have the same regulatory rules
> > applied;
>
> Indeed, this does seems like a bug.
>
> > I would further expect to be able to select a different country's
> > regulations to the ones selected by default,
>
> Yeah typically that's what users expect but that's not the case.
> Granted there are devices in Linux for which the device has no
> regulatory information at all. In those cases the user does have final
> say on the device. If the vendor does know better though that
> information is respected.
>
> > without losing the card's
> > calibration settings (which I believe are stored in a way that depends =
on
> > the EEPROM regdomain setting).
>
> Spot on -- calibration is actually very important for device
> functionality, it is actually also used for regulatory conformance on
> what we call 'Conformance Test Limits'. Now this is very Atheros
> specific but the idea is the same between vendors, to respect max EIRP
> on band edges very carefully. The CTL info *also* does provide
> regulatory limits for max EIPR in-band, and not just band edges. This
> information is used to conform to the device's calibrated regulatory
> domain.
>
> > I should note that I'm happy to run a
> > privately patched kernel, if that's the only way to do what I want, but
> > I'm still concerned about the differing regulatory rules between the two
> > cards.
>
> I recommend to help resolve your issues by reporting the issues as you
> have but with detailed logs. Sure you can hack up ath5k and ath9k to
> do weird things, maybe even sing, but I advise against it unless you
> know what you are doing. We do have good support upstream for ath9k
> and ath5k for regulatory and calibration purposes. The point is to
> help you use your device as was intended, we can't help you if you
> take your device out of intended regulatory domain due to the
> differences in calibration settings and because it may make the device
> use settings which could potentially damage it. Things are they way
> they are for a reason, except if there is a bug and I do think you
> have found one.
>
The intended regulatory domain is GB. The card was sold as suitable for use
in GB. Chasing the vendor confirms that in their eyes, the upstream
kernel is buggy when it claims US.

> > The relevant chunk of dmesg follows, and I can provide any other needed
> > information upon request:
> >
> > [    1.857433] cfg80211: Calling CRDA to update world regulatory domain
> > [    1.891579] cfg80211: Calling CRDA for country: GB
>
> This probably came from the modprobe thing you have, whatever that
> was. This indicates userspace is being kicked to call /sbin/crda so
> that crda sends the GB regulatory domain to cfg80211. Notice how
> cfg80211 hasn't yet replied though, or maybe it has but cfg80211
> hasn't yet processed anything until later after the other
> regulatory_hint()s.
>
> > [    2.015975] ath5k 0000:02:04.0: PCI INT A -> GSI 18 (level, low) ->
> > IRQ 18 [    2.016204] ath5k 0000:02:04.0: registered as 'phy0'
> > [    2.152564] ath: EEPROM regdomain: 0x0
>
> OK first device has 0x0.
>
> > [    2.152574] ath: EEPROM indicates default country code should be used
> > [    2.152580] ath: doing EEPROM country->regdmn map search
> > [    2.152589] ath: country maps to regdmn code: 0x3a
> > [    2.152595] ath: Country alpha2 being used: US
>
> and it maps the US.
>
> > [    2.152601] ath: Regpair used: 0x3a
> > [    2.264328] phy0: Selected rate control algorithm 'minstrel'
> > [    2.264822] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY:
> > 0x61) [    2.265041]   alloc irq_desc for 17 on node -1
> > [    2.265048]   alloc kstat_irqs on node -1
> > [    2.265066] ath5k 0000:02:08.0: PCI INT A -> GSI 17 (level, low) ->
> > IRQ 17 [    2.265276] ath5k 0000:02:08.0: registered as 'phy1'
> > [    2.400795] ath: EEPROM regdomain: 0x0
>
> Here is the second device and it also has 0x0, ok good.
>
> > [    2.400805] ath: EEPROM indicates default country code should be used
> > [    2.400812] ath: doing EEPROM country->regdmn map search
> > [    2.400821] ath: country maps to regdmn code: 0x3a
> > [    2.400827] ath: Country alpha2 being used: US
>
> And again "US" is picked up.
>
> > [    2.400832] ath: Regpair used: 0x3a
> > [    2.400924] cfg80211: Calling CRDA for country: US
>
> This is the first regulatory_hint() being processed by cfg80211
> module. Eventually userspace udev will kick /sbin/crda and crda will
> send the "US" regulatory domain to cfg80211.
>
> > [    2.403133] phy1: Selected rate control algorithm 'minstrel'
> > [    2.403636] ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY:
> > 0x61) [    2.403867] cfg80211: Calling CRDA for country: US
>
> Here is the second regulatory_hint() being processed. At this point
> userspace is expected to have run twice and the kernel should have
> received the "US" regulatory domain twice.
>
> Now notice the timestamps below in comparison to the one above:
> > [    3.076972] cfg80211: Current regulatory domain intersected:
> > [    3.077089]  (start_freq - end_freq @ bandwidth), (max_antenna_gain,
> > max_eirp) [    3.077277]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
> > mBi, 2000 mBm) [    3.077386]  (2457000 KHz - 2472000 KHz @ 15000 KHz),
> > (300 mBi, 2000 mBm) [    3.077494]  (5170000 KHz - 5250000 KHz @ 40000
> > KHz), (300 mBi, 1700 mBm) [    3.077602]  (5735000 KHz - 5835000 KHz @
> > 40000 KHz), (300 mBi, 2000 mBm)
>
> Lets compare this against the intersection I ran in userspace:
>
> 	(2402.000 - 2472.000 @ 40.000), (N/A, 20.00)
> 	(5170.000 - 5250.000 @ 40.000), (N/A, 17.00)
> 	(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS
> 	(5490.000 - 5710.000 @ 40.000), (N/A, 20.00), DFS
>
> A few observations:
>
>   * Notice how the 2457000 KHz - 2472000 KHz is present on your ouput
> but not on mine.
>
>   * Notice how you have 15000 KHz bandwidth allowed for your 2457000
> KHz - 2472000 KHz frequency range. That bandwidth is there because
> 2472000 minus 2457000 yields  15000, but why the rule is there is not
> clear to me as I am not sure what regulatory domains are being
> intersected here.
>
>   * The 2472000 - 2457000 frequency rule is good example of
> overlapping rules which could probably be avoided if we formalize
> regulatory definitions more as Johannes had proved a while ago.
>
>   * My intersection yielded 5250.000 - 5330.000 but you do not have this =
at
> all
>
>   * You have 5735000 KHz - 5835000 KHz but should not.
>
> We can debug all this further but first I'd like to see your full log.
> To be clearer I'll also recommend for now for you to not have
> something to trigger a regulatory hint from userspace early, either
> through the ieee80211_regdom module parameter, which you have not
> indicated you have used but I do suspect you did use, or through some
> script upon cfg80211 loading. I don't expect a script to have
> triggered a regulatory hint prior to ath5k loading so I am curious how
> you accomplished this.
>
> What is very curious here is cfg80211 indicates it is already
> intersecting. This to me indicates you have either forgotten to add
> more dmesg info from the initial regulatory domain setting *or* there
> is a bug here between cfg80211 believing it already has processed GB.
> Either way you are certainly right that something is fishy here.
>
> Can you just post your full dmesg log?
>
> > [    3.082954] cfg80211: Current regulatory domain intersected:
> > [    3.083078]  (start_freq - end_freq @ bandwidth), (max_antenna_gain,
> > max_eirp) [    3.083278]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
> > mBi, 2000 mBm) [    3.083392]  (2457000 KHz - 2472000 KHz @ 15000 KHz),
> > (300 mBi, 2000 mBm) [    3.083504]  (5170000 KHz - 5250000 KHz @ 40000
> > KHz), (300 mBi, 1700 mBm) [    3.083616]  (5735000 KHz - 5835000 KHz @
> > 40000 KHz), (300 mBi, 2000 mBm)
>
> This listing is identical as the one above. What is even fishier is
> once you have an intersected regulatory domain IIRC we don't let much
> through anymore.
>
> Please enable in your kernel
>
> CONFIG_CFG80211_REG_DEBUG=3Dy
>
Already done.
> Also please ensure to disable CONFIG_WIRELESS_OLD_REGULATORY and
> please tell me if you had this set or not.
>
Already done - it was not set. Just for sanity's sake, I've attached the
=2Econfig that goes with the dmesg.

> Thank you for taking the time to report this.
>
Thank you for responding. It does sound like I'm going to have to work out
how to bypass the regulatory infrastructure - you appear to be confident
that my vendor's wrong, and they're confident that the Linux kernel is wron=
g.

I'm no longer running the kernel with REG_DEBUG set, as I was hitting a
different bug, but the following logs were produced by it. When I have a
bit more spare time, I'll be updating to a more recent wireless-testing,
and then chasing the minstrel warnings (assuming no-one else has fixed
them in the meantime). I'm confident from reading the code that the
minstrel warnings and the out of txbuf messages are related.

Aug 17 21:32:44 newadsl kernel: [    0.000000] Linux version 2.6.31-rc6-wl =
(simon@lister) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #9 SMP Mon Aug =
17 08:58:42 BST 2009
Aug 17 21:32:44 newadsl kernel: [    0.000000] Command line: BOOT_IMAGE=3D/=
boot/vmlinuz-2.6.31-rc6-wl root=3D/dev/sda1 ro libata.force=3D2:short40c
Aug 17 21:32:44 newadsl kernel: [    0.000000] KERNEL supported cpus:
Aug 17 21:32:44 newadsl kernel: [    0.000000]   Intel GenuineIntel
Aug 17 21:32:44 newadsl kernel: [    0.000000]   AMD AuthenticAMD
Aug 17 21:32:44 newadsl kernel: [    0.000000]   Centaur CentaurHauls
Aug 17 21:32:44 newadsl kernel: [    0.000000] BIOS-provided physical RAM m=
ap:
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 0000000000000000=
 - 000000000009f400 (usable)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 000000000009f400=
 - 00000000000a0000 (reserved)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 00000000000f0000=
 - 0000000000100000 (reserved)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 0000000000100000=
 - 000000007f690000 (usable)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 000000007f690000=
 - 000000007f6e0000 (reserved)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 000000007f6e0000=
 - 000000007f6e3000 (ACPI NVS)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 000000007f6e3000=
 - 000000007f6f0000 (ACPI data)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 000000007f6f0000=
 - 000000007f700000 (reserved)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 00000000e0000000=
 - 00000000f0000000 (reserved)
Aug 17 21:32:44 newadsl kernel: [    0.000000]  BIOS-e820: 00000000fec00000=
 - 0000000100000000 (reserved)
Aug 17 21:32:44 newadsl kernel: [    0.000000] DMI 2.2 present.
Aug 17 21:32:44 newadsl kernel: [    0.000000] last_pfn =3D 0x7f690 max_arc=
h_pfn =3D 0x400000000
Aug 17 21:32:44 newadsl kernel: [    0.000000] MTRR default type: uncachable
Aug 17 21:32:44 newadsl kernel: [    0.000000] MTRR fixed ranges enabled:
Aug 17 21:32:44 newadsl kernel: [    0.000000]   00000-9FFFF write-back
Aug 17 21:32:44 newadsl kernel: [    0.000000]   A0000-BFFFF uncachable
Aug 17 21:32:44 newadsl kernel: [    0.000000]   C0000-C9FFF write-protect
Aug 17 21:32:44 newadsl kernel: [    0.000000]   CA000-EFFFF uncachable
Aug 17 21:32:44 newadsl kernel: [    0.000000]   F0000-FFFFF write-through
Aug 17 21:32:44 newadsl kernel: [    0.000000] MTRR variable ranges enabled:
Aug 17 21:32:44 newadsl kernel: [    0.000000]   0 base 000000000 mask 0800=
00000 write-back
Aug 17 21:32:44 newadsl kernel: [    0.000000]   1 base 07F800000 mask 0FF8=
00000 uncachable
Aug 17 21:32:44 newadsl kernel: [    0.000000]   2 base 07F700000 mask 0FFF=
00000 uncachable
Aug 17 21:32:44 newadsl kernel: [    0.000000]   3 disabled
Aug 17 21:32:44 newadsl kernel: [    0.000000]   4 disabled
Aug 17 21:32:44 newadsl kernel: [    0.000000]   5 disabled
Aug 17 21:32:44 newadsl kernel: [    0.000000]   6 disabled
Aug 17 21:32:44 newadsl kernel: [    0.000000]   7 disabled
Aug 17 21:32:44 newadsl kernel: [    0.000000] initial memory mapped : 0 - =
20000000
Aug 17 21:32:44 newadsl kernel: [    0.000000] init_memory_mapping: 0000000=
000000000-000000007f690000
Aug 17 21:32:44 newadsl kernel: [    0.000000]  0000000000 - 007f600000 pag=
e 2M
Aug 17 21:32:44 newadsl kernel: [    0.000000]  007f600000 - 007f690000 pag=
e 4k
Aug 17 21:32:44 newadsl kernel: [    0.000000] kernel direct mapping tables=
 up to 7f690000 @ 8000-c000
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: RSDP 00000000000f7f80 =
00014 (v00 IntelR)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: RSDT 000000007f6e3000 =
00030 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: FACP 000000007f6e3080 =
00074 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: DSDT 000000007f6e3100 =
050A5 (v01 INTELR AWRDACPI 00001000 MSFT 03000000)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: FACS 000000007f6e0000 =
00040
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: MCFG 000000007f6e8280 =
0003C (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: APIC 000000007f6e81c0 =
00084 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: Local APIC address 0xf=
ee00000
Aug 17 21:32:44 newadsl kernel: [    0.000000] (6 early reservations) =3D=
=3D> bootmem [0000000000 - 007f690000]
Aug 17 21:32:44 newadsl kernel: [    0.000000]   #0 [0000000000 - 000000100=
0]   BIOS data page =3D=3D> [0000000000 - 0000001000]
Aug 17 21:32:44 newadsl kernel: [    0.000000]   #1 [0000006000 - 000000800=
0]       TRAMPOLINE =3D=3D> [0000006000 - 0000008000]
Aug 17 21:32:44 newadsl kernel: [    0.000000]   #2 [0001000000 - 00014c0ab=
4]    TEXT DATA BSS =3D=3D> [0001000000 - 00014c0ab4]
Aug 17 21:32:44 newadsl kernel: [    0.000000]   #3 [000009f000 - 000010000=
0]    BIOS reserved =3D=3D> [000009f000 - 0000100000]
Aug 17 21:32:44 newadsl kernel: [    0.000000]   #4 [00014c1000 - 00014c106=
e]              BRK =3D=3D> [00014c1000 - 00014c106e]
Aug 17 21:32:44 newadsl kernel: [    0.000000]   #5 [0000008000 - 000000a00=
0]          PGTABLE =3D=3D> [0000008000 - 000000a000]
Aug 17 21:32:44 newadsl kernel: [    0.000000]  [ffffea0000000000-ffffea000=
1bfffff] PMD -> [ffff880001a00000-ffff8800035fffff] on node 0
Aug 17 21:32:44 newadsl kernel: [    0.000000] Zone PFN ranges:
Aug 17 21:32:44 newadsl kernel: [    0.000000]   DMA      0x00000000 -> 0x0=
0001000
Aug 17 21:32:44 newadsl kernel: [    0.000000]   DMA32    0x00001000 -> 0x0=
0100000
Aug 17 21:32:44 newadsl kernel: [    0.000000]   Normal   0x00100000 -> 0x0=
0100000
Aug 17 21:32:44 newadsl kernel: [    0.000000] Movable zone start PFN for e=
ach node
Aug 17 21:32:44 newadsl kernel: [    0.000000] early_node_map[2] active PFN=
 ranges
Aug 17 21:32:44 newadsl kernel: [    0.000000]     0: 0x00000000 -> 0x00000=
09f
Aug 17 21:32:44 newadsl kernel: [    0.000000]     0: 0x00000100 -> 0x0007f=
690
Aug 17 21:32:44 newadsl kernel: [    0.000000] On node 0 totalpages: 521775
Aug 17 21:32:44 newadsl kernel: [    0.000000]   DMA zone: 56 pages used fo=
r memmap
Aug 17 21:32:44 newadsl kernel: [    0.000000]   DMA zone: 102 pages reserv=
ed
Aug 17 21:32:44 newadsl kernel: [    0.000000]   DMA zone: 3841 pages, LIFO=
 batch:0
Aug 17 21:32:44 newadsl kernel: [    0.000000]   DMA32 zone: 7079 pages use=
d for memmap
Aug 17 21:32:44 newadsl kernel: [    0.000000]   DMA32 zone: 510697 pages, =
LIFO batch:31
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: Local APIC address 0xf=
ee00000
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] l=
apic_id[0x00] enabled)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] l=
apic_id[0x01] enabled)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] l=
apic_id[0x02] disabled)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] l=
apic_id[0x03] disabled)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0=
0] high edge lint[0x1])
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0=
1] high edge lint[0x1])
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0=
2] high edge lint[0x1])
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0=
3] high edge lint[0x1])
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: IOAPIC (id[0x04] addre=
ss[0xfec00000] gsi_base[0])
Aug 17 21:32:44 newadsl kernel: [    0.000000] IOAPIC[0]: apic_id 4, versio=
n 32, address 0xfec00000, GSI 0-23
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 0 global_irq 2 dfl dfl)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 9 global_irq 9 high level)
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: IRQ0 used by override.
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: IRQ2 used by override.
Aug 17 21:32:44 newadsl kernel: [    0.000000] ACPI: IRQ9 used by override.
Aug 17 21:32:44 newadsl kernel: [    0.000000] Using ACPI (MADT) for SMP co=
nfiguration information
Aug 17 21:32:44 newadsl kernel: [    0.000000] 4 Processors exceeds NR_CPUS=
 limit of 2
Aug 17 21:32:44 newadsl kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotp=
lug CPUs
Aug 17 21:32:44 newadsl kernel: [    0.000000] nr_irqs_gsi: 24
Aug 17 21:32:44 newadsl kernel: [    0.000000] Allocating PCI resources sta=
rting at 7f700000 (gap: 7f700000:60900000)
Aug 17 21:32:44 newadsl kernel: [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 =
nr_cpu_ids:2 nr_node_ids:1
Aug 17 21:32:44 newadsl kernel: [    0.000000] PERCPU: Embedded 25 pages at=
 ffff8800014d2000, static data 70944 bytes
Aug 17 21:32:44 newadsl kernel: [    0.000000] Built 1 zonelists in Zone or=
der, mobility grouping on.  Total pages: 514538
Aug 17 21:32:44 newadsl kernel: [    0.000000] Kernel command line: BOOT_IM=
AGE=3D/boot/vmlinuz-2.6.31-rc6-wl root=3D/dev/sda1 ro libata.force=3D2:shor=
t40c
Aug 17 21:32:44 newadsl kernel: [    0.000000] PID hash table entries: 4096=
 (order: 12, 32768 bytes)
Aug 17 21:32:44 newadsl kernel: [    0.000000] Dentry cache hash table entr=
ies: 262144 (order: 9, 2097152 bytes)
Aug 17 21:32:44 newadsl kernel: [    0.000000] Inode-cache hash table entri=
es: 131072 (order: 8, 1048576 bytes)
Aug 17 21:32:44 newadsl kernel: [    0.000000] Initializing CPU#0
Aug 17 21:32:44 newadsl kernel: [    0.000000] Checking aperture...
Aug 17 21:32:44 newadsl kernel: [    0.000000] No AGP bridge found
Aug 17 21:32:44 newadsl kernel: [    0.000000] Memory: 2049640k/2087488k av=
ailable (2821k kernel code, 388k absent, 36948k reserved, 1297k data, 384k =
init)
Aug 17 21:32:44 newadsl kernel: [    0.000000] SLUB: Genslabs=3D13, HWalign=
=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
Aug 17 21:32:44 newadsl kernel: [    0.000000] NR_IRQS:4352 nr_irqs:424
Aug 17 21:32:44 newadsl kernel: [    0.000000] Fast TSC calibration using P=
IT
Aug 17 21:32:44 newadsl kernel: [    0.000000] Detected 1600.187 MHz proces=
sor.
Aug 17 21:32:44 newadsl kernel: [    0.000999] Console: colour VGA+ 80x25
Aug 17 21:32:44 newadsl kernel: [    0.000999] console [tty0] enabled
Aug 17 21:32:44 newadsl kernel: [    0.001012] Calibrating delay loop (skip=
ped), value calculated using timer frequency.. 3200.37 BogoMIPS (lpj=3D1600=
187)
Aug 17 21:32:44 newadsl kernel: [    0.001289] Mount-cache hash table entri=
es: 256
Aug 17 21:32:44 newadsl kernel: [    0.001686] CPU: L1 I cache: 32K, L1 D c=
ache: 24K
Aug 17 21:32:44 newadsl kernel: [    0.001822] CPU: L2 cache: 512K
Aug 17 21:32:44 newadsl kernel: [    0.001928] CPU: Physical Processor ID: 0
Aug 17 21:32:44 newadsl kernel: [    0.002007] CPU: Processor Core ID: 0
Aug 17 21:32:44 newadsl kernel: [    0.002114] mce: CPU supports 5 MCE banks
Aug 17 21:32:44 newadsl kernel: [    0.002230] CPU0: Thermal monitoring ena=
bled (TM1)
Aug 17 21:32:44 newadsl kernel: [    0.002341] using mwait in idle threads.
Aug 17 21:32:44 newadsl kernel: [    0.002468] Freeing SMP alternatives: 29=
k freed
Aug 17 21:32:44 newadsl kernel: [    0.002620] ACPI: Core revision 20090521
Aug 17 21:32:44 newadsl kernel: [    0.015077] Setting APIC routing to flat
Aug 17 21:32:44 newadsl kernel: [    0.016264] ..TIMER: vector=3D0x30 apic1=
=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
Aug 17 21:32:44 newadsl kernel: [    0.026384] CPU0: Intel(R) Atom(TM) CPU =
 230   @ 1.60GHz stepping 02
Aug 17 21:32:44 newadsl kernel: [    0.026995] Booting processor 1 APIC 0x1=
 ip 0x6000
Aug 17 21:32:44 newadsl kernel: [    0.000999] Initializing CPU#1
Aug 17 21:32:44 newadsl kernel: [    0.000999] Calibrating delay using time=
r specific routine.. 3199.12 BogoMIPS (lpj=3D1599562)
Aug 17 21:32:44 newadsl kernel: [    0.000999] CPU: L1 I cache: 32K, L1 D c=
ache: 24K
Aug 17 21:32:44 newadsl kernel: [    0.000999] CPU: L2 cache: 512K
Aug 17 21:32:44 newadsl kernel: [    0.000999] CPU: Physical Processor ID: 0
Aug 17 21:32:44 newadsl kernel: [    0.000999] CPU: Processor Core ID: 0
Aug 17 21:32:44 newadsl kernel: [    0.000999] mce: CPU supports 5 MCE banks
Aug 17 21:32:44 newadsl kernel: [    0.000999] CPU1: Thermal monitoring ena=
bled (TM2)
Aug 17 21:32:44 newadsl kernel: [    0.097185] CPU1: Intel(R) Atom(TM) CPU =
 230   @ 1.60GHz stepping 02
Aug 17 21:32:44 newadsl kernel: [    0.098127] checking TSC synchronization=
 [CPU#0 -> CPU#1]: passed.
Aug 17 21:32:44 newadsl kernel: [    0.099018] Brought up 2 CPUs
Aug 17 21:32:44 newadsl kernel: [    0.099127] Total of 2 processors activa=
ted (6399.49 BogoMIPS).
Aug 17 21:32:44 newadsl kernel: [    0.100175] NET: Registered protocol fam=
ily 16
Aug 17 21:32:44 newadsl kernel: [    0.101043] ACPI: bus type pci registered
Aug 17 21:32:44 newadsl kernel: [    0.101169] PCI: Found Intel Corporation=
 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support.
Aug 17 21:32:44 newadsl kernel: [    0.101226] PCI: MCFG configuration 0: b=
ase e0000000 segment 0 buses 0 - 255
Aug 17 21:32:44 newadsl kernel: [    0.101338] PCI: MCFG area at e0000000 r=
eserved in E820
Aug 17 21:32:44 newadsl kernel: [    0.107632] PCI: Using MMCONFIG at e0000=
000 - efffffff
Aug 17 21:32:44 newadsl kernel: [    0.107750] PCI: Using configuration typ=
e 1 for base access
Aug 17 21:32:44 newadsl kernel: [    0.115167] bio: create slab <bio-0> at 0
Aug 17 21:32:44 newadsl kernel: [    0.116878] ACPI: EC: Look up EC in DSDT
Aug 17 21:32:44 newadsl kernel: [    0.131513] ACPI: Interpreter enabled
Aug 17 21:32:44 newadsl kernel: [    0.131632] ACPI: (supports S0 S5)
Aug 17 21:32:44 newadsl kernel: [    0.131805] ACPI: Using IOAPIC for inter=
rupt routing
Aug 17 21:32:44 newadsl kernel: [    0.147235] ACPI: No dock devices found.
Aug 17 21:32:44 newadsl kernel: [    0.147553] ACPI: PCI Root Bridge [PCI0]=
 (0000:00)
Aug 17 21:32:44 newadsl kernel: [    0.148228] pci 0000:00:02.0: reg 10 32b=
it mmio: [0xfdf00000-0xfdf7ffff]
Aug 17 21:32:44 newadsl kernel: [    0.148228] pci 0000:00:02.0: reg 14 io =
port: [0xff00-0xff07]
Aug 17 21:32:44 newadsl kernel: [    0.148228] pci 0000:00:02.0: reg 18 32b=
it mmio: [0xd0000000-0xdfffffff]
Aug 17 21:32:44 newadsl kernel: [    0.148228] pci 0000:00:02.0: reg 1c 32b=
it mmio: [0xfdf80000-0xfdfbffff]
Aug 17 21:32:44 newadsl kernel: [    0.148228] pci 0000:00:1c.0: PME# suppo=
rted from D0 D3hot D3cold
Aug 17 21:32:44 newadsl kernel: [    0.148228] pci 0000:00:1c.0: PME# disab=
led
Aug 17 21:32:44 newadsl kernel: [    0.148312] pci 0000:00:1d.0: reg 20 io =
port: [0xfe00-0xfe1f]
Aug 17 21:32:44 newadsl kernel: [    0.148375] pci 0000:00:1d.1: reg 20 io =
port: [0xfd00-0xfd1f]
Aug 17 21:32:44 newadsl kernel: [    0.148437] pci 0000:00:1d.2: reg 20 io =
port: [0xfc00-0xfc1f]
Aug 17 21:32:44 newadsl kernel: [    0.148499] pci 0000:00:1d.3: reg 20 io =
port: [0xfb00-0xfb1f]
Aug 17 21:32:44 newadsl kernel: [    0.148580] pci 0000:00:1d.7: reg 10 32b=
it mmio: [0xfdfff000-0xfdfff3ff]
Aug 17 21:32:44 newadsl kernel: [    0.148641] pci 0000:00:1d.7: PME# suppo=
rted from D0 D3hot D3cold
Aug 17 21:32:44 newadsl kernel: [    0.148755] pci 0000:00:1d.7: PME# disab=
led
Aug 17 21:32:44 newadsl kernel: [    0.149014] pci 0000:00:1f.0: Force enab=
led HPET at 0xfed00000
Aug 17 21:32:44 newadsl kernel: [    0.149026] pci 0000:00:1f.0: quirk: reg=
ion 0400-047f claimed by ICH6 ACPI/GPIO/TCO
Aug 17 21:32:44 newadsl kernel: [    0.149217] pci 0000:00:1f.0: quirk: reg=
ion 0480-04bf claimed by ICH6 GPIO
Aug 17 21:32:44 newadsl kernel: [    0.149330] pci 0000:00:1f.0: ICH7 LPC G=
eneric IO decode 1 PIO at 0294 (mask 007f)
Aug 17 21:32:44 newadsl kernel: [    0.149520] pci 0000:00:1f.0: ICH7 LPC G=
eneric IO decode 2 PIO at 04e0 (mask 001f)
Aug 17 21:32:44 newadsl kernel: [    0.149768] pci 0000:00:1f.2: reg 10 io =
port: [0x00-0x07]
Aug 17 21:32:44 newadsl kernel: [    0.149778] pci 0000:00:1f.2: reg 14 io =
port: [0x00-0x03]
Aug 17 21:32:44 newadsl kernel: [    0.149788] pci 0000:00:1f.2: reg 18 io =
port: [0x00-0x07]
Aug 17 21:32:44 newadsl kernel: [    0.149798] pci 0000:00:1f.2: reg 1c io =
port: [0x00-0x03]
Aug 17 21:32:44 newadsl kernel: [    0.149808] pci 0000:00:1f.2: reg 20 io =
port: [0xf800-0xf80f]
Aug 17 21:32:44 newadsl kernel: [    0.149839] pci 0000:00:1f.2: PME# suppo=
rted from D3hot
Aug 17 21:32:44 newadsl kernel: [    0.149950] pci 0000:00:1f.2: PME# disab=
led
Aug 17 21:32:44 newadsl kernel: [    0.150033] pci 0000:00:1f.3: reg 20 io =
port: [0x500-0x51f]
Aug 17 21:32:44 newadsl kernel: [    0.150123] pci 0000:01:00.0: reg 10 io =
port: [0xce00-0xceff]
Aug 17 21:32:44 newadsl kernel: [    0.150149] pci 0000:01:00.0: reg 18 64b=
it mmio: [0xfdbff000-0xfdbfffff]
Aug 17 21:32:44 newadsl kernel: [    0.150168] pci 0000:01:00.0: reg 20 64b=
it mmio: [0xfdcf0000-0xfdcfffff]
Aug 17 21:32:44 newadsl kernel: [    0.150181] pci 0000:01:00.0: reg 30 32b=
it mmio: [0x000000-0x01ffff]
Aug 17 21:32:44 newadsl kernel: [    0.150228] pci 0000:01:00.0: supports D=
1 D2
Aug 17 21:32:44 newadsl kernel: [    0.150234] pci 0000:01:00.0: PME# suppo=
rted from D0 D1 D2 D3hot D3cold
Aug 17 21:32:44 newadsl kernel: [    0.150348] pci 0000:01:00.0: PME# disab=
led
Aug 17 21:32:44 newadsl kernel: [    0.153077] pci 0000:00:1c.0: bridge io =
port: [0xc000-0xcfff]
Aug 17 21:32:44 newadsl kernel: [    0.153086] pci 0000:00:1c.0: bridge 32b=
it mmio: [0xfdb00000-0xfdbfffff]
Aug 17 21:32:44 newadsl kernel: [    0.153097] pci 0000:00:1c.0: bridge 64b=
it mmio pref: [0xfdc00000-0xfdcfffff]
Aug 17 21:32:44 newadsl kernel: [    0.153138] pci 0000:02:01.0: reg 10 32b=
it mmio: [0xfdeff000-0xfdeff07f]
Aug 17 21:32:44 newadsl kernel: [    0.153150] pci 0000:02:01.0: reg 14 32b=
it mmio: [0xfdef0000-0xfdef7fff]
Aug 17 21:32:44 newadsl kernel: [    0.153230] pci 0000:02:04.0: reg 10 32b=
it mmio: [0xfdee0000-0xfdeeffff]
Aug 17 21:32:44 newadsl kernel: [    0.153336] pci 0000:02:08.0: reg 10 32b=
it mmio: [0xfded0000-0xfdedffff]
Aug 17 21:32:44 newadsl kernel: [    0.153433] pci 0000:00:1e.0: transparen=
t bridge
Aug 17 21:32:44 newadsl kernel: [    0.153545] pci 0000:00:1e.0: bridge io =
port: [0xd000-0xdfff]
Aug 17 21:32:44 newadsl kernel: [    0.153553] pci 0000:00:1e.0: bridge 32b=
it mmio: [0xfde00000-0xfdefffff]
Aug 17 21:32:44 newadsl kernel: [    0.153564] pci 0000:00:1e.0: bridge 64b=
it mmio pref: [0xfdd00000-0xfddfffff]
Aug 17 21:32:44 newadsl kernel: [    0.153581] pci_bus 0000:00: on NUMA nod=
e 0
Aug 17 21:32:44 newadsl kernel: [    0.153595] ACPI: PCI Interrupt Routing =
Table [\_SB_.PCI0._PRT]
Aug 17 21:32:44 newadsl kernel: [    0.153935] ACPI: PCI Interrupt Routing =
Table [\_SB_.PCI0.PEX0._PRT]
Aug 17 21:32:44 newadsl kernel: [    0.154115] ACPI: PCI Interrupt Routing =
Table [\_SB_.PCI0.HUB0._PRT]
Aug 17 21:32:44 newadsl kernel: [    0.177180] ACPI: PCI Interrupt Link [LN=
KA] (IRQs 5 7 *9 10 11 12 14 15)
Aug 17 21:32:44 newadsl kernel: [    0.177746] ACPI: PCI Interrupt Link [LN=
KB] (IRQs 5 7 9 *10 11 12 14 15)
Aug 17 21:32:44 newadsl kernel: [    0.178474] ACPI: PCI Interrupt Link [LN=
KC] (IRQs *5 7 9 10 11 12 14 15)
Aug 17 21:32:44 newadsl kernel: [    0.179051] ACPI: PCI Interrupt Link [LN=
KD] (IRQs 5 7 9 10 *11 12 14 15)
Aug 17 21:32:44 newadsl kernel: [    0.179604] ACPI: PCI Interrupt Link [LN=
KE] (IRQs 5 7 9 10 *11 12 14 15)
Aug 17 21:32:44 newadsl kernel: [    0.180160] ACPI: PCI Interrupt Link [LN=
KF] (IRQs 5 7 9 10 11 12 14 15) *0, disabled.
Aug 17 21:32:44 newadsl kernel: [    0.180833] ACPI: PCI Interrupt Link [LN=
K0] (IRQs 5 7 9 10 11 12 14 15) *0, disabled.
Aug 17 21:32:44 newadsl kernel: [    0.181501] ACPI: PCI Interrupt Link [LN=
K1] (IRQs 5 7 9 *10 11 12 14 15)
Aug 17 21:32:44 newadsl kernel: [    0.182468] SCSI subsystem initialized
Aug 17 21:32:44 newadsl kernel: [    0.183057] libata version 3.00 loaded.
Aug 17 21:32:44 newadsl kernel: [    0.183059] usbcore: registered new inte=
rface driver usbfs
Aug 17 21:32:44 newadsl kernel: [    0.183059] usbcore: registered new inte=
rface driver hub
Aug 17 21:32:44 newadsl kernel: [    0.183114] usbcore: registered new devi=
ce driver usb
Aug 17 21:32:44 newadsl kernel: [    0.184036] PCI: Using ACPI for IRQ rout=
ing
Aug 17 21:32:44 newadsl kernel: [    0.184122] NET: Registered protocol fam=
ily 8
Aug 17 21:32:44 newadsl kernel: [    0.184145] NET: Registered protocol fam=
ily 20
Aug 17 21:32:44 newadsl kernel: [    0.185168] hpet clockevent registered
Aug 17 21:32:44 newadsl kernel: [    0.185175] HPET: 3 timers in total, 0 t=
imers will be used for per-cpu timer
Aug 17 21:32:44 newadsl kernel: [    0.185175] hpet0: at MMIO 0xfed00000, I=
RQs 2, 8, 0
Aug 17 21:32:44 newadsl kernel: [    0.185185] hpet0: 3 comparators, 64-bit=
 14.318180 MHz counter
Aug 17 21:32:44 newadsl kernel: [    0.188036] pnp: PnP ACPI init
Aug 17 21:32:44 newadsl kernel: [    0.188161] ACPI: bus type pnp registered
Aug 17 21:32:44 newadsl kernel: [    0.191283] pnp 00:06: IRQ 4 override to=
 edge, high
Aug 17 21:32:44 newadsl kernel: [    0.192330] pnp 00:07: IRQ 3 override to=
 edge, high
Aug 17 21:32:44 newadsl kernel: [    0.197560] pnp: PnP ACPI: found 14 devi=
ces
Aug 17 21:32:44 newadsl kernel: [    0.197671] ACPI: ACPI bus type pnp unre=
gistered
Aug 17 21:32:44 newadsl kernel: [    0.197802] system 00:01: ioport range 0=
x4d0-0x4d1 has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.197916] system 00:01: ioport range 0=
x290-0x29f has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.198034] system 00:01: ioport range 0=
x290-0x297 has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.198147] system 00:01: ioport range 0=
x880-0x88f has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.198275] system 00:0a: ioport range 0=
x400-0x4bf could not be reserved
Aug 17 21:32:44 newadsl kernel: [    0.198394] system 00:0c: iomem range 0x=
e0000000-0xefffffff has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.198520] system 00:0d: iomem range 0x=
f0000-0xfffff could not be reserved
Aug 17 21:32:44 newadsl kernel: [    0.198633] system 00:0d: iomem range 0x=
7f6e0000-0x7f6fffff could not be reserved
Aug 17 21:32:44 newadsl kernel: [    0.198821] system 00:0d: iomem range 0x=
0-0x9ffff could not be reserved
Aug 17 21:32:44 newadsl kernel: [    0.198934] system 00:0d: iomem range 0x=
100000-0x7f6dffff could not be reserved
Aug 17 21:32:44 newadsl kernel: [    0.199126] system 00:0d: iomem range 0x=
fec00000-0xfec00fff could not be reserved
Aug 17 21:32:44 newadsl kernel: [    0.199315] system 00:0d: iomem range 0x=
fed13000-0xfed1dfff has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.199433] system 00:0d: iomem range 0x=
fed20000-0xfed8ffff has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.199545] system 00:0d: iomem range 0x=
fee00000-0xfee00fff has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.199659] system 00:0d: iomem range 0x=
ffb00000-0xffb7ffff has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.199771] system 00:0d: iomem range 0x=
fff00000-0xffffffff has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.199886] system 00:0d: iomem range 0x=
e0000-0xeffff has been reserved
Aug 17 21:32:44 newadsl kernel: [    0.205589] pci 0000:00:1c.0: PCI bridge=
, secondary bus 0000:01
Aug 17 21:32:44 newadsl kernel: [    0.205705] pci 0000:00:1c.0:   IO windo=
w: 0xc000-0xcfff
Aug 17 21:32:44 newadsl kernel: [    0.205818] pci 0000:00:1c.0:   MEM wind=
ow: 0xfdb00000-0xfdbfffff
Aug 17 21:32:44 newadsl kernel: [    0.205933] pci 0000:00:1c.0:   PREFETCH=
 window: 0x000000fdc00000-0x000000fdcfffff
Aug 17 21:32:44 newadsl kernel: [    0.208361] pci 0000:00:1e.0: PCI bridge=
, secondary bus 0000:02
Aug 17 21:32:44 newadsl kernel: [    0.208472] pci 0000:00:1e.0:   IO windo=
w: 0xd000-0xdfff
Aug 17 21:32:44 newadsl kernel: [    0.208581] pci 0000:00:1e.0:   MEM wind=
ow: 0xfde00000-0xfdefffff
Aug 17 21:32:44 newadsl kernel: [    0.208691] pci 0000:00:1e.0:   PREFETCH=
 window: 0x000000fdd00000-0x000000fddfffff
Aug 17 21:32:44 newadsl kernel: [    0.208889]   alloc irq_desc for 16 on n=
ode -1
Aug 17 21:32:44 newadsl kernel: [    0.208894]   alloc kstat_irqs on node -1
Aug 17 21:32:44 newadsl kernel: [    0.208906] pci 0000:00:1c.0: PCI INT A =
=2D> GSI 16 (level, low) -> IRQ 16
Aug 17 21:32:44 newadsl kernel: [    0.209019] pci 0000:00:1c.0: setting la=
tency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.209031] pci 0000:00:1e.0: setting la=
tency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.209041] pci_bus 0000:00: resource 0 =
io:  [0x00-0xffff]
Aug 17 21:32:44 newadsl kernel: [    0.209047] pci_bus 0000:00: resource 1 =
mem: [0x000000-0xffffffffffffffff]
Aug 17 21:32:44 newadsl kernel: [    0.209054] pci_bus 0000:01: resource 0 =
io:  [0xc000-0xcfff]
Aug 17 21:32:44 newadsl kernel: [    0.209061] pci_bus 0000:01: resource 1 =
mem: [0xfdb00000-0xfdbfffff]
Aug 17 21:32:44 newadsl kernel: [    0.209067] pci_bus 0000:01: resource 2 =
pref mem [0xfdc00000-0xfdcfffff]
Aug 17 21:32:44 newadsl kernel: [    0.209074] pci_bus 0000:02: resource 0 =
io:  [0xd000-0xdfff]
Aug 17 21:32:44 newadsl kernel: [    0.209080] pci_bus 0000:02: resource 1 =
mem: [0xfde00000-0xfdefffff]
Aug 17 21:32:44 newadsl kernel: [    0.209086] pci_bus 0000:02: resource 2 =
pref mem [0xfdd00000-0xfddfffff]
Aug 17 21:32:44 newadsl kernel: [    0.209093] pci_bus 0000:02: resource 3 =
io:  [0x00-0xffff]
Aug 17 21:32:44 newadsl kernel: [    0.209099] pci_bus 0000:02: resource 4 =
mem: [0x000000-0xffffffffffffffff]
Aug 17 21:32:44 newadsl kernel: [    0.209135] NET: Registered protocol fam=
ily 2
Aug 17 21:32:44 newadsl kernel: [    0.209308] IP route cache hash table en=
tries: 65536 (order: 7, 524288 bytes)
Aug 17 21:32:44 newadsl kernel: [    0.210245] TCP established hash table e=
ntries: 262144 (order: 10, 4194304 bytes)
Aug 17 21:32:44 newadsl kernel: [    0.214251] TCP bind hash table entries:=
 65536 (order: 8, 1048576 bytes)
Aug 17 21:32:44 newadsl kernel: [    0.215329] TCP: Hash tables configured =
(established 262144 bind 65536)
Aug 17 21:32:44 newadsl kernel: [    0.215461] TCP reno registered
Aug 17 21:32:44 newadsl kernel: [    0.215750] NET: Registered protocol fam=
ily 1
Aug 17 21:32:44 newadsl kernel: [    0.224747] msgmni has been set to 4004
Aug 17 21:32:44 newadsl kernel: [    0.225364] alg: No test for stdrng (krn=
g)
Aug 17 21:32:44 newadsl kernel: [    0.225499] io scheduler noop registered=
 (default)
Aug 17 21:32:44 newadsl kernel: [    0.225627] pci 0000:00:02.0: Boot video=
 device
Aug 17 21:32:44 newadsl kernel: [    0.226017]   alloc irq_desc for 24 on n=
ode -1
Aug 17 21:32:44 newadsl kernel: [    0.226023]   alloc kstat_irqs on node -1
Aug 17 21:32:44 newadsl kernel: [    0.226039] pcieport-driver 0000:00:1c.0=
: irq 24 for MSI/MSI-X
Aug 17 21:32:44 newadsl kernel: [    0.226054] pcieport-driver 0000:00:1c.0=
: setting latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.226859] input: Power Button as /devi=
ces/LNXSYSTM:00/LNXPWRBN:00/input/input0
Aug 17 21:32:44 newadsl kernel: [    0.227067] ACPI: Power Button [PWRF]
Aug 17 21:32:44 newadsl kernel: [    0.227376] input: Power Button as /devi=
ces/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
Aug 17 21:32:44 newadsl kernel: [    0.227569] ACPI: Power Button [PWRB]
Aug 17 21:32:44 newadsl kernel: [    0.227982] processor LNXCPU:00: registe=
red as cooling_device0
Aug 17 21:32:44 newadsl kernel: [    0.228244] processor LNXCPU:01: registe=
red as cooling_device1
Aug 17 21:32:44 newadsl kernel: [    0.229674] thermal LNXTHERM:01: registe=
red as thermal_zone0
Aug 17 21:32:44 newadsl kernel: [    0.229801] ACPI: Thermal Zone [THRM] (3=
0 C)
Aug 17 21:32:44 newadsl kernel: [    0.323226] Linux agpgart interface v0.1=
03
Aug 17 21:32:44 newadsl kernel: [    0.323340] Serial: 8250/16550 driver, 4=
 ports, IRQ sharing enabled
Aug 17 21:32:44 newadsl kernel: [    0.323630] serial8250: ttyS0 at I/O 0x3=
f8 (irq =3D 4) is a 16550A
Aug 17 21:32:44 newadsl kernel: [    0.324093] serial8250: ttyS1 at I/O 0x2=
f8 (irq =3D 3) is a 16550A
Aug 17 21:32:44 newadsl kernel: [    0.325554] 00:06: ttyS0 at I/O 0x3f8 (i=
rq =3D 4) is a 16550A
Aug 17 21:32:44 newadsl kernel: [    0.326424] 00:07: ttyS1 at I/O 0x2f8 (i=
rq =3D 3) is a 16550A
Aug 17 21:32:44 newadsl kernel: [    0.327219] ata_piix 0000:00:1f.2: versi=
on 2.13
Aug 17 21:32:44 newadsl kernel: [    0.327254]   alloc irq_desc for 19 on n=
ode -1
Aug 17 21:32:44 newadsl kernel: [    0.327259]   alloc kstat_irqs on node -1
Aug 17 21:32:44 newadsl kernel: [    0.327272] ata_piix 0000:00:1f.2: PCI I=
NT B -> GSI 19 (level, low) -> IRQ 19
Aug 17 21:32:44 newadsl kernel: [    0.327397] ata_piix 0000:00:1f.2: MAP [=
 P0 P2 IDE IDE ]
Aug 17 21:32:44 newadsl kernel: [    0.327651] ata_piix 0000:00:1f.2: setti=
ng latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.327761] scsi0 : ata_piix
Aug 17 21:32:44 newadsl kernel: [    0.328170] scsi1 : ata_piix
Aug 17 21:32:44 newadsl kernel: [    0.329938] ata1: SATA max UDMA/133 cmd =
0x1f0 ctl 0x3f6 bmdma 0xf800 irq 14
Aug 17 21:32:44 newadsl kernel: [    0.330061] ata2: PATA max UDMA/100 cmd =
0x170 ctl 0x376 bmdma 0xf808 irq 15
Aug 17 21:32:44 newadsl kernel: [    0.330332] PPP generic driver version 2=
=2E4.2
Aug 17 21:32:44 newadsl kernel: [    0.330846] r8169 Gigabit Ethernet drive=
r 2.3LK-NAPI loaded
Aug 17 21:32:44 newadsl kernel: [    0.330994] r8169 0000:01:00.0: PCI INT =
A -> GSI 16 (level, low) -> IRQ 16
Aug 17 21:32:44 newadsl kernel: [    0.331153] r8169 0000:01:00.0: setting =
latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.331204]   alloc irq_desc for 25 on n=
ode -1
Aug 17 21:32:44 newadsl kernel: [    0.331209]   alloc kstat_irqs on node -1
Aug 17 21:32:44 newadsl kernel: [    0.331230] r8169 0000:01:00.0: irq 25 f=
or MSI/MSI-X
Aug 17 21:32:44 newadsl kernel: [    0.331485] eth0: RTL8168c/8111c at 0xff=
ffc90000028000, 00:30:18:a9:57:5f, XID 3c4000c0 IRQ 25
Aug 17 21:32:44 newadsl kernel: [    0.334533] Solos PCI Driver Version 0.07
Aug 17 21:32:44 newadsl kernel: [    0.334671] solos 0000:02:01.0: PCI INT =
A -> GSI 16 (level, low) -> IRQ 16
Aug 17 21:32:44 newadsl kernel: [    0.334804] solos 0000:02:01.0: Solos FP=
GA Version 0.03 svn-36
Aug 17 21:32:44 newadsl kernel: [    0.335205] solos 0000:02:01.0: Register=
ed ATM device 0
Aug 17 21:32:44 newadsl kernel: [    0.335577] solos 0000:02:01.0: Register=
ed ATM device 1
Aug 17 21:32:44 newadsl kernel: [    0.335781] ehci_hcd: USB 2.0 'Enhanced'=
 Host Controller (EHCI) Driver
Aug 17 21:32:44 newadsl kernel: [    0.335927]   alloc irq_desc for 23 on n=
ode -1
Aug 17 21:32:44 newadsl kernel: [    0.335934]   alloc kstat_irqs on node -1
Aug 17 21:32:44 newadsl kernel: [    0.335946] ehci_hcd 0000:00:1d.7: PCI I=
NT A -> GSI 23 (level, low) -> IRQ 23
Aug 17 21:32:44 newadsl kernel: [    0.336073] ehci_hcd 0000:00:1d.7: setti=
ng latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.336080] ehci_hcd 0000:00:1d.7: EHCI =
Host Controller
Aug 17 21:32:44 newadsl kernel: [    0.336200] ehci_hcd 0000:00:1d.7: new U=
SB bus registered, assigned bus number 1
Aug 17 21:32:44 newadsl kernel: [    0.340343] ehci_hcd 0000:00:1d.7: debug=
 port 1
Aug 17 21:32:44 newadsl kernel: [    0.340462] ehci_hcd 0000:00:1d.7: cache=
 line size of 32 is not supported
Aug 17 21:32:44 newadsl kernel: [    0.340491] ehci_hcd 0000:00:1d.7: irq 2=
3, io mem 0xfdfff000
Aug 17 21:32:44 newadsl kernel: [    0.350377] ehci_hcd 0000:00:1d.7: USB 2=
=2E0 started, EHCI 1.00
Aug 17 21:32:44 newadsl kernel: [    0.350807] usb usb1: configuration #1 c=
hosen from 1 choice
Aug 17 21:32:44 newadsl kernel: [    0.351040] hub 1-0:1.0: USB hub found
Aug 17 21:32:44 newadsl kernel: [    0.351156] hub 1-0:1.0: 8 ports detected
Aug 17 21:32:44 newadsl kernel: [    0.351458] uhci_hcd: USB Universal Host=
 Controller Interface driver
Aug 17 21:32:44 newadsl kernel: [    0.351747] uhci_hcd 0000:00:1d.0: PCI I=
NT A -> GSI 23 (level, low) -> IRQ 23
Aug 17 21:32:44 newadsl kernel: [    0.351867] uhci_hcd 0000:00:1d.0: setti=
ng latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.351874] uhci_hcd 0000:00:1d.0: UHCI =
Host Controller
Aug 17 21:32:44 newadsl kernel: [    0.351991] uhci_hcd 0000:00:1d.0: new U=
SB bus registered, assigned bus number 2
Aug 17 21:32:44 newadsl kernel: [    0.352202] uhci_hcd 0000:00:1d.0: irq 2=
3, io base 0x0000fe00
Aug 17 21:32:44 newadsl kernel: [    0.352667] usb usb2: configuration #1 c=
hosen from 1 choice
Aug 17 21:32:44 newadsl kernel: [    0.352896] hub 2-0:1.0: USB hub found
Aug 17 21:32:44 newadsl kernel: [    0.353018] hub 2-0:1.0: 2 ports detected
Aug 17 21:32:44 newadsl kernel: [    0.353224] uhci_hcd 0000:00:1d.1: PCI I=
NT B -> GSI 19 (level, low) -> IRQ 19
Aug 17 21:32:44 newadsl kernel: [    0.353348] uhci_hcd 0000:00:1d.1: setti=
ng latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.353355] uhci_hcd 0000:00:1d.1: UHCI =
Host Controller
Aug 17 21:32:44 newadsl kernel: [    0.353480] uhci_hcd 0000:00:1d.1: new U=
SB bus registered, assigned bus number 3
Aug 17 21:32:44 newadsl kernel: [    0.353722] uhci_hcd 0000:00:1d.1: irq 1=
9, io base 0x0000fd00
Aug 17 21:32:44 newadsl kernel: [    0.354171] usb usb3: configuration #1 c=
hosen from 1 choice
Aug 17 21:32:44 newadsl kernel: [    0.354429] hub 3-0:1.0: USB hub found
Aug 17 21:32:44 newadsl kernel: [    0.354546] hub 3-0:1.0: 2 ports detected
Aug 17 21:32:44 newadsl kernel: [    0.354749]   alloc irq_desc for 18 on n=
ode -1
Aug 17 21:32:44 newadsl kernel: [    0.354755]   alloc kstat_irqs on node -1
Aug 17 21:32:44 newadsl kernel: [    0.354768] uhci_hcd 0000:00:1d.2: PCI I=
NT C -> GSI 18 (level, low) -> IRQ 18
Aug 17 21:32:44 newadsl kernel: [    0.354888] uhci_hcd 0000:00:1d.2: setti=
ng latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.354897] uhci_hcd 0000:00:1d.2: UHCI =
Host Controller
Aug 17 21:32:44 newadsl kernel: [    0.355017] uhci_hcd 0000:00:1d.2: new U=
SB bus registered, assigned bus number 4
Aug 17 21:32:44 newadsl kernel: [    0.355248] uhci_hcd 0000:00:1d.2: irq 1=
8, io base 0x0000fc00
Aug 17 21:32:44 newadsl kernel: [    0.355707] usb usb4: configuration #1 c=
hosen from 1 choice
Aug 17 21:32:44 newadsl kernel: [    0.355941] hub 4-0:1.0: USB hub found
Aug 17 21:32:44 newadsl kernel: [    0.356060] hub 4-0:1.0: 2 ports detected
Aug 17 21:32:44 newadsl kernel: [    0.356266] uhci_hcd 0000:00:1d.3: PCI I=
NT D -> GSI 16 (level, low) -> IRQ 16
Aug 17 21:32:44 newadsl kernel: [    0.356421] uhci_hcd 0000:00:1d.3: setti=
ng latency timer to 64
Aug 17 21:32:44 newadsl kernel: [    0.356428] uhci_hcd 0000:00:1d.3: UHCI =
Host Controller
Aug 17 21:32:44 newadsl kernel: [    0.356546] uhci_hcd 0000:00:1d.3: new U=
SB bus registered, assigned bus number 5
Aug 17 21:32:44 newadsl kernel: [    0.356763] uhci_hcd 0000:00:1d.3: irq 1=
6, io base 0x0000fb00
Aug 17 21:32:44 newadsl kernel: [    0.357194] usb usb5: configuration #1 c=
hosen from 1 choice
Aug 17 21:32:44 newadsl kernel: [    0.357443] hub 5-0:1.0: USB hub found
Aug 17 21:32:44 newadsl kernel: [    0.357569] hub 5-0:1.0: 2 ports detected
Aug 17 21:32:44 newadsl kernel: [    0.357983] usbcore: registered new inte=
rface driver libusual
Aug 17 21:32:44 newadsl kernel: [    0.358283] PNP: PS/2 Controller [PNP030=
3:PS2K] at 0x60,0x64 irq 1
Aug 17 21:32:44 newadsl kernel: [    0.358415] PNP: PS/2 appears to have AU=
X port disabled, if this is incorrect please boot with i8042.nopnp
Aug 17 21:32:44 newadsl kernel: [    0.358827] serio: i8042 KBD port at 0x6=
0,0x64 irq 1
Aug 17 21:32:44 newadsl kernel: [    0.359204] mice: PS/2 mouse device comm=
on for all mice
Aug 17 21:32:44 newadsl kernel: [    0.359451] rtc_cmos 00:03: RTC can wake=
 from S4
Aug 17 21:32:44 newadsl kernel: [    0.359755] rtc_cmos 00:03: rtc core: re=
gistered rtc_cmos as rtc0
Aug 17 21:32:44 newadsl kernel: [    0.359907] rtc0: alarms up to one month=
, 242 bytes nvram, hpet irqs
Aug 17 21:32:44 newadsl kernel: [    0.360140] f71882fg: Found f71862fg chi=
p at 0x290, revision 18
Aug 17 21:32:44 newadsl kernel: [    0.360335] ACPI: I/O resource f71882fg =
[0x290-0x297] conflicts with ACPI region IP__ [0x295-0x296]
Aug 17 21:32:44 newadsl kernel: [    0.360557] ACPI: Device needs an ACPI d=
river
Aug 17 21:32:44 newadsl kernel: [    0.360734] iTCO_wdt: Intel TCO WatchDog=
 Timer Driver v1.05
Aug 17 21:32:44 newadsl kernel: [    0.361048] iTCO_wdt: Found a ICH7 or IC=
H7R TCO device (Version=3D2, TCOBASE=3D0x0460)
Aug 17 21:32:44 newadsl kernel: [    0.361415] iTCO_wdt: initialized. heart=
beat=3D30 sec (nowayout=3D0)
Aug 17 21:32:44 newadsl kernel: [    0.361533] cpuidle: using governor ladd=
er
Aug 17 21:32:44 newadsl kernel: [    0.361638] cpuidle: using governor menu
Aug 17 21:32:44 newadsl kernel: [    0.363975] usbcore: registered new inte=
rface driver hiddev
Aug 17 21:32:44 newadsl kernel: [    0.364170] usbcore: registered new inte=
rface driver usbhid
Aug 17 21:32:44 newadsl kernel: [    0.364294] usbhid: v2.6:USB HID core dr=
iver
Aug 17 21:32:44 newadsl kernel: [    0.364572] TCP cubic registered
Aug 17 21:32:44 newadsl kernel: [    0.365279] NET: Registered protocol fam=
ily 10
Aug 17 21:32:44 newadsl kernel: [    0.365835] NET: Registered protocol fam=
ily 17
Aug 17 21:32:44 newadsl kernel: [    0.366011] Bridge firewalling registered
Aug 17 21:32:44 newadsl kernel: [    0.366429] RPC: Registered udp transpor=
t module.
Aug 17 21:32:44 newadsl kernel: [    0.366537] RPC: Registered tcp transpor=
t module.
Aug 17 21:32:44 newadsl kernel: [    0.367490] rtc_cmos 00:03: setting syst=
em clock to 2009-08-17 20:32:33 UTC (1250541153)
Aug 17 21:32:44 newadsl kernel: [    0.367683] BIOS EDD facility v0.16 2004=
=2DJun-25, 1 devices found
Aug 17 21:32:44 newadsl kernel: [    0.377042] input: AT Translated Set 2 k=
eyboard as /devices/platform/i8042/serio0/input/input2
Aug 17 21:32:44 newadsl kernel: [    0.495146] ata2: FORCE: cable set to sh=
ort40c
Aug 17 21:32:44 newadsl kernel: [    0.495285] ata2.00: CFA: InnoDisk Corp.=
 - EDC4000 1GB, 080414S4, max UDMA/66
Aug 17 21:32:44 newadsl kernel: [    0.495399] ata2.00: 2047248 sectors, mu=
lti 2: LBA=20
Aug 17 21:32:44 newadsl kernel: [    0.498092] ata2.00: configured for UDMA=
/66
Aug 17 21:32:44 newadsl kernel: [    0.498366] scsi 1:0:0:0: Direct-Access =
    ATA      InnoDisk Corp. - 0804 PQ: 0 ANSI: 5
Aug 17 21:32:44 newadsl kernel: [    0.499018] sd 1:0:0:0: [sda] 2047248 51=
2-byte logical blocks: (1.04 GB/999 MiB)
Aug 17 21:32:44 newadsl kernel: [    0.499315] sd 1:0:0:0: [sda] Write Prot=
ect is off
Aug 17 21:32:44 newadsl kernel: [    0.499427] sd 1:0:0:0: [sda] Mode Sense=
: 00 3a 00 00
Aug 17 21:32:44 newadsl kernel: [    0.499485] sd 1:0:0:0: [sda] Write cach=
e: disabled, read cache: enabled, doesn't support DPO or FUA
Aug 17 21:32:44 newadsl kernel: [    0.499992]  sda: sda1
Aug 17 21:32:44 newadsl kernel: [    0.500999] sd 1:0:0:0: [sda] Attached S=
CSI disk
Aug 17 21:32:44 newadsl kernel: [    0.502024] EXT3-fs: INFO: recovery requ=
ired on readonly filesystem.
Aug 17 21:32:44 newadsl kernel: [    0.502136] EXT3-fs: write access will b=
e enabled during recovery.
Aug 17 21:32:44 newadsl kernel: [    0.694243] Switched to high resolution =
mode on CPU 1
Aug 17 21:32:44 newadsl kernel: [    0.694773] Switched to high resolution =
mode on CPU 0
Aug 17 21:32:44 newadsl kernel: [    1.169974] kjournald starting.  Commit =
interval 5 seconds
Aug 17 21:32:44 newadsl kernel: [    1.170114] EXT3-fs: recovery complete.
Aug 17 21:32:44 newadsl kernel: [    1.203387] EXT3-fs: mounted filesystem =
with writeback data mode.
Aug 17 21:32:44 newadsl kernel: [    1.203521] VFS: Mounted root (ext3 file=
system) readonly on device 8:1.
Aug 17 21:32:44 newadsl kernel: [    1.203697] Freeing unused kernel memory=
: 384k freed
Aug 17 21:32:44 newadsl kernel: [    2.478180] cfg80211: Calling CRDA to up=
date world regulatory domain
Aug 17 21:32:44 newadsl kernel: [    2.637412] cfg80211: Calling CRDA for c=
ountry: GB
Aug 17 21:32:44 newadsl kernel: [    2.648309] i801_smbus 0000:00:1f.3: PCI=
 INT B -> GSI 19 (level, low) -> IRQ 19
Aug 17 21:32:44 newadsl kernel: [    2.751599] ath5k 0000:02:04.0: PCI INT =
A -> GSI 18 (level, low) -> IRQ 18
Aug 17 21:32:44 newadsl kernel: [    2.751813] ath5k 0000:02:04.0: register=
ed as 'phy0'
Aug 17 21:32:44 newadsl kernel: [    2.887293] ath: EEPROM regdomain: 0x0
Aug 17 21:32:44 newadsl kernel: [    2.887301] ath: EEPROM indicates defaul=
t country code should be used
Aug 17 21:32:44 newadsl kernel: [    2.887308] ath: doing EEPROM country->r=
egdmn map search
Aug 17 21:32:44 newadsl kernel: [    2.887316] ath: country maps to regdmn =
code: 0x3a
Aug 17 21:32:44 newadsl kernel: [    2.887322] ath: Country alpha2 being us=
ed: US
Aug 17 21:32:44 newadsl kernel: [    2.887327] ath: Regpair used: 0x3a
Aug 17 21:32:44 newadsl kernel: [    3.055988] phy0: Selected rate control =
algorithm 'minstrel'
Aug 17 21:32:44 newadsl kernel: [    3.056593] ath5k phy0: Atheros AR5414 c=
hip found (MAC: 0xa5, PHY: 0x61)
Aug 17 21:32:44 newadsl kernel: [    3.056794]   alloc irq_desc for 17 on n=
ode -1
Aug 17 21:32:44 newadsl kernel: [    3.056803]   alloc kstat_irqs on node -1
Aug 17 21:32:44 newadsl kernel: [    3.056822] ath5k 0000:02:08.0: PCI INT =
A -> GSI 17 (level, low) -> IRQ 17
Aug 17 21:32:44 newadsl kernel: [    3.057071] ath5k 0000:02:08.0: register=
ed as 'phy1'
Aug 17 21:32:44 newadsl kernel: [    3.192696] ath: EEPROM regdomain: 0x0
Aug 17 21:32:44 newadsl kernel: [    3.192705] ath: EEPROM indicates defaul=
t country code should be used
Aug 17 21:32:44 newadsl kernel: [    3.192711] ath: doing EEPROM country->r=
egdmn map search
Aug 17 21:32:44 newadsl kernel: [    3.192719] ath: country maps to regdmn =
code: 0x3a
Aug 17 21:32:44 newadsl kernel: [    3.192725] ath: Country alpha2 being us=
ed: US
Aug 17 21:32:44 newadsl kernel: [    3.192730] ath: Regpair used: 0x3a
Aug 17 21:32:44 newadsl kernel: [    3.192798] cfg80211: Calling CRDA for c=
ountry: US
Aug 17 21:32:44 newadsl kernel: [    3.262875] phy1: Selected rate control =
algorithm 'minstrel'
Aug 17 21:32:44 newadsl kernel: [    3.263552] ath5k phy1: Atheros AR5414 c=
hip found (MAC: 0xa5, PHY: 0x61)
Aug 17 21:32:44 newadsl kernel: [    3.264073] cfg80211: Calling CRDA for c=
ountry: US
Aug 17 21:32:44 newadsl kernel: [    3.785070] cfg80211: Current regulatory=
 domain intersected:=20
Aug 17 21:32:44 newadsl kernel: [    3.785188] 	(start_freq - end_freq @ ba=
ndwidth), (max_antenna_gain, max_eirp)
Aug 17 21:32:44 newadsl kernel: [    3.785384] 	(2402000 KHz - 2472000 KHz =
@ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 21:32:44 newadsl kernel: [    3.785497] 	(2457000 KHz - 2472000 KHz =
@ 15000 KHz), (300 mBi, 2000 mBm)
Aug 17 21:32:44 newadsl kernel: [    3.785609] 	(5170000 KHz - 5250000 KHz =
@ 40000 KHz), (300 mBi, 1700 mBm)
Aug 17 21:32:44 newadsl kernel: [    3.785722] 	(5735000 KHz - 5835000 KHz =
@ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 21:32:44 newadsl kernel: [    3.791044] cfg80211: Current regulatory=
 domain intersected:=20
Aug 17 21:32:44 newadsl kernel: [    3.791163] 	(start_freq - end_freq @ ba=
ndwidth), (max_antenna_gain, max_eirp)
Aug 17 21:32:44 newadsl kernel: [    3.791364] 	(2402000 KHz - 2472000 KHz =
@ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 21:32:44 newadsl kernel: [    3.791477] 	(2457000 KHz - 2472000 KHz =
@ 15000 KHz), (300 mBi, 2000 mBm)
Aug 17 21:32:44 newadsl kernel: [    3.791589] 	(5170000 KHz - 5250000 KHz =
@ 40000 KHz), (300 mBi, 1700 mBm)
Aug 17 21:32:44 newadsl kernel: [    3.791702] 	(5735000 KHz - 5835000 KHz =
@ 40000 KHz), (300 mBi, 2000 mBm)
Aug 17 21:32:44 newadsl kernel: [    4.775996] EXT3 FS on sda1, internal jo=
urnal
Aug 17 21:32:44 newadsl kernel: [    6.393049] device eth0 entered promiscu=
ous mode
Aug 17 21:32:44 newadsl kernel: [    6.398545] r8169: eth0: link up
Aug 17 21:32:44 newadsl kernel: [    6.398663] r8169: eth0: link up
Aug 17 21:32:44 newadsl kernel: [    6.406594] device wlan0 entered promisc=
uous mode
Aug 17 21:32:44 newadsl kernel: [    6.467998] ADDRCONF(NETDEV_UP): wlan0: =
link is not ready
Aug 17 21:32:44 newadsl kernel: [    6.477945] device wlan1 entered promisc=
uous mode
Aug 17 21:32:44 newadsl kernel: [    6.536186] ADDRCONF(NETDEV_UP): wlan1: =
link is not ready
Aug 17 21:32:44 newadsl kernel: [    6.544256] main-bridge: port 1(eth0) en=
tering learning state
Aug 17 21:32:44 newadsl kernel: [    9.544019] main-bridge: port 1(eth0) en=
tering forwarding state
Aug 17 21:32:44 newadsl kernel: [    9.912617] Device: 0 Vpi: 0 Vci: 38
Aug 17 21:32:44 newadsl kernel: [   10.025274] Device: 1 Vpi: 0 Vci: 38
Aug 17 21:32:44 newadsl kernel: [   10.025283] Device: 0 Vpi: 0 Vci: 38
Aug 17 21:32:44 newadsl kernel: [   11.268159] main-bridge: port 2(wlan0) e=
ntering disabled state
Aug 17 21:32:44 newadsl kernel: [   11.283143] main-bridge: port 3(wlan1) e=
ntering disabled state
Aug 17 21:32:44 newadsl kernel: [   11.375451] main-bridge: port 2(wlan0) e=
ntering learning state
Aug 17 21:32:44 newadsl kernel: [   11.479701] main-bridge: port 3(wlan1) e=
ntering learning state
Aug 17 21:32:47 newadsl kernel: [   14.375017] main-bridge: port 2(wlan0) e=
ntering forwarding state
Aug 17 21:32:47 newadsl kernel: [   14.479012] main-bridge: port 3(wlan1) e=
ntering forwarding state
Aug 17 21:33:43 newadsl kernel: [   70.034156] Device: 0 Vpi: 0 Vci: 38
Aug 17 21:33:43 newadsl kernel: [   70.150642] Device: 1 Vpi: 0 Vci: 38
Aug 17 21:33:43 newadsl kernel: [   70.150649] Device: 0 Vpi: 0 Vci: 38
Aug 17 21:34:04 newadsl kernel: [   91.091054] warning: `ntpd' uses 32-bit =
capabilities (legacy support in use)
Aug 17 21:34:43 newadsl kernel: [  130.148456] Device: 0 Vpi: 0 Vci: 38
Aug 17 21:34:43 newadsl kernel: [  130.148463] Device: 1 Vpi: 0 Vci: 38
Aug 18 01:06:19 newadsl kernel: [12826.369464] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:19 newadsl kernel: [12826.369590] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:19 newadsl kernel: [12826.369768] Hardware name: =20
Aug 18 01:06:19 newadsl kernel: [12826.369851] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:19 newadsl kernel: [12826.370042] Pid: 0, comm: swapper Not ta=
inted 2.6.31-rc6-wl #9
Aug 18 01:06:19 newadsl kernel: [12826.370130] Call Trace:
Aug 18 01:06:19 newadsl kernel: [12826.370212]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:19 newadsl kernel: [12826.370408]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:19 newadsl kernel: [12826.370441]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:19 newadsl kernel: [12826.370441]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:19 newadsl kernel: [12826.370441] ---[ end trace d7317fe10a3c1=
ed8 ]---
Aug 18 01:06:25 newadsl kernel: [12832.275343] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:25 newadsl kernel: [12832.275470] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:25 newadsl kernel: [12832.275639] Hardware name: =20
Aug 18 01:06:25 newadsl kernel: [12832.275720] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:25 newadsl kernel: [12832.275911] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:25 newadsl kernel: [12832.276000] Call Trace:
Aug 18 01:06:25 newadsl kernel: [12832.276083]  <IRQ>  [<ffffffff8105327e>]=
 ? handle_fasteoi_irq+0xb0/0xbc
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffffa00595a4>] ? mins=
trel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffffa0072e67>] ? ath5=
k_hw_setup_4word_tx_desc+0x0/0x288 [ath5k]
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:25 newadsl kernel: [12832.276147]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:25 newadsl kernel: [12832.276147]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:25 newadsl kernel: [12832.276147] ---[ end trace d7317fe10a3c1=
ed9 ]---
Aug 18 01:06:25 newadsl kernel: [12832.278718] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:25 newadsl kernel: [12832.278841] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:25 newadsl kernel: [12832.279010] Hardware name: =20
Aug 18 01:06:25 newadsl kernel: [12832.279098] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:25 newadsl kernel: [12832.279287] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:25 newadsl kernel: [12832.279380] Call Trace:
Aug 18 01:06:25 newadsl kernel: [12832.279457]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.279644]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:25 newadsl kernel: [12832.279732]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:25 newadsl kernel: [12832.279838]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.279938]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.280047]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:25 newadsl kernel: [12832.280137]  [<ffffffff8102af45>] ? try_=
to_wake_up+0x17f/0x190
Aug 18 01:06:25 newadsl kernel: [12832.280230]  [<ffffffff81042bac>] ? ktim=
e_get+0x11/0x42
Aug 18 01:06:25 newadsl kernel: [12832.280322]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:25 newadsl kernel: [12832.280413]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:25 newadsl kernel: [12832.280502]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:25 newadsl kernel: [12832.280591]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:25 newadsl kernel: [12832.280679]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:25 newadsl kernel: [12832.280768]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:25 newadsl kernel: [12832.280857]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:25 newadsl kernel: [12832.280943]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:25 newadsl kernel: [12832.281046]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:25 newadsl kernel: [12832.281134]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:25 newadsl kernel: [12832.281224]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:25 newadsl kernel: [12832.281313]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:25 newadsl kernel: [12832.281405]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:25 newadsl kernel: [12832.281498]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:25 newadsl kernel: [12832.281588] ---[ end trace d7317fe10a3c1=
eda ]---
Aug 18 01:06:25 newadsl kernel: [12832.281677] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:25 newadsl kernel: [12832.281785] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:25 newadsl kernel: [12832.281953] Hardware name: =20
Aug 18 01:06:25 newadsl kernel: [12832.282042] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:25 newadsl kernel: [12832.282229] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:25 newadsl kernel: [12832.282318] Call Trace:
Aug 18 01:06:25 newadsl kernel: [12832.282398]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.282594]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:25 newadsl kernel: [12832.282686]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:25 newadsl kernel: [12832.282797]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.282905]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.283011]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:25 newadsl kernel: [12832.283110]  [<ffffffff8102af45>] ? try_=
to_wake_up+0x17f/0x190
Aug 18 01:06:25 newadsl kernel: [12832.283202]  [<ffffffff81042bac>] ? ktim=
e_get+0x11/0x42
Aug 18 01:06:25 newadsl kernel: [12832.283292]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:25 newadsl kernel: [12832.283381]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:25 newadsl kernel: [12832.283472]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:25 newadsl kernel: [12832.283561]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:25 newadsl kernel: [12832.283650]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:25 newadsl kernel: [12832.283739]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:25 newadsl kernel: [12832.283827]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:25 newadsl kernel: [12832.283913]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:25 newadsl kernel: [12832.284017]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:25 newadsl kernel: [12832.284107]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:25 newadsl kernel: [12832.284197]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:25 newadsl kernel: [12832.284287]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:25 newadsl kernel: [12832.284377]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:25 newadsl kernel: [12832.284469]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:25 newadsl kernel: [12832.284557] ---[ end trace d7317fe10a3c1=
edb ]---
Aug 18 01:06:25 newadsl kernel: [12832.556658] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:25 newadsl kernel: [12832.556787] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:25 newadsl kernel: [12832.556955] Hardware name: =20
Aug 18 01:06:25 newadsl kernel: [12832.557038] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:25 newadsl kernel: [12832.557231] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:25 newadsl kernel: [12832.557320] Call Trace:
Aug 18 01:06:25 newadsl kernel: [12832.557403]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.557599]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:25 newadsl kernel: [12832.557644]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:25 newadsl kernel: [12832.557644]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:25 newadsl kernel: [12832.557644] ---[ end trace d7317fe10a3c1=
edc ]---
Aug 18 01:06:25 newadsl kernel: [12832.560282] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:25 newadsl kernel: [12832.560437] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:25 newadsl kernel: [12832.562981] Hardware name: =20
Aug 18 01:06:25 newadsl kernel: [12832.563068] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:25 newadsl kernel: [12832.563260] Pid: 2642, comm: rsyslogd Ta=
inted: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:25 newadsl kernel: [12832.563352] Call Trace:
Aug 18 01:06:25 newadsl kernel: [12832.563436]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.563635]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:25 newadsl kernel: [12832.563727]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:25 newadsl kernel: [12832.563838]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.563944]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.564054]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:25 newadsl kernel: [12832.564144]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:25 newadsl kernel: [12832.564232]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:25 newadsl kernel: [12832.564319]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:25 newadsl kernel: [12832.564405]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:25 newadsl kernel: [12832.564491]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:25 newadsl kernel: [12832.564576]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:25 newadsl kernel: [12832.564662]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:25 newadsl kernel: [12832.564744]  <EOI>=20
Aug 18 01:06:25 newadsl kernel: [12832.564753] ---[ end trace d7317fe10a3c1=
edd ]---
Aug 18 01:06:25 newadsl kernel: [12832.593231] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:25 newadsl kernel: [12832.593350] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:25 newadsl kernel: [12832.593520] Hardware name: =20
Aug 18 01:06:25 newadsl kernel: [12832.593607] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:25 newadsl kernel: [12832.593787] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:25 newadsl kernel: [12832.593872] Call Trace:
Aug 18 01:06:25 newadsl kernel: [12832.593950]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.594146]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:25 newadsl kernel: [12832.594215]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:25 newadsl kernel: [12832.594215]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:25 newadsl kernel: [12832.594215] ---[ end trace d7317fe10a3c1=
ede ]---
Aug 18 01:06:26 newadsl kernel: [12832.741184] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:26 newadsl kernel: [12832.741309] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:26 newadsl kernel: [12832.741477] Hardware name: =20
Aug 18 01:06:26 newadsl kernel: [12832.741558] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:26 newadsl kernel: [12832.741745] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:26 newadsl kernel: [12832.741833] Call Trace:
Aug 18 01:06:26 newadsl kernel: [12832.741916]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.742115]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:26 newadsl kernel: [12832.742167]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:26 newadsl kernel: [12832.742167]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:26 newadsl kernel: [12832.742167] ---[ end trace d7317fe10a3c1=
edf ]---
Aug 18 01:06:26 newadsl kernel: [12832.760526] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:26 newadsl kernel: [12832.760649] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:26 newadsl kernel: [12832.760817] Hardware name: =20
Aug 18 01:06:26 newadsl kernel: [12832.760907] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:26 newadsl kernel: [12832.761097] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:26 newadsl kernel: [12832.761186] Call Trace:
Aug 18 01:06:26 newadsl kernel: [12832.761269]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.761467]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:26 newadsl kernel: [12832.761511]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:26 newadsl kernel: [12832.761511]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:26 newadsl kernel: [12832.761511] ---[ end trace d7317fe10a3c1=
ee0 ]---
Aug 18 01:06:26 newadsl kernel: [12832.764401] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:26 newadsl kernel: [12832.764546] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:26 newadsl kernel: [12832.764751] Hardware name: =20
Aug 18 01:06:26 newadsl kernel: [12832.764850] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:26 newadsl kernel: [12832.765090] Pid: 2642, comm: rsyslogd Ta=
inted: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:26 newadsl kernel: [12832.765196] Call Trace:
Aug 18 01:06:26 newadsl kernel: [12832.765294]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.765548]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:26 newadsl kernel: [12832.765661]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:26 newadsl kernel: [12832.765802]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.765939]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:26 newadsl kernel: [12832.766087]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:26 newadsl kernel: [12832.766207]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:26 newadsl kernel: [12832.766321]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:26 newadsl kernel: [12832.766429]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:26 newadsl kernel: [12832.766519]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:26 newadsl kernel: [12832.766609]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:26 newadsl kernel: [12832.766697]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:26 newadsl kernel: [12832.766786]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:26 newadsl kernel: [12832.766873]  <EOI>=20
Aug 18 01:06:26 newadsl kernel: [12832.766882] ---[ end trace d7317fe10a3c1=
ee1 ]---
Aug 18 01:06:26 newadsl kernel: [12833.273434] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:26 newadsl kernel: [12833.273560] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:26 newadsl kernel: [12833.273727] Hardware name: =20
Aug 18 01:06:26 newadsl kernel: [12833.273807] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:26 newadsl kernel: [12833.274009] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:26 newadsl kernel: [12833.274099] Call Trace:
Aug 18 01:06:26 newadsl kernel: [12833.274183]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12833.274380]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:26 newadsl kernel: [12833.274417]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:26 newadsl kernel: [12833.274417]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:26 newadsl kernel: [12833.274417] ---[ end trace d7317fe10a3c1=
ee2 ]---
Aug 18 01:06:35 newadsl kernel: [12842.336543] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:35 newadsl kernel: [12842.336669] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:35 newadsl kernel: [12842.336837] Hardware name: =20
Aug 18 01:06:35 newadsl kernel: [12842.336918] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:35 newadsl kernel: [12842.337109] Pid: 0, comm: swapper Tainte=
d: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:35 newadsl kernel: [12842.337199] Call Trace:
Aug 18 01:06:35 newadsl kernel: [12842.337283]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.337481]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:35 newadsl kernel: [12842.337528]  <EOI>  [<ffffffff8101192d>]=
 ? mwait_idle+0x6e/0x73
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8100a212>] ? ente=
r_idle+0x20/0x22
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8100a266>] ? cpu_=
idle+0x52/0x93
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff812b5c5d>] ? rest=
_init+0x61/0x63
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff81412c16>] ? star=
t_kernel+0x325/0x330
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8141229a>] ? x86_=
64_start_reservations+0xaa/0xae
Aug 18 01:06:35 newadsl kernel: [12842.337528]  [<ffffffff8141237f>] ? x86_=
64_start_kernel+0xe1/0xe8
Aug 18 01:06:35 newadsl kernel: [12842.337528] ---[ end trace d7317fe10a3c1=
ee3 ]---
Aug 18 01:06:35 newadsl kernel: [12842.342062] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:35 newadsl kernel: [12842.342209] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:35 newadsl kernel: [12842.342434] Hardware name: =20
Aug 18 01:06:35 newadsl kernel: [12842.342535] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:35 newadsl kernel: [12842.342762] Pid: 2642, comm: rsyslogd Ta=
inted: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:35 newadsl kernel: [12842.342852] Call Trace:
Aug 18 01:06:35 newadsl kernel: [12842.342933]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.343142]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:35 newadsl kernel: [12842.343233]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:35 newadsl kernel: [12842.343345]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.343452]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.343560]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:35 newadsl kernel: [12842.343655]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:35 newadsl kernel: [12842.343745]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:35 newadsl kernel: [12842.343834]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:35 newadsl kernel: [12842.343923]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:35 newadsl kernel: [12842.344019]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:35 newadsl kernel: [12842.344109]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:35 newadsl kernel: [12842.344199]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:35 newadsl kernel: [12842.344288]  <EOI>=20
Aug 18 01:06:35 newadsl kernel: [12842.344298] ---[ end trace d7317fe10a3c1=
ee4 ]---
Aug 18 01:06:35 newadsl kernel: [12842.344463] ------------[ cut here ]----=
=2D-------
Aug 18 01:06:35 newadsl kernel: [12842.344572] WARNING: at net/mac80211/rc8=
0211_minstrel.c:185 minstrel_tx_status+0xdb/0x133 [mac80211]()
Aug 18 01:06:35 newadsl kernel: [12842.344740] Hardware name: =20
Aug 18 01:06:35 newadsl kernel: [12842.344821] Modules linked in: sch_teql =
ath5k mac80211 ath i2c_i801 i2c_core cfg80211 led_class
Aug 18 01:06:35 newadsl kernel: [12842.345015] Pid: 2642, comm: rsyslogd Ta=
inted: G        W  2.6.31-rc6-wl #9
Aug 18 01:06:35 newadsl kernel: [12842.345104] Call Trace:
Aug 18 01:06:35 newadsl kernel: [12842.345186]  <IRQ>  [<ffffffffa00595a4>]=
 ? minstrel_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.345381]  [<ffffffff8102e507>] warn_s=
lowpath_common+0x77/0xa4
Aug 18 01:06:35 newadsl kernel: [12842.345472]  [<ffffffff8102e543>] warn_s=
lowpath_null+0xf/0x11
Aug 18 01:06:35 newadsl kernel: [12842.345580]  [<ffffffffa00595a4>] minstr=
el_tx_status+0xdb/0x133 [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.345686]  [<ffffffffa0041a55>] ieee80=
211_tx_status+0x188/0x3da [mac80211]
Aug 18 01:06:35 newadsl kernel: [12842.345790]  [<ffffffffa007f5f1>] ath5k_=
tasklet_tx+0x246/0x329 [ath5k]
Aug 18 01:06:35 newadsl kernel: [12842.345884]  [<ffffffff8103242c>] taskle=
t_action+0x71/0xbc
Aug 18 01:06:35 newadsl kernel: [12842.345975]  [<ffffffff81032c28>] __do_s=
oftirq+0x9b/0x12f
Aug 18 01:06:35 newadsl kernel: [12842.346071]  [<ffffffff8100befc>] call_s=
oftirq+0x1c/0x28
Aug 18 01:06:35 newadsl kernel: [12842.346161]  [<ffffffff8100da14>] do_sof=
tirq+0x34/0x72
Aug 18 01:06:35 newadsl kernel: [12842.346250]  [<ffffffff810329b2>] irq_ex=
it+0x3f/0x79
Aug 18 01:06:35 newadsl kernel: [12842.346342]  [<ffffffff8100d115>] do_IRQ=
+0xa3/0xba
Aug 18 01:06:35 newadsl kernel: [12842.346432]  [<ffffffff8100b793>] ret_fr=
om_intr+0x0/0xa
Aug 18 01:06:35 newadsl kernel: [12842.346519]  <EOI>=20
Aug 18 01:06:35 newadsl kernel: [12842.346527] ---[ end trace d7317fe10a3c1=
ee5 ]---
Aug 18 06:25:01 newadsl kernel: imklog 3.18.6, log source =3D /proc/kmsg st=
arted.
Aug 18 11:16:16 newadsl kernel: [49423.388314] Device: 0 Vpi: 0 Vci: 38
Aug 18 11:16:16 newadsl kernel: [49423.388322] Device: 1 Vpi: 0 Vci: 38
Aug 18 18:29:56 newadsl kernel: [75442.697143] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:29:57 newadsl kernel: [75443.721400] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:00 newadsl kernel: [75447.408761] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:01 newadsl kernel: [75447.818463] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:01 newadsl kernel: [75448.433020] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:02 newadsl kernel: [75448.842727] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:02 newadsl kernel: [75449.252429] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:03 newadsl kernel: [75450.444393] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:13 newadsl kernel: [75460.520200] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:23 newadsl kernel: [75470.557999] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:32 newadsl kernel: [75478.751283] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:33 newadsl kernel: [75479.775563] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:33 newadsl kernel: [75480.595801] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:43 newadsl kernel: [75490.633606] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:30:54 newadsl kernel: [75500.694412] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:03 newadsl kernel: [75509.684092] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:04 newadsl kernel: [75510.708374] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:04 newadsl kernel: [75510.709206] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:14 newadsl kernel: [75520.747008] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:24 newadsl kernel: [75530.784809] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:34 newadsl kernel: [75540.822611] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:44 newadsl kernel: [75550.860410] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:31:54 newadsl kernel: [75560.898214] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:32:04 newadsl kernel: [75570.936013] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:32:14 newadsl kernel: [75580.973815] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:32:24 newadsl kernel: [75591.011613] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:32:34 newadsl kernel: [75601.072489] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:32:44 newadsl kernel: [75611.087216] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:32:54 newadsl kernel: [75621.125019] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:33:04 newadsl kernel: [75631.186306] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:33:14 newadsl kernel: [75641.200625] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:33:24 newadsl kernel: [75651.238426] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:33:34 newadsl kernel: [75661.276225] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:33:44 newadsl kernel: [75671.314026] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:33:54 newadsl kernel: [75681.351827] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:34:04 newadsl kernel: [75691.389630] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:34:14 newadsl kernel: [75701.427427] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:34:24 newadsl kernel: [75711.468667] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:34:34 newadsl kernel: [75721.503031] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:34:44 newadsl kernel: [75731.540832] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:34:54 newadsl kernel: [75741.578631] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:35:04 newadsl kernel: [75751.616433] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:35:15 newadsl kernel: [75761.654234] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:35:25 newadsl kernel: [75771.714991] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:35:35 newadsl kernel: [75781.729838] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:35:45 newadsl kernel: [75791.767639] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:35:55 newadsl kernel: [75801.805440] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:36:05 newadsl kernel: [75811.843241] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:36:15 newadsl kernel: [75821.881040] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:36:25 newadsl kernel: [75831.941293] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:36:35 newadsl kernel: [75841.956640] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:36:45 newadsl kernel: [75851.994441] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:36:55 newadsl kernel: [75862.032243] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:37:05 newadsl kernel: [75872.070044] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:37:15 newadsl kernel: [75882.107846] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:37:25 newadsl kernel: [75892.145647] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:37:35 newadsl kernel: [75902.183445] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:37:45 newadsl kernel: [75912.221247] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:37:55 newadsl kernel: [75922.259045] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:38:05 newadsl kernel: [75932.296853] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:38:15 newadsl kernel: [75942.334651] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:38:25 newadsl kernel: [75952.372452] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:38:35 newadsl kernel: [75962.410251] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:38:45 newadsl kernel: [75972.448051] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:38:55 newadsl kernel: [75982.485853] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:39:05 newadsl kernel: [75992.523654] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:39:15 newadsl kernel: [76002.561456] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:39:25 newadsl kernel: [76012.623323] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:39:36 newadsl kernel: [76022.637055] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:39:46 newadsl kernel: [76032.698349] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:39:56 newadsl kernel: [76042.736438] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:40:06 newadsl kernel: [76052.750455] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:40:16 newadsl kernel: [76062.788257] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:40:26 newadsl kernel: [76072.826058] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:40:36 newadsl kernel: [76082.854725] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:40:46 newadsl kernel: [76092.901661] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:40:56 newadsl kernel: [76102.939463] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:41:06 newadsl kernel: [76112.977263] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:41:16 newadsl kernel: [76122.995787] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:41:26 newadsl kernel: [76133.052864] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:41:36 newadsl kernel: [76143.090662] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:41:46 newadsl kernel: [76153.128466] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:41:56 newadsl kernel: [76163.166264] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:42:06 newadsl kernel: [76173.204065] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:42:16 newadsl kernel: [76183.207383] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:42:26 newadsl kernel: [76193.279668] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:42:36 newadsl kernel: [76203.317467] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:42:46 newadsl kernel: [76213.355268] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:42:56 newadsl kernel: [76223.393072] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:43:06 newadsl kernel: [76233.430874] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:43:16 newadsl kernel: [76243.468672] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:43:26 newadsl kernel: [76253.506474] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:43:36 newadsl kernel: [76263.544272] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:43:46 newadsl kernel: [76273.582073] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:43:56 newadsl kernel: [76283.619875] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:44:07 newadsl kernel: [76293.657676] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:44:17 newadsl kernel: [76303.717773] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:44:27 newadsl kernel: [76313.733278] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:44:37 newadsl kernel: [76323.771076] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:44:47 newadsl kernel: [76333.808877] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:44:57 newadsl kernel: [76343.846676] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:45:07 newadsl kernel: [76353.884477] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:45:17 newadsl kernel: [76363.922278] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:45:27 newadsl kernel: [76373.960082] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:45:37 newadsl kernel: [76383.997880] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:45:47 newadsl kernel: [76394.035681] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:45:57 newadsl kernel: [76404.073482] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:46:07 newadsl kernel: [76414.111284] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:46:17 newadsl kernel: [76424.149081] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:46:27 newadsl kernel: [76434.186882] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:46:37 newadsl kernel: [76444.224684] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:46:47 newadsl kernel: [76454.262485] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:46:57 newadsl kernel: [76464.271781] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:47:07 newadsl kernel: [76474.338083] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:47:17 newadsl kernel: [76484.375885] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:47:27 newadsl kernel: [76494.413685] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:47:37 newadsl kernel: [76504.451483] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:47:47 newadsl kernel: [76514.473553] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:47:57 newadsl kernel: [76524.527088] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:48:07 newadsl kernel: [76534.564890] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:48:17 newadsl kernel: [76544.602687] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:48:28 newadsl kernel: [76554.640488] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:48:38 newadsl kernel: [76564.703613] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:48:48 newadsl kernel: [76574.716087] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:48:58 newadsl kernel: [76584.753888] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:49:08 newadsl kernel: [76594.791689] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:49:18 newadsl kernel: [76604.829490] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:49:28 newadsl kernel: [76614.867290] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:49:38 newadsl kernel: [76624.905088] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:49:48 newadsl kernel: [76634.942889] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:49:58 newadsl kernel: [76644.980687] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:50:08 newadsl kernel: [76655.018487] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:50:18 newadsl kernel: [76665.078731] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:50:28 newadsl kernel: [76675.094092] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:50:38 newadsl kernel: [76685.131890] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:50:48 newadsl kernel: [76695.169691] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:50:58 newadsl kernel: [76705.207492] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:51:08 newadsl kernel: [76715.245292] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:51:18 newadsl kernel: [76725.283090] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:51:28 newadsl kernel: [76735.320894] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:51:38 newadsl kernel: [76745.358691] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:51:48 newadsl kernel: [76755.419254] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:51:58 newadsl kernel: [76765.434290] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:52:08 newadsl kernel: [76775.472091] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:52:18 newadsl kernel: [76785.509891] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:52:28 newadsl kernel: [76795.547692] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:52:38 newadsl kernel: [76805.585492] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:52:48 newadsl kernel: [76815.623297] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:52:59 newadsl kernel: [76825.685067] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:53:09 newadsl kernel: [76835.722913] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:53:19 newadsl kernel: [76845.760962] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:53:29 newadsl kernel: [76855.774497] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:53:39 newadsl kernel: [76865.810244] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:53:49 newadsl kernel: [76875.850095] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:53:59 newadsl kernel: [76885.887898] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:54:09 newadsl kernel: [76895.925696] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:54:19 newadsl kernel: [76905.985753] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:54:29 newadsl kernel: [76916.023751] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:54:39 newadsl kernel: [76926.039096] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:54:49 newadsl kernel: [76936.076897] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:54:59 newadsl kernel: [76946.114698] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:55:09 newadsl kernel: [76956.152499] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:55:19 newadsl kernel: [76966.190300] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:55:29 newadsl kernel: [76976.228101] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:55:39 newadsl kernel: [76986.233789] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:55:49 newadsl kernel: [76996.303701] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:55:59 newadsl kernel: [77006.341502] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:56:09 newadsl kernel: [77016.379300] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:56:19 newadsl kernel: [77026.417102] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:56:29 newadsl kernel: [77036.454903] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:56:39 newadsl kernel: [77046.492704] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:56:49 newadsl kernel: [77056.553117] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:56:59 newadsl kernel: [77066.590730] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:57:09 newadsl kernel: [77076.606105] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:57:20 newadsl kernel: [77086.643906] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:57:30 newadsl kernel: [77096.704148] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:57:40 newadsl kernel: [77106.719512] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:57:50 newadsl kernel: [77116.757310] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:58:00 newadsl kernel: [77126.795095] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:58:10 newadsl kernel: [77136.832910] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:58:20 newadsl kernel: [77146.870711] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:58:30 newadsl kernel: [77156.908512] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:58:40 newadsl kernel: [77166.946314] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:58:50 newadsl kernel: [77176.984115] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:59:00 newadsl kernel: [77187.021916] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:59:10 newadsl kernel: [77197.059714] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:59:20 newadsl kernel: [77207.097516] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:59:30 newadsl kernel: [77217.135314] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:59:40 newadsl kernel: [77227.173115] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 18:59:50 newadsl kernel: [77237.210917] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:00:00 newadsl kernel: [77247.248718] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:00:10 newadsl kernel: [77257.286519] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:00:20 newadsl kernel: [77267.324320] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:00:30 newadsl kernel: [77277.362121] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:00:40 newadsl kernel: [77287.399923] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:00:50 newadsl kernel: [77297.437721] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:01:00 newadsl kernel: [77307.464310] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:01:10 newadsl kernel: [77317.513320] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:01:20 newadsl kernel: [77327.534840] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:01:30 newadsl kernel: [77337.588923] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:01:40 newadsl kernel: [77347.605370] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:01:51 newadsl kernel: [77357.686970] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:02:01 newadsl kernel: [77367.724737] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:02:11 newadsl kernel: [77377.711165] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:02:21 newadsl kernel: [77387.777926] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:02:31 newadsl kernel: [77397.815734] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:02:41 newadsl kernel: [77407.853539] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:02:51 newadsl kernel: [77417.891339] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:03:01 newadsl kernel: [77427.929108] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:03:11 newadsl kernel: [77437.966869] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:03:21 newadsl kernel: [77448.004632] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:03:31 newadsl kernel: [77458.042552] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:03:41 newadsl kernel: [77468.080357] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:03:51 newadsl kernel: [77478.118161] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:04:01 newadsl kernel: [77488.155965] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:04:11 newadsl kernel: [77498.193766] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:04:21 newadsl kernel: [77508.231570] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:04:31 newadsl kernel: [77518.269371] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:04:41 newadsl kernel: [77528.307176] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:04:51 newadsl kernel: [77538.344980] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:05:01 newadsl kernel: [77548.382404] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:05:11 newadsl kernel: [77558.420589] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:05:21 newadsl kernel: [77568.458393] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:05:31 newadsl kernel: [77578.496198] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:05:41 newadsl kernel: [77588.534003] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:05:51 newadsl kernel: [77598.571804] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:06:01 newadsl kernel: [77608.609608] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:06:12 newadsl kernel: [77618.647413] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:06:22 newadsl kernel: [77628.708992] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:06:32 newadsl kernel: [77638.723019] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:06:42 newadsl kernel: [77648.760823] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:06:52 newadsl kernel: [77658.798628] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:07:02 newadsl kernel: [77668.836322] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:07:12 newadsl kernel: [77678.874234] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:07:22 newadsl kernel: [77688.912042] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:07:32 newadsl kernel: [77698.949847] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:07:42 newadsl kernel: [77708.987652] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:07:52 newadsl kernel: [77719.025454] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:08:02 newadsl kernel: [77729.063258] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:08:12 newadsl kernel: [77739.083590] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:08:22 newadsl kernel: [77749.138864] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:08:32 newadsl kernel: [77759.176669] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:08:42 newadsl kernel: [77769.214475] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:08:52 newadsl kernel: [77779.252279] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:09:02 newadsl kernel: [77789.290084] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:09:12 newadsl kernel: [77799.327885] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:09:22 newadsl kernel: [77809.365690] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:09:32 newadsl kernel: [77819.365342] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:09:42 newadsl kernel: [77829.400609] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:09:52 newadsl kernel: [77839.479105] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:10:02 newadsl kernel: [77849.516909] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:10:12 newadsl kernel: [77859.554711] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:10:22 newadsl kernel: [77869.592516] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:10:32 newadsl kernel: [77879.630320] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:10:43 newadsl kernel: [77889.690282] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:10:53 newadsl kernel: [77899.705927] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:11:03 newadsl kernel: [77909.743735] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:11:13 newadsl kernel: [77919.781536] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:11:23 newadsl kernel: [77929.819341] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:11:33 newadsl kernel: [77939.857143] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:11:43 newadsl kernel: [77949.894947] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:11:53 newadsl kernel: [77959.932752] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:12:03 newadsl kernel: [77969.970557] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:12:13 newadsl kernel: [77980.008362] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:12:23 newadsl kernel: [77990.046169] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:12:33 newadsl kernel: [78000.083974] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:12:43 newadsl kernel: [78010.121775] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:12:53 newadsl kernel: [78020.159580] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:13:03 newadsl kernel: [78030.197385] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:13:13 newadsl kernel: [78040.235189] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:13:23 newadsl kernel: [78050.272991] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:13:33 newadsl kernel: [78060.310799] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:13:43 newadsl kernel: [78070.348600] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:13:53 newadsl kernel: [78080.384687] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:14:03 newadsl kernel: [78090.424206] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:14:13 newadsl kernel: [78100.462010] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:14:23 newadsl kernel: [78110.499814] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:14:33 newadsl kernel: [78120.525755] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:14:43 newadsl kernel: [78130.575424] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:14:53 newadsl kernel: [78140.596290] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:15:04 newadsl kernel: [78150.651033] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:15:14 newadsl kernel: [78160.711144] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:15:24 newadsl kernel: [78170.723685] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:15:34 newadsl kernel: [78180.764442] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:15:44 newadsl kernel: [78190.802244] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:15:54 newadsl kernel: [78200.840048] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:16:04 newadsl kernel: [78210.843159] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:16:14 newadsl kernel: [78220.915657] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:16:24 newadsl kernel: [78230.953461] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:16:34 newadsl kernel: [78240.991265] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:16:44 newadsl kernel: [78251.029066] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:16:54 newadsl kernel: [78261.066871] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:17:04 newadsl kernel: [78271.104672] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:17:14 newadsl kernel: [78281.142483] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:17:24 newadsl kernel: [78291.180284] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:17:34 newadsl kernel: [78301.218088] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:17:44 newadsl kernel: [78311.255889] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:17:54 newadsl kernel: [78321.293693] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:18:04 newadsl kernel: [78331.331497] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:18:14 newadsl kernel: [78341.369302] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:18:24 newadsl kernel: [78351.407106] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:18:34 newadsl kernel: [78361.444910] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:18:44 newadsl kernel: [78371.482711] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:18:54 newadsl kernel: [78381.520515] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:19:04 newadsl kernel: [78391.558316] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:19:14 newadsl kernel: [78401.596121] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:19:24 newadsl kernel: [78411.633925] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:19:35 newadsl kernel: [78421.694858] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:19:45 newadsl kernel: [78431.709538] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:19:55 newadsl kernel: [78441.747344] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:20:05 newadsl kernel: [78451.785151] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:20:15 newadsl kernel: [78461.822958] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:20:25 newadsl kernel: [78471.860761] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:20:35 newadsl kernel: [78481.897783] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:20:45 newadsl kernel: [78491.936371] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:20:55 newadsl kernel: [78501.968322] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:21:05 newadsl kernel: [78512.003592] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:21:15 newadsl kernel: [78522.049790] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:21:25 newadsl kernel: [78532.087597] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:21:35 newadsl kernel: [78542.125403] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:21:45 newadsl kernel: [78552.144669] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:21:55 newadsl kernel: [78562.201713] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:22:05 newadsl kernel: [78572.238823] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:22:15 newadsl kernel: [78582.250477] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:22:25 newadsl kernel: [78592.336597] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:22:35 newadsl kernel: [78602.352239] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:22:45 newadsl kernel: [78612.390042] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:22:55 newadsl kernel: [78622.427849] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:23:05 newadsl kernel: [78632.465655] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:23:15 newadsl kernel: [78642.503463] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:23:25 newadsl kernel: [78652.541268] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:23:35 newadsl kernel: [78662.579074] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:23:45 newadsl kernel: [78672.616877] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:23:56 newadsl kernel: [78682.654683] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:24:06 newadsl kernel: [78692.714810] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:24:16 newadsl kernel: [78702.730292] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:24:26 newadsl kernel: [78712.768099] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:24:36 newadsl kernel: [78722.805908] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:24:46 newadsl kernel: [78732.843711] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:24:56 newadsl kernel: [78742.881518] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:25:06 newadsl kernel: [78752.919324] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:25:16 newadsl kernel: [78762.957130] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:25:26 newadsl kernel: [78772.994933] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:25:36 newadsl kernel: [78783.032738] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:25:46 newadsl kernel: [78793.070545] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:25:56 newadsl kernel: [78803.108351] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:26:06 newadsl kernel: [78813.146154] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:26:16 newadsl kernel: [78823.183961] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:26:26 newadsl kernel: [78833.221766] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:26:36 newadsl kernel: [78843.259572] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:26:46 newadsl kernel: [78853.297375] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:26:56 newadsl kernel: [78863.335185] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:27:06 newadsl kernel: [78873.372990] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:27:16 newadsl kernel: [78883.410796] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:27:26 newadsl kernel: [78893.448599] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:27:36 newadsl kernel: [78903.486405] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:27:46 newadsl kernel: [78913.516762] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:27:56 newadsl kernel: [78923.562014] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:28:06 newadsl kernel: [78933.599820] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:28:17 newadsl kernel: [78943.637626] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:28:27 newadsl kernel: [78953.698076] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:28:37 newadsl kernel: [78963.713238] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:28:47 newadsl kernel: [78973.751040] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:28:57 newadsl kernel: [78983.813820] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:29:07 newadsl kernel: [78993.826648] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:29:17 newadsl kernel: [79003.864455] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:29:27 newadsl kernel: [79013.902264] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:29:37 newadsl kernel: [79023.940070] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:29:47 newadsl kernel: [79033.977872] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:29:57 newadsl kernel: [79044.015678] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:30:07 newadsl kernel: [79054.053484] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:30:17 newadsl kernel: [79064.091289] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:30:27 newadsl kernel: [79074.129092] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:30:37 newadsl kernel: [79084.166901] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:30:47 newadsl kernel: [79094.204704] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:30:57 newadsl kernel: [79104.242510] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:31:07 newadsl kernel: [79114.280312] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:31:17 newadsl kernel: [79124.318118] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:31:27 newadsl kernel: [79134.355923] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:31:37 newadsl kernel: [79144.393729] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:31:47 newadsl kernel: [79154.431535] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:31:57 newadsl kernel: [79164.469343] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:32:07 newadsl kernel: [79174.507150] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:32:17 newadsl kernel: [79184.544951] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:32:27 newadsl kernel: [79194.582758] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:32:37 newadsl kernel: [79204.620563] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:32:48 newadsl kernel: [79214.658369] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:32:58 newadsl kernel: [79224.719303] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:33:08 newadsl kernel: [79234.733980] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:33:18 newadsl kernel: [79244.771782] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:33:28 newadsl kernel: [79254.809588] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:33:38 newadsl kernel: [79264.847390] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:33:48 newadsl kernel: [79274.885196] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:33:58 newadsl kernel: [79284.923001] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:34:08 newadsl kernel: [79294.959385] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:34:18 newadsl kernel: [79304.994654] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:34:28 newadsl kernel: [79315.029923] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:34:38 newadsl kernel: [79325.065192] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:34:48 newadsl kernel: [79335.100461] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:34:58 newadsl kernel: [79345.135729] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:35:08 newadsl kernel: [79355.170998] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:35:18 newadsl kernel: [79365.225438] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:35:28 newadsl kernel: [79375.263244] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:35:38 newadsl kernel: [79385.276805] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:35:48 newadsl kernel: [79395.338855] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:35:58 newadsl kernel: [79405.376660] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:36:08 newadsl kernel: [79415.414465] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:36:18 newadsl kernel: [79425.417879] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:36:28 newadsl kernel: [79435.490072] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:36:38 newadsl kernel: [79445.527868] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:36:48 newadsl kernel: [79455.565673] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:36:58 newadsl kernel: [79465.603469] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:37:09 newadsl kernel: [79475.641267] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:37:19 newadsl kernel: [79485.701539] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:37:29 newadsl kernel: [79495.716862] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:37:39 newadsl kernel: [79505.754660] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:37:49 newadsl kernel: [79515.792459] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:37:59 newadsl kernel: [79525.830258] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:38:09 newadsl kernel: [79535.868057] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:38:19 newadsl kernel: [79545.905852] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:38:29 newadsl kernel: [79555.943651] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:38:39 newadsl kernel: [79565.981447] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:38:49 newadsl kernel: [79576.019245] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:38:59 newadsl kernel: [79586.057044] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:39:09 newadsl kernel: [79596.094843] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:39:19 newadsl kernel: [79606.132642] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:39:29 newadsl kernel: [79616.170441] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:39:39 newadsl kernel: [79626.208239] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:39:49 newadsl kernel: [79636.246038] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:39:59 newadsl kernel: [79646.283834] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:40:09 newadsl kernel: [79656.321633] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:40:19 newadsl kernel: [79666.359428] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:40:29 newadsl kernel: [79676.397230] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:40:39 newadsl kernel: [79686.435026] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:40:49 newadsl kernel: [79696.472825] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:40:59 newadsl kernel: [79706.507625] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:41:09 newadsl kernel: [79716.542887] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:41:19 newadsl kernel: [79726.578149] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:41:29 newadsl kernel: [79736.613413] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:41:40 newadsl kernel: [79746.661819] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:41:50 newadsl kernel: [79756.705251] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:42:00 newadsl kernel: [79766.737413] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:42:10 newadsl kernel: [79776.754461] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:42:20 newadsl kernel: [79786.813008] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:42:30 newadsl kernel: [79796.824985] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:42:40 newadsl kernel: [79806.860247] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:42:50 newadsl kernel: [79816.926405] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:43:00 newadsl kernel: [79826.930772] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:43:10 newadsl kernel: [79836.966035] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:43:20 newadsl kernel: [79847.039799] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:43:30 newadsl kernel: [79857.077598] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:43:40 newadsl kernel: [79867.115393] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:43:50 newadsl kernel: [79877.153192] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:44:00 newadsl kernel: [79887.190991] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:44:10 newadsl kernel: [79897.228793] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:44:20 newadsl kernel: [79907.266589] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:44:30 newadsl kernel: [79917.304387] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:44:40 newadsl kernel: [79927.342186] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:44:50 newadsl kernel: [79937.379986] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:45:00 newadsl kernel: [79947.417781] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:45:10 newadsl kernel: [79957.455581] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:45:20 newadsl kernel: [79967.493380] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:45:30 newadsl kernel: [79977.531178] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:45:40 newadsl kernel: [79987.568975] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:45:50 newadsl kernel: [79997.606773] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:46:01 newadsl kernel: [80007.644572] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:46:11 newadsl kernel: [80017.706067] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:46:21 newadsl kernel: [80027.720167] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:46:31 newadsl kernel: [80037.757970] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:46:41 newadsl kernel: [80047.795769] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:46:51 newadsl kernel: [80057.833567] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:47:01 newadsl kernel: [80067.871364] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:47:11 newadsl kernel: [80077.909162] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:47:21 newadsl kernel: [80087.946958] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:47:31 newadsl kernel: [80097.984757] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:47:41 newadsl kernel: [80108.022557] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:47:51 newadsl kernel: [80118.060356] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:48:01 newadsl kernel: [80128.098155] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:48:11 newadsl kernel: [80138.135954] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:48:21 newadsl kernel: [80148.173750] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:48:31 newadsl kernel: [80158.196833] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:48:41 newadsl kernel: [80168.232096] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:48:51 newadsl kernel: [80178.287144] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:49:01 newadsl kernel: [80188.302620] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:49:11 newadsl kernel: [80198.362746] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:49:21 newadsl kernel: [80208.373145] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:49:31 newadsl kernel: [80218.408408] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:49:41 newadsl kernel: [80228.476140] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:49:51 newadsl kernel: [80238.478933] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:50:01 newadsl kernel: [80248.514196] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:50:11 newadsl kernel: [80258.589538] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:50:21 newadsl kernel: [80268.627334] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:50:32 newadsl kernel: [80278.687579] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:50:42 newadsl kernel: [80288.725074] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:50:52 newadsl kernel: [80298.740728] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:51:02 newadsl kernel: [80308.801178] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:51:12 newadsl kernel: [80318.816326] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:51:22 newadsl kernel: [80328.854126] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:51:32 newadsl kernel: [80338.891928] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:51:42 newadsl kernel: [80348.929728] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:51:52 newadsl kernel: [80358.967524] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:52:02 newadsl kernel: [80369.005323] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:52:12 newadsl kernel: [80379.043122] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:52:22 newadsl kernel: [80389.080921] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:52:32 newadsl kernel: [80399.118717] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:52:42 newadsl kernel: [80409.156520] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:52:52 newadsl kernel: [80419.194316] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:53:02 newadsl kernel: [80429.232115] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:53:12 newadsl kernel: [80439.269911] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:53:22 newadsl kernel: [80449.307711] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:53:32 newadsl kernel: [80459.345509] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:53:42 newadsl kernel: [80469.383306] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:53:52 newadsl kernel: [80479.421103] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:54:02 newadsl kernel: [80489.458901] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:54:12 newadsl kernel: [80499.496698] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:54:22 newadsl kernel: [80509.533418] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:54:32 newadsl kernel: [80519.572289] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:54:42 newadsl kernel: [80529.610086] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:54:53 newadsl kernel: [80539.647880] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:55:03 newadsl kernel: [80549.695707] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:55:13 newadsl kernel: [80559.723474] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:55:23 newadsl kernel: [80569.744981] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:55:33 newadsl kernel: [80579.780241] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:55:43 newadsl kernel: [80589.815502] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:55:53 newadsl kernel: [80599.850763] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:56:03 newadsl kernel: [80609.886023] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:56:13 newadsl kernel: [80619.950250] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:56:23 newadsl kernel: [80629.988054] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:56:33 newadsl kernel: [80639.991805] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:56:43 newadsl kernel: [80650.027066] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:56:53 newadsl kernel: [80660.101440] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:57:03 newadsl kernel: [80670.139237] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:57:13 newadsl kernel: [80680.177034] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:57:23 newadsl kernel: [80690.214831] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:57:33 newadsl kernel: [80700.261010] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:57:43 newadsl kernel: [80710.290426] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:57:53 newadsl kernel: [80720.328220] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:58:03 newadsl kernel: [80730.366017] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:58:13 newadsl kernel: [80740.403811] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:58:23 newadsl kernel: [80750.441608] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:58:33 newadsl kernel: [80760.479406] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:58:43 newadsl kernel: [80770.517203] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:58:53 newadsl kernel: [80780.555001] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:59:03 newadsl kernel: [80790.592798] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:59:13 newadsl kernel: [80800.630595] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:59:24 newadsl kernel: [80810.690886] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:59:34 newadsl kernel: [80820.706187] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:59:44 newadsl kernel: [80830.743984] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 19:59:54 newadsl kernel: [80840.781778] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:00:04 newadsl kernel: [80850.819579] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:00:14 newadsl kernel: [80860.857373] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:00:24 newadsl kernel: [80870.895170] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:00:34 newadsl kernel: [80880.932968] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:00:44 newadsl kernel: [80890.970766] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:00:54 newadsl kernel: [80901.008559] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:01:04 newadsl kernel: [80911.046249] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:01:14 newadsl kernel: [80921.081510] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:01:24 newadsl kernel: [80931.121955] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:01:34 newadsl kernel: [80941.159750] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:01:44 newadsl kernel: [80951.197547] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:01:54 newadsl kernel: [80961.235342] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:02:04 newadsl kernel: [80971.257815] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:02:14 newadsl kernel: [80981.293076] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:02:24 newadsl kernel: [80991.328338] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:02:34 newadsl kernel: [81001.386532] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:02:44 newadsl kernel: [81011.424329] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:02:54 newadsl kernel: [81021.462124] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:03:04 newadsl kernel: [81031.499921] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:03:14 newadsl kernel: [81041.504644] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:03:24 newadsl kernel: [81051.539905] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:03:34 newadsl kernel: [81061.613311] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:03:45 newadsl kernel: [81071.651112] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:03:55 newadsl kernel: [81081.711251] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:04:05 newadsl kernel: [81091.726704] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:04:15 newadsl kernel: [81101.764502] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:04:25 newadsl kernel: [81111.802299] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:04:35 newadsl kernel: [81121.840094] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:04:45 newadsl kernel: [81131.877891] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:04:55 newadsl kernel: [81141.915689] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:05:05 newadsl kernel: [81151.953487] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:05:15 newadsl kernel: [81161.991281] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:05:25 newadsl kernel: [81172.029079] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:05:35 newadsl kernel: [81182.066876] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:05:45 newadsl kernel: [81192.104674] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:05:55 newadsl kernel: [81202.142469] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:06:05 newadsl kernel: [81212.180270] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:06:15 newadsl kernel: [81222.218068] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:06:25 newadsl kernel: [81232.255865] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:06:35 newadsl kernel: [81242.293660] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:06:45 newadsl kernel: [81252.331458] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:06:55 newadsl kernel: [81262.369252] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:07:05 newadsl kernel: [81272.407050] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:07:15 newadsl kernel: [81282.444848] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:07:25 newadsl kernel: [81292.482646] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:07:35 newadsl kernel: [81302.520444] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:07:45 newadsl kernel: [81312.558242] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:07:55 newadsl kernel: [81322.594365] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:08:05 newadsl kernel: [81332.633834] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:08:16 newadsl kernel: [81342.693803] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:08:26 newadsl kernel: [81352.709427] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:08:36 newadsl kernel: [81362.747227] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:08:46 newadsl kernel: [81372.785025] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:08:56 newadsl kernel: [81382.822820] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:09:06 newadsl kernel: [81392.860618] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:09:16 newadsl kernel: [81402.898416] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:09:26 newadsl kernel: [81412.936214] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:09:36 newadsl kernel: [81422.974008] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:09:46 newadsl kernel: [81433.011809] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:09:56 newadsl kernel: [81443.049604] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:10:06 newadsl kernel: [81453.087402] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:10:16 newadsl kernel: [81463.125196] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:10:26 newadsl kernel: [81473.162994] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:10:36 newadsl kernel: [81483.200793] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:10:46 newadsl kernel: [81493.238591] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:10:56 newadsl kernel: [81503.276389] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:11:06 newadsl kernel: [81513.314189] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:11:16 newadsl kernel: [81523.351987] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:11:26 newadsl kernel: [81533.389782] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:11:36 newadsl kernel: [81543.427580] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:11:46 newadsl kernel: [81553.465378] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:11:56 newadsl kernel: [81563.503176] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:12:06 newadsl kernel: [81573.540018] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:12:16 newadsl kernel: [81583.575279] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:12:26 newadsl kernel: [81593.616567] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:12:37 newadsl kernel: [81603.654365] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:12:47 newadsl kernel: [81613.714385] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:12:57 newadsl kernel: [81623.729958] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:13:07 newadsl kernel: [81633.751587] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:13:17 newadsl kernel: [81643.805554] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:13:27 newadsl kernel: [81653.843352] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:13:37 newadsl kernel: [81663.857372] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:13:47 newadsl kernel: [81673.892633] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:13:57 newadsl kernel: [81683.956746] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:14:07 newadsl kernel: [81693.994541] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:14:17 newadsl kernel: [81704.032339] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:14:27 newadsl kernel: [81714.070134] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:14:37 newadsl kernel: [81724.107932] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:14:47 newadsl kernel: [81734.145730] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:14:57 newadsl kernel: [81744.183528] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:15:07 newadsl kernel: [81754.221326] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:15:17 newadsl kernel: [81764.259124] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:15:27 newadsl kernel: [81774.296919] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:15:37 newadsl kernel: [81784.334717] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:15:47 newadsl kernel: [81794.372512] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:15:57 newadsl kernel: [81804.410317] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:16:07 newadsl kernel: [81814.448111] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:16:17 newadsl kernel: [81824.485910] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:16:27 newadsl kernel: [81834.523705] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:16:37 newadsl kernel: [81844.561503] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:16:47 newadsl kernel: [81854.599301] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:16:58 newadsl kernel: [81864.637099] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:17:08 newadsl kernel: [81874.697570] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:17:18 newadsl kernel: [81884.712695] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:17:28 newadsl kernel: [81894.750490] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:17:38 newadsl kernel: [81904.788288] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:17:48 newadsl kernel: [81914.826083] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:17:58 newadsl kernel: [81924.863881] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:18:08 newadsl kernel: [81934.901679] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:18:18 newadsl kernel: [81944.939478] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:18:28 newadsl kernel: [81954.977275] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:18:38 newadsl kernel: [81965.015074] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:18:48 newadsl kernel: [81975.052872] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:18:58 newadsl kernel: [81985.090670] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:19:08 newadsl kernel: [81995.128465] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:19:18 newadsl kernel: [82005.166264] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:19:28 newadsl kernel: [82015.204058] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:19:38 newadsl kernel: [82025.261008] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:19:48 newadsl kernel: [82035.279655] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:19:58 newadsl kernel: [82045.299721] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:20:08 newadsl kernel: [82055.355251] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:20:18 newadsl kernel: [82065.370244] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:20:28 newadsl kernel: [82075.430845] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:20:38 newadsl kernel: [82085.468643] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:20:48 newadsl kernel: [82095.476030] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:20:58 newadsl kernel: [82105.511291] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:21:08 newadsl kernel: [82115.582038] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:21:18 newadsl kernel: [82125.619836] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:21:29 newadsl kernel: [82135.657631] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:21:39 newadsl kernel: [82145.717738] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:21:49 newadsl kernel: [82155.733228] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:21:59 newadsl kernel: [82165.771026] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:22:09 newadsl kernel: [82175.808824] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:22:19 newadsl kernel: [82185.846623] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:22:29 newadsl kernel: [82195.884417] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:22:39 newadsl kernel: [82205.922216] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:22:49 newadsl kernel: [82215.960011] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:22:59 newadsl kernel: [82225.997809] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:23:09 newadsl kernel: [82236.035607] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:23:19 newadsl kernel: [82246.073409] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:23:29 newadsl kernel: [82256.111204] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:23:39 newadsl kernel: [82266.149003] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:23:49 newadsl kernel: [82276.186801] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:23:59 newadsl kernel: [82286.224599] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:24:09 newadsl kernel: [82296.262394] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:24:19 newadsl kernel: [82306.300193] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:24:29 newadsl kernel: [82316.337991] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:24:39 newadsl kernel: [82326.375790] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:24:49 newadsl kernel: [82336.413585] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:24:59 newadsl kernel: [82346.451384] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:25:09 newadsl kernel: [82356.489182] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:25:19 newadsl kernel: [82366.526980] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:25:29 newadsl kernel: [82376.564775] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:25:39 newadsl kernel: [82386.602577] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:25:50 newadsl kernel: [82396.640375] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:26:00 newadsl kernel: [82406.701045] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:26:10 newadsl kernel: [82416.715969] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:26:20 newadsl kernel: [82426.742081] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:26:30 newadsl kernel: [82436.791563] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:26:40 newadsl kernel: [82446.812606] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:26:50 newadsl kernel: [82456.867160] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:27:00 newadsl kernel: [82466.904958] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:27:10 newadsl kernel: [82476.942756] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:27:20 newadsl kernel: [82486.953655] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:27:30 newadsl kernel: [82497.018350] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:27:40 newadsl kernel: [82507.056148] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:27:50 newadsl kernel: [82517.093944] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:28:00 newadsl kernel: [82527.094705] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:28:10 newadsl kernel: [82537.129967] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:28:20 newadsl kernel: [82547.207343] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:28:30 newadsl kernel: [82557.245138] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:28:40 newadsl kernel: [82567.282936] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:28:50 newadsl kernel: [82577.320735] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:29:00 newadsl kernel: [82587.358533] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:29:10 newadsl kernel: [82597.396329] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:29:20 newadsl kernel: [82607.434131] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:29:30 newadsl kernel: [82617.471926] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:29:40 newadsl kernel: [82627.509724] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:29:50 newadsl kernel: [82637.547520] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:30:00 newadsl kernel: [82647.585319] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:30:10 newadsl kernel: [82657.623117] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:30:21 newadsl kernel: [82667.660915] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:30:31 newadsl kernel: [82677.720863] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:30:41 newadsl kernel: [82687.736515] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:30:51 newadsl kernel: [82697.774314] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:31:01 newadsl kernel: [82707.812110] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:31:11 newadsl kernel: [82717.849909] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:31:21 newadsl kernel: [82727.887707] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:31:31 newadsl kernel: [82737.925505] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:31:41 newadsl kernel: [82747.963301] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:31:51 newadsl kernel: [82758.001103] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:32:01 newadsl kernel: [82768.038899] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:32:11 newadsl kernel: [82778.076698] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:32:21 newadsl kernel: [82788.114492] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:32:31 newadsl kernel: [82798.152291] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:32:41 newadsl kernel: [82808.190090] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:32:51 newadsl kernel: [82818.227889] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:33:01 newadsl kernel: [82828.265687] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:33:11 newadsl kernel: [82838.303486] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:33:21 newadsl kernel: [82848.341285] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:33:31 newadsl kernel: [82858.379084] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:33:41 newadsl kernel: [82868.396033] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:33:51 newadsl kernel: [82878.431295] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:34:01 newadsl kernel: [82888.492473] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:34:11 newadsl kernel: [82898.501821] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:34:21 newadsl kernel: [82908.537084] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:34:31 newadsl kernel: [82918.605869] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:34:42 newadsl kernel: [82928.643668] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:34:52 newadsl kernel: [82938.703781] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:35:02 newadsl kernel: [82948.719262] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:35:12 newadsl kernel: [82958.757061] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:35:22 newadsl kernel: [82968.794857] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:35:32 newadsl kernel: [82978.832661] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:35:42 newadsl kernel: [82988.870457] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:35:52 newadsl kernel: [82998.908256] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:36:02 newadsl kernel: [83008.946052] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:36:12 newadsl kernel: [83018.983850] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:36:22 newadsl kernel: [83029.021649] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:36:32 newadsl kernel: [83039.059448] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:36:42 newadsl kernel: [83049.097247] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:36:52 newadsl kernel: [83059.135045] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:37:02 newadsl kernel: [83069.172841] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:37:12 newadsl kernel: [83079.210640] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:37:22 newadsl kernel: [83089.248435] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:37:32 newadsl kernel: [83099.286234] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:37:42 newadsl kernel: [83109.324033] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:37:52 newadsl kernel: [83119.361832] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:38:02 newadsl kernel: [83129.399631] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:38:12 newadsl kernel: [83139.437430] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:38:22 newadsl kernel: [83149.475228] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:38:32 newadsl kernel: [83159.513027] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:38:42 newadsl kernel: [83169.550823] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:38:52 newadsl kernel: [83179.588622] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:39:02 newadsl kernel: [83189.626417] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:39:13 newadsl kernel: [83199.687096] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:39:23 newadsl kernel: [83209.718654] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:39:33 newadsl kernel: [83219.732634] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:39:43 newadsl kernel: [83229.777613] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:39:53 newadsl kernel: [83239.815411] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:40:03 newadsl kernel: [83249.838423] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:40:13 newadsl kernel: [83259.891006] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:40:23 newadsl kernel: [83269.928808] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:40:33 newadsl kernel: [83279.944213] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:40:43 newadsl kernel: [83289.979476] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:40:53 newadsl kernel: [83300.014739] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:41:03 newadsl kernel: [83310.050002] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:41:13 newadsl kernel: [83320.117797] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:41:23 newadsl kernel: [83330.155596] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:41:33 newadsl kernel: [83340.193395] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:41:43 newadsl kernel: [83350.231193] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:41:53 newadsl kernel: [83360.268992] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:42:03 newadsl kernel: [83370.306788] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:42:13 newadsl kernel: [83380.344587] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:42:23 newadsl kernel: [83390.382383] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:42:33 newadsl kernel: [83400.420182] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:42:43 newadsl kernel: [83410.457981] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:42:53 newadsl kernel: [83420.495783] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:43:03 newadsl kernel: [83430.533579] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:43:13 newadsl kernel: [83440.571378] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:43:23 newadsl kernel: [83450.609177] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:43:34 newadsl kernel: [83460.646976] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:43:44 newadsl kernel: [83470.706928] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:43:54 newadsl kernel: [83480.722571] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:44:04 newadsl kernel: [83490.760369] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:44:14 newadsl kernel: [83500.798169] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:44:24 newadsl kernel: [83510.835965] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:44:34 newadsl kernel: [83520.873764] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:44:44 newadsl kernel: [83530.911562] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:44:54 newadsl kernel: [83540.949358] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:45:04 newadsl kernel: [83550.987150] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:45:14 newadsl kernel: [83561.024950] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:45:24 newadsl kernel: [83571.062745] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:45:34 newadsl kernel: [83581.100541] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:45:44 newadsl kernel: [83591.138334] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:45:54 newadsl kernel: [83601.175012] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:46:04 newadsl kernel: [83611.213923] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:46:14 newadsl kernel: [83621.251719] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:46:24 newadsl kernel: [83631.281997] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:46:34 newadsl kernel: [83641.327311] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:46:44 newadsl kernel: [83651.365107] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:46:54 newadsl kernel: [83661.386574] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:47:04 newadsl kernel: [83671.421834] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:47:14 newadsl kernel: [83681.457094] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:47:24 newadsl kernel: [83691.516285] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:47:34 newadsl kernel: [83701.554081] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:47:44 newadsl kernel: [83711.562875] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:47:54 newadsl kernel: [83721.598135] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:48:05 newadsl kernel: [83731.689780] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:48:15 newadsl kernel: [83741.705266] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:48:25 newadsl kernel: [83751.743062] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:48:35 newadsl kernel: [83761.780858] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:48:45 newadsl kernel: [83771.818651] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:48:55 newadsl kernel: [83781.856450] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:49:05 newadsl kernel: [83791.894243] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:49:15 newadsl kernel: [83801.932039] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:49:25 newadsl kernel: [83811.969832] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:49:35 newadsl kernel: [83822.007628] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:49:45 newadsl kernel: [83832.045425] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:49:55 newadsl kernel: [83842.083220] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:50:05 newadsl kernel: [83852.121016] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:50:15 newadsl kernel: [83862.158817] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:50:25 newadsl kernel: [83872.196612] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:50:35 newadsl kernel: [83882.234405] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:50:45 newadsl kernel: [83892.272202] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:50:55 newadsl kernel: [83902.309998] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:51:05 newadsl kernel: [83912.347794] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:51:15 newadsl kernel: [83922.385587] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:51:25 newadsl kernel: [83932.423386] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:51:35 newadsl kernel: [83942.461179] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:51:45 newadsl kernel: [83952.498975] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:51:55 newadsl kernel: [83962.536768] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:52:05 newadsl kernel: [83972.574565] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:52:15 newadsl kernel: [83982.612361] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:52:26 newadsl kernel: [83992.650157] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:52:36 newadsl kernel: [84002.710262] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:52:46 newadsl kernel: [84012.723087] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:52:56 newadsl kernel: [84022.763546] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:53:06 newadsl kernel: [84032.801342] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:53:16 newadsl kernel: [84042.839135] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:53:26 newadsl kernel: [84052.876932] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:53:36 newadsl kernel: [84062.914725] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:53:46 newadsl kernel: [84072.952521] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:53:56 newadsl kernel: [84082.969909] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:54:06 newadsl kernel: [84093.005170] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:54:16 newadsl kernel: [84103.065910] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:54:26 newadsl kernel: [84113.103706] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:54:36 newadsl kernel: [84123.110952] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:54:46 newadsl kernel: [84133.146212] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:54:56 newadsl kernel: [84143.181472] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:55:06 newadsl kernel: [84153.254892] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:55:16 newadsl kernel: [84163.292685] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:55:26 newadsl kernel: [84173.330481] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:55:36 newadsl kernel: [84183.368274] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:55:46 newadsl kernel: [84193.406071] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:55:56 newadsl kernel: [84203.443867] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:56:06 newadsl kernel: [84213.481663] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:56:16 newadsl kernel: [84223.519460] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:56:26 newadsl kernel: [84233.557256] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:56:36 newadsl kernel: [84243.595049] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:56:46 newadsl kernel: [84253.632846] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:56:57 newadsl kernel: [84263.692796] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:57:07 newadsl kernel: [84273.708436] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:57:17 newadsl kernel: [84283.746232] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:57:27 newadsl kernel: [84293.784028] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:57:37 newadsl kernel: [84303.788448] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:57:47 newadsl kernel: [84313.859621] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:57:57 newadsl kernel: [84323.897417] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:58:07 newadsl kernel: [84333.935214] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:58:17 newadsl kernel: [84343.973007] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:58:27 newadsl kernel: [84354.010804] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:58:37 newadsl kernel: [84364.048597] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:58:47 newadsl kernel: [84374.086397] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:58:57 newadsl kernel: [84384.124190] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:59:07 newadsl kernel: [84394.161987] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:59:17 newadsl kernel: [84404.199783] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:59:27 newadsl kernel: [84414.237579] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:59:37 newadsl kernel: [84424.275373] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:59:47 newadsl kernel: [84434.313169] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 20:59:57 newadsl kernel: [84444.350969] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:00:07 newadsl kernel: [84454.388766] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:00:17 newadsl kernel: [84464.412213] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:00:27 newadsl kernel: [84474.464356] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:00:37 newadsl kernel: [84484.482735] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:00:47 newadsl kernel: [84494.517995] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:00:57 newadsl kernel: [84504.553256] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:01:07 newadsl kernel: [84514.588517] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:01:17 newadsl kernel: [84524.623778] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:01:28 newadsl kernel: [84534.713603] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:01:38 newadsl kernel: [84544.728926] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:01:48 newadsl kernel: [84554.729561] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:01:58 newadsl kernel: [84564.804515] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:02:08 newadsl kernel: [84574.842312] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:02:18 newadsl kernel: [84584.880108] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:02:28 newadsl kernel: [84594.917908] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:02:38 newadsl kernel: [84604.955701] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:02:48 newadsl kernel: [84614.993498] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:02:58 newadsl kernel: [84625.031295] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:03:08 newadsl kernel: [84635.069091] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:03:18 newadsl kernel: [84645.106886] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:03:28 newadsl kernel: [84655.144681] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:03:38 newadsl kernel: [84665.182478] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:03:48 newadsl kernel: [84675.220275] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:03:58 newadsl kernel: [84685.280241] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:04:08 newadsl kernel: [84695.295866] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:04:18 newadsl kernel: [84705.333662] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:04:28 newadsl kernel: [84715.371459] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:04:38 newadsl kernel: [84725.409252] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:04:48 newadsl kernel: [84735.447052] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:04:58 newadsl kernel: [84745.484849] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:05:08 newadsl kernel: [84755.522646] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:05:18 newadsl kernel: [84765.560439] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:05:28 newadsl kernel: [84775.598235] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:05:39 newadsl kernel: [84785.636029] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:05:49 newadsl kernel: [84795.696630] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:05:59 newadsl kernel: [84805.711623] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:06:09 newadsl kernel: [84815.749420] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:06:19 newadsl kernel: [84825.784007] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:06:29 newadsl kernel: [84835.819268] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:06:39 newadsl kernel: [84845.854529] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:06:49 newadsl kernel: [84855.889790] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:06:59 newadsl kernel: [84865.938397] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:07:09 newadsl kernel: [84875.976194] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:07:19 newadsl kernel: [84885.995574] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:07:29 newadsl kernel: [84896.051790] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:07:39 newadsl kernel: [84906.089584] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:07:49 newadsl kernel: [84916.127381] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:07:59 newadsl kernel: [84926.136618] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:08:09 newadsl kernel: [84936.202974] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:08:19 newadsl kernel: [84946.207140] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:08:29 newadsl kernel: [84956.278568] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:08:39 newadsl kernel: [84966.316362] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:08:49 newadsl kernel: [84976.354158] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:08:59 newadsl kernel: [84986.391953] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:09:09 newadsl kernel: [84996.429749] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:09:19 newadsl kernel: [85006.467546] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:09:29 newadsl kernel: [85016.505343] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:09:39 newadsl kernel: [85026.543140] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:09:49 newadsl kernel: [85036.580940] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:09:59 newadsl kernel: [85046.618737] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:10:10 newadsl kernel: [85056.656530] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:10:20 newadsl kernel: [85066.716472] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:10:30 newadsl kernel: [85076.732125] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:10:40 newadsl kernel: [85086.769921] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:10:50 newadsl kernel: [85096.807715] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:11:00 newadsl kernel: [85106.845515] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:11:10 newadsl kernel: [85116.883309] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:11:20 newadsl kernel: [85126.921106] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:11:30 newadsl kernel: [85136.958900] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:11:40 newadsl kernel: [85146.996696] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:11:50 newadsl kernel: [85157.034494] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:12:00 newadsl kernel: [85167.072290] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:12:10 newadsl kernel: [85177.110087] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:12:20 newadsl kernel: [85187.147885] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:12:30 newadsl kernel: [85197.185681] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:12:40 newadsl kernel: [85207.223478] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:12:50 newadsl kernel: [85217.261272] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:13:00 newadsl kernel: [85227.296855] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:13:10 newadsl kernel: [85237.336863] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:13:20 newadsl kernel: [85247.374660] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:13:30 newadsl kernel: [85257.412457] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:13:40 newadsl kernel: [85267.450254] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:13:50 newadsl kernel: [85277.473161] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:14:00 newadsl kernel: [85287.508423] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:14:10 newadsl kernel: [85297.543684] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:14:20 newadsl kernel: [85307.578946] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:14:30 newadsl kernel: [85317.614207] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:14:41 newadsl kernel: [85327.699394] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:14:51 newadsl kernel: [85337.706119] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:15:01 newadsl kernel: [85347.752627] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:15:11 newadsl kernel: [85357.790421] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:15:21 newadsl kernel: [85367.790515] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:15:31 newadsl kernel: [85377.866015] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:15:41 newadsl kernel: [85387.903812] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:15:51 newadsl kernel: [85397.916130] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:16:01 newadsl kernel: [85407.979407] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:16:11 newadsl kernel: [85418.017200] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:16:21 newadsl kernel: [85428.054997] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:16:31 newadsl kernel: [85438.092792] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:16:41 newadsl kernel: [85448.130588] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:16:51 newadsl kernel: [85458.168386] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:17:01 newadsl kernel: [85468.224318] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:17:11 newadsl kernel: [85478.243980] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:17:21 newadsl kernel: [85488.281777] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:17:31 newadsl kernel: [85498.319574] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:17:41 newadsl kernel: [85508.357371] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:17:51 newadsl kernel: [85518.395165] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:18:01 newadsl kernel: [85528.432962] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:18:11 newadsl kernel: [85538.470756] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:18:21 newadsl kernel: [85548.508556] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:18:31 newadsl kernel: [85558.546350] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:18:41 newadsl kernel: [85568.584147] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:18:51 newadsl kernel: [85578.621944] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:19:02 newadsl kernel: [85588.659742] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:19:12 newadsl kernel: [85598.720519] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:19:22 newadsl kernel: [85608.735334] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:19:32 newadsl kernel: [85618.773135] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:19:42 newadsl kernel: [85628.809719] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:19:52 newadsl kernel: [85638.844979] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:20:02 newadsl kernel: [85648.886524] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:20:12 newadsl kernel: [85658.924318] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:20:22 newadsl kernel: [85668.950765] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:20:32 newadsl kernel: [85678.986027] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:20:42 newadsl kernel: [85689.037710] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:20:52 newadsl kernel: [85699.056552] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:21:02 newadsl kernel: [85709.113306] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:21:12 newadsl kernel: [85719.151100] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:21:22 newadsl kernel: [85729.188898] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:21:32 newadsl kernel: [85739.226692] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:21:42 newadsl kernel: [85749.264490] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:21:52 newadsl kernel: [85759.268123] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:22:02 newadsl kernel: [85769.340088] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:22:12 newadsl kernel: [85779.377882] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:22:22 newadsl kernel: [85789.438304] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:22:32 newadsl kernel: [85799.453478] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:22:42 newadsl kernel: [85809.491275] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:22:52 newadsl kernel: [85819.529069] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:23:02 newadsl kernel: [85829.566867] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:23:12 newadsl kernel: [85839.604664] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:23:23 newadsl kernel: [85849.642462] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:23:33 newadsl kernel: [85859.702862] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:23:43 newadsl kernel: [85869.718055] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:23:53 newadsl kernel: [85879.755852] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:24:03 newadsl kernel: [85889.793650] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:24:13 newadsl kernel: [85899.831445] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:24:23 newadsl kernel: [85909.869245] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:24:33 newadsl kernel: [85919.907042] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:24:43 newadsl kernel: [85929.944840] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:24:53 newadsl kernel: [85939.982635] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:25:03 newadsl kernel: [85950.020433] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:25:13 newadsl kernel: [85960.058227] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:25:23 newadsl kernel: [85970.096025] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:25:33 newadsl kernel: [85980.133822] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:25:43 newadsl kernel: [85990.171620] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:25:53 newadsl kernel: [86000.209418] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:26:03 newadsl kernel: [86010.247215] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:26:13 newadsl kernel: [86020.307941] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:26:23 newadsl kernel: [86030.322807] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:26:33 newadsl kernel: [86040.324791] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:26:43 newadsl kernel: [86050.398400] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:26:53 newadsl kernel: [86060.436201] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:27:03 newadsl kernel: [86070.463649] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:27:13 newadsl kernel: [86080.511792] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:27:23 newadsl kernel: [86090.549590] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:27:33 newadsl kernel: [86100.587388] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:27:43 newadsl kernel: [86110.604697] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:27:54 newadsl kernel: [86120.685290] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:28:04 newadsl kernel: [86130.723105] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:28:14 newadsl kernel: [86140.710484] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:28:24 newadsl kernel: [86150.776374] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:28:34 newadsl kernel: [86160.814168] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:28:44 newadsl kernel: [86170.816270] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:28:54 newadsl kernel: [86180.889764] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:29:04 newadsl kernel: [86190.927561] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:29:14 newadsl kernel: [86200.965359] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:29:24 newadsl kernel: [86211.003160] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:29:34 newadsl kernel: [86221.040957] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:29:44 newadsl kernel: [86231.078753] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:29:54 newadsl kernel: [86241.116550] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:30:04 newadsl kernel: [86251.154348] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:30:14 newadsl kernel: [86261.192145] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:30:24 newadsl kernel: [86271.229940] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:30:34 newadsl kernel: [86281.267741] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:30:44 newadsl kernel: [86291.305535] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:30:54 newadsl kernel: [86301.343334] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:31:04 newadsl kernel: [86311.381128] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:31:14 newadsl kernel: [86321.418925] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:31:24 newadsl kernel: [86331.456724] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:31:34 newadsl kernel: [86341.494521] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:31:44 newadsl kernel: [86351.532319] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:31:54 newadsl kernel: [86361.570117] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:32:04 newadsl kernel: [86371.607915] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:32:15 newadsl kernel: [86381.645712] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:32:25 newadsl kernel: [86391.706797] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:32:35 newadsl kernel: [86401.721305] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:32:45 newadsl kernel: [86411.759099] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:32:55 newadsl kernel: [86421.796898] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:33:05 newadsl kernel: [86431.834695] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:33:15 newadsl kernel: [86441.872493] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:33:25 newadsl kernel: [86451.906017] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:33:35 newadsl kernel: [86461.941280] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:33:45 newadsl kernel: [86471.985883] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:33:55 newadsl kernel: [86482.023681] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:34:05 newadsl kernel: [86492.061475] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:34:15 newadsl kernel: [86502.099280] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:34:25 newadsl kernel: [86512.137075] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:34:35 newadsl kernel: [86522.174872] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:34:45 newadsl kernel: [86532.234922] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:34:55 newadsl kernel: [86542.250465] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:35:05 newadsl kernel: [86552.288262] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:35:15 newadsl kernel: [86562.326060] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:35:25 newadsl kernel: [86572.363858] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:35:35 newadsl kernel: [86582.364430] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:35:45 newadsl kernel: [86592.439450] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:35:55 newadsl kernel: [86602.477252] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:36:05 newadsl kernel: [86612.515055] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:36:15 newadsl kernel: [86622.552860] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:36:25 newadsl kernel: [86632.590665] ath5k phy0: no further txbuf=
 available, dropping packet
Aug 18 21:36:35 newadsl kernel: [86642.628470] ath5k phy0: no further txbuf=
 available, dropping packet


--Boundary-01=_NgQjKdiNVAep9ll
Content-Type: text/plain;
  charset="utf-8";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31-rc6
# Mon Aug 17 08:58:17 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=2
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEFAULT_PS_VALUE=1
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
# CONFIG_ATH9K is not set
# CONFIG_AR9170_USB is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set
# CONFIG_HERMES is not set
# CONFIG_WL12XX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
CONFIG_ATM_SOLOS=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=y
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_IMA is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--Boundary-01=_NgQjKdiNVAep9ll--

--nextPart1888185.uDfLT9YcJn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqNCA0ACgkQSWe+XpRKvi156QCgkr3kymAatL3pnSFhV1kxrXTa
ndgAmwXsOyyfx+81RoQqTu5Vs4tvUSEA
=tovG
-----END PGP SIGNATURE-----

--nextPart1888185.uDfLT9YcJn--
