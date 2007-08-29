Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213AbXH2NiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 09:38:20 -0400
Subject: Re: mac80211 problems
From: Dan Williams <dcbw@redhat.com>
To: Jesse Shaver <J_shaver@comcast.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708281025.50899.J_shaver@comcast.net>
References: <200708281025.50899.J_shaver@comcast.net>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Aug 2007 09:32:51 -0400
Message-Id: <1188394371.18746.3.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-08-28 at 10:25 -0400, Jesse Shaver wrote:
> Hello All;
> I am sorry for bothering this dev list with this question, but I can'=
t seem to=20
> find an answer anywhere else...
>=20
> I am trying to get my Intel 4965AGN wireless to work under SuSE 10.2 =
(64bit)=20
> no a Lenovo X61 Core duo 2. I am trying to build mac80211 for it, but=
 am=20
> getting errors.=20
>=20
> my kernel is:
> hayden:~/mac80211-9.0.4 # uname -a
> Linux hayden 2.6.18.8-0.5-default #1 SMP Fri Jun 22 12:17:53 UTC 2007=
 x86_64=20
> x86_64 x86_64 GNU/Linux
>=20
> The error I get is:
>=20
> net/mac80211/ieee80211_sta.c: In function =E2=80=98sta_process_csa=E2=
=80=99:
> net/mac80211/ieee80211_sta.c:2546: warning: format =E2=80=98%d=E2=80=99=
 expects type =E2=80=98int=E2=80=99,=20
> but argument 2 has type =E2=80=98size_t=E2=80=99

The '%d' here should probably be a '%z' or a '%p' if it's a pointer.

>   CC [M]  net/mac80211/ieee80211_iface.o
>   CC [M]  net/mac80211/ieee80211_rate.o
>   CC [M]  net/mac80211/michael.o
>   CC [M]  net/mac80211/regdomain.o
>   CC [M]  net/mac80211/tkip.o
>   CC [M]  net/mac80211/aes_ccm.o
>   CC [M]  net/mac80211/wme.o
>   CC [M]  net/mac80211/ieee80211_cfg.o
>   CC [M]  net/mac80211/ieee80211_led.o
>   CC [M]  net/mac80211/debugfs.o
> net/mac80211/debugfs.c: In function =E2=80=98mac80211_open_file_gener=
ic=E2=80=99:
> net/mac80211/debugfs.c:28: error: =E2=80=98struct inode=E2=80=99 has =
no member=20
> named =E2=80=98i_private=E2=80=99

Seems like a kernel/mac80211 mismatch?  What kernel are you using, and
where are you getting your mac80211 from?  This probably means you're
using a quite-recent mac80211 with an older kernel and stuff has
changed.

Dan

> make[2]: *** [net/mac80211/debugfs.o] Error 1
> make[1]: *** [net/mac80211] Error 2
> make: *** [net] Error 2
>=20
> I do have some programming background, but very little in C/C++ and o=
nly=20
> limited kernel compiling experience.
>=20
> thanks for any help you can give, sorry to bother you all.
>=20
> -Jesse Shaver
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
