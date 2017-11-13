Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:25282 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdKMJYk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:24:40 -0500
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
        micalg=sha-256; boundary="------------ms030101050605000402050409"
Subject: Re: [PATCH v2 3/4] cfg80211: reg: remove support for built-in regdb
To: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>
References: <20171009095018.5289-1-johannes@sipsolutions.net>
 <20171009095018.5289-4-johannes@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <5392a1bb-378c-17c6-de0d-862e86041c2e@uni-rostock.de> (sfid-20171113_102644_934511_9C2ED721)
Date: Mon, 13 Nov 2017 10:19:18 +0100
MIME-Version: 1.0
In-Reply-To: <20171009095018.5289-4-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------ms030101050605000402050409
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: de-DE

Hi Johannes,

Am 09.10.2017 um 11:50 schrieb Johannes Berg:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Parsing and building C structures from a regdb is no longer needed
> since the "firmware" file (regulatory.db) can be linked into the
> kernel image to achieve the same effect.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  Documentation/networking/regulatory.txt |  22 +----
>  net/wireless/Kconfig                    |  24 +----
>  net/wireless/Makefile                   |   6 --
>  net/wireless/db.txt                     |  17 ----
>  net/wireless/genregdb.awk               | 158 ------------------------=
--------
>  net/wireless/reg.c                      |  39 --------
>  net/wireless/regdb.h                    |  23 -----
>  7 files changed, 3 insertions(+), 286 deletions(-)
>  delete mode 100644 net/wireless/db.txt
>  delete mode 100644 net/wireless/genregdb.awk
>  delete mode 100644 net/wireless/regdb.h
>
> diff --git a/Documentation/networking/regulatory.txt b/Documentation/ne=
tworking/regulatory.txt
> index 46c8d8b1cc66..381e5b23d61d 100644
> --- a/Documentation/networking/regulatory.txt
> +++ b/Documentation/networking/regulatory.txt
> @@ -200,23 +200,5 @@ Then in some part of your code after your wiphy ha=
s been registered:
>  Statically compiled regulatory database
>  ---------------------------------------
> =20
> -In most situations the userland solution using CRDA as described
> -above is the preferred solution.  However in some cases a set of
> -rules built into the kernel itself may be desirable.  To account
> -for this situation, a configuration option has been provided
> -(i.e. CONFIG_CFG80211_INTERNAL_REGDB).  With this option enabled,
> -the wireless database information contained in net/wireless/db.txt is
> -used to generate a data structure encoded in net/wireless/regdb.c.
> -That option also enables code in net/wireless/reg.c which queries
> -the data in regdb.c as an alternative to using CRDA.
> -
> -The file net/wireless/db.txt should be kept up-to-date with the db.txt=

> -file available in the git repository here:
> -
> -    git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-re=
gdb.git
> -
> -Again, most users in most situations should be using the CRDA package
> -provided with their distribution, and in most other situations users
> -should be building and using CRDA on their own rather than using
> -this option.  If you are not absolutely sure that you should be using
> -CONFIG_CFG80211_INTERNAL_REGDB then _DO_NOT_USE_IT_.
> +When a database should be fixed into the kernel, it can be provided as=
 a
> +firmware file at build time that is then linked into the kernel.
>

Is there already an example regulatory.db file available? And is there
already a tool chain for creating the new format? I don't see any
corresponding commit on
https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.g=
it/
for your change. Or can I simply use the regulartory.bin as firmware file=
?


--------------ms030101050605000402050409
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
ggIjMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE3MTExMzA5
MTkxOFowLwYJKoZIhvcNAQkEMSIEIKtbyrsaXiU4Tt08E3+w+111AlWw5Uo2x+0rbPFlS5Ve
MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0D
BzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwIC
ASgwgaIGCSsGAQQBgjcQBDGBlDCBkTCBhTELMAkGA1UEBhMCREUxHTAbBgNVBAoTFFVuaXZl
cnNpdGFldCBSb3N0b2NrMRYwFAYDVQQLEw1SZWNoZW56ZW50cnVtMR0wGwYDVQQDExRVbmkg
Um9zdG9jayBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRY2FAdW5pLXJvc3RvY2suZGUCBxm/
BrxSSRowgaQGCyqGSIb3DQEJEAILMYGUoIGRMIGFMQswCQYDVQQGEwJERTEdMBsGA1UEChMU
VW5pdmVyc2l0YWV0IFJvc3RvY2sxFjAUBgNVBAsTDVJlY2hlbnplbnRydW0xHTAbBgNVBAMT
FFVuaSBSb3N0b2NrIENBIC0gRzAyMSAwHgYJKoZIhvcNAQkBFhFjYUB1bmktcm9zdG9jay5k
ZQIHGb8GvFJJGjANBgkqhkiG9w0BAQEFAASCAQCVh95GvdjsNd2t7icVA7RjDEYoJ5HO7hyY
OTrQXZXE2ugzLSfeYdIeUBLaodndG/4VJZNwT+9wgCSCcS5F5JrQofwmogeFz3lrtSpkR/Rf
Ds7XA6WTm8YQlEbC5YqVhHFIQKwD4EQv08zO2f8QdPnsJncDN2nOKyM0/MoVxrfJj2bm8IC+
LteBwYunSEURFfUxfVIUgjORnBJZYpc3lYSVJbUyN1DFZi0Yq74doZwyfHmX8Q39sgm1pe72
yEqqpfU0obJ6L53N9BK+oKV/9u7Fy8ke2/4yYY2Sbsg9q8VFgQkyjj7hJz1zSWJcQl6qWrox
Ro3+Hca4SWy02aJNTEWlAAAAAAAA
--------------ms030101050605000402050409--
