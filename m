Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp7-g19.free.fr ([212.27.42.64]:38300 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbYLLIta (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 03:49:30 -0500
Message-ID: <49422598.5050204@free.fr> (sfid-20081212_094935_238432_831215B4)
Date: Fri, 12 Dec 2008 09:49:28 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] ath5k : Fix correct padding
References: <49418D23.8060905@free.fr>  <1229033298.15776.18.camel@brick>	 (sfid-20081211_230823_881207_DB5831F0) <1229033411.8081.91.camel@johannes.berg>
In-Reply-To: <1229033411.8081.91.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a =E9crit :
> On Thu, 2008-12-11 at 14:08 -0800, Harvey Harrison wrote:
>> On Thu, 2008-12-11 at 22:58 +0100, Benoit PAPILLAULT wrote:
>>> Padding the 802.11 header to a multiple of 4 bytes needs to be done=
 only
>>> for DATA frames. This fixes a bug where 2 bytes were missing in mon=
itor
>>> mode for ACK frames.
>> Without commenting on whether or not this is needed
>>
>>>   		/*
>>> @@ -2623,6 +2629,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_b=
uff *skb)
>>>   	unsigned long flags;
>>>   	int hdrlen;
>>>   	int pad;
>>> +	const struct ieee80211_hdr * hdr =3D (const struct ieee80211_hdr =
*)skb;
>> skb->data perhaps.
>=20
> For sure, there's a second place like that too.
>=20
> johannes

Nice catch! I wonder how it was working in my preliminary tests. Sorry=20
for the duplicates with the same patch for ath9k. The padding/unpadding=
=20
stuff is needed by the hardware, ie the hardware insert padding on RX=20
and expect padding on TX, as mentioned in earlier ath5k and madwifi=20
source code.

According to my tests, there are 4 kinds of frames:
- Management
- Control
- Data (including QoS data)
- Invalid

Management frames have a fixed header of 24 bytes, so are already a=20
multiple of 4. Control frames are either 10 (ACK!) or 16 bytes and it's=
=20
clear that none of them needs padding (hence the current bug). Data=20
frames can be 24, 26, 30 or 32 bytes so it clearly needs some=20
padding/unpadding in some cases. At last, we don't care about Invalid f=
rame.

The ath9k patch does padding/unpadding for hdrlen >=3D 24, which appear=
s=20
to be equivalent and simpler to compute. I will rewrite the patch using=
=20
the ath9k formula.

Regards,
Benoit
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
