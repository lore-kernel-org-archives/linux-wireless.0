Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23835 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbdKCJva (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 05:51:30 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Daniel Drake <drake@endlessm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: ath9k disconnects in 4.13 with reason=4 locally_generated=1
Date: Fri, 3 Nov 2017 09:51:19 +0000
Message-ID: <20171103095112.GA14915@jouni.qca.qualcomm.com> (sfid-20171103_105135_163956_FB139568)
References: <CAD8Lp47N8ENCPp0ELd5_H8efEna9FGemM-vvi0kf7=coG5tNXA@mail.gmail.com>
In-Reply-To: <CAD8Lp47N8ENCPp0ELd5_H8efEna9FGemM-vvi0kf7=coG5tNXA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 03, 2017 at 10:57:11AM +0800, Daniel Drake wrote:
> Endless OS recently upgraded from Linux 4.11 to Linux 4.13, and we now
> have a few reports of issues with ath9k wireless becoming unusable.
>=20
> In the logs we can see that it authenticates, associates and completes
> the WPA 4 way handshake, before then being disconnected with:
>=20
>  wlp2s0: CTRL-EVENT-DISCONNECTED bssid=3D74:26:ac:68:2f:c0 reason=3D4
> locally_generated=3D1

reason=3D4 is WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY. I'd expect the most
likely source of this to be one of the mac80211 code paths in mlme.c
where disconnection is triggered if the current AP become unreachable.
Getting a debug log from mac80211 might help in figuring out what is
causing this (there seem to be number of mlme_dbg() calls before most,
but not necessarily all, places where
WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY is used).

--=20
Jouni Malinen                                            PGP id EFC895FA=
