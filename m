Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58364 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423541Ab2LGRwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 12:52:02 -0500
Message-ID: <50C22CBB.5060704@etit.tu-chemnitz.de> (sfid-20121207_185208_012851_97822119)
Date: Fri, 07 Dec 2012 09:51:55 -0800
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: devel@lists.open80211s.org
CC: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211_hwsim: dont modify TBTT if beacon is already enabled
References: <1354680761-32703-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> <CAG6hwVN3F+KY=LkrG0j8WfFczBJawTD5J4kbbsnPfSAGrX5dXA@mail.gmail.com>
In-Reply-To: <CAG6hwVN3F+KY=LkrG0j8WfFczBJawTD5J4kbbsnPfSAGrX5dXA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010406030000090005040507"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010406030000090005040507
Content-Type: multipart/mixed;
 boundary="------------090001020009010704070206"

This is a multi-part message in MIME format.
--------------090001020009010704070206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/05/2012 12:26 PM, Thomas Pedersen wrote:> On Tue, Dec 4, 2012 at=20
8:12 PM, Marco Porsch
 > <marco.porsch@etit.tu-chemnitz.de> wrote:
 >> If the beacon is already enabled, do not modify the beacon timer.=20
This causes
 >> a hard TBTT adjustment and may cause mischief for powersave or=20
synchronization.j
 >
 > It might be clearer if you explain this patch actually defers "TBTT"
 > adjustment until the next beacon.

This commit is supposed to not change the TBTT at all, if the beacon is=20
not enabled/disabled. Or do I misunderstand you here? Please clarify.

 >> Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
 >> ---
 >>   drivers/net/wireless/mac80211_hwsim.c |    2 +-
 >>   1 file changed, 1 insertion(+), 1 deletion(-)
 >>
 >> diff --git a/drivers/net/wireless/mac80211_hwsim.c=20
b/drivers/net/wireless/mac80211_hwsim.c
 >> index bc763d2..abfa7e6 100644
 >> --- a/drivers/net/wireless/mac80211_hwsim.c
 >> +++ b/drivers/net/wireless/mac80211_hwsim.c
 >> @@ -1174,7 +1174,7 @@ static int mac80211_hwsim_config(struct=20
ieee80211_hw *hw, u32 changed)
 >>          data->power_level =3D conf->power_level;
 >>          if (!data->started || !data->beacon_int)
 >>                  del_timer(&data->beacon_timer);
 >> -       else
 >> +       else if (!timer_pending(&data->beacon_timer))
 >>                  mod_timer(&data->beacon_timer, jiffies +=20
data->beacon_int);
 >
 > There is an immediate beacon timer adjustment in
 > mac80211_hwsim_bss_info_changed() as well.

But that other one really has to change the TBTT because it changes the=20
beacon interval.

--Marco


--------------090001020009010704070206
Content-Type: text/x-vcard; charset=utf-8;
 name="marco_porsch.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="marco_porsch.vcf"

begin:vcard
fn:Marco Porsch
n:Porsch;Marco
org:Chemnitz University of Technology;Communication Networks
adr;quoted-printable;quoted-printable:Fakult=3DC3=3DA4t f=3DC3=3DBCr Elek=
trotechnik und Informationstechnik , Professur=3D
	 Kommunikationsnetze;;Technische Universit=3DC3=3DA4t Chemnitz;Chemnitz;=
;D - 09107;Germany
email;internet:marco.porsch@etit.tu-chemnitz.de
title:Dipl.-Ing.
tel;work:+49 371 531 37523
version:2.1
end:vcard


--------------090001020009010704070206--

