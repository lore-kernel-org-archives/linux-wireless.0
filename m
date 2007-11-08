Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbXKHUDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 15:03:30 -0500
Subject: Re: mac80211 and SIOCSIWAUTH
From: Dan Williams <dcbw@redhat.com>
To: =?UTF-8?Q?=D0=92=D0=B5=D1=82=D0=BE=D1=88=D0=BA=D0=B8=D0=BD_?=
	 =?UTF-8?Q?=D0=9D=D0=B8=D0=BA=D0=B8=D1=82=D0=B0?=
	<nvetoshkin@naumen.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47335980.4070103@naumen.ru>
References: <47335980.4070103@naumen.ru>
Content-Type: text/plain; charset=utf-8
Date: Thu, 08 Nov 2007 15:00:53 -0500
Message-Id: <1194552053.31657.0.camel@localhost.localdomain> (sfid-20071108_200338_034151_864C1C1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-11-08 at 23:46 +0500, =D0=92=D0=B5=D1=82=D0=BE=D1=88=D0=BA=
=D0=B8=D0=BD =D0=9D=D0=B8=D0=BA=D0=B8=D1=82=D0=B0 wrote:
> Hi, I'm a user of Lenovo R61 laptop with Intel 3945 wireless card. I=20
> have Gentoo and would like to use the iwlwifi + wpa_supplicant driver=
,=20
> but I can't because Wi-Fi installed in our office needs WPA2=20
> authentication and I can't connect to it. There no problems using ipw=
3945d.
> #wpa_supplicant config
> ap_scan=3D2
> network=3D{
>          ssid=3D"point1"
>          key_mgmt=3DWPA-EAP
>          scan_ssid=3D1
>          identity=3D"nvetoshkin"
>          proto=3DWPA2
>          eap=3DTLS
>          ca_cert=3D"/home/nekto/certificate.pem"
>          private_key=3D"/home/nekto/nvetoshkin.p12"
>          private_key_passwd=3D"nvetoshkin"
> }
> ioctl[SIOCSIWAUTH]: Operation not supported - this error always appea=
rs=20
> in wpa_supplicant output. I digged a bit in source code and found out=
=20
> that it is mac80211 subsystem who returns ENOTSUP.
> Is it really the cause of my problems or am I just confused?

There's a number of SIOCSIWAUTH sub-options, and not all are necessary,
and not all are supported by every driver.  That's normal.  Ignore the
wpa_supplicant message.

Dan


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
