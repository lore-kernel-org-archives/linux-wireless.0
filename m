Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:48652 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZHTAVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 20:21:17 -0400
Received: by iwn42 with SMTP id 42so253687iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 17:21:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <h6ced0$hoi$1@ger.gmane.org>
References: <h6ced0$hoi$1@ger.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 19 Aug 2009 17:20:58 -0700
Message-ID: <43e72e890908191720m6838e81ei853a27856288db8f@mail.gmail.com>
Subject: Re: Regulatory problems with ath5k in AP mode
To: Simon Farnsworth <simon@farnz.org.uk>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 1:27 PM, Simon Farnsworth<simon@farnz.org.uk> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hello,
>
> I'm facing problems using two ath5k miniPCI cards in a single box as a
> dual-band access point. I'm using wireless-testing as of commit
> d5a88a192e556a7c30f9d425bb6673b5bff5e3f3.

This is a bit old now, please update. The updates won't help you
regulatory wise, but for purposes of testing new patches it would be
easier.

> As I'm trying to use the cards for AP mode, I cannot rely on beacons with
> regulatory data being present;

Regulatory questions are often and I try really hard to answer them
first through documentation so it seems we need to improve
documentation further. To be thorough though I'd first like to ask if
you have read all this:

Linux regulatory docs:

http://wireless.kernel.org/en/developers/Regulatory

Atheros shared module documentation (ath.ko):

http://wireless.kernel.org/en/users/Drivers/ath

The above has specifics about how the Atheros EEPROM is designed in
consideration for regulatory purposes, and what we do in Linux with
regards to the new Linux regulatory infrastructure.

Perhaps one aspect regarding regulatory that may need some updating is
how we deal with world roaming. Let me clarify a little on that and
please let me know if the documentation hasn't been crystal clear so
we can improve on it.

World roaming is a practice vendors use to allow customers (OEMs, etc)
sell wireless devices in different regions. Typically you would expect
one device sold for one particular region and building and programming
the device, EEPROM or firmware for that region. Over time this has
proven economically cost prohibitive but also impractical due to the
dynamic nature of regulatory rules world wide so vendors tend to allow
for more control for regulatory purposes to be more dynamic, one way
or another. This shift is done purely for the sake of reducing cost,
while also simplifying hardware and increasing the range in which
customers can sell their products. What increases in complexity is
software which needs to deal with this.

Technically you can come up with a world wide regulatory domain which
allows operation of an 802.11 device world wide. But obviously this
itself can change as well, and so remains dynamic. The complexity of
the considerations increases when you start to consider the different
modes of operation which you can use on an 802.11 device. Addressing
station mode support is the easiest as you *do* not necessarily have
to initiate transmit in order to find your Access Point. If you try to
address regulatory rules in consideration for dealing with initial TX
your rules become more complex.

Sometimes you don't have to be so restrictive on some bands (2.4 GHz
or 5 GHz) for some customers shipping to only a few countries, so a
world regulatory domain is pretty restrictive. When only a few
countries are being used to ship products some customers may request a
different regulatory domain to be created to work as the intersection
between those countries and not *every* country. Sometimes some
companies like to only customize a few "world regulatory domains" and
only sell to customers on one of those few choices. This varies,
vendor by vendor.

Your most basic regulatory setting would consist of a 1-1 mapping
where the device *knows* for sure it was packaged and sold and tested
for only one country. For that case the rules are very clear and we
can simply read the rules only for that country on some sort of
database. This is however a very rare case though, at least for
Atheros cards. Most Atheros cards use world regulatory domains. From a
design perspective what regulatory domain an 802.11 device falls under
is up to the customer, where the customer typically means an OEM, or
card manufacturer. Today the end user has no say in what regulatory
domain your card is designed and tested for except for the general
assumption that if you purchase a laptop or wireless device in a
country an assumption is made based on the targeted audience for that
product. A laptop from a manufacturer who typically sells a lot to
companies world wide may prefer to use a world regulatory domain to
accommodate a set of countries they will market their product for, we
refer to these as SKUs. At times maybe a manufacturer will see a
product is not selling well in certain countries and may change their
strategy and sell to some other countries. A prepared manufacturer may
have foreseen this and because of it chose a world regulatory domain
SKU which would fit its current target countries and also a few
potential ones.

What mode of operation you use is important too, but for example today
laptops are *typically* not sold with the intention to support AP
mode, for example, even though your hardware is completely capable of
it, and we may see this change in the future.

