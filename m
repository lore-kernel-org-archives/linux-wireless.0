Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g19.free.fr ([212.27.42.30]:41987 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYJNTUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:20:16 -0400
Message-ID: <48F4F0E9.8070706@free.fr> (sfid-20081014_212021_656995_0D69A404)
Date: Tue, 14 Oct 2008 21:20:09 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix scan RX processing oops
References: <20081011002955.GA15802@jm.kir.nu>	 <1223685486.29811.17.camel@johannes.berg>	 <20081011004828.GB15802@jm.kir.nu> <1223686439.29811.27.camel@johannes.berg>
In-Reply-To: <1223686439.29811.27.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a =E9crit :
> On Sat, 2008-10-11 at 03:48 +0300, Jouni Malinen wrote:
>> On Sat, Oct 11, 2008 at 02:38:06AM +0200, Johannes Berg wrote:
>>>> -	ieee80211_rx_bss_put(sdata->local, bss);
>>>> +	if (bss)
>>>> +		ieee80211_rx_bss_put(sdata->local, bss);
>>> I keep falling into that trap, maybe the put function should just h=
andle
>>> NULL instead...
>> I though about that for half a second or so ;-) and ended up doing t=
his
>> instead after checking that other ieee80211_rx_bss_put() calls were =
only
>> passing in non-NULL values. Anyway, I would be fine with _put() bein=
g
>> able to handle NULL, too.
>=20
> I looked at it before and for some reason decided against it too. Let=
's
> stick to this patch, I'll re-evaluate making it handle NULL.
>=20
>> PS.
>>
>> I don't know what exactly was triggering this oops (or well, what wa=
s
>> triggering ieee80211_bss_info_update() to return NULL to be more exa=
ct),
>> but it was happening very consistently in our office (but not anywhe=
re
>> else I've been this week).
>=20
> Strange. You probably have a mesh network with bogus mesh config or m=
esh
> ID IEs, I can't see the allocation fail consistently in your office ;=
)
>=20
>> It was kind of funny to see that oops at the
>> very moment when I was convincing people in a meeting that we can ch=
ange
>> mac80211 and should do so if it is the best location for something a=
nd
>> makes it easier to implement something in a driver.. ;-)
>=20
> Ouch, sorry :)
>=20
> johannes

Acked-by: Benoit Papillault <benoit.papillault@free.fr>

BTW, This is indeed Mesh Config IE received with incorrect mesh_id_len
(8 bytes instead of 19 bytes as expected). I really think the current
patch is the correct one.

Regards,
Benoit
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
