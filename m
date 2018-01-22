Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.uni-rostock.de ([139.30.22.72]:54226 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751085AbeAVO61 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 09:58:27 -0500
Subject: Re: [PATCH v3 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
 <44644db1-58a4-4b6e-a77e-37c72ee2e4a6@MAIL2.uni-rostock.de>
 <1516018121.410.13.camel@sipsolutions.net>
 <3c846ba5-a017-1993-79c6-2e33d78dfcf4@uni-rostock.de>
 <1516627453.2508.31.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <c7e28f9c-db3a-acb0-660d-9c0e2958bf3a@uni-rostock.de> (sfid-20180122_155830_581352_F4F6219E)
Date: Mon, 22 Jan 2018 15:58:24 +0100
MIME-Version: 1.0
In-Reply-To: <1516627453.2508.31.camel@sipsolutions.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
        micalg=sha-256; boundary="------------ms030308000602000406030502"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------ms030308000602000406030502
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Am 22.01.2018 um 14:24 schrieb Johannes Berg:
> On Mon, 2018-01-15 at 15:28 +0100, Benjamin Beichler wrote:
>> Am 15.01.2018 um 13:08 schrieb Johannes Berg:
>>> On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
>>>>  Change the dump iteration to be independent from
>>>> increasing radio indices on radio list.
>>> You can't do that, data structures can be deleted while the dump is
>>> ongoing.
>> That's what I try to address with this patch. In the past there were
>> corner cases, which might have failed while deletion.
> Hah, ok.
>
>> Nonetheless, the radio count is in the current version strictly
>> monotonic, maybe the description is misleading. :-)
>> So in the inner loop there is no deletion possible because of the
>> spinlock, and multiple calls of nl_dump check the generation count and=

>> cancel if it have changed.
> Ah, I missed that you cancel when it's changed, we don't usually do
> that normally.
>
> I'd still prefer if you could have the code not rely on the pointers,
> because if somebody gets it wrong (forgets to update the generation
> count) I'm not sure I want that to crash in some corner cases...
Mkay, I saw the same pattern in other parts of the kernel, that's why I
adopted it. Then I restore the magic with searching the next radio id
bigger then the last one. Since on my machine, It needs several hundreds
of radios for a full message to cause interruptions, I think the code is
really rarely used and should be fail safe :-)


> johannes
>

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



