Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:53903 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964906Ab2CPN6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:58:24 -0400
Message-ID: <4F6346FE.4060005@etit.tu-chemnitz.de> (sfid-20120316_145829_351208_DB479509)
Date: Fri, 16 Mar 2012 14:58:22 +0100
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] UAPSD: WLAN_STA_PS flag  cleared prematurely?
References: <4F630757.6070901@etit.tu-chemnitz.de>  <1331901852.6753.2.camel@jlt3.sipsolutions.net>  <4F634259.7040107@etit.tu-chemnitz.de> <1331905240.6753.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331905240.6753.14.camel@jlt3.sipsolutions.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050109070703060305060107"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050109070703060305060107
Content-Type: multipart/mixed;
 boundary="------------060607050302060801000904"

This is a multi-part message in MIME format.
--------------060607050302060801000904
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 03/16/12 14:40, Johannes Berg wrote:
> On Fri, 2012-03-16 at 14:38 +0100, Marco Porsch wrote:
>> On 03/16/12 13:44, Johannes Berg wrote:
>>> On Fri, 2012-03-16 at 10:26 +0100, Marco Porsch wrote:
>>>> Hi all,
>>>>
>>>> in sta_info.c : ieee80211_sta_ps_deliver_response the
>>>> IEEE80211_TX_STATUS_EOSP is set for all to-be-sent frames, not only =
for
>>>> the last. But only the last buffered frame actually gets the EOSP fl=
ag.
>>>>
>>>>
>>>> /* set EOSP for the frame */
>>>> if (reason =3D=3D IEEE80211_FRAME_RELEASE_UAPSD&&
>>>>        qoshdr&&   skb_queue_empty(&frames))
>>>> 	*qoshdr |=3D IEEE80211_QOS_CTL_EOSP;
>>>>
>>>> info->flags |=3D IEEE80211_TX_STATUS_EOSP |
>>>>           IEEE80211_TX_CTL_REQ_TX_STATUS;
>>>>
>>>>
>>>> Consequence is, that the WLAN_STA_SP flag gets cleared (multiple tim=
es)
>>>> in ieee80211_tx_status before the last frame with EOSP has been sent=
=2E
>>>> Is this correct?
>>>
>>> Looks like the bug is above, the EOSP/TX_STATUS should only be set fo=
r
>>> the last frame?
>>
>> I Agree. But what about the case, when the last frame is not a QoS
>> frame? Can this even happen - or is U-APSD only for QoS STA?
>
> uAPSD can only be used by a QoS STA.
>
>> Then we would have to manually append a QoS Null with the EOSP flag +
>> TX_STATUS?
>>
>> So like this:
>>
>> /* set EOSP for the _last_ frame or appended a QoS Null when needed */=

>> if (reason =3D=3D IEEE80211_FRAME_RELEASE_UAPSD&&
>>       skb_queue_empty(&frames)) {
>> 	if (qoshdr) {
>> 		*qoshdr |=3D IEEE80211_QOS_CTL_EOSP;
>>
>> 		info->flags |=3D IEEE80211_TX_STATUS_EOSP |
>> 		               IEEE80211_TX_CTL_REQ_TX_STATUS;
>> 	} else {
>> 		ieee80211_send_null_response(sdata, tid, reason);
>> 	}
>> }
>
> No, I think it should be more like this:
>
>
> /* set EOSP for the frame */
>
> if (skb_queue_empty(&frames)) {
> 	if (reason =3D=3D IEEE80211_FRAME_RELEASE_UAPSD&&  qoshdr)
> 	        *qoshdr |=3D IEEE80211_QOS_CTL_EOSP;
>
> 	info->flags |=3D IEEE80211_TX_STATUS_EOSP |
> 			IEEE80211_TX_CTL_REQ_TX_STATUS;
> }

Oh, yes, I see. In case of reason=3D=3DIEEE80211_FRAME_RELEASE_PSPOLL, it=
 is=20
intended to not send the EOSP, but still set IEEE80211_TX_STATUS_EOSP.

Who sends the patch?

Regards,
Marco

--------------060607050302060801000904
Content-Type: text/x-vcard; charset=utf-8;
 name="marco_porsch.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="marco_porsch.vcf"