--------------ms010406030000090005040507
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPPDCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIFSDCCBDCgAwIBAgIECdfudzAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDEyNTA4NTcxMloXDTE5MDExNTAwMDAwMFowgb0xCzAJBgNVBAYTAkRFMSkwJwYDVQQK
EyBUZWNobmlzY2hlIFVuaXZlcnNpdGFldCBDaGVtbml0ejEjMCEGA1UECxMaVW5pdmVyc2l0
YWV0c3JlY2hlbnplbnRydW0xPDA6BgNVBAMTM1RVIENoZW1uaXR6IENlcnRpZmljYXRpb24g
QXV0aG9yaXR5IC0gVFVDL1VSWiBDQSBHMzEgMB4GCSqGSIb3DQEJARYRY2FAdHUtY2hlbW5p
dHouZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCwu6P4RoCP2kbHqjFDJdHr
Pt/WUGh42n8kyaxdyxn+HaJrynixJEvLjoDsN3Q49+v+77Vdr7kOcFNTpkEF3QF8rN7GfM0B
ym64E7wppMMW06HBehKaq9EPEono+XVuJUmbyjdyS7RfXnuAqcraVUXx6YY9hXfk5E+JtWU9
du886W6VW1jG8uPHX0m5lYDK9y++bbu9M56F+HdK4THjcumjso0+3KGjUdADfGj4lKPoWYQq
Qqm+L7DbgyjrkcoEYsXFE9yeXcuSXf6LMBuaFzkx0+/Eta77N7UvEB5x/yNdsTpNCg8FY6Q5
zRdFHXXUNFIA9BZUtHZvtRGA90Q9EYVbAgMBAAGjggGwMIIBrDAPBgNVHRMBAf8EBTADAQH/
MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQU6Nq48kfemSR9Z0CJJ2dxDWPYo44wHwYDVR0jBBgw
FoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERY2FAdHUtY2hlbW5pdHouZGUw
gYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2ds
b2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcBAQSBlTCBkjBHBggr
BgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xv
YmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQB7
gH9exRtN1ZZLVZLnd3oc9FB/1jT9vEVj/71JcvNmGsnjJlNKGGB5gmBBJvHmVR/BHihLAq15
MHE3OnTe6VCxKghC/etkL/AeSCJzPl45s1Gh8wtb9TRYTgiPxtMdyEJMNiL3w6KRR/c+5Bdd
psKERddeViNJL/S9M9JHLHV7t71FBSmnu7HI5ksEC5xDDGroiIrahBwQ5u8OAbFqpLKWFCCy
AVTpfQIjaf4klhLVBRis2YHZ60YsxWzmvUykBtEs0AzlyVy+P4rJwqSYdvxNPxonjkuWdVpm
WQoSpYJ0jzalZhoEKTra9Tov9i6kb7ezWKjQ1t6Rkr0a03uQ6qJ2MIIFxzCCBK+gAwIBAgIE
Eie+yTANBgkqhkiG9w0BAQUFADCBvTELMAkGA1UEBhMCREUxKTAnBgNVBAoTIFRlY2huaXNj
aGUgVW5pdmVyc2l0YWV0IENoZW1uaXR6MSMwIQYDVQQLExpVbml2ZXJzaXRhZXRzcmVjaGVu
emVudHJ1bTE8MDoGA1UEAxMzVFUgQ2hlbW5pdHogQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkg
LSBUVUMvVVJaIENBIEczMSAwHgYJKoZIhvcNAQkBFhFjYUB0dS1jaGVtbml0ei5kZTAeFw0x
MTA2MjcwODM3MTNaFw0xNDA2MjYwODM3MTNaMHAxCzAJBgNVBAYTAkRFMSkwJwYDVQQKEyBU
ZWNobmlzY2hlIFVuaXZlcnNpdGFldCBDaGVtbml0ejEfMB0GA1UECxMWQ29tbXVuaWNhdGlv
biBOZXR3b3JrczEVMBMGA1UEAxMMTWFyY28gUG9yc2NoMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA0nFNVZi3WPvy4Lw8vEFwXFVbaSsw0UccANLjaPkiuJ6k8IueISYmxTeN
h3vOc3zEY7VeDTUzsAtt6dvN2dH7Jy0wtmbq8G0YzHxybCclQG+0cLcxuVrsK06zxlCtwVi3
DUkv6y+aQGUktpEzIzRC5L/WvEP3iwrQrzdyaMJSSGt7OK1VjgUfx1DBkco+nPUt0mxSg9jg
P8uZFFWdnB9Yv7queXAgM91KeBswNaR1NCqwFYq06kB2qmyMzNXYhCyAm89UvU7bTJV4KNWy
DMNuDT0i7SpdflOnHZaSua+ha7Bw2LuvtXUrE4cgK+Ep5TbbmimX1HtKNy9mu1FpTt7SVQID
AQABo4ICGTCCAhUwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwKQYDVR0lBCIwIAYIKwYBBQUH
AwIGCCsGAQUFBwMEBgorBgEEAYI3FAICMB0GA1UdDgQWBBQs40HmQA6aGyXI7//X6YDV3MiU
9zAfBgNVHSMEGDAWgBTo2rjyR96ZJH1nQIknZ3ENY9ijjjArBgNVHREEJDAigSBtYXJjby5w
b3JzY2hAZXRpdC50dS1jaGVtbml0ei5kZTCBiAYDVR0fBIGAMH4wPaA7oDmGN2h0dHA6Ly9j
ZHAxLnBjYS5kZm4uZGUvdHUtY2hlbW5pdHotY2EvcHViL2NybC9jYWNybC5jcmwwPaA7oDmG
N2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvdHUtY2hlbW5pdHotY2EvcHViL2NybC9jYWNybC5j
cmwwgdcGCCsGAQUFBwEBBIHKMIHHMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZu
LmRlL09DU1AtU2VydmVyL09DU1AwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAxLnBjYS5kZm4u
ZGUvdHUtY2hlbW5pdHotY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEcGCCsGAQUFBzAChjto
dHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWNoZW1uaXR6LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0
LmNydDANBgkqhkiG9w0BAQUFAAOCAQEAJv+OZiWgF/Pq1PmdotTWBMflvVKf9D95xupljUd9
OUWRXiE0gqS+1ucFOlgybWlxLF9o12SfbauJaWrulENuKTTrUuMHIfsO+XvHMEmKe4DJs26p
ufFxyyFatrQHlYqTXrbAKUKntv3BBqLRJK5Efn7drtPLROjnjeWmUVFZ350ZytlknqEBNASJ
c4hkzHaueJ1gvXV6cxSWw1/evhA4nkL8hTHaU6v0lVayTSKuosswTzhR8PtubklaUjWkGXpE
0jDg6f1NdPXKslt310dmwCwpnPlT1+5OZkVgOQ/No/lutab6wFnCPjcrM72lXPp7CkhpitcY
h0asZtTNl3iK/DGCBHMwggRvAgEBMIHGMIG9MQswCQYDVQQGEwJERTEpMCcGA1UEChMgVGVj
aG5pc2NoZSBVbml2ZXJzaXRhZXQgQ2hlbW5pdHoxIzAhBgNVBAsTGlVuaXZlcnNpdGFldHNy
ZWNoZW56ZW50cnVtMTwwOgYDVQQDEzNUVSBDaGVtbml0eiBDZXJ0aWZpY2F0aW9uIEF1dGhv
cml0eSAtIFRVQy9VUlogQ0EgRzMxIDAeBgkqhkiG9w0BCQEWEWNhQHR1LWNoZW1uaXR6LmRl
AgQSJ77JMAkGBSsOAwIaBQCgggKBMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZI
hvcNAQkFMQ8XDTEyMTIwNzE3NTE1NVowIwYJKoZIhvcNAQkEMRYEFFq0c7fyvTy6F9y0kzzH
6miDEbrTMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggq
hkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZI
hvcNAwICASgwgdcGCSsGAQQBgjcQBDGByTCBxjCBvTELMAkGA1UEBhMCREUxKTAnBgNVBAoT
IFRlY2huaXNjaGUgVW5pdmVyc2l0YWV0IENoZW1uaXR6MSMwIQYDVQQLExpVbml2ZXJzaXRh
ZXRzcmVjaGVuemVudHJ1bTE8MDoGA1UEAxMzVFUgQ2hlbW5pdHogQ2VydGlmaWNhdGlvbiBB
dXRob3JpdHkgLSBUVUMvVVJaIENBIEczMSAwHgYJKoZIhvcNAQkBFhFjYUB0dS1jaGVtbml0
ei5kZQIEEie+yTCB2QYLKoZIhvcNAQkQAgsxgcmggcYwgb0xCzAJBgNVBAYTAkRFMSkwJwYD
VQQKEyBUZWNobmlzY2hlIFVuaXZlcnNpdGFldCBDaGVtbml0ejEjMCEGA1UECxMaVW5pdmVy
c2l0YWV0c3JlY2hlbnplbnRydW0xPDA6BgNVBAMTM1RVIENoZW1uaXR6IENlcnRpZmljYXRp
b24gQXV0aG9yaXR5IC0gVFVDL1VSWiBDQSBHMzEgMB4GCSqGSIb3DQEJARYRY2FAdHUtY2hl
bW5pdHouZGUCBBInvskwDQYJKoZIhvcNAQEBBQAEggEApM5407eYY3oydpr5HMbwqDSGClSe
NGJ3mGpolIXtWmooFDHuh8/ovxWPTS8b6WnivSYT/q+JfcPXxOg6tpCokeaZtKEYYETcRUWM
VP6pKz4VV0gEnfXum6CHXQlDsfiOY8WqI2xbYZO0E/NgYeTY2Y2RtDinb5U0MqLXDGeQ5sgJ
CKyWh1JhsqzBlqKWfidVHqdp6OHlahOgeYT7BnmWDkd16VNsoo9hdpBAhBLissZjf/yHcwsp
TdONDh+ssyzFimw/rcmojOwfIUTX2PM3wF2iFf15PVhVYaz8mkdMdWowluHDEy4nvb+1FoCf
gfvcl3tXID3laf08SN5Y5+J5+gAAAAAAAA==
--------------ms010406030000090005040507--
