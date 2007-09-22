Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:5193 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXIVAWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 20:22:25 -0400
Received: by wx-out-0506.google.com with SMTP id h31so790208wxd
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 17:22:23 -0700 (PDT)
Date: Fri, 21 Sep 2007 20:23:30 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/5] Add central regulatory domain agent - Patchset I
Message-ID: <20070922002330.GK31768@pogo>
References: <20070921204606.GD31768@pogo> <1190410796.14368.17.camel@xo-3E-67-34.localdomain> <1190411390.18521.174.camel@johannes.berg> <43e72e890709211500k741e7a8ai21f2de12eec81926@mail.gmail.com> <43e72e890709211714m312daa6cg8f92c10010d9d8ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <43e72e890709211714m312daa6cg8f92c10010d9d8ce@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2007 at 08:14:09PM -0400, Luis R. Rodriguez wrote:
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/v2-regdomain-pat=
ches/

Oh and bellow inline is the Documenation/networking/regdomains.txt I
have so far.. its not much but its a start:

  Luis

---

Linux central regulatory domain agent
-------------------------------------

The central reg agent consists of two main parts:

* ISO3166-1 module (iso3166-1.ko)
* Regulatory module (regdomains.ko)

Integration with the kernel wireless subsystem is done by extending cfg=
80211
to support a central regulatory domain to which all devices should adhe=
re to.
Then, mac80211 is expanded to allow devices to indicate their deivice i=
s
configured to a specific regulatory domain domain, set set either in it=
s EEPROM
or firmware. Helper routines are also provided for mac80211 to build th=
e=20
ieee80211_channel array of hardware supported channels.

After a regulatory domain is set all cfg80211 devices are scanned for a=
nd
their channels are iterated over, only channels which the regulatory do=
main
indicates are valid for its current regulatory domain are enabled. Powe=
r
restriction for PtP and PtMP type of connections are also considered=20
and set.

Each country can be mapped to one regulatory domain. Each regulatory do=
main=20
has two maps for channels, one on the 2.4GHz band and another on the 5G=
Hz band.
Power restrictions are a little more complicated -- we break both the 2=
GHz band
and the 5GHz band into 7 logical subbands as follows:

Subband name	Min (MHz)	Max (MHz)	IEEE-802.11 Channel range
ISM-2.4		2412		2732		1-26
Telec		5005		5145		1-29
UNII-1		5150		5245		30-49
UNII-2		5250		5350		50-70
ETSI		5355		5720		71-144
UNII-3		5725		5825		145-165
AAD		5830		6100		166-220

Note that ETSI also operates on UNII-2, we split this into logical name=
s just
to be pragmatic. Then for each subband we define specific power restric=
tions.

The current regualtory map is found in regulatory_map.h A userspace dae=
mon can
later be provided to update the regulatory map. At the very least the k=
ernel
should have the world regulatory domain but note that due to large amou=
nt of
varied restrictions this means only enabling 3 channels on the 2GHz ban=
d=20
(5, 6 and 7) and no channels on the 5GHz band with minimal PtMP power
restrictions.

=46or further implementation details please refer kerneldoc of iso3166-=
1,=20
regdomains, cfg80211, and mac80211.=20

---

Wireles regulatory primer:

PtMP	- Point to Multipoint
PtP	- Point to Point

EIRP	- Equivalent Isotropically Radiated Power
IR	- Intentional Radiator, transmitter
dBm	- dB milliwatt (mW), the base says that 1mW =3D 0 dBm
dBi	- dB relative to isotropic, used to measure antenna gain compared t=
o an
	  isotropic antenna on which radiation is distributed uniformly on the
	  surface of a sphere=20

EIRP =3D IR - loss in transmission line + passive gain of the antenna

---

Some information based on:=20

http://university.cyberarmy.net/kb/tiki-index.php?page=3DThe+Power+of+8=
02.11

Bellow is an example for FCC.

In the 2.4Ghz ISM band the FCC stipulates that the creation of PtMP=20
links be subject to the following restrictions:
- EIRP must not exceed 36 dBm (4W)
- IR must not exceed 30 dBm (1W)
- For every 3 dBi of antenna gain after the first 6 =E2=80=9Cfree=E2=80=
=9D dBi the IR must=20
  be decreased by 3 dBi (the 1:1 rule)

Example (without considering loss) of possible settings if Max EIRP is=20
defined as 36 dBm and we are using the 1:1 rule:

TX power (dBm)	Antenna Gain (dBi)	Max EIRP (dBm)
30-------------------6----------------------36
29-------------------7----------------------36
28-------------------8----------------------36
27-------------------9----------------------36=20

=46or PtP links that rule is augmented:
- No Maximum EIRP
- IR is limited to 30 dBm (1W)
- For every 3 dBi after the first 6 of antenna gain the IR must be=20
  decreased by 1 dBi (the 3:1 rule)

Example, where IR limit is 30, and has the 3:1 rule above for gain:

TX power (dBm)	Antenna Gain (dBi)	Effective EIRP (dBm)
29-------------------6-----------------------35
30-------------------6-----------------------36
29-------------------9-----------------------38
28-------------------12----------------------40
27-------------------15----------------------42
26-------------------18----------------------44
25-------------------21----------------------46=20

In the 5GHz band the FCC stipulates for PtMP:

- UNII-1: Maximum IR power may not exceed 40mW (16dBm)
- UNII-1: EIRP may not exceed 160mW (22dBm)
- UNII-2: Maximum IR power may not exceed 200mW (23dBm)
- UNII-2: EIRP may not exceed 800mW (29dBm)
- UNII-3: Maximum IR power may not exceed 800mW (29dBm)
- UNII-3: EIRP may not exceed 3.2W (35dBm)
- All three bands utilize the 1:1 rule

=46or PtP:

- UNII-1 Follows the same rules as the PtMP links
- UNII-2 Follows the same rules as the PtMP links
- UNII-3 May use an antenna with up to 23dBi of gain before the 1:1 rul=
e=20
  becomes effective. (Giving a maximum EIRP of 200W!!)

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
