Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:37564 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752822AbdCMPtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2017 11:49:21 -0400
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
To: Matthias May <matthias.may@neratec.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jesse Jones <jjones@uniumwifi.com>, <agreen@cococorp.com>,
        <linux-wireless@vger.kernel.org>
References: <58B09082.7020704@cococorp.com>
 <1488202227.28431.9.camel@sipsolutions.net> <58B487A8.7000602@cococorp.com>
 <1488443814.8390.3.camel@sipsolutions.net>
 <d717a94d5c6632b6665b7ac3b319b726@mail.gmail.com>
 <1488803913.5761.11.camel@sipsolutions.net>
 <19214832-030e-2028-49a2-2db087c8c857@neratec.com>
CC: Jesse Jones <jjones@cococorp.com>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <75194465-9f80-04f5-5529-bffa4372b632@uni-rostock.de> (sfid-20170313_165005_246468_F9794198)
Date: Mon, 13 Mar 2017 16:49:14 +0100
MIME-Version: 1.0
In-Reply-To: <19214832-030e-2028-49a2-2db087c8c857@neratec.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
        micalg=sha-256; boundary="------------ms010502090605060207080002"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------ms010502090605060207080002
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 09.03.2017 um 16:49 schrieb Matthias May:
> On 06/03/17 13:38, Johannes Berg wrote:
>>> Well it certainly attempts to via stuff like carrier sense. But that
>>> is not fool proof and any time two routers hear a frame and both
>>> decide to forward it immediately there is a chance that they will
>>> both sense the air at the same time, decide that it is clear, and
>>> lose both their forwarded frames due to a collision. How often that
>>> happens is hard to say but we have observed that exact behavior a few=

>>> years ago with an 802.11 multicast routing protocol and adding jitter=

>>> significantly improved reliability.
>> I'm really surprised by this since they both should jitter their
>> transmissions already between CWmin and CWmax. Is that window somehow =
really super small for what you're doing?
>>
>> johannes
>>
> Isn't CWmin and CWmax only used for retries?
> We recently had the problem that on 5MHz channels probe-responses of AP=
s
> which can't hear each other (hidden node problem) always collide.
> See [1] for a trace showing the problem.
> Yellow is the probe-request (and ack on success), the other colours are=

> 3 APs.
> Putting probe-responses on their own queue with it's own timing results=

> in [2] and seems to make the problem less worse.
> However the first frame still always collides, and only subsequent
> retries have the randomness of cwmin/cwmax added.
> 5MHz channels make the problem worse since frames are 4 times longer.
>
> I'm currently trying to find a way to add some randomness to the initia=
l
> response, which it seems this patchset attempts to solve as well
> (different context though).
>
> [1] http://may.nu/images/problem.png
> [2] http://may.nu/images/jittered.png
How do you measure this signals ? Maybe the first choose of in the
contention window is the same for all nodes caused by simulation, or so
=2E.. In general the chance for choosing all nodes the same waiting value=

is 1/16 * n (for best effort). So for 3 nodes it seems unlikely.

But from first look on your pictures, CW seems to work, since the cyan
AP is slightly earlier then magenta and green one, which may the
distance of some slot times. But of course for hidden stations this (at
best) 16 slot times (which may be only 5 to 8 slot times in average) are
much shorter than the actual probe response air time. Would they have
proper carrier sense they would not collide. The jitter of path request
are also only a bit of more gambling, which may help ... at this point
the client should probe a smaller set of APs a time, but the APs cannot
change their behavior ...

But the actual patch fro PREPs have another goal. Since they could only
collide, if multiple routes to destination exists, it might help to
spread the a bit. But from what I see, every PREP is jittered. Maybe the
first PREP should not be artificially delayed, but all following PREPs
of this specific PREQ (which mostly only contain redundant routes,
without a better ALM).

kind regards

--=20
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrote=
chnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/



