Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:34518 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754127AbcI0I4z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 04:56:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 27 Sep 2016 10:53:28 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Amitkumar Karwar <akarwar@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: Re: [PATCHv2] mac80211: check A-MSDU inner frame source address on AP
 interfaces
In-Reply-To: <1474963267.5141.11.camel@sipsolutions.net>
References: <1474802886-27220-1-git-send-email-michael-dev@fami-braun.de>
 (sfid-20160925_132809_451078_E31A6EC3)
 <1474963267.5141.11.camel@sipsolutions.net>
Message-ID: <dbc9f09e4d932d808fed99ebd02301c0@fami-braun.de> (sfid-20160927_105705_240282_41686FED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 27.09.2016 10:01, schrieb Johannes Berg:
> ...
>=20
> This leaves "eth_80211" uninitialized if has_80211_header is false.
>=20
>> @@ -768,6 +768,13 @@ void ieee80211_amsdu_to_8023s(struct sk_buff
>> *skb, struct sk_buff_head *list,
>> =C2=A0		subframe_len =3D sizeof(struct ethhdr) + len;
>> =C2=A0		padding =3D (4 - subframe_len) & 0x3;
>> =C2=A0
>> +		if (unlikely(has_80211_header &&
>> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(iftype =3D=3D NL80211_IFTYPE_AP ||
>> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iftype =3D=3D NL80211_IFTYPE_AP_=
VLAN) &&
>> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0!ether_addr_equal(eth_80211.h_source,
>> eth.h_source)
>> +		=C2=A0=C2=A0=C2=A0))
>> +			goto purge;
>=20
> And this then compares against uninitialized data, so this won't work.

but it only compares against eth_80211 if has_80211_header is true due=20
to order of evaluation, which in turn implies eth_80211 is initialized,=20
right?

michael
