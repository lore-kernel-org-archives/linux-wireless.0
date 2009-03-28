Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:34235 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbZC1VwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 17:52:09 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: p54spi - mesh mode summary
Date: Sat, 28 Mar 2009 22:51:42 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903271506.10614.chunkeey@web.de> <200903280621.02362.jcmvbkbc@gmail.com>
In-Reply-To: <200903280621.02362.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903282251.42585.chunkeey@web.de> (sfid-20090328_225213_096337_40D3AD31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 28 March 2009 04:21:02 Max Filippov wrote:
> > That's odd.
> >
> > P54_FILTER_TYPE_TRANSPARENT should be already set for mesh mode.
> >
> > The reason is that mesh mode will automatically set the FIF_OTHER_B=
SS flag,
> > (file:net/mac80211/iface.c func:ieee80211_open lines:251 f)
> >
> > which in turn ORs the P54_FILTER_TYPE_TRANSPARENT flag to the mode.=
=2E.
> > (file:drivers/net/wireless/p54/p54common.c func: p54_setup_mac line=
s: 1691
> > f)
> >
> > So, there's no need to OR a flag that gets ORed anyway?
>=20
> Found the problem, that's my fault at merge of omap and wireless-test=
ing=20
> trees:
> p54_configure_filter that I tested with has the following code:
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 *total_flags &=3D FIF_PROMISC_IN_BSS |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 FIF_OTHER_BSS |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 (*total_flags & FIF_PROMISC_IN_BSS) ?
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FIF_FCSFAIL : 0;
>=20
> which does not what it is intended to. '|' operator has higher preced=
ence=20
> than '? :'
> thus it is equivalent to *total_flags &=3D FIF_FCSFAIL; which never y=
ields=20
> neither
> FIF_PROMISC_IN_BSS nor FIF_OTHER_BSS.
>=20
> Current wireless-testing head has=20
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 *total_flags &=3D FIF_PROMISC_IN_BSS |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 FIF_OTHER_BSS;
>=20
> at this place, which work fine.
Yup that was fixed by "p54: misplaced parentheses"
( c1359ddff01dc63b2770f876a94b6dd97e0473f6 )
and FCS_FAIL was removed by "p54: completely ignore rx'd frames with ba=
d FCS"
( adda7e08403adf0980efb69ffe339567df8eb8d1 )=20

your last patches had some offset, do you have more code fixes or
does everything work (properly)?

Regards,
	Chr
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
