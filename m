Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:46208 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761459AbZANPrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 10:47:17 -0500
Message-ID: <496E08FD.9030803@lwfinger.net> (sfid-20090114_164722_082660_E1EB346F)
Date: Wed, 14 Jan 2009 09:47:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Eliminate compilation warning in b43_op_set_key
References: <496d2fc9.UiHMYJR2melvWyoO%Larry.Finger@lwfinger.net> <20090114133417.GB18634@tuxdriver.com>
In-Reply-To: <20090114133417.GB18634@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Tue, Jan 13, 2009 at 06:20:25PM -0600, Larry Finger wrote:
>> A recent pull from wireless testing generates the following warning:
>> =20
>>    CC [M]  drivers/net/wireless/b43/main.o
>>  drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_set_ke=
y=E2=80=99:
>>  drivers/net/wireless/b43/main.c:3636: warning: pointer type mismatc=
h
>>  in conditional expression
>>
>> This fix was suggested by Johannes Berg <johannes@sipsolutions.net>.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> Index: wireless-testing/drivers/net/wireless/b43/main.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
>> +++ wireless-testing/drivers/net/wireless/b43/main.c
>> @@ -3630,10 +3630,12 @@ static int b43_op_set_key(struct ieee802
>> =20
>>  out_unlock:
>>  	if (!err) {
>> +		u8 bcast[ETH_ALEN];
>> +		memset(bcast, 0xff, ETH_ALEN);
>=20
> Isn't there a statically-allocated array w/ the broadcast MAC in it
> somewhere already?
>=20

Not that I could find.

There are several places in mac80211 where the broadcast MAC is
created on the fly. None of them would benefit from having a static
array - one would just substitute memcpy for memset and possibly trash
the cache.

There is an array broadcast[MAX_ADDR_LEN] in struct net_device, but it
would need to be initialized with 0xFF's before usage.

I still think that b43 needs to create this array, and that the best
place to do it is in the error path that is unlikely to be executed.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
