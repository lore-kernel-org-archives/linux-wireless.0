Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:34961 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZBISK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 13:10:28 -0500
Subject: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
 ranges
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: linux-wireless@vger.kernel.org
Cc: reinette chatre <reinette.chatre@intel.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nu5bzE8sRtPjV2Xfsgci"
Date: Mon, 09 Feb 2009 18:09:53 +0000
Message-Id: <1234202993.21570.18.camel@localhost> (sfid-20090209_191033_790996_E7FA908E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nu5bzE8sRtPjV2Xfsgci
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'm using:
[ebuild   R   ] net-wireless/wireless-regdb-20090130  0 kB
[ebuild   R   ] net-wireless/crda-1.0.1-r1  0 kB
[ebuild   R   ] net-wireless/iwl5000-ucode-5.4.0.11  0 kB

The regulatory information for Great Britain looks as follows:
country GB:
	(2402.000 - 2482.000 @ 40.000), (N/A, 20.00)
	(5170.000 - 5250.000 @ 40.000), (N/A, 20.00)
	(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS
	(5490.000 - 5710.000 @ 40.000), (N/A, 27.00), DFS

iw reports the card configuration like such:
Wiphy phy0
	Band 1:
		HT capabilities: 0x087e
			 * 20/40 MHz operation
			 * SM PS disabled
			 * HT-greenfield
			 * 20 MHz short GI
			 * 40 MHz short GI
			 * max A-MSDU len 7935
		HT A-MPDU factor: 0x0003 (65535 bytes)
		HT A-MPDU density: 0x0005 (4 usec)
		HT MCS set: ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00
		Frequencies:
			* 2412 MHz [1] (15.0 dBm)
			* 2417 MHz [2] (15.0 dBm)
			* 2422 MHz [3] (15.0 dBm)
			* 2427 MHz [4] (15.0 dBm)
			* 2432 MHz [5] (15.0 dBm)
			* 2437 MHz [6] (15.0 dBm)
			* 2442 MHz [7] (15.0 dBm)
			* 2447 MHz [8] (15.0 dBm)
			* 2452 MHz [9] (15.0 dBm)
			* 2457 MHz [10] (15.0 dBm)
			* 2462 MHz [11] (15.0 dBm)
			* 2467 MHz [12] (15.0 dBm) (passive scanning, no IBSS)
			* 2472 MHz [13] (15.0 dBm) (passive scanning, no IBSS)
		Bitrates:
			* 1.0 Mbps
			* 2.0 Mbps (short preamble supported)
			* 5.5 Mbps (short preamble supported)
			* 11.0 Mbps (short preamble supported)
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
			* 60.0 Mbps
	Band 2:
		HT capabilities: 0x087e
			 * 20/40 MHz operation
			 * SM PS disabled
			 * HT-greenfield
			 * 20 MHz short GI
			 * 40 MHz short GI
			 * max A-MSDU len 7935
		HT A-MPDU factor: 0x0003 (65535 bytes)
		HT A-MPDU density: 0x0005 (4 usec)
		HT MCS set: ff ff ff 00 01 00 00 00 00 00 c2 01 01 00 00 00
		Frequencies:
			* 5180 MHz [36] (disabled)
			* 5200 MHz [40] (disabled)
			* 5220 MHz [44] (disabled)
			* 5240 MHz [48] (disabled)
			* 5260 MHz [52] (disabled)
			* 5280 MHz [56] (disabled)
			* 5300 MHz [60] (disabled)
			* 5320 MHz [64] (disabled)
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
			* 5745 MHz [149] (disabled)
			* 5765 MHz [153] (disabled)
			* 5785 MHz [157] (disabled)
			* 5805 MHz [161] (disabled)
			* 5825 MHz [165] (disabled)
		Bitrates:
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
			* 60.0 Mbps
	Supported interface modes:
		 * IBSS
		 * Station
		 * Monitor

My Cisco AIR-AP1131AG-E-K9_v04 access point with C1130 Software
(C1130-K9W7-M), Version 12.4(10b)JA, RELEASE has Dot11Radio0 &
Dot11Radio1 configured like so:
world-mode dot11d country GB indoor

The kernel seems to do something else:
cfg80211: Calling CRDA for country: GB
cfg80211: Current regulatory domain updated by AP to: GB
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)

Any idea how that could happen please?

Regards,
Tony V.

--=-nu5bzE8sRtPjV2Xfsgci
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmQcXEACgkQp5vW4rUFj5qXxACgpw+efLHma/hI+nj3tNTmw1aw
GYkAoMHPAbOG3jllCgRW4wvHWLJ0Adq+
=OJIE
-----END PGP SIGNATURE-----

--=-nu5bzE8sRtPjV2Xfsgci--

