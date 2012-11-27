Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep24.mx.upcmail.net ([62.179.121.44]:48202 "EHLO
	fep24.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2K0Hvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 02:51:45 -0500
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep17-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20121127075034.KRKG7658.viefep17-int.chello.at@edge04.upcmail.net>
          for <linux-wireless@vger.kernel.org>;
          Tue, 27 Nov 2012 08:50:34 +0100
Received: from [194.124.158.2] (jupiter.think.ch [194.124.158.2])
	(authenticated bits=0)
	by luna.think.ch (8.14.3/8.14.3) with ESMTP id qAR7oWTe008077
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 08:50:32 +0100
Message-ID: <50B470CE.8070402@think.ch> (sfid-20121127_085149_457934_F6A3DAED)
Date: Tue, 27 Nov 2012 08:50:38 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: regulatory domain settings overwritten
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000705090901010305040608"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms000705090901010305040608
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello

I am trying to set up wireless support on an embedded X86 based device
(PCengines WRAP) using an atheros based CM-9 card manufactured by
Wistron Neweb.

I am using cfg80211 with the internal regulatory domain database. I am
observing the following with dmesg

[  133.324451] cfg80211: Calling CRDA to update world regulatory domain
[  133.344421] cfg80211: World regulatory domain updated:
[  133.346021]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  133.347622]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  133.348902]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[  133.349842]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[  133.350455]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  133.351736]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  133.353431] cfg80211: Calling CRDA for country: CH
[  133.443881] cfg80211: Regulatory domain changed to country: CH
[  133.444568]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  133.445486]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mB=
m)
[  133.446397]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mB=
m)
[  133.447630]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mB=
m)
[  133.448863]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mB=
m)
[  141.971982] ath5k 0000:00:0d.0: registered as 'phy0'
[  142.453824] ath: EEPROM regdomain: 0x0
[  142.453881] ath: EEPROM indicates default country code should be used
[  142.453940] ath: doing EEPROM country->regdmn map search
[  142.454009] ath: country maps to regdmn code: 0x3a
[  142.454062] ath: Country alpha2 being used: US
[  142.454109] ath: Regpair used: 0x3a
[  146.738786] phy0: Selected rate control algorithm 'minstrel'
[  146.838666] ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x=
43)
[  146.839284] ath5k phy0: RF5112B multiband radio found (0x36)
[  146.842202] cfg80211: Calling CRDA for country: US
[  146.936338] cfg80211: Current regulatory domain intersected:
[  146.937470]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  146.938415]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mB=
m)
[  146.939290]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 1700 mB=
m)
[  146.940525]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mB=
m)
[  146.941758]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (N/A, 2000 mB=
m)
[  146.942702]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2000 mB=
m)

Although I specify a country code CH at module loading, it appears that
the athk5 driver is calling cfg80211 with a default country code. Why is
US the default country code and why is it called at all.

Thanks

Erich Titl


--------------ms000705090901010305040608
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

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
--------------ms000705090901010305040608--
