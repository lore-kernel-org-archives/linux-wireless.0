Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [62.179.121.45] ([62.179.121.45]:64263 "EHLO
	fep25.mx.upcmail.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751964AbbAFHDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 02:03:16 -0500
Received: from edge02.upcmail.net ([192.168.13.237])
          by viefep25-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20150106070244.GNST16167.viefep25-int.chello.at@edge02.upcmail.net>
          for <linux-wireless@vger.kernel.org>;
          Tue, 6 Jan 2015 08:02:44 +0100
Received: from [194.124.158.2] (jupiter.think.ch [194.124.158.2])
	(authenticated bits=0)
	by luna.think.ch (8.14.3/8.14.3) with ESMTP id t0672g2T025761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 6 Jan 2015 08:02:43 +0100
Message-ID: <54AB8895.1020301@think.ch> (sfid-20150106_080322_176111_E355C87A)
Date: Tue, 06 Jan 2015 08:02:45 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: b43 driver and WEP (solved)
References: <54AA5438.9070902@think.ch> <54AAFFB1.8030109@lwfinger.net> <54AB2405.3050602@think.ch> <54AB31EB.6020801@lwfinger.net>
In-Reply-To: <54AB31EB.6020801@lwfinger.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000601080506080705060609"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000601080506080705060609
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 06.01.2015 um 01:52 schrieb Larry Finger:
> On 01/05/2015 05:53 PM, Erich Titl wrote:
>> Hi Larry
>>
>> Am 05.01.2015 um 22:18 schrieb Larry Finger:
>>> On 01/05/2015 03:07 AM, Erich Titl wrote:
>> ...
>>>
>>> I then generated a 3.10.63 kernel, rebooted and retested. It also wor=
ks.
>>>
>>> One thing would be to try disabling hardware encryption using option
>>> "nohwcrypt=3D1". You might also check to determine what key slot your=
 AP
>>> is expecting to use. My AP has only a single key setup. It calls it #=
1
>>> while Linux is using #0, but that is expected.
>>
>> Thanks a lot for coming back on this issue. I have been digging into t=
he
>> code and found the culprit tonight. The arc4 module was not loaded and=

>> WEP could not be initialized. The puzzling thing is, the outgoing dhcp=

>> packet passed.... weird.
>=20
> Glad you found it. Strange that loading mac80211 did not force loading.=

> Have you run 'depmod -a' on the modules?

This is an embedded device with quite a small footprint. It does not
have all the drivers by default. Yes, I ran depmod -a, but depmod
produces only one line for arc4, so no luck.

kernel/crypto/arc4.ko.gz:

cheers

Erich


--------------ms000601080506080705060609
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
1GmMP9nPAtGrpglNAAAAAAAA
--------------ms000601080506080705060609--
