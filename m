Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:54963 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2K0MxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 07:53:05 -0500
Message-ID: <50B4B7B6.7020205@think.ch> (sfid-20121127_135310_098519_BF293047)
Date: Tue, 27 Nov 2012 13:53:10 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: regulatory domain settings overwritten
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
In-Reply-To: <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010100000302040903080602"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms010100000302040903080602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Julian

Thank you for the quick reply and the link

on 27.11.2012 10:55, Julian Calaby wrote:
> Hi Erich,
>=20
=2E..


>=20
> It's not being completely overridden and it is working as designed.
>=20
> Firstly, the default country code for all Atheros chips is the USA.
> This is most likely because that's where the company is based.
>=20
> Secondly, your choice, China, is not being overridden. As the card is
> saying that it's configured for the USA, and you're saying that it's
> in China, the regulatory framework is using the intersection of the US
> and Chinese rules to govern it's output, thereby ensuring that the
> operation of the card complies with all the information it has about
> it's location.
>=20
> This has been explained in more detail in this thread:
>=20
> http://www.spinics.net/lists/linux-wireless/msg92420.html
>=20
> If you want to have the complete set of frequencies as specified by
> the Chinese rules, you will need to obtain a card which has been
> configured for Chinese operation.

Actually the country code CH should stand for Switzerland and I am
surprised a default for the US should be hard coded into the driver

        regdmn =3D ath_regd_get_eepromRD(reg);
        reg->country_code =3D ath_regd_get_default_country(regdmn);

        if (reg->country_code =3D=3D CTRY_DEFAULT &&
            regdmn =3D=3D CTRY_DEFAULT) {
                printk(KERN_DEBUG "ath: EEPROM indicates default "
                       "country code should be used\n");
                reg->country_code =3D CTRY_UNITED_STATES;
        }

        if (reg->country_code =3D=3D CTRY_DEFAULT) {
                country =3D NULL;
        } else {
                printk(KERN_DEBUG "ath: doing EEPROM country->regdmn "
                       "map search\n");
                country =3D ath_regd_find_country(reg->country_code);
                if (country =3D=3D NULL) {
                        printk(KERN_DEBUG
                                "ath: no valid country maps found for "
                                "country code: 0x%0x\n",
                                reg->country_code);
                        return -EINVAL;
                } else {
                        regdmn =3D country->regDmnEnum;
                        printk(KERN_DEBUG "ath: country maps to "
                               "regdmn code: 0x%0x\n",
                               regdmn);
                }
        }

Anyway, I am located in Switzerland and I saw similar threads from a few
people on the net. Today's mobile society demands that equipment can be
reconfigured freely to accommodate the local regulatory limits. This can
be achieved at will with an open card, which just gets crippled by the
hard coded limits set here.

So under the worst thinkable circumstances this code won't work for my
environment as, for example, the intersection of the world regdomain and
the US regdomain would AFAIK cut away channels 12 and 13, which are
perfectly legal at my domicile and are used by some AP's.

I could (and will probably have to) recompile the driver using another
regdomain file, but this is not really satisfactory either. IMHO the
regdomain should be chosen as seen fit and not imposed by hard coded
limits in the driver.

Thanks

Erich


