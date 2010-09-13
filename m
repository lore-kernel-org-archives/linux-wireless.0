Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay01-haj2.antispameurope.com ([83.246.65.51]:54909 "EHLO
	relay01-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072Ab0IMRSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 13:18:08 -0400
MIME-Version: 1.0
Subject: AW: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
Date: Mon, 13 Sep 2010 19:11:23 +0200
Content-Type: multipart/signed;
	boundary="----=_NextPart_000_010A_01CB5377.7431DE70";
	protocol="application/x-pkcs7-signature";
	micalg=SHA1
Message-ID: <804B13F8F3D94A4AB18B9B01ACB68FA103AB02D1@EXCHSRV.fokus.fraunhofer.de>
In-Reply-To: <20100727172020.GE8293@tux>
References: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de> <20100727172020.GE8293@tux>
From: "Simsek, Burak" <burak.simsek@fokus.fraunhofer.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_010A_01CB5377.7431DE70
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dear Luis,

we are moving your patch to the latest version whenever we have the time =
to
do so... You had sent us two patch files:

http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21=
.pa
tch
http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/iw-add-wo=
w.p
atch


The first one is successfully accomplished, but we have problems with =
the
second one. I am giving a summary of the errors that we get below. There =
are
files and variables defined in that patch that we cannot find anywhere =
and
do not know what they should do. Can you please provide us with some =
hints
regarding those errors?

best regards

Burak=20

=91NL_CB_CUSTOM=92 undeclared (first use in this function)	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 159
C/C++ Problem
=91NL_CB_VALID=92 undeclared (first use in this function)	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 159
C/C++ Problem
=91NL_OK=92 undeclared (first use in this function)	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 137
C/C++ Problem
=91NL_SKIP=92 undeclared (first use in this function)	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 129
C/C++ Problem
=91stderr=92 undeclared (first use in this function)	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 79	C/C++
Problem
errno.h: No such file or directory	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 21	C/C++
Problem
expected =91)=92 before =91(=92 token	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 162
C/C++ Problem
expected =91)=92 before string constant	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 95	C/C++
Problem
implicit declaration of function =91fprintf=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 79	C/C++
Problem
implicit declaration of function =91genlmsg_attrdata=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 123
C/C++ Problem
implicit declaration of function =91genlmsg_attrlen=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 124
C/C++ Problem
implicit declaration of function =91nl_cb_set=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 159
C/C++ Problem
implicit declaration of function =91nla_get_u32=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 132
C/C++ Problem
implicit declaration of function =91nla_parse=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 123
C/C++ Problem
implicit declaration of function =91NLA_PUT_U32=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 89	C/C++
Problem
implicit declaration of function =91nlmsg_data=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 119
C/C++ Problem
implicit declaration of function =91printf=92	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 128
C/C++ Problem
iw.h: No such file or directory	wow.c
/wireless-testing/drivers/net/wireless/ath/ath9k	line 32	C/C++
Problem



-----Urspr=FCngliche Nachricht-----
Von: Luis R. Rodriguez [mailto:lrodriguez@atheros.com]=20
Gesendet: Dienstag, 27. Juli 2010 19:20
An: Simsek, Burak
Cc: Luis Rodriguez; linux-wireless@vger.kernel.org
Betreff: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support

On Tue, Jul 27, 2010 at 08:12:10AM -0700, Simsek, Burak wrote:
> Dear Luis,
>
> I have found out that you have worked on WoW for ath9k for a while.=20
> However, in the wiki page of wireless.kernel.org the current state is=20
> written as ongoing work. Can you please tell me whether you were=20
> successful while implementing WoW. Is there anything that we could =
use?

WoW worked for me but inconsistantly and at the time of writing the =
patches
I had to do quite a lot of coordination with Johannes since he had a lot =
of
API changes and his changes needed to get merged first.

I also found quite a few issues in mac80211 back then but I believe we =
have
resolved all of them by now so I would expect that if the same WoW-only
patches to be rebased and tested we may get better results.

I stopped working on the WoW stuff due to lack of time to keep testing =
them
but the last series can be edited to remove all of the already merged =
stuff
and test out the new stuff. The more challenging thing for me was to
actually get a WoW enabled
802.11 card, these are not as popular as you would hope. The EEPROM =
would be
modified when WoW is enabled but WoW requires some actual hardware =
mucking
to allow for the PCI Wake signal which is typically blocked off. If the
EEPROM has WoW enabled then the hardware mucking would have been done.

