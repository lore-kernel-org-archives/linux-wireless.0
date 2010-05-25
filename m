Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:52177 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab0EYCnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 22:43:16 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2105153fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 19:43:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFB36B9.8010706@gmail.com>
References: <4BFB21C1.3060703@gmail.com> <AANLkTil4AnMqzSN4d_VTRJGFqWQl7CkZtr80GcffqM3h@mail.gmail.com>
	<AANLkTilGK0jIqYDYQBP7RgJ6b_3Pk7FEbo4S7n6e-4Ly@mail.gmail.com>
	<4BFB36B9.8010706@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 25 May 2010 04:42:54 +0200
Message-ID: <AANLkTimUMngNCV5clGLJu9q0If_xCxhBVgdgp0yMf_dD@mail.gmail.com>
Subject: Re: ioctl for b43 driver
To: Huy Le <lehuy0406@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636426575705ac70487621e9b
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001636426575705ac70487621e9b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2010/5/25 Huy Le <lehuy0406@gmail.com>:
> On 05/24/2010 06:26 PM, G=E1bor Stefanik wrote:
>
> 2010/5/25 G=E1bor Stefanik <netrolller.3d@gmail.com>:
>
>
> On Tue, May 25, 2010 at 3:02 AM, Huy Le <lehuy0406@gmail.com> wrote:
>
>
> Hi,
>
> Currently I try aircrack-ng with b43 driver but it is fail at this statem=
ent
> due to the following statement:
>
> =A0 =A0ioctl( fd, SIOCGIWFREQ, &wrq ) < 0
>
> This happens because we do not have ioctl for b43 driver. I just want to =
ask
> if there is any way to work around.
>
>
> Confirmed with ath9k. Apparently rdev->channel is NULL for monitor
> interfaces.
>
>
> I meant wdev->channel - it got changed recently.
>
>
>
>
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>
>
>
>
>
> Thanks for your respond. However, I can't get what you meant. I am trying
> aircrack-ng and I found in the source of aircrack-ng that they call ioctl=
(
> fd, SIOCGIWFREQ, &wrq ). But the driver of b43 doesn't support ioctl, so
> this call is failed. Is there any solution for me? My wireless card is
> BCM4312 [14e4:4315]
>
> Thanks.
>

Well, b43 supports ioctls using cfg80211, at least if cfg80211 wext
compat support is enabled in the kernel configuration. The problem is
something else - since the change from rdev->channel to wdev->channel,
monitor interfaces do not have a valid channel pointer in either rdev
or wdev. The same problem exists on ath9k and ath5k, and probably
anything that uses mac80211.

Attached is a C source for a test app that shows whether SIOCGIWFREQ
completes successfully. Compile it using "gcc iwfreqtest.c -o
iwfreqtest", the run as "iwfreqtest <name of interface>". It seems to
consistently fail on monitor interfaces, and succeed on anything else.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

--001636426575705ac70487621e9b
Content-Type: application/octet-stream; name="iwfreqtest.c"
Content-Disposition: attachment; filename="iwfreqtest.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9m4c35f0

I2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4NCiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4NCiNpbmNsdWRl
IDxzeXMvdHlwZXMuaD4NCiNpbmNsdWRlIDxzeXMvd2FpdC5oPg0KI2luY2x1ZGUgPHN5cy90aW1l
Lmg+DQojaW5jbHVkZSA8c3lzL3N0YXQuaD4NCiNpbmNsdWRlIDxuZXRwYWNrZXQvcGFja2V0Lmg+
DQojaW5jbHVkZSA8bGludXgvaWZfZXRoZXIuaD4NCiNpbmNsdWRlIDxsaW51eC9pZi5oPg0KI2lu
Y2x1ZGUgPGxpbnV4L3dpcmVsZXNzLmg+DQojaW5jbHVkZSA8bmV0aW5ldC9pbi5oPg0KI2luY2x1
ZGUgPGxpbnV4L2lmX3R1bi5oPg0KI2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8c3RkbGli
Lmg+DQojaW5jbHVkZSA8c3RyaW5nLmg+DQojaW5jbHVkZSA8dW5pc3RkLmg+DQojaW5jbHVkZSA8
ZmNudGwuaD4NCiNpbmNsdWRlIDxlcnJuby5oPg0KI2luY2x1ZGUgPGRpcmVudC5oPg0KI2luY2x1
ZGUgPHN5cy91dHNuYW1lLmg+DQoNCmludCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pDQp7
DQoJaW50IGZkID0gc29ja2V0KFBGX1BBQ0tFVCwgU09DS19SQVcsIGh0b25zKEVUSF9QX0FMTCkp
Ow0KCXN0cnVjdCBpd3JlcSB3cnE7DQoJaW50IHJldDsNCgkNCglpZiAoZmQgPCAwKSB7DQoJCXBy
aW50ZigiVW5hYmxlIHRvIG9wZW4gc29ja2V0IVxuIik7DQoJCXJldHVybiAtMTsNCgl9DQoJDQoJ
bWVtc2V0KCZ3cnEsIDAsIHNpemVvZihzdHJ1Y3QgaXdyZXEpKTsNCgkNCglpZiAoYXJnYyA+IDEp
DQoJCXN0cm5jcHkod3JxLmlmcl9uYW1lLCBhcmd2WzFdLCBJRk5BTVNJWik7DQoJZWxzZQ0KCQlz
dHJuY3B5KHdycS5pZnJfbmFtZSwgIm1vbjAiLCBJRk5BTVNJWik7DQoJDQoJcmV0ID0gaW9jdGwo
ZmQsIFNJT0NHSVdGUkVRLCAmd3JxKTsNCglwcmludGYoIlNJT0NHSVdGUkVRIHJldHVybmVkICVk
IHdpdGggc3RhdHVzIGNvZGUgJWQvJWRcbiIsIHdycS51LmZyZXEubSwgcmV0LCBlcnJubyk7DQoJ
DQoJY2xvc2UoZmQpOw0KDQoJcmV0dXJuIDA7DQp9
--001636426575705ac70487621e9b--
