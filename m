Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:49676 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab2HWJ23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 05:28:29 -0400
Date: Thu, 23 Aug 2012 11:28:31 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian.chadd@gmail.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: AR9330 hornet board stops beaconing after a few days
 (0xdeadbeef)
Message-ID: <20120823092831.GA25818@pandem0nium> (sfid-20120823_112834_653636_127D1999)
References: <20120813165340.GA10044@pandem0nium>
 <20120819220436.GA9899@pandem0nium>
 <CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com>
 <CAJ-VmokN_2PHZinfE8zfx6-8VZ+KenccymfSs+JFWtDtmjExVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
In-Reply-To: <CAJ-VmokN_2PHZinfE8zfx6-8VZ+KenccymfSs+JFWtDtmjExVg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Adrian,

thanks for your comments!

On Wed, Aug 22, 2012 at 11:57:04AM -0700, Adrian Chadd wrote:
> Yeah. The deadbeef means "something's turned off."
>=20
> I'd start with the SoC reset register and see if the MAC/WMAC bits are
> correctly set. Ie, that something hasn't gone and reset the wireless
> bits behind your back.

Sure, but which register would that be? How can I find out? Is it included
in regdump of ath9k debugfs?

>=20
> You could try hacking up a work around that does a full MAC/WMAC reset
> when you reset the driver.
>=20
> Ie, when ath9k does a full reset, actually _do_ a full reset by
> resetting the mac/wmac via the SoC lines.

So far, I could resolve the situation by doing ifconfig wlan0 down ; ifconf=
ig
wlan0 up. But I don't know if this problem will be triggered much faster
in "more hostile" environments (wherever this comes from).

>=20
> It could also be the RTC state. Maybe it's found its way into network
> sleep (ie, the force wake bits aren't set right.) Or something PLL
> related isn't programmed correctly. Dumping the RTC registers would be
> helpful.


I'm not sure which registers you mean exactly, but I have looked through
the regdump, compared to ath9k's reg.h and annotated it a bit (see below).
As I lack the Chip Specification, maybe some QCA/Atheros dev can help me
on that?

BTW, I've uploaded the full dumps in case anyone is interested [1]. node200
is the broken one, node201 is working at that moment (for comparison).

Thanks,
	Simon

[1] http://packetmixer.de/ar9330_deadbeef/

#### Some PLL stuff:

#define AR_CH0_BB_DPLL1          0x16180
0x016180 0x08400000
#define AR_CH0_BB_DPLL2          0x16184
0x016184 0x18e90f00
#define AR_CH0_BB_DPLL3          0x16188
0x016188 0x00800000
#define AR_CH0_DDR_DPLL2         0x16244
0x016244 0x18e82f01
#define AR_CH0_DDR_DPLL3         0x16248
0x016248 0x008024d0
0x01624c 0xfc4d78b0


#### RTC Registers, annotated:

0x007000 0x00000002
0x007004 0x00000000
0x007008 0x00000000
0x00700c 0x00000001
0x007010 0x00000022
0x007014 0x0000142c
0x007018 0x00000500
0x00701c 0x00000001
0x007020 0x00000000
0x007024 0x00000000
0x007028 0x00000000
0x00702c 0x00000000
0x007030 0x00000002
#define AR_RTC_KEEP_AWAKE       0x7034
0x007034 0x00000002
0x007038 0x000002f8
0x00703c 0x00e04a3d
#define AR_RTC_RESET ((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0040) : 0x7040
#define AR_RTC_RESET_EN         (0x00000001)
0x007040 0x00000001
#define AR_RTC_STATUS  ((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0044) : 0x704=
4)
#define AR_RTC_STATUS_M ((AR_SREV_9100(ah)) ? 0x0000003f : 0x0000000f)
#define AR_RTC_PM_STATUS_M      0x0000000f
#define AR_RTC_STATUS_SHUTDOWN  0x00000001
#define AR_RTC_STATUS_ON        0x00000002
#define AR_RTC_STATUS_SLEEP     0x00000004
#define AR_RTC_STATUS_WAKEUP    0x00000008
0x007044 0x00000002
 --> so RTC Status is "on"?

#define AR_RTC_SLEEP_CLK ((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0048) : 0x7=
048)
#define AR_RTC_FORCE_DERIVED_CLK    0x2
#define AR_RTC_FORCE_SWREG_PRD      0x00000004

0x007048 0x00000002

#define AR_RTC_FORCE_WAKE ((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x004c) : 0x=
704c)
#define AR_RTC_FORCE_WAKE_EN        0x00000001
#define AR_RTC_FORCE_WAKE_ON_INT    0x00000002
0x00704c 0x00000003

 --> both on, looks good?

#define AR_RTC_INTR_CAUSE ((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0050) : 0x=
7050)
0x007050 0x00000000
#define AR_RTC_INTR_ENABLE ((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0054) : 0=
x7054)
0x007054 0x00000000
#define AR_RTC_INTR_MASK ((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0058) : 0x7=
058)
0x007058 0x00000000


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlA1978ACgkQrzg/fFk7axbfggCeITM4FFLJNKeun7SK453WpFYs
5MYAoKiTtHMKzyLA7XGaNT0fxrel+GG0
=1ToI
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
