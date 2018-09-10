Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60810 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbeIJW2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 18:28:16 -0400
Message-ID: <85af1917c8da6179f6455318d9db3132819ac1b4.camel@mbuf.com> (sfid-20180910_193442_622362_2B15F759)
Subject: Re: desktop hard lock up (kernel panic) with Alfa AWUSB036ACM and
 wireless-testing 72d1e548defbf
From: David Poole <davep@mbuf.com>
Reply-To: davep@mbuf.com
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        dpoole@cradlepoint.com
Date: Mon, 10 Sep 2018 11:32:57 -0600
In-Reply-To: <CAA2SeNKshXx2e9z+iWf=pbM0SN0teT2cvnye4noEjBxtOo4Vvw@mail.gmail.com>
References: <4922c981d88ab8b16d6ebd130829b6c04d8bbc56.camel@mbuf.com>
         <CAA2SeNKshXx2e9z+iWf=pbM0SN0teT2cvnye4noEjBxtOo4Vvw@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-Ozw7riGKhTtxU2QUP2hg"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ozw7riGKhTtxU2QUP2hg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-09-10 at 19:27 +0200, Lorenzo Bianconi wrote:
> >=20
> > Start wpa_supplicant
> > Attach to a Cisco AP (haven't tried too many other APs yet).
> > Desktop
> > locks up hard.  I have some shell scripts I use start wpa_supp and
> > run
> > wpa_cli (I'm not going through the GNOME ui or other).
> >=20
> > (Occurs to me I need to verify I didn't have the system's
> > wpa_supplicant running... I forget to kill the systemd started
> > wpa_supp
> > before starting mine.)
> >=20
> > Captured a kernel oops (attached) with netconsole. Same kernel with
> > my
> > 2nd wifi (an Intel 8265 PCI-e card) works.
> >=20
> > Running:
> > git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-
> > testing.git   72d1e548defbf75c6bb42fc99276cd88fda7dda0
> >=20
> >=20
> > I can 'iw dev scan' & scan through wpa_supplicant with the card
> > fairly
> > successfully. I haven't tried monitor mode. Have recreated the oops
> > a
> > couple times.
> >=20
> >=20
> > Alfa AWUSB036ACM
> >=20
>=20
> Hi David,
>=20
> according to the kernel log you provided the crash occurs in
> ieee80211_wake_txqs().
> Could you please run gdb in order to identify the point where NULL
> pointer dereference occurs? E.g:
>=20
> $gdb mac80211.ko
> $info address ieee80211_wake_txqs
> $l*(<func addr>+<offset>)
> offset is 0x1e3 in your log
>=20
> Regards,
> Lorenzo
>=20

Hello. Here's the requested info.

...trillian:wireless-testing% gdb ./net/mac80211/mac80211.ko
[...]
(gdb) info address ieee80211_wake_txqs
Symbol "ieee80211_wake_txqs" is a function at address 0x35890.
[...]
(gdb) l*(0x35890+0x1e3)
0x35a73 is in ieee80211_wake_txqs (net/mac80211/util.c:269).
264                     for (i =3D 0; i < ARRAY_SIZE(sta->sta.txq); i++)
{
265                             struct ieee80211_txq *txq =3D sta-
>sta.txq[i];
266
267                             txqi =3D to_txq_info(txq);
268
269                             if (ac !=3D txq->ac)
270                                     continue;
271
272                             if
(!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX,
273                                                     &txqi->flags))

--=-Ozw7riGKhTtxU2QUP2hg
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCED4w
ggUmMIIEDqADAgECAg9AYUF9DU7tUt/yQOGcC7swDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE4MDUwMjAwMDAwMFoXDTE5MDUwMjIzNTk1
OVowHzEdMBsGCSqGSIb3DQEJARYOZGF2ZXBAbWJ1Zi5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDG3ZcrTwoSMWU71k/a11C62Kosw0JnN6KiPYVp2K2nmQLVikesNxxQaVzoqg/K
4Ni+fFHVRXrHXNtdA/qCBk6OIVNM8flrIkKadZc/NkUCDpnCXBMUw++TM7Ep8f3kWzU/ew/TyKph
ZoXY06BDuwIat+cBaI2fSrhBh9Zf5o2UgD+VUMZ6X6l3LY8VPqX7TPV1EkYaqNGcD4aePmNlaN9V
rMh+CcgOTBD7WW8FLvBOB+UHXeQMJGuYJ3yhIMUrm2ENb6+G9TvTrMq5IJFL6n8QnFSlZEaVQggg
qnTrC30m+XcV0SnhlQLbMqUfh92V0lGLP4cr70Ue0T4E7T6FVTJ3AgMBAAGjggHkMIIB4DAfBgNV
HSMEGDAWgBSCr2yM+MX+lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQUpbFJQCvVskIKNGZjFUWO4lX7
JJswDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysG
AQQBsjEBAwUCMBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATAr
MCkGCCsGAQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+g
TaBLhklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlv
bmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6
Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJl
RW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAZBgNVHREE
EjAQgQ5kYXZlcEBtYnVmLmNvbTANBgkqhkiG9w0BAQsFAAOCAQEACNNjJh0ziFbSuwM0fdKuBIdN
TanvFma+sECnDjYh8VSJNzbUGWyXgY5RzjSySaM0lkLgXQQQfW0htwoNBbzsxlfsDkLOwGH6t5nb
8HepAUwGF3tz4lrG7YMPhDSWh3sdeRtJ1V6/bpHsY5bMK73U260QJBNJqUvbrnhCRw8WRSlauWzd
hp0eKgwDKXJdktKPq8cy1DQ7PHUUt1JOVCwk39nFPUeQrtUKoat1dLP3/LiwRxvkM3NTYlFd7Utp
4Oa8PHKMIC8eHfVV7rbZwMfdZDMOHfVbPRGxpsdBt3a7jqJXJYBVUY6+6PDX24mMGeOt/sD/S9AZ
O9Oy2uFR+KOPsTCCBSYwggQOoAMCAQICD0BhQX0NTu1S3/JA4ZwLuzANBgkqhkiG9w0BAQsFADCB
lzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTgwNTAyMDAwMDAwWhcN
MTkwNTAyMjM1OTU5WjAfMR0wGwYJKoZIhvcNAQkBFg5kYXZlcEBtYnVmLmNvbTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAMbdlytPChIxZTvWT9rXULrYqizDQmc3oqI9hWnYraeZAtWK
R6w3HFBpXOiqD8rg2L58UdVFesdc210D+oIGTo4hU0zx+WsiQpp1lz82RQIOmcJcExTD75MzsSnx
/eRbNT97D9PIqmFmhdjToEO7Ahq35wFojZ9KuEGH1l/mjZSAP5VQxnpfqXctjxU+pftM9XUSRhqo
0ZwPhp4+Y2Vo31WsyH4JyA5MEPtZbwUu8E4H5Qdd5Awka5gnfKEgxSubYQ1vr4b1O9OsyrkgkUvq
fxCcVKVkRpVCCCCqdOsLfSb5dxXRKeGVAtsypR+H3ZXSUYs/hyvvRR7RPgTtPoVVMncCAwEAAaOC
AeQwggHgMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBSlsUlAK9Wy
Qgo0ZmMVRY7iVfskmzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAgBgNVHSUEGTAXBggr
BgEFBQcDBAYLKwYBBAGyMQEDBQIwEQYJYIZIAYb4QgEBBAQDAgUgMEYGA1UdIAQ/MD0wOwYMKwYB
BAGyMQECAQEBMCswKQYIKwYBBQUHAgEWHWh0dHBzOi8vc2VjdXJlLmNvbW9kby5uZXQvQ1BTMFoG
A1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1
dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYsGCCsGAQUFBwEBBH8wfTBVBggrBgEF
BQcwAoZJaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRp
b25hbmRTZWN1cmVFbWFpbENBLmNydDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2Eu
Y29tMBkGA1UdEQQSMBCBDmRhdmVwQG1idWYuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQAI02MmHTOI
VtK7AzR90q4Eh01Nqe8WZr6wQKcONiHxVIk3NtQZbJeBjlHONLJJozSWQuBdBBB9bSG3Cg0FvOzG
V+wOQs7AYfq3mdvwd6kBTAYXe3PiWsbtgw+ENJaHex15G0nVXr9ukexjlswrvdTbrRAkE0mpS9uu
eEJHDxZFKVq5bN2GnR4qDAMpcl2S0o+rxzLUNDs8dRS3Uk5ULCTf2cU9R5Cu1Qqhq3V0s/f8uLBH
G+Qzc1NiUV3tS2ng5rw8cowgLx4d9VXuttnAx91kMw4d9Vs9EbGmx0G3druOolclgFVRjr7o8Nfb
iYwZ463+wP9L0Bk707La4VH4o4+xMIIF5jCCA86gAwIBAgIQapvhODv/K2ufAdXZuKdSVjANBgkq
hkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQ
MA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNP
TU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5
MjM1OTU5WjCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpyn
MS6n9jR22YRq2tA9NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgz
KlWlVJGyK+UlNEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqO
tzk06kb2qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTDyUGg
2hJZjrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1AgMBAAGj
ggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUgq9sjPjF
/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYDVR0g
BAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NP
TU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEBBGUwYzA7BggrBgEF
BQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRkVHJ1c3RDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAeFyy
gSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+jsQgwRGiHjZrAYayZrrm78hOx7aEpk
fNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD7f3iT7PdkHJY9B51csvU50rxpEg1OyOT
8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOd
GCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurf
fade2022O/tUU1gb4jfWCcyvB8czm12FgX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZ
ojTq/OCR6MvnzS6X72HP0PRLRTiOSEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo
9jzJ16HO5m60ttl1Enk8MQkz/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8ao
rYew6CQvdVifC3HtwlSam9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zm
EVDNXFnHn9tFpMpOUvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggPE
MIIDwAIBATCBqzCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQ
MA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENP
TU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECD0BhQX0N
Tu1S3/JA4ZwLuzANBglghkgBZQMEAgEFAKCCAekwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMTgwOTEwMTczMjU3WjAvBgkqhkiG9w0BCQQxIgQgXYiHO6hg2gqeebvi
JzNqfFd/UAP03DwwcvDccYGZ19YwgbwGCSsGAQQBgjcQBDGBrjCBqzCBlzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMR
Q09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0
aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECD0BhQX0NTu1S3/JA4ZwLuzCBvgYLKoZIhvcNAQkQAgsx
ga6ggaswgZcxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNV
BAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAg9AYUF9DU7tUt/y
QOGcC7swDQYJKoZIhvcNAQEBBQAEggEAsyI4AuVwqCDAQ9bGI9dsy3XIUtp8Ptrs3T99VFMTIYsv
DMn26UTghUxYFrZMjbmorg2Et8YWiaWztpIPe2YYjRHNCHWPvQv5tCitEeH6y/7zYl9qJ0b8P7Qi
iur389xF/vltW73sCKbZiPUg1zgPzeprGuS9zSWw6SmEOVzfYxMXj7IDCAeo2JCM7iMsr4gsumO4
K1YjDP7ZXcHc1OXTrfagy94A585M2aSL4rPWGiB9Y1lZal2kN9ZASXLb2oA7lJJim8b8Ac4zavlQ
b5BPX15SKucDiIBC2Uf7XostCeOWs2Sp6e7MsF9YHfO9/czAC3IAGpv52u5Xc09xsA8PNgAAAAAA
AA==


--=-Ozw7riGKhTtxU2QUP2hg--