When you world roam you are typically now allowed to initiate TX on
some channels, the exception today is channels 1-11 on the 2.4 GHz
band as every country allows for operation on these channels. On 5 GHz
though this means regulatory wise we enforce passive scanning on many
world regulatory domains. This is the case of all Atheros world
regulatory domains, and the Linux world regulatory domain. There are
certain heuristics you can use, however, to help with this though if
you do want to support AP mode on 5 GHz on some of these cards though.
An example here is if you detect a beacon from an AP on a 5 GHz
channel you could then assume you can also initiate TX. This
assumption works well right on 5 GHz except for channels which require
DFS. We take advantage of this assumption in Linux and enable
initiating TX (beaconing) when we see an AP around us on non-DFS
channels.

Typical practice in the industry is user input is not used for
regulatory compliance. Truth is user input could in fact be very
valuable and we do take advantage of it on Linux to *help* regulatory
compliance. An example here is a user purchases a device from Japan
and moves to the US and wants to disable usage of channels 13 and 14
which are not allowed in the US. If a user informs the kernel the user
is in the US we can disable scanning on channels 13 and 14 and
therefore improve scan time and roaming time.

Now, although some optimizations may be welcomed like world roaming
enhancements, and user input could in fact be valuable information to
help regulatory compliance, one thing still remains true: devices sold
today are not designed with user input in mind for regulatory
compliance. The extent to which we make use of certain optimizations
in Linux are purely practical in nature, but care must be taken to
note that laws must still be respected. Because regulatory laws vary
but do not make it clear explicit user input is welcomed manufacturers
still do need to be careful to not over step the boundaries of what is
allowed and what may make perfect sense to some developers and users
may not be necessarily agreeable currently to current regulatory
agencies. I do believe this shall change though, it is inevitable, but
we're not there yet.

Until then please do understand that current regulatory framework
exist to aid vendors primarily with regulatory compliance and user
input is used only as optimizations. As such also take into
consideration that although the "US" regulatory domain can be well
defined, not all vendors use it even if they do sell devices in the
US. Vendors may also have custom world regulatory domains if they
choose to not want to just use the intersection between all countries,
the default.

Now with all that said and with you having read the documentation,
lets move on :)

> instead, I have modprobe configured to run
> "iw reg set GB" after cfg80211 is loaded,

How do you have modprove configured to do that? Are you using
ieee80211_regdom module parameter? If so please consider just using
'iw' or hostapd configured as you have below.

> and hostapd.conf files containing
> the line "country_code=GB".

You only need one of those.

For Atheros devices this is an example of a user helping compliance.

> My cards both have a regdomain in the EEPROM of 0x0,

This is something that the manufacturer would have decided on.

> which my vendor assures
> me is the correct regdomain for cards which don't claim any particular
> regulatory compliance,

Who exactly did you speak to?

Atheros uses 0x0 for a default mapping to the US.

> and which rely on the host OS getting regulatory
> compliance right.

The driver does indeed map 0x0 to "US".

> I am seeing two problems; firstly, the regulatory
> infrastructure insists that I'm in the United States,

Bingo, its not the Linux regulatory infrastructure doing this, it is
the ath.ko shared module which is used as a helper to share code
between ath5k, ath9k, ar9170 and soon ar9271. Atheros' EEPROM was
designed with specific regulatory considerations, its engineered so
that the device's EEPROM indicates what regulatory domain should be
used. As I explained above, what regulatory domain your card is
programmed with is not up to you, it is up to the manufacturer. While
I agree this may be silly, its for a reason and until regulatory rules
change this will be the case.

> thus preventing legal
> use of the WiFi bands, but allowing me illegal use.

This is no different than considering the case of when you ship an
access point from JP to the US and you start beaconing on channel 13.
You are violating local US regulatory laws if your configuration was
to beacon on channel 13. If you take a US AP to the JP you then are
prevented from usage of the allowed channel 13.

I realize it may seem silly, and in fact I agree, but that is the law.
If you were to bring an AP from JP to the US *with* a regulatory
domain which matches the JP SKUs and therefore are allowed to beacon
on channel 13 we give you the flexibility in Linux to enhance
compliance and indicate you are on in the US and disable channel 13.
Now, as much as I would love for it to be the case that the other way
around should be enabled it is not, and although technically it is
feasible, it is just not something agreeable to current regulatory
agencies. Maybe one day it will be for 802.11, who knows.

Anyway in your case since the device sends a regulatory hint for "US"
first, and then you say "GB" the card will *always* respect first
"US", and "GB" is just used to further help compliance.

> Secondly, I'm seeing different regulatory settings on each card. "iw list"
> shows me that in the 2GHz band, phy1 is being allowed to use 27.0 dBm on
> channels 1-11, whereas I'm only allowed to use 20.0 dBm, but I'm allowed
> channels 1-13.