--------------ms030308000602000406030502
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
D/kwggTVMIIDvaADAgECAghQTsb1PRG0ZDANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJE
RTEcMBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRy
dXN0IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQw
NzIyMTIwODI2WhcNMTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZO
LVZlcmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xv
YmFsIC0gRzAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTD
llA1PWLpbkztlNcAW5UidNQg6zSP1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1
OXstkEXQ7aAAeny/Sg4bAMOG6VwrMRF7DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8B
r3QPwQmi9mvOvdPNFDBP9eXjpMhim4IaAycwDQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9
bzOz2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO72uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSa
cXXFbOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQABo4IBhjCCAYIwDgYDVR0PAQH/BAQD
AgEGMB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAfBgNVHSMEGDAWgBQxw3kbuvVT
1xfgiXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMGIGA1UdIARbMFkwEQYPKwYBBAGB
rSGCLAEBBAICMBEGDysGAQQBga0hgiwBAQQDADARBg8rBgEEAYGtIYIsAQEEAwEwDwYNKwYB
BAGBrSGCLAEBBDANBgsrBgEEAYGtIYIsHjA+BgNVHR8ENzA1MDOgMaAvhi1odHRwOi8vcGtp
MDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweAYIKwYBBQUHAQEEbDBqMCwG
CCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA6BggrBgEFBQcw
AoYuaHR0cDovL3BraTAzMzYudGVsZXNlYy5kZS9jcnQvRFRfUk9PVF9DQV8yLmNlcjANBgkq
hkiG9w0BAQsFAAOCAQEAYyAo/ZwhhnK+OUZZOTIlvKkBmw3Myn1BnIZtCm4ssxNZdbEzkhth
Jxb/w7LVNYL7hCoBSb1mu2YvssIGXW4/buMBWlvKQ2NclbbhMacf1QdfTeZlgk4y+cN8ekvN
TVx07iHydQLsUj7SyWrTkCNuSWc1vn9NVqTszC/Pt6GXqHI+ybxA1lqkCD3WvILDt7cyjrEs
jmpttzUCGc/1OURYY6ckABCwu/xOr24vOLulV0k/2G5QbyyXltwdRpplic+uzPLl2Z9Tsz6h
L5Kp2AvGhB8Exuse6J99tXulAvEkxSRjETTMWpMgKnmIOiVCkKllO3yG0xIVIyn8LNrMOVtU
FzCCBWEwggRJoAMCAQICBxeQYQtLfuwwDQYJKoZIhvcNAQELBQAwWjELMAkGA1UEBhMCREUx
EzARBgNVBAoTCkRGTi1WZXJlaW4xEDAOBgNVBAsTB0RGTi1QS0kxJDAiBgNVBAMTG0RGTi1W
ZXJlaW4gUENBIEdsb2JhbCAtIEcwMTAeFw0xNDA1MTIxNTA2MzVaFw0xOTA3MDkyMzU5MDBa
MIGFMQswCQYDVQQGEwJERTEdMBsGA1UEChMUVW5pdmVyc2l0YWV0IFJvc3RvY2sxFjAUBgNV
BAsTDVJlY2hlbnplbnRydW0xHTAbBgNVBAMTFFVuaSBSb3N0b2NrIENBIC0gRzAyMSAwHgYJ
KoZIhvcNAQkBFhFjYUB1bmktcm9zdG9jay5kZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAKMzLcQy67mVXsTVKZnBwJcZ/9QsaaCz1TCp6J3pCMhImfsq07Xq8qOQJRYqqOuY
TxTjNkCuimsXXGAjCC6wDJpfihtOW56Rp+OP7UrDIynmWWqoiybw82/I9V0Qo33oE9ZXv4nc
1udtH/jeSptioarAgZWneyZIzqOHGbWG2CZ+HFVQM9zANtKPuligQdR1Ojn4CjHPfzf20s3i
igmZyJ1nJt3YltdeB3417GYA1wnFWcQOQpdCkcaucqZ8QWoe6COociQxQ7IuSQraQJBfgL5z
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
ggIjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE4MDEyMjE0
NTgyNFowLwYJKoZIhvcNAQkEMSIEIKUYDSkFkoUAzvcAWr4zLS3EDmewP2+zt8PcvVoh7eDG
MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0D
BzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwIC
ASgwgaIGCSsGAQQBgjcQBDGBlDCBkTCBhTELMAkGA1UEBhMCREUxHTAbBgNVBAoTFFVuaXZl
cnNpdGFldCBSb3N0b2NrMRYwFAYDVQQLEw1SZWNoZW56ZW50cnVtMR0wGwYDVQQDExRVbmkg
Um9zdG9jayBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRY2FAdW5pLXJvc3RvY2suZGUCBxm/
BrxSSRowgaQGCyqGSIb3DQEJEAILMYGUoIGRMIGFMQswCQYDVQQGEwJERTEdMBsGA1UEChMU
VW5pdmVyc2l0YWV0IFJvc3RvY2sxFjAUBgNVBAsTDVJlY2hlbnplbnRydW0xHTAbBgNVBAMT
FFVuaSBSb3N0b2NrIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFjYUB1bmktcm9zdG9jay5k
ZQIHGb8GvFJJGjANBgkqhkiG9w0BAQEFAASCAQBN/BEbxolqmXrDo+NKx9KCq3szl9DlkOel
yvdUgxTBheeBPCH+KllQGw8AKuE9JoNTMwOsFsj0l0w3f5fh6LlFJ41rAfwbdKZyiRp2nPPI
6lG/DxwCL12VgTtLuhNt9q3uTOHCfkIh6Ff3QCchDm1RcsQdQi7vsT8dIpzpyshbcQIMYLhH
h4Zf7IIfsrsYJ8M5SObICwLB9zRMoVDf3l5SnsjaB6yP6HCfd9mvenab0qCGOpjA0L123uwU
TH773Aq52SRYGCT0NkhUocmBrMsv/nmgT8o8pu2e5mT3V8sLPZz0pgxkRSA3ZSYEuIrZ2i/R
lBnXTjvzlxTeiC7f2BUyAAAAAAAA
--------------ms030308000602000406030502--
