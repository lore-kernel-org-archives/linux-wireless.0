Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbeH1PoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 11:44:19 -0400
From: <murugana@codeaurora.org>
To: "'Johannes Berg'" <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
Cc: "'Felix Fietkau'" <nbd@nbd.name>
References: <1534423635-28222-1-git-send-email-murugana@codeaurora.org>  (sfid-20180816_144745_205490_C47B9321) <1535450281.5895.34.camel@sipsolutions.net>
In-Reply-To: <1535450281.5895.34.camel@sipsolutions.net>
Subject: RE: [PATCH] mac80211: WFA Multi-AP backhaul STA Rx requirement
Date: Tue, 28 Aug 2018 17:22:56 +0530
Message-ID: <003d01d43ec5$ab42fb00$01c8f100$@codeaurora.org> (sfid-20180828_135304_100588_71CA833C)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Hmm. The subject/patch title isn't very clear - does it *implement* =
this
> requirement? Or do something else with it? Please clarify.
>=20

Yes, this patch implements the missing Rx requirement (ii) for backhaul =
STA
below.
..

> > Receiver requirements
> > ---------------------
> > 1. Fronthaul AP
> >         i) When SA!=3DTA of backhaul STA, must support receiving =
4-address
> >            format frames
> >         ii) When SA=3D=3DTA of backhaul STA, must support receiving =
both
> >             3-address and 4-address format frames
> >
> >             (mac80211 support both 3-addr & 4-addr via AP/VLAN
> > interface)
> >
> > 2. Backhaul STA
> >         i) When DA!=3DRA of backhaul STA, must support receiving =
4-address
> >            format frames
> >         ii) When DA=3D=3DRA of backhaul STA,  must support receiving =
both
> >             3-address and 4-address format frames
> >
> >             (mac80211 support only receiving 4-address format via
> >              use_4addr)
> >
> > This patch addresses the above Rx requirement (ii) for backhaul STA.

This patch implements the Rx requirement (ii) of receiving unicast =
3-addr frames in
addition to 4-addr format frames.

Thanks,
Sathishkumar