I did not understand the last part, can you rephrase this again?

> In the 5GHz band, phy1 is allowed 17.0 dBm on channels 36-48,
> to my local regulation's 20.0 dBm, reduced power in the (unusable as yet due
> to driver limitations) DFS-only channels between 5.490 GHz and 5.710 GHz,
> and 30 dBm in the illegal channels for my region of 149 to 165.

OK, first lets review US and GB regulatory domain:

country GB:
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ 40), (N/A, 20)
        (5250 - 5330 @ 40), (N/A, 20), DFS
        (5490 - 5710 @ 40), (N/A, 27), DFS

country US:
        (2402 - 2472 @ 40), (3, 27)
        (5170 - 5250 @ 40), (3, 17)
        (5250 - 5330 @ 40), (3, 20), DFS
        (5490 - 5710 @ 40), (3, 20), DFS
        (5735 - 5835 @ 40), (3, 30)

Now here is what an intersection yields for me between US and GB:

mcgrof@tux ~/devel/crda (git::master)$ sudo ./intersect
../wireless-regdb/regulatory.bin
GB (4) intersect US (5) ==> 4 rules
Only one intersection completed
== World regulatory domain: ==
country 99:
	(2402.000 - 2472.000 @ 40.000), (N/A, 20.00)
	(5170.000 - 5250.000 @ 40.000), (N/A, 17.00)
	(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS
	(5490.000 - 5710.000 @ 40.000), (N/A, 20.00), DFS

So since your card is programmed for the "US" that information is
*always* respected. GB info is only used to further help compliance.
This means whatever channels are not allowed by the "US" regulatory
domain will never be allowed on your card even if you say you are in
"GB".

> On phy0, I see that I'm being permitted 20.0 dBm in the 2GHz band (but still
> only channels 1-11, and no beaconing permitted in the 5GHz band.

Interesting, consider that phy0 is the first device detected, its
regulatory hint would have first listened to, since both devices have
the same regulatory domain according to what you are indicating they
would agree.

And instead of reading your interpretation of what is allowed or not
can you please instead provide the 'iw list' output?

> How do I persuade the Atheros drivers that, since I'm using AP mode, the
> user-set regulatory domain is correct,

You cannot. But information from the user to help compliance is
certainly welcomed.

> and that the domain it selects for
> EEPROM regdomain 0x0 is wrong?

Its not wrong per se, it was designed that way and you do disagree
with it. There is also a lot of historical and legal history behind
how you ended up with a "US" card in "GB". I hope to have clarified
that.

> Ideally, I would expect both cards to have the same regulatory rules
> applied;

Indeed, this does seems like a bug.

> I would further expect to be able to select a different country's
> regulations to the ones selected by default,

Yeah typically that's what users expect but that's not the case.
Granted there are devices in Linux for which the device has no
regulatory information at all. In those cases the user does have final
say on the device. If the vendor does know better though that
information is respected.

> without losing the card's
> calibration settings (which I believe are stored in a way that depends on
> the EEPROM regdomain setting).

Spot on -- calibration is actually very important for device
functionality, it is actually also used for regulatory conformance on
what we call 'Conformance Test Limits'. Now this is very Atheros
specific but the idea is the same between vendors, to respect max EIRP
on band edges very carefully. The CTL info *also* does provide
regulatory limits for max EIPR in-band, and not just band edges. This
information is used to conform to the device's calibrated regulatory
domain.

> I should note that I'm happy to run a
> privately patched kernel, if that's the only way to do what I want, but I'm
> still concerned about the differing regulatory rules between the two cards.

I recommend to help resolve your issues by reporting the issues as you
have but with detailed logs. Sure you can hack up ath5k and ath9k to
do weird things, maybe even sing, but I advise against it unless you
know what you are doing. We do have good support upstream for ath9k
and ath5k for regulatory and calibration purposes. The point is to
help you use your device as was intended, we can't help you if you
take your device out of intended regulatory domain due to the
differences in calibration settings and because it may make the device
use settings which could potentially damage it. Things are they way
they are for a reason, except if there is a bug and I do think you
have found one.

> The relevant chunk of dmesg follows, and I can provide any other needed
> information upon request:
>
> [    1.857433] cfg80211: Calling CRDA to update world regulatory domain
> [    1.891579] cfg80211: Calling CRDA for country: GB

This probably came from the modprobe thing you have, whatever that
was. This indicates userspace is being kicked to call /sbin/crda so
that crda sends the GB regulatory domain to cfg80211. Notice how
cfg80211 hasn't yet replied though, or maybe it has but cfg80211
hasn't yet processed anything until later after the other
regulatory_hint()s.

> [    2.015975] ath5k 0000:02:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    2.016204] ath5k 0000:02:04.0: registered as 'phy0'
> [    2.152564] ath: EEPROM regdomain: 0x0

