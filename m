Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36138 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbdAIVal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 16:30:41 -0500
Received: by mail-pf0-f182.google.com with SMTP id 189so21483195pfu.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 13:30:40 -0800 (PST)
Date: Mon, 9 Jan 2017 13:30:32 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>
Cc: "M. Braun" <michael-dev@fami-braun.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] bridge: multicast to unicast
Message-ID: <20170109133032.221f8669@xeon-e3> (sfid-20170109_223054_213510_150B1D9A)
In-Reply-To: <20170109212345.GA5513@otheros>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
        <1483706872.4089.8.camel@sipsolutions.net>
        <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
        <1483710841.12677.1.camel@sipsolutions.net>
        <22fad045-57c6-7789-d19f-f47bd0faf441@fami-braun.de>
        <20170107145516.GE3134@otheros>
        <1483949336.17582.3.camel@sipsolutions.net>
        <6f5ec9f1-800a-2bc4-2f41-9d803343bb22@fami-braun.de>
        <20170109212345.GA5513@otheros>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 9 Jan 2017 22:23:45 +0100
Linus L=C3=BCssing <linus.luessing@c0d3.blue> wrote:

> On Mon, Jan 09, 2017 at 12:44:19PM +0100, M. Braun wrote:
> > Am 09.01.2017 um 09:08 schrieb Johannes Berg: =20
> > > Does it make sense to implement the two in separate layers though?
> > >=20
> > > Clearly, this part needs to be implemented in the bridge layer due to
> > > the snooping knowledge, but the code is very similar to what mac80211
> > > has now. =20
> >=20
> > Does the bridge always know about all stations connected? =20
>=20
> The bridge does not always know about all stations, especially the
> silent ones like in your DVB-T example.
>=20
> However, concerning IP multicast, there is IGMP/MLD. So the bridge
> does know about all stations which are interested in a specific IP
> multicast stream.
>=20
> (As long as there is a querier on the link, which periodically
> queriers for IGMP/MLD reports from any listener. If there is no
> querier then the bridge multicast snooping, including the bridge
> multicast-to-unicast will fall back to flooding)
>=20
>=20
> So if your television example uses IP multicast properly, it is
> completely doable with the bridge multicast-to-unicast, thanks to
> IGMP/MLD.

I wonder if MAC80211 should be doing IGMP snooping and not bridge
in this environment.
