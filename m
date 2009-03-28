Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56393 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZC1D3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 23:29:06 -0400
Received: by bwz17 with SMTP id 17so1227343bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 20:29:02 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: p54spi - mesh mode summary
Date: Sat, 28 Mar 2009 06:21:02 +0300
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903270803.54820.jcmvbkbc@gmail.com> <200903271506.10614.chunkeey@web.de>
In-Reply-To: <200903271506.10614.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903280621.02362.jcmvbkbc@gmail.com> (sfid-20090328_042917_234280_94B5168B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> That's odd.
>
> P54_FILTER_TYPE_TRANSPARENT should be already set for mesh mode.
>
> The reason is that mesh mode will automatically set the FIF_OTHER_BSS=
 flag,
> (file:net/mac80211/iface.c func:ieee80211_open lines:251 f)
>
> which in turn ORs the P54_FILTER_TYPE_TRANSPARENT flag to the mode...
> (file:drivers/net/wireless/p54/p54common.c func: p54_setup_mac lines:=
 1691
> f)
>
> So, there's no need to OR a flag that gets ORed anyway?

=46ound the problem, that's my fault at merge of omap and wireless-test=
ing=20
trees:
p54_configure_filter that I tested with has the following code:

=C2=A0 =C2=A0 =C2=A0 =C2=A0 *total_flags &=3D FIF_PROMISC_IN_BSS |
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 FIF_OTHER_BSS |
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (*total_flags & FIF_PROMISC_IN_BSS) ?
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FIF_FCSFAIL : 0;

which does not what it is intended to. '|' operator has higher preceden=
ce=20
than '? :'
thus it is equivalent to *total_flags &=3D FIF_FCSFAIL; which never yie=
lds=20
neither
=46IF_PROMISC_IN_BSS nor FIF_OTHER_BSS.

Current wireless-testing head has=20

=C2=A0 =C2=A0 =C2=A0 =C2=A0 *total_flags &=3D FIF_PROMISC_IN_BSS |
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 FIF_OTHER_BSS;

at this place, which work fine.

--=20
Thanks.
-- Max
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
