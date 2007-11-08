Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.post.naumen.ru ([77.222.34.75]:47363 "EHLO
	relay.post.naumen.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbXKHUNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 15:13:49 -0500
Message-ID: <47336DEC.2040007@naumen.ru> (sfid-20071108_201355_432963_16070322)
Date: Fri, 09 Nov 2007 01:13:32 +0500
From: =?UTF-8?B?0JLQtdGC0L7RiNC60LjQvSDQndC40LrQuNGC0LA=?=
	<nvetoshkin@naumen.ru>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and SIOCSIWAUTH
References: <47335980.4070103@naumen.ru> <1194552053.31657.0.camel@localhost.localdomain>
In-Reply-To: <1194552053.31657.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is anybody interested in this case?
If so, what information should I provide you which be enough to=20
investigate the problem?
- kernel 2.6.23-gentoo
- iwl3945 1.1.21
- ucode 2.14.1
- wpa_supplicant 0.6.0

What else(logs,output)?

Vetoshkin Nikita


Dan Williams =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Thu, 2007-11-08 at 23:46 +0500, =D0=92=D0=B5=D1=82=D0=BE=D1=88=D0=BA=
=D0=B8=D0=BD =D0=9D=D0=B8=D0=BA=D0=B8=D1=82=D0=B0 wrote:
>> Hi, I'm a user of Lenovo R61 laptop with Intel 3945 wireless card. I=
=20
>> have Gentoo and would like to use the iwlwifi + wpa_supplicant drive=
r,=20
>> but I can't because Wi-Fi installed in our office needs WPA2=20
>> authentication and I can't connect to it. There no problems using ip=
w3945d.
>> #wpa_supplicant config
>> ap_scan=3D2
>> network=3D{
>>          ssid=3D"point1"
>>          key_mgmt=3DWPA-EAP
>>          scan_ssid=3D1
>>          identity=3D"nvetoshkin"
>>          proto=3DWPA2
>>          eap=3DTLS
>>          ca_cert=3D"/home/nekto/certificate.pem"
>>          private_key=3D"/home/nekto/nvetoshkin.p12"
>>          private_key_passwd=3D"nvetoshkin"
>> }
>> ioctl[SIOCSIWAUTH]: Operation not supported - this error always appe=
ars=20
>> in wpa_supplicant output. I digged a bit in source code and found ou=
t=20
>> that it is mac80211 subsystem who returns ENOTSUP.
>> Is it really the cause of my problems or am I just confused?
>=20
> There's a number of SIOCSIWAUTH sub-options, and not all are necessar=
y,
> and not all are supported by every driver.  That's normal.  Ignore th=
e
> wpa_supplicant message.
>=20
> Dan
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
=D0=A1 =D1=83=D0=B2=D0=B0=D0=B6=D0=B5=D0=BD=D0=B8=D0=B5=D0=BC,
=D0=92=D0=B5=D1=82=D0=BE=D1=88=D0=BA=D0=B8=D0=BD =D0=9D=D0=B8=D0=BA=D0=B8=
=D1=82=D0=B0

=D0=98=D0=BD=D0=B6=D0=B5=D0=BD=D0=B5=D1=80 =D0=BF=D0=BE=D0=B4=D0=B4=D0=B5=
=D1=80=D0=B6=D0=BA=D0=B8 =D1=81=D0=B8=D1=81=D1=82=D0=B5=D0=BC IP-=D1=82=
=D0=B5=D0=BB=D0=B5=D1=84=D0=BE=D0=BD=D0=B8=D0=B8
=D0=A1=D0=B5=D1=80=D0=B2=D0=B8=D1=81=D0=BD=D1=8B=D0=B9 =D1=86=D0=B5=D0=BD=
=D1=82=D1=80
=D0=9A=D0=BE=D0=BC=D0=BF=D0=B0=D0=BD=D0=B8=D1=8F Naumen
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
