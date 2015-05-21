Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072AbbEUQFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:05:04 -0400
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seth.forshee@canonical.com" <seth.forshee@canonical.com>,
	"zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>,
	"mricon@kernel.org" <mricon@kernel.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"jlee@suse.de" <jlee@suse.de>, "kyle@kernel.org" <kyle@kernel.org>,
	"gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"mcgrof@suse.com" <mcgrof@suse.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Date: Thu, 21 May 2015 16:03:02 +0000
Message-ID: <1432224181.8004.7.camel@intel.com> (sfid-20150521_180617_646892_E021EFD4)
References: <20150519200232.GM23057@wotan.suse.de>
	 <20150520140426.GB126473@ubuntu-hedt>
	 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
	 <20150520164613.GD10473@localhost> <20150521044104.GH22632@kroah.com>
	 <20150521054101.GA15037@localhost> <20150521061453.GC30864@kroah.com>
	 <1432213521.4230.43.camel@linux.vnet.ibm.com>
	 <20150521154508.GA11821@kroah.com>
In-Reply-To: <20150521154508.GA11821@kroah.com>
Content-Type: multipart/signed; micalg=sha-1;
	protocol="application/x-pkcs7-signature"; boundary="=-zrP8O7wg3+s4rAX1JOMl"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-zrP8O7wg3+s4rAX1JOMl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 08:45 -0700, Greg Kroah-Hartman wrote:
> On Thu, May 21, 2015 at 09:05:21AM -0400, Mimi Zohar wrote:
> > Signatures don't provide any guarantees as to code quality or
> > correctness.   They do provide file integrity and provenance.  In
> > addition to the license and a Signed-off-by line, having the=20
> > firmware provider include a signature of the firmware would be=20
> > nice.
>=20
> That would be "nice", but that's not going to be happening here, from
> what I can tell.  The firmware provider should be putting the signature
> inside the firmware image itself, and verifying it on the device, in
> order to properly "know" that it should be running that firmware.  The
> kernel shouldn't be involved here at all, as Alan pointed out.

In a lot of cases we have loadable firmware precisely to allow us to
reduce the cost of the hardware. Adding cryptographic capability in the
'load firmware' state of the device isn't really compatible with that
:)

In the case where kernel and modules are signed, it *is* useful for a
kernel device driver also to be able to validate that what it's about
to load into a device is authentic. Where 'authentic' will originally
just mean that it's come from the linux-firmware.git repository or the
same entity that built (and signed) the kernel, but actually I *do*
expect vendors who are actively maintaining the firmware images in
linux-firmware.git to start providing detached signatures of their own.

--=20
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-zrP8O7wg3+s4rAX1JOMl
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
kiW8/Nj6KITQvHqz7x/Es0IRJCc9/zBES7yMeD+fgJKHAEv/uTcFfGM9HIWxPQIDAQABo4IC6jCC
AuYwHQYDVR0OBBYEFGK1Mey+kPYGHowHJ0YXtQU4NmbSMB8GA1UdIwQYMBaAFB5pKrTcKP5HGE4h
Cz+8rBEv8Jj1MIHJBgNVHR8EgcEwgb4wgbuggbiggbWGVGh0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDRB
LmNybIZdaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwl
MjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3JsMIHvBggrBgEFBQcBAQSB
4jCB3zBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZp
Y2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3J0MHIG
CCsGAQUFBzAChmZodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRp
ZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjA0QS5jcnQw
CwYDVR0PBAQDAgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OC
kcAJZ4HevTmV8EMCAWQCAQgwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMME8GA1UdEQRIMEagKQYKKwYBBAGC
NxQCA6AbDBlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tgRlkYXZpZC53b29kaG91c2VAaW50ZWwu
Y29tMA0GCSqGSIb3DQEBBQUAA4IBAQBCQ4UH3yybC+PzPo7W4PQJQwIDkKfD2i20i/DosQ7+Yeof
KF7qDASe9eoJGXbINBx1u648uOnaMBsxgUUamJo7pdt1ZnsetRtCQrJIsrsJA3Q2MOsrv7xHkzqn
DF99KHEbO2yKvyjJVDznHUWh8M1OFmdoziyWE/VPdqTwXwS/UKO81XaTtWUDGO716HHVlfT9yPle
Ukg2MTcIhhNWmlS8gDUayhteIAlPci71f/oXzXxBiGiO6FVZUEx+rZBQB84Ey0S0Tfm7hiGzoegg
ra0hfiiMOKMio+n0r4NUn03Z+VRUTbdjHIA6Lkozwpadvs9/uK8dIGqfcgxYgk9qdjFPMYICDjCC
AgoCAQEwgYcweTELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFy
YTEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJh
c2ljIElzc3VpbmcgQ0EgNEECCmJiMmoAAAAATKAwCQYFKw4DAhoFAKBdMBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUyMTE2MDMwMVowIwYJKoZIhvcNAQkEMRYE
FLi7c9BbD2THs3c0Xe4cPjNonY6nMA0GCSqGSIb3DQEBAQUABIIBAK3mwixFGUlb7qd1jOaMQZ5N
o1Q0pzI8OrL64pQmMt97wpImqM/AeldKbKimAoXSllzswMVQ280bDG0T05Z0tKNjOsYJzaIJ3/Xa
xCg7cZBdUxb3CxrALvh252AAihYiIl8lkEWnF6HKOmyBdv7oE1U55urv3UJ67MblE0UH9PTpll/U
7qr++7iDxPmDBwAeDFDNUC75wRhTyr/ROZ+7xWIGBZF2ARzrg25kQvCCtHngpmxUpEFyc5N5Fiuk
rgEhhYzZHCLbSjaypI1yQuCuEaij7HWNErSOr/BgUBlnbv6UJMqbFxoxsXwN188B0dlaW75h+y29
uEeRIPuOQV46/ywAAAAAAAA=


--=-zrP8O7wg3+s4rAX1JOMl--