OK first device has 0x0.

> [    2.152574] ath: EEPROM indicates default country code should be used
> [    2.152580] ath: doing EEPROM country->regdmn map search
> [    2.152589] ath: country maps to regdmn code: 0x3a
> [    2.152595] ath: Country alpha2 being used: US

and it maps the US.

> [    2.152601] ath: Regpair used: 0x3a
> [    2.264328] phy0: Selected rate control algorithm 'minstrel'
> [    2.264822] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> [    2.265041]   alloc irq_desc for 17 on node -1
> [    2.265048]   alloc kstat_irqs on node -1
> [    2.265066] ath5k 0000:02:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    2.265276] ath5k 0000:02:08.0: registered as 'phy1'
> [    2.400795] ath: EEPROM regdomain: 0x0

Here is the second device and it also has 0x0, ok good.

> [    2.400805] ath: EEPROM indicates default country code should be used
> [    2.400812] ath: doing EEPROM country->regdmn map search
> [    2.400821] ath: country maps to regdmn code: 0x3a
> [    2.400827] ath: Country alpha2 being used: US

And again "US" is picked up.

> [    2.400832] ath: Regpair used: 0x3a
> [    2.400924] cfg80211: Calling CRDA for country: US

This is the first regulatory_hint() being processed by cfg80211
module. Eventually userspace udev will kick /sbin/crda and crda will
send the "US" regulatory domain to cfg80211.

> [    2.403133] phy1: Selected rate control algorithm 'minstrel'
> [    2.403636] ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> [    2.403867] cfg80211: Calling CRDA for country: US

Here is the second regulatory_hint() being processed. At this point
userspace is expected to have run twice and the kernel should have
received the "US" regulatory domain twice.

Now notice the timestamps below in comparison to the one above:

> [    3.076972] cfg80211: Current regulatory domain intersected:
> [    3.077089]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [    3.077277]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    3.077386]  (2457000 KHz - 2472000 KHz @ 15000 KHz), (300 mBi, 2000 mBm)
> [    3.077494]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
> [    3.077602]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

Lets compare this against the intersection I ran in userspace:

	(2402.000 - 2472.000 @ 40.000), (N/A, 20.00)
	(5170.000 - 5250.000 @ 40.000), (N/A, 17.00)
	(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS
	(5490.000 - 5710.000 @ 40.000), (N/A, 20.00), DFS

A few observations:

  * Notice how the 2457000 KHz - 2472000 KHz is present on your ouput
but not on mine.

  * Notice how you have 15000 KHz bandwidth allowed for your 2457000
KHz - 2472000 KHz frequency range. That bandwidth is there because
2472000 minus 2457000 yields  15000, but why the rule is there is not
clear to me as I am not sure what regulatory domains are being
intersected here.

  * The 2472000 - 2457000 frequency rule is good example of
overlapping rules which could probably be avoided if we formalize
regulatory definitions more as Johannes had proved a while ago.

  * My intersection yielded 5250.000 - 5330.000 but you do not have this at all

  * You have 5735000 KHz - 5835000 KHz but should not.

We can debug all this further but first I'd like to see your full log.
To be clearer I'll also recommend for now for you to not have
something to trigger a regulatory hint from userspace early, either
through the ieee80211_regdom module parameter, which you have not
indicated you have used but I do suspect you did use, or through some
script upon cfg80211 loading. I don't expect a script to have
triggered a regulatory hint prior to ath5k loading so I am curious how
you accomplished this.

What is very curious here is cfg80211 indicates it is already
intersecting. This to me indicates you have either forgotten to add
more dmesg info from the initial regulatory domain setting *or* there
is a bug here between cfg80211 believing it already has processed GB.
Either way you are certainly right that something is fishy here.

Can you just post your full dmesg log?

> [    3.082954] cfg80211: Current regulatory domain intersected:
> [    3.083078]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [    3.083278]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    3.083392]  (2457000 KHz - 2472000 KHz @ 15000 KHz), (300 mBi, 2000 mBm)
> [    3.083504]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
> [    3.083616]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

This listing is identical as the one above. What is even fishier is
once you have an intersected regulatory domain IIRC we don't let much
through anymore.

Please enable in your kernel

CONFIG_CFG80211_REG_DEBUG=y

Also please ensure to disable CONFIG_WIRELESS_OLD_REGULATORY and
please tell me if you had this set or not.

Thank you for taking the time to report this.

  Luis
