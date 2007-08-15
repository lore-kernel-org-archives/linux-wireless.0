Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dike.telenet-ops.be ([195.130.132.36]:34006 "EHLO
	dike.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175AbXHOPJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 11:09:27 -0400
Received: from ananke.telenet-ops.be (ananke.telenet-ops.be [195.130.137.78])
	by dike.telenet-ops.be (Postfix) with ESMTP id 7AC78301D7A
	for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2007 13:55:32 +0200 (CEST)
Message-ID: <46C2E992.5070805@telenet.be>
Date: Wed, 15 Aug 2007 13:54:58 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Subject: Re: warnings in iwlwifi
References: <1187133051.31200.26.camel@johannes.berg>
In-Reply-To: <1187133051.31200.26.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
>   CC [M]  drivers/net/wireless/iwl-base-3945.o
> drivers/net/wireless/iwl-base.c: In function =E2=80=98iwl_handle_data=
_packet_monitor=E2=80=99:
> drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in ex=
pression
> drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in ex=
pression
>   CC [M]  drivers/net/wireless/iwl-3945.o
>   CC [M]  drivers/net/wireless/iwl-3945-rs.o
>   CC [M]  drivers/net/wireless/iwl-base-4965.o
> drivers/net/wireless/iwl-base.c:2169: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2170: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2171: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2172: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2173: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2179: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2181: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2183: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2185: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c:2186: warning: large integer implicit=
ly truncated to unsigned type
> drivers/net/wireless/iwl-base.c: In function =E2=80=98iwl_handle_data=
_packet_monitor=E2=80=99:
> drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in ex=
pression
> drivers/net/wireless/iwl-base.c:3318: warning: integer overflow in ex=
pression
>=20
>=20
> I suspect most of them are caused by endianness bugs.
> This for example:
>=20
> 	le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
>=20
> looks totally bogus unless you somehow do macro magic to define the
> RX_RES_PHY...MASK in little endian...

iwl-hw.h:#define        RX_RES_PHY_FLAGS_ANTENNA_MSK            __const=
ant_cpu_to_le16(0xf0)


I don't understand how this would generate the warning though

>=20
> Maybe it's time for you to get a cross compiler or better yet buy a
> big-endian machine and actually test things on that? :)
>=20

No need for these drastic comments, for two warnings imho ;-)
We all know that one typo can make gcc very upset.
And actually i believe somebody has a big endian anyways. Zhu Yi anounc=
ed that once
and judging from the git commits i'm guessing it's Tomas Winkler.

one of the warnings was already fixed in iwlwifi git yesterday
http://intellinuxwireless.org/repos/?p=3Diwlwifi.git;a=3Dcommit;h=3Db7c=
e8c9f73b44a2f91424ce522844bb29e23a739
which will take care of the 2xxx warnings.

I'm predicting that patch will arrive on linux-wireless soon too.
(took me quite some time to figure this out, because I was looking at t=
he iwlwifi git)



Ian

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
