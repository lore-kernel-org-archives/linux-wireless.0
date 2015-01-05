Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep17.mx.upcmail.net ([62.179.121.37]:40035 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbbAEXxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 18:53:43 -0500
Message-ID: <54AB2405.3050602@think.ch> (sfid-20150106_005346_749038_B4535AF5)
Date: Tue, 06 Jan 2015 00:53:41 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 driver and WEP (solved)
References: <54AA5438.9070902@think.ch> <54AAFFB1.8030109@lwfinger.net>
In-Reply-To: <54AAFFB1.8030109@lwfinger.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090605000500070805050900"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090605000500070805050900
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Larry

Am 05.01.2015 um 22:18 schrieb Larry Finger:
> On 01/05/2015 03:07 AM, Erich Titl wrote:
=2E..
>=20
> I then generated a 3.10.63 kernel, rebooted and retested. It also works=
=2E
>=20
> One thing would be to try disabling hardware encryption using option
> "nohwcrypt=3D1". You might also check to determine what key slot your A=
P
> is expecting to use. My AP has only a single key setup. It calls it #1
> while Linux is using #0, but that is expected.

Thanks a lot for coming back on this issue. I have been digging into the
code and found the culprit tonight. The arc4 module was not loaded and
WEP could not be initialized. The puzzling thing is, the outgoing dhcp
packet passed.... weird.

Thanks again

Erich




--------------ms090605000500070805050900
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
swLJ0YFfirZMmWjyAAAAAAAA
--------------ms090605000500070805050900--