--------------ms010502090605060207080002
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
81Vs95cUAdtV/Oj7ywXmMkcerQ8egitlHVQh/jwG6EbsFLab9erzbPDs7VHsmusCAwEAAaOC
Af4wggH6MBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0PAQH/BAQDAgEGMBEGA1UdIAQKMAgw
BgYEVR0gADAdBgNVHQ4EFgQUsxX1olePg3vUENNc8o4+U/dvQzcwHwYDVR0jBBgwFoAUSbfG
z+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERY2FAdW5pLXJvc3RvY2suZGUwgYgGA1Ud
HwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1
Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1y
b290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIHXBggrBgEFBQcBAQSByjCBxzAzBggrBgEFBQcw
AYYnaHR0cDovL29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsGAQUFBzAC
hjtodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNlcnQvY2Fj
ZXJ0LmNydDBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAE8SmQRK1aE9
dqcmXuU9ZPzSN5dd19HgtQuvNAceB1mhearys7UljqQ9Ua3BAtWTthqLGuiy7vr7ul87frgp
JRVozeRyIePOY7R0iKYbmPTbHgj4XHRyc9Z2D6h1Nec8pWQgx4BSqs3xALpio+gBK3UHsi3X
sJx4ZpLTuboRR4+BFTmEwdtsGZf6fPLBapfbS0xls05HvPtrSw6JGWClE1PidPl3M5kiARjd
Ep4HzDr+/IzTx9823poYGnxfCPL1M3Tb6ECugv7mBZiWE90bPzFfv9yEXkX0Pp5ielz/XkCC
MOB+gDgVZbttmM/BSvoeuw+GtuCqqV1g6lc1/JZBNtgwggW3MIIEn6ADAgECAgcZvwa8Ukka
MA0GCSqGSIb3DQEBCwUAMIGFMQswCQYDVQQGEwJERTEdMBsGA1UEChMUVW5pdmVyc2l0YWV0
IFJvc3RvY2sxFjAUBgNVBAsTDVJlY2hlbnplbnRydW0xHTAbBgNVBAMTFFVuaSBSb3N0b2Nr
IENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFjYUB1bmktcm9zdG9jay5kZTAeFw0xNTA3MTAw
ODU4MjFaFw0xODA3MDkwODU4MjFaMFYxCzAJBgNVBAYTAkRFMR0wGwYDVQQKDBRVbml2ZXJz
aXRhZXQgUm9zdG9jazEMMAoGA1UECwwDSUVGMRowGAYDVQQDDBFCZW5qYW1pbiBCZWljaGxl
cjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMP+J5bUv7oCrhYz7tz+vKg/sGwQ
9WHm3j528AX5cEn7Qh92cE/Y31gpimuSVlHN/CyYt/PEQ12Gc83vB8HU3gl0t00PwIElWroW
yeGUBhMzH5Jfv0jkBz5xb/Byv8weXDVHbYvtTZfvWIv6SjDhgjY5puAHw/Z8XpEeksOoBLa6
H7LQDR3O530Jwvay5ZDPFcWV9n01rBoglnAcfIh7v9Ua6A8BhqdZ/Yt0wlOXN94sTklsiCYy
cmyKfhrrJWuJMD8WWAYEa69+mi9QodzHg/b58pzUDTE4QOLUR2jAk27g63yC3Nh/+lZi79gB
e6JfSBieesen0Y2s4DYJG9T207MCAwEAAaOCAlgwggJUMEAGA1UdIAQ5MDcwEQYPKwYBBAGB
rSGCLAEBBAMDMBEGDysGAQQBga0hgiwCAQQDATAPBg0rBgEEAYGtIYIsAQEEMAkGA1UdEwQC
MAAwCwYDVR0PBAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4E
FgQUNBPZS5VyYehPYcxCwh0ss/3r2zswHwYDVR0jBBgwFoAUsxX1olePg3vUENNc8o4+U/dv
QzcwKwYDVR0RBCQwIoEgYmVuamFtaW4uYmVpY2hsZXJAdW5pLXJvc3RvY2suZGUwgY0GA1Ud
HwSBhTCBgjA/oD2gO4Y5aHR0cDovL2NkcDEucGNhLmRmbi5kZS91bmktcm9zdG9jay1jYS9w
dWIvY3JsL2dfY2FjcmwuY3JsMD+gPaA7hjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3VuaS1y
b3N0b2NrLWNhL3B1Yi9jcmwvZ19jYWNybC5jcmwwgdsGCCsGAQUFBwEBBIHOMIHLMDMGCCsG
AQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwSQYIKwYB
BQUHMAKGPWh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdW5pLXJvc3RvY2stY2EvcHViL2NhY2Vy
dC9nX2NhY2VydC5jcnQwSQYIKwYBBQUHMAKGPWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvdW5p
LXJvc3RvY2stY2EvcHViL2NhY2VydC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEB
ADPT0DMfqh3ie0QoV5dpv/ULazwuXoXFAYd3rikdZxxGfhR4/zzrQM9QtH4a1+nR66HnoAJR
6NH76MDmaVY37LO3Jb+WHSbMQfN4ijv2j5Oxc8OnepTp/FY4Vo4qP0TzmW8dtqgJCwWVAcYj
GPrZLG6oubw2aL0DYirEQYMpEh3LEAf2nemCKdLkahdmbvx5AMDcz1XODWLI9PDhGtifFHCA
keel0T9YceFhA1myfawGh3GDD43ltM8i0PZzxaex/mw1ropnQ/wfzs3N6EYOmZNsc6RbRJLi
HEJcraQTzI2bFSuO2Z856KRXMV+jj8c2cJ8xQuVd4ptYFSt1miDSGmwxggPkMIID4AIBATCB
kTCBhTELMAkGA1UEBhMCREUxHTAbBgNVBAoTFFVuaXZlcnNpdGFldCBSb3N0b2NrMRYwFAYD
VQQLEw1SZWNoZW56ZW50cnVtMR0wGwYDVQQDExRVbmkgUm9zdG9jayBDQSAtIEcwMjEgMB4G
CSqGSIb3DQEJARYRY2FAdW5pLXJvc3RvY2suZGUCBxm/BrxSSRowDQYJYIZIAWUDBAIBBQCg
ggIjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE3MDMxMzE1
NDkxNFowLwYJKoZIhvcNAQkEMSIEIE6a1EXMMIxDrirbcjMNjVc/qQbIyS5x0AK9DObUYu0Y
MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0D
BzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwIC
ASgwgaIGCSsGAQQBgjcQBDGBlDCBkTCBhTELMAkGA1UEBhMCREUxHTAbBgNVBAoTFFVuaXZl
cnNpdGFldCBSb3N0b2NrMRYwFAYDVQQLEw1SZWNoZW56ZW50cnVtMR0wGwYDVQQDExRVbmkg
Um9zdG9jayBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRY2FAdW5pLXJvc3RvY2suZGUCBxm/
BrxSSRowgaQGCyqGSIb3DQEJEAILMYGUoIGRMIGFMQswCQYDVQQGEwJERTEdMBsGA1UEChMU
VW5pdmVyc2l0YWV0IFJvc3RvY2sxFjAUBgNVBAsTDVJlY2hlbnplbnRydW0xHTAbBgNVBAMT
FFVuaSBSb3N0b2NrIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFjYUB1bmktcm9zdG9jay5k
ZQIHGb8GvFJJGjANBgkqhkiG9w0BAQEFAASCAQAk3+VQOw9A5PRXk5axiHLojJ1qZUs799mD
jQXyfzlQmV+BoZNQLxML7cJQu56q7EfYMDbRJzYWzUAUWUHA41fXqxDX8LjYAYorWeSG92lG
MnCnpsgb/KqgrtKY3d0oxsibWq2XxXaCwonqtzMJgFjElJHWCpMTbGeGSxI1ngkWkcohR/cN
iVaECkvFCDv8ZEIHaie23xG5i91s9TWo9Eorni6qKpxuTUw0idRirbReFaJ8cQTdX4p+vZmy
A22MPcXvvZIcgMVIa/1BVhcZynoMDqXZ7H/dWSwT8rS5EjFIaaHVi6s4MzmTuxmJznJh3XYF
bbDrdE3ielxidTz9p063AAAAAAAA
--------------ms010502090605060207080002--
