Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:41843 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3KKJg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 04:36:56 -0500
From: Sven Eckelmann <sven@open-mesh.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [OpenWrt-Devel] [ath9k-devel] ath9k: Deaf QCA9558 when setting rxchainmask
Date: Mon, 11 Nov 2013 10:36:52 +0100
Message-ID: <2985619.kldLYNDlSX@bentobox> (sfid-20131111_103700_461520_24D9F98B)
In-Reply-To: <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
References: <19772470.YgPhAz9cYD@bentobox> <87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de> <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1627114.W7mjhIOlzQ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1627114.W7mjhIOlzQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 08 November 2013 18:33:19 Adrian Chadd wrote:
> Hm, is the 0x5 chainmask triggering the ALT_CHAIN logic?

You are talking about ar9003_phy.c -> ar9003_hw_set_chain_masks? No, the 
device is 3x3 and ah->caps.tx_chainmask & ah->caps.rx_chainmask are 7 and not 
5. The AR_PHY_ANALOG_SWAP := AR_PHY_SWAP_ALT_CHAIN is only done when one of 
them would be 5. But I am not really sure what this register setting is really 
doing. Maybe you can explain it when you think it could be related. Thanks

> What are you trying to do? Control the receive antenna config, or the
> transmit antenna config?

I have a device which is using a QCA9558 3x3 and a AR93XX 3x3 device. Both are 
working fine with the proprietary atheros driver and a 2x2 device as client 
(Intel and Atheros). The used driver is a a binary blob of 9.5.3.15 
(Atheros/multi-bss). But the download rate (AP -> Client) is relative low when 
using ath9k and the QCA9558 for tx. It is quite good when using the AR93XX.

The bad TX seems to be related to the low ewma prop for MCS14/15 in an 1-4.5m 
test (HT20). One idea was to test the different antennas to check whether 
there is some kind of antenna (selection) related problem. Unfortunatelly, 
this test only caused the problem mentioned in this thread.

Kind regards,
	Sven
--nextPart1627114.W7mjhIOlzQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCgAGBQJSgKU0AAoJEF2HCgfBJntGR2gP/1fly2jSpSgsAogVT1mBLz0S
/SD0Axdee/udmyrhAiqnPat+U8eIpC0QrzJF4rwwukTejBEd2wE43qVm6j9k6ZQu
OA66sM0ZxUhtp3PtqXHjgmMNxrNF9LV+o2GRhweQOpEQQwy5L3u5XzzCiQ+vzDbr
mnxbug3hR3SdGGCoiReGytqQ23fVeFKMDl9gnSlfqdonbW5A8ejmF7GhaWLNIDet
HcKXkmHc9hT+HqiBg628GYfZKH1rk7nbNAWMe75mvSHu93TTQ0x6t4bOwQXplbju
ZWZ88qjmceLCCHWJQ+Gk9CwI1r2RKtk/jXplGb21Be+Mg91fvcjqlQ7Evhh1szVt
oy/bwhEQARd/kXTdklUDVVruumeaDnFV3Qg5r2o8xtt5mEEcCwPYEBrGra5tRUOe
lPQnRV4WahDalGZjgA3qXi4oQmSL91STinhg7el/1s2hfgO/q5byao5+TU6jGV0R
4yo4uHSZfY9o975MT607rsr+Db0PZ1Nafs1Hu4LeTeyCov5WBqazOvrjd74YDQxg
Pd/tmO+XvLObmgU9ybyORYtngeut5vR3+gqVistRsG1w8dJN7Q494StmcJBNACrf
TY4R1o373evQaeQyPDQ9a9m2ltT0IV1KomVwkF7Iz7M2vsEWhPYZSAwBUVJUx2dj
I4Rs9vuZCQeM5XnT8xpW
=n37t
-----END PGP SIGNATURE-----

--nextPart1627114.W7mjhIOlzQ--