To test WoW you also need to drop Network Manager and use the supplicant
directly so that during suspend you remain associated. I should note =
that
WoW will only work on non-WPA networks with ath9k due to the lack of
hardware CPU, during suspend there is only power for the
802.11 hardware, the CPU on your box would be asleep but would be =
required
for group key changes. The way I was thinking of doing this was to only
enable WoW through cfg80211 for ath9k if and only if you are associated =
and
you are connected to a non WPA network.

WoW would work with encryption on our USB devices where there is a CPU
though.

You can find my last series here:

http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21=
.pa
tch
http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/iw-add-wo=
w.p
atch

If you manage to do what I noted above, get an actual WoW enabled card, =
and
it works reliably I'd gladly welcome and ACK the patches :)

  Luis

------=_NextPart_000_010A_01CB5377.7431DE70
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

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
etU9nPcwdQYDVR0fBG4wbDBqoGigZoYxaHR0cDovL2NybC5wa2kuZnJhdW5ob2Zlci5kZS9maGct
cm9vdC1jYS0yMDA3LmNybIYxaHR0cDovL2NybC5mcmF1bmhvZmVyLXBraS5kZS9maGctcm9vdC1j
YS0yMDA3LmNybDCBkAYIKwYBBQUHAQEEgYMwgYAwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jZXJ0LnBr
aS5mcmF1bmhvZmVyLmRlL2ZoZy1yb290LWNhLTIwMDcuY2VyMD4GCCsGAQUFBzAChjJodHRwOi8v
Y2VydC5mcmF1bmhvZmVyLXBraS5kZS9maGctcm9vdC1jYS0yMDA3LmNlcjANBgkqhkiG9w0BAQUF
AAOCAQEAAHdsjDP57lcEJcrLiDnmTkykzsKWSxmGTbhEV8KVqRA37DBVMV/1nrW7tWtaoXfseksl
2OFdQs3BQzhhd8AO28iFf+ncgudyPZbmU48vc41LIy2bnA+I3jY2t0BLt/bELGLLhNzE3xRSYK/z
XgBTB1ZJBxsd5VV2/hdyd/vcXlx5P8Af8iCnf0SIjDE0+Pmvq2tjEwrGAHuJICdL89k12BjfLbo4
woLFFG8HyQvcKzogiTDSTNYu7FFalSiKLMFu4eUKVlDbtROEQLAxM+3XqVwmGgCMD6axCJK9HROt
86h4ZjOHoEu4hpgXzUKIVDuoyTljXCfXSManNHP+FlB4PDCCBagwggSQoAMCAQICChDLDkIAAAAA
SmIwDQYJKoZIhvcNAQEFBQAwZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAf
BgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2Vy
IENBIDIwMDcwHhcNMDgxMDE2MTAzMjE0WhcNMTQxMDE1MTAzMjE0WjBaMQswCQYDVQQGEwJERTET
MBEGA1UEChMKRnJhdW5ob2ZlcjEOMAwGA1UECxMFRk9LVVMxDzANBgNVBAsTBlBlb3BsZTEVMBMG
A1UEAxMMQnVyYWsgU2ltc2VrMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4/j8Cq0T
LI1gTUMObyoy0q5Z53qQ7rMz2Z5EEmIRrlXXY8kPjmlICf02zX6vskC/s3lUbnp+YxrQDmLFWzmk
b4g7lrwECjYQXm4N6bA4mfTYEWbaugII0H/9Fl5ix1hZhdOLwDqQ66TED5yc3KemV6sQ9rlLrmO8
nErzq45qQdC1irmT+WzWUty4cfZ63cet4+ZAm3dRBBJB5dYyNDOKfypJEXRrUeb79OkGy0UrcL4S
8eu6dr+Y1LbJWuJBfyeTQIacYXgcvSHDn6eI4/ApcMI+WFFnLcIXoONZJTVp6S1GlkqoMk3gS7no
mQk0Ne/W3xwFWLG/uTbGM6uNMpzYTQIDAQABo4ICYTCCAl0wDgYDVR0PAQH/BAQDAgbAMCsGA1Ud
EQQkMCKBIGJ1cmFrLnNpbXNla0Bmb2t1cy5mcmF1bmhvZmVyLmRlMB0GA1UdDgQWBBSP/XQQ8rB8
HBO8RjXkd12B6unhMjAfBgNVHSMEGDAWgBRPHa+Iym24qhwJ+cXREe1ZtJP6CzB1BgNVHR8EbjBs
MGqgaKBmhjFodHRwOi8vY3JsLnBraS5mcmF1bmhvZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY3Js
hjFodHRwOi8vY3JsLmZyYXVuaG9mZXItcGtpLmRlL2ZoZy11c2VyLWNhLTIwMDcuY3JsMIIBCgYI
KwYBBQUHAQEEgf0wgfowPgYIKwYBBQUHMAKGMmh0dHA6Ly9jZXJ0LnBraS5mcmF1bmhvZmVyLmRl
L2ZoZy11c2VyLWNhLTIwMDcuY2VyMD4GCCsGAQUFBzAChjJodHRwOi8vY2VydC5mcmF1bmhvZmVy
LXBraS5kZS9maGctdXNlci1jYS0yMDA3LmNlcjA7BggrBgEFBQcwAYYvaHR0cDovL2ZoZy11c2Vy
LWNhLTIwMDcub2NzcC5wa2kuZnJhdW5ob2Zlci5kZS8wOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGct
dXNlci1jYS0yMDA3Lm9jc3AuZnJhdW5ob2Zlci1wa2kuZGUvMBMGA1UdJQQMMAoGCCsGAQUFBwME
MEQGA1UdIAQ9MDswOQYLKwYBBAGGClADAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5mcmF1
bmhvZmVyLmRlL2NwLzANBgkqhkiG9w0BAQUFAAOCAQEAG6FTr4/gKhN47dFYahdJvJbnpXPN+p3k
t/L7uj3NZkBhVng/DTed+GLXi2q0dYkFg9OSnaOXBvnqyQ/WzRrwnlnubOvbwIDXdmv4h+zwvKov
RWDOUXYfD+5x7kb2kb0bdvx/cgpeMws66Lht0T35wd1fiwG1TUu6Gt/CWMsq09ktUZTNAfOhFBrQ
o92qTntB3n6BwBfFz+MDChdi/vTM3uGrEcUVH9Q2PNIqn1siq6SRCoUfZPRt/d+1bO/bb5r0QnYC
Xc1s/+haKPxaE355vF8c44JIAoNITit6vd8xcamLPuOhBH5E66oeOFHTp6f6Nz02ura4nQxOjak1
ef2/IDCCBbQwggScoAMCAQICChDLC3MAAAAASmEwDQYJKoZIhvcNAQEFBQAwZzELMAkGA1UEBhMC
REUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBL
STEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcwHhcNMDgxMDE2MTAzMjEzWhcNMTQx
MDE1MTAzMjEzWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEOMAwGA1UECxMF
Rk9LVVMxDzANBgNVBAsTBlBlb3BsZTEVMBMGA1UEAxMMQnVyYWsgU2ltc2VrMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxugMz/DdOl8MAyli8vlMXUxof8/7XqhJaIUUoRQbR/DbszqZ
VMlD2tRiWWpNA3LTr0sVPyhjDU7e/7LmICLYKqeYAggE54ehQZUIrsjTr2MCEnnfX0Zp4w0Gu8yw
CfdjSSXk2EpUJbTkCRQNB1qq+wbACnJ4f5b0efMn4qCCaqFMLNDokY6sEa++cEkn8MpS2Ja4PzE4
e9v3k5Yp/UxAri9oCvwPAWY4x/P9aeTsulamD8WD7A2F38IXuUXD76tVraM/b4aqvHPmbeB1N1Sp
V/Gs1O4eehQAfacSpn98MFQ4zs/QOiKcmYwTVDYMihBJKCW8LcgeyaNnsn1TFWaW5QIDAQABo4IC
bTCCAmkwDgYDVR0PAQH/BAQDAgQwMCsGA1UdEQQkMCKBIGJ1cmFrLnNpbXNla0Bmb2t1cy5mcmF1
bmhvZmVyLmRlMB0GA1UdDgQWBBT3SwHoDf+d70rz2OH6u6WkOzB1cDAfBgNVHSMEGDAWgBRPHa+I
ym24qhwJ+cXREe1ZtJP6CzB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8vY3JsLnBraS5mcmF1bmhv
ZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY3JshjFodHRwOi8vY3JsLmZyYXVuaG9mZXItcGtpLmRl
L2ZoZy11c2VyLWNhLTIwMDcuY3JsMIIBCgYIKwYBBQUHAQEEgf0wgfowPgYIKwYBBQUHMAKGMmh0
dHA6Ly9jZXJ0LnBraS5mcmF1bmhvZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY2VyMD4GCCsGAQUF
BzAChjJodHRwOi8vY2VydC5mcmF1bmhvZmVyLXBraS5kZS9maGctdXNlci1jYS0yMDA3LmNlcjA7
BggrBgEFBQcwAYYvaHR0cDovL2ZoZy11c2VyLWNhLTIwMDcub2NzcC5wa2kuZnJhdW5ob2Zlci5k
ZS8wOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3Lm9jc3AuZnJhdW5ob2Zlci1w
a2kuZGUvMB8GA1UdJQQYMBYGCisGAQQBgjcKAwQGCCsGAQUFBwMEMEQGA1UdIAQ9MDswOQYLKwYB
BAGGClADAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5mcmF1bmhvZmVyLmRlL2NwLzANBgkq
hkiG9w0BAQUFAAOCAQEAgOFdC0c38/nirLUIOLHYFLnguuEawTbuXvXeYcaSiK0xESYSd4YuU+8p
oD6CnF6qnKHkKiJ0mcAo+Rdxd5YVKXgrheIwGxwRcEQgzKMXqf5jyQY5msEcze7/zL2I8mp2q2sv
EAZbs+Ji9DdvLss3eiqlyacNhy+1ldLCqH9lLSBa6YLvpJxytNo+xj6Qf3xaAtCBZ/0MFeq5xTtQ
h+A8X1YqWSEiDoyYsydc199UBFp/rOB9IuNv3zG1pDmDBEaVLnCDZ72oXWTPwB1fcidvguR1JyDL
HB/gVGxB/MhtiFW5fpp/h4KmJpT2jHnGyAf771qGbGKFKZRBMstANb5pbTGCA2owggNmAgEBMHUw
ZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIg
Q29ycG9yYXRlIFBLSTEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCChDLDkIAAAAA
SmIwCQYFKw4DAhoFAKCCAcowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTAwOTEzMTcxMTIyWjAjBgkqhkiG9w0BCQQxFgQUFlDhf6Cvx2PR+8ZsnLAuzSOry4IwWwYJ
KoZIhvcNAQkPMU4wTDAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAw
BwYFKw4DAgcwDQYIKoZIhvcNAwICASgwBwYFKw4DAhowgYQGCSsGAQQBgjcQBDF3MHUwZzELMAkG
A1UEBhMCREUxEzARBgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9y
YXRlIFBLSTEgMB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCChDLC3MAAAAASmEwgYYG
CyqGSIb3DQEJEAILMXegdTBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEhMB8G
A1UECxMYRnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVyIFVzZXIg
Q0EgMjAwNwIKEMsLcwAAAABKYTANBgkqhkiG9w0BAQEFAASCAQAsFwwvdLHgkRCEyAoJh+DSO3zk
kPt4zvTBqtTbLoQuR5JMtSbEaUufLzcsOToKUsVrMZwhHsCFgNct9Cnu1wJNavsoHErMKnmNViWv
hi0MaX597GAa47dCY0sx4XbUSO5kBR1VzV8HRCT9AhfP6v93bda8Q38jpG1AAqQXuqMZPr8i75Tf
fUPxfFU6oIcIr9Ig+6NqZp453q898MR7i2duUex3uAHt+vSFqPcOejtZNzuJBFOgTTCAEoFuwA5v
SVhkTnf3L9gZvhaRWZa6AdR26Uz6c78I3NOTYJ9+4PKSt/1ehz8cgg+0YFhDKcyPTs8yf7PZEdq8
v7RqKLwDeoeEAAAAAAAA

------=_NextPart_000_010A_01CB5377.7431DE70--