--------------ms010100000302040903080602
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIDjTCC
A4kwggJxoAMCAQICAQIwDQYJKoZIhvcNAQELBQAwdTELMAkGA1UEBhMCQ0gxEjAQBgNVBAcT
CVN0YWxsaWtvbjEOMAwGA1UEChMFVEhJTksxEzARBgNVBAsTCkNBIFNlY3Rpb24xETAPBgNV
BAMTCFRoaW5rIENBMRowGAYJKoZIhvcNAQkBFgtjYUB0aGluay5jaDAeFw0xMDEyMDcxMDA1
MTFaFw0xNTEyMDYxMDA1MTFaMH8xCzAJBgNVBAYTAkNIMRIwEAYDVQQHEwlTdGFsbGlrb24x
DjAMBgNVBAoTBVRISU5LMRMwEQYDVQQLEwpDQSBTZWN0aW9uMRMwEQYDVQQDEwpFcmljaCBU
aXRsMSIwIAYJKoZIhvcNAQkBFhNlcmljaC50aXRsQHRoaW5rLmNoMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAzIkWAOGsN6MJyoPDiquf88muXKonJwQUE7wcf8SZ7tBZKHCy
RMt+zdv28XI3Lvofgp3er67FvlSmJsTEUr2f/WX9hihspdsvVIoAkYiY57lHIGKBwxb2qRt5
ve191qP4lo1MLCkDZeKIxTbNIcebwzuK7qsU3LH+als/JVnPViZs7pk3oXOOP8vAC9tU0o+t
8WOMREMAQ0hlePxzc5RUjrv+UNuBGAt95r/ui9c8hvLaGzNMhKNQSaqJ71eOR4Urwt+IvYWH
q6Lt3iqnvT3oN5kAOrFYzAaPiVa9VyYiky8tQkeBrzyP/OIlPQXLUMMlfhQtfZnIWCqlj4+s
wBz1VwIDAQABoxowGDAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DANBgkqhkiG9w0BAQsFAAOC
AQEADxFUuWY9WMAvDxrxFfq2+D+bWvwjpXlls3KPUCuUL/yST/ttMdZ6SQf+WeTjLhcwYmnB
Z21GOyrce4HvzQmgzhcrmAD9MOhKSi9ZpP10LXqt7j2qPmoTBJI9B5NOwK/yj+E40cU+lAEM
8hHGvz8Z5LaiXowpmVH5TWv5oJeqlg36BrQuKoKcYlRuo35uJ/4DFR2u5KDnx+b4jKhO+fK6
MMFgdZQBnKp5TXjd306ggx27Xg/67PMzwWdUMSGuuAZ6D99sI5b1Nkos37pXjsAYawXHE513
m50kZX9pgDS/WXm9YYEips/Ujq1C49l+W8Lhc59JW4FVQxgX+6UkEIEmWDGCA4owggOGAgEB
MHowdTELMAkGA1UEBhMCQ0gxEjAQBgNVBAcTCVN0YWxsaWtvbjEOMAwGA1UEChMFVEhJTksx
EzARBgNVBAsTCkNBIFNlY3Rpb24xETAPBgNVBAMTCFRoaW5rIENBMRowGAYJKoZIhvcNAQkB
FgtjYUB0aGluay5jaAIBAjAJBgUrDgMCGgUAoIIB5TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0xMjExMjcxMjUzMTBaMCMGCSqGSIb3DQEJBDEWBBTlSuLo
BFdUB8iHEdzFL/foyp5wRTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIGJBgkrBgEEAYI3EAQxfDB6MHUxCzAJBgNVBAYTAkNIMRIw
EAYDVQQHEwlTdGFsbGlrb24xDjAMBgNVBAoTBVRISU5LMRMwEQYDVQQLEwpDQSBTZWN0aW9u
MREwDwYDVQQDEwhUaGluayBDQTEaMBgGCSqGSIb3DQEJARYLY2FAdGhpbmsuY2gCAQIwgYsG
CyqGSIb3DQEJEAILMXygejB1MQswCQYDVQQGEwJDSDESMBAGA1UEBxMJU3RhbGxpa29uMQ4w
DAYDVQQKEwVUSElOSzETMBEGA1UECxMKQ0EgU2VjdGlvbjERMA8GA1UEAxMIVGhpbmsgQ0Ex
GjAYBgkqhkiG9w0BCQEWC2NhQHRoaW5rLmNoAgECMA0GCSqGSIb3DQEBAQUABIIBAFm7Ycqt
2tXDV06PLj//x5TPXpRqUNcNGF/gK6ex7O2OgdSei6TRIL+yixRFHMY1sJ2M1AHI1VFhVF1r
EYef+szeOovsIc+y0FxSbeiRDHK+qbPzMNki26TelyjmzCXFUvCPjHCiuDVfrWi6G7EaAWTZ
16beKN/ZsNSONGXlwNJlBWtry/+OVnAWnyaFCQZ+N4RKPKvTWm53T1ugngpRg7THODI9Qz+A
6spjJs5Q3uX924ajXjFJAz99jvzYizqlxDEwwJt19BIOA9QA0KvmBvyag2BhVcrQdQE1zOa7
hGm0wzLl9zS47+RS1jcAHXY9DhZ3Zld/yXmlv9uTXtB0DjQAAAAAAAA=
--------------ms010100000302040903080602--