YmVnaW46dmNhcmQNCmZuOk1hcmNvIFBvcnNjaA0KbjpQb3JzY2g7TWFyY28NCm9yZzpDaGVt
bml0eiBVbml2ZXJzaXR5IG9mIFRlY2hub2xvZ3k7Q29tbXVuaWNhdGlvbiBOZXR3b3Jrcw0K
YWRyO3F1b3RlZC1wcmludGFibGU7cXVvdGVkLXByaW50YWJsZTpGYWt1bHQ9QzM9QTR0IGY9
QzM9QkNyIEVsZWt0cm90ZWNobmlrIHVuZCBJbmZvcm1hdGlvbnN0ZWNobmlrICwgUHJvZmVz
c3VyPQ0KCSBLb21tdW5pa2F0aW9uc25ldHplOztUZWNobmlzY2hlIFVuaXZlcnNpdD1DMz1B
NHQgQ2hlbW5pdHo7Q2hlbW5pdHo7O0QgLSAwOTEwNztHZXJtYW55DQplbWFpbDtpbnRlcm5l
dDptYXJjby5wb3JzY2hAZXRpdC50dS1jaGVtbml0ei5kZQ0KdGl0bGU6RGlwbC4tSW5nLg0K
dGVsO3dvcms6KzQ5IDM3MSA1MzEgMzc1MjMNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------060607050302060801000904--

--------------ms050109070703060305060107
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
h0asZtTNl3iK/DGCBGYwggRiAgEBMIHGMIG9MQswCQYDVQQGEwJERTEpMCcGA1UEChMgVGVj
aG5pc2NoZSBVbml2ZXJzaXRhZXQgQ2hlbW5pdHoxIzAhBgNVBAsTGlVuaXZlcnNpdGFldHNy
ZWNoZW56ZW50cnVtMTwwOgYDVQQDEzNUVSBDaGVtbml0eiBDZXJ0aWZpY2F0aW9uIEF1dGhv
cml0eSAtIFRVQy9VUlogQ0EgRzMxIDAeBgkqhkiG9w0BCQEWEWNhQHR1LWNoZW1uaXR6LmRl
AgQSJ77JMAkGBSsOAwIaBQCgggJ0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZI
hvcNAQkFMQ8XDTEyMDMxNjEzNTgyMlowIwYJKoZIhvcNAQkEMRYEFDpVA/tZ7XzAzv5A71iV
LFvrZXrnMF8GCSqGSIb3DQEJDzFSMFAwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqG
SIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCB1wYJ
KwYBBAGCNxAEMYHJMIHGMIG9MQswCQYDVQQGEwJERTEpMCcGA1UEChMgVGVjaG5pc2NoZSBV
bml2ZXJzaXRhZXQgQ2hlbW5pdHoxIzAhBgNVBAsTGlVuaXZlcnNpdGFldHNyZWNoZW56ZW50
cnVtMTwwOgYDVQQDEzNUVSBDaGVtbml0eiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIFRV
Qy9VUlogQ0EgRzMxIDAeBgkqhkiG9w0BCQEWEWNhQHR1LWNoZW1uaXR6LmRlAgQSJ77JMIHZ
BgsqhkiG9w0BCRACCzGByaCBxjCBvTELMAkGA1UEBhMCREUxKTAnBgNVBAoTIFRlY2huaXNj
aGUgVW5pdmVyc2l0YWV0IENoZW1uaXR6MSMwIQYDVQQLExpVbml2ZXJzaXRhZXRzcmVjaGVu
emVudHJ1bTE8MDoGA1UEAxMzVFUgQ2hlbW5pdHogQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkg
LSBUVUMvVVJaIENBIEczMSAwHgYJKoZIhvcNAQkBFhFjYUB0dS1jaGVtbml0ei5kZQIEEie+
yTANBgkqhkiG9w0BAQEFAASCAQAKUbH7blCkN0Of5hwfMnS75garsGSf29wUVX/dgpeLv1Vz
r5rEpyKoVHUI6Xzi9iWN/TmdoYlP1eQT9cCRQvrE01X5jbA3hua0kIEMvaG8ckHgAK87GexV
n24vsn2dEl2fZTfJFOu/HKevm/5mUkb3DlcA9dcN2JddvtMgH+r54KuMttgkCiCZI9RF25NF
FXBgjcEN68N1I3u/b6YbXTYVNzk3LTsq2H9tvjnSvS4xiC7LcTeeLjgBp919p4VQ3z4VkQir
2aTu5j2rdDPGNOciQtLfk+r/HAwFl1DUg02ox/l1bHGesD2mXK+pYpCfG7kP4tW4kz6viatv
YYzdtt2FAAAAAAAA
--------------ms050109070703060305060107--
