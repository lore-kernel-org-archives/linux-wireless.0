Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43406 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1CQPGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 11:06:44 -0400
Received: by gyf1 with SMTP id 1so1140567gyf.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 08:06:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300354167.3774.0.camel@jlt3.sipsolutions.net>
References: <AANLkTimQRgAr9aY_zs0L7hjXhECiR9w8V5Y7fbwrJ1DX@mail.gmail.com>
	<1300354167.3774.0.camel@jlt3.sipsolutions.net>
Date: Thu, 17 Mar 2011 08:06:42 -0700
Message-ID: <AANLkTi=doS4LtZ3k9f6Lw+RhXOq5iF22-B9w1rGOMuMw@mail.gmail.com>
Subject: Re: [PATCH] iw: Add send callback with optional debug handler
From: Sean Robinson <seankrobinson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd5cf7252b30c049eaf02cb
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd5cf7252b30c049eaf02cb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

  I have made the test syntax change you recommended and attached the
gzipped 'git format-patch'.

On Thu, Mar 17, 2011 at 2:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-03-16 at 17:28 -0700, Sean Robinson wrote:
>> libnl supports callbacks for send and recv. =C2=A0This patch enables cal=
lbacks
>> for sent messages and uses the debug callback for the --debug option, as
>> the recv callbacks do.
>
> I can't apply this, the patch is corrupted.
>
>> =C2=A0 =C2=A0 =C2=A0 cb =3D nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_D=
EFAULT);
>> - =C2=A0 =C2=A0 if (!cb) {
>> + =C2=A0 =C2=A0 s_cb =3D nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_DEFA=
ULT);
>> + =C2=A0 =C2=A0 if (!(cb && s_cb)) {
>
> I think (!cb || !s_cb) would be easier to read.
>
> johannes
>
>
>



--=20
Sean Robinson
WiFi Radar - http://wifi-radar.berlios.de
Python WiFi - http://pythonwifi.wikispot.org
pymnl - http://pymnl.wikispot.org

--000e0cd5cf7252b30c049eaf02cb
Content-Type: application/x-gzip;
	name="0001-Add-send-callbacks-with-optional-debug-handler.patch.gz"
Content-Disposition: attachment;
	filename="0001-Add-send-callbacks-with-optional-debug-handler.patch.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gldt7d350

H4sICB0igk0CAzAwMDEtQWRkLXNlbmQtY2FsbGJhY2tzLXdpdGgtb3B0aW9uYWwtZGVidWctaGFu
ZGxlci5wYXRjaACtVNty0zAQfY6+YuEpaWwjJ07iplxaLoWHwjC0fQJGo5sdUcfKWDJth/LvrJQU
MvDCMHiSyFrtOXvOSsppZ9cgy0OuD+dTKqaV4kXFuaITMZOzouCzspTzhS7E4YTDW9vCud5AvgBK
l/EDE0pzcoo0S1ziLXywwrQOEx87nF51u+lxveamyaRdPyUvuddLuFj1SWB6yzskyXOgi+WsXBY5
pHRBKTnvxRct/RI+vj+5ePHmM5woBU63CiRvGsHllYNr41dgN97YljegtOhrWPFWNbojpDGibcD1
m43tvNtDVbbbEmEmdFp+zQDVGAcb7uUKdMtFo/cAZAfwsNbO8RrXArJ3+OJXelf3Pj3Sh3Cabhe2
+hLgjoRwKLgnRtmMkHNTt1qltqpScfv3jUzTlIC5ziTcAT5zGIcHYzlUJlrAZtRaJTADBOsuCHHD
8Qgbj6obvZ2nI0KUqSpUXBsP/FGkFHEgplX6Biazw2lR5lk2o3LKiwnklM6LIijY5ROsfI85PoYU
EQkKCsMCMOA890aiDA+MbfeIybUaOt/10kPblHSS5yykaTiIQ4Jb0a/BKGbaTe/xRdwmBL4RGEjU
7WGHRRo4wJ8EDtZxB5/Au8uzM5w6PEC4cISIn3WYFJgtjsj4t5hjIbqfuXY1Uro6RINwpb8adYP0
9D6iuy4By3hXy6Noe1pS9DuelnlS/l/bg+8EgnOB9aNihmfIyqG5Zttz9gzenbEXz9nLV88vX8Py
5+z05PLsYnRE0oGpYPhAihG2EM2zf6ca31PB3R08CEyjuC2DatOh1QrtqdiahxUeVq3AW4glgstW
+8a0V7/uwKf24Sg0dIAQVDSJ77VFjO09qzqtWdyE0N+CFuFYFXT+3/sbLKGC0X51lIJmsUfOyivt
mcOvFMPIkz7dxROIHcC2IHTrIazgPwzjvbcM7+oG75r+A4auovFdZXgM9LfqeL1Ini2yIssJ+QH5
el2jrQUAAA==
--000e0cd5cf7252b30c049eaf02cb--
