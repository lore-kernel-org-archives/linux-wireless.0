Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60979 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752081AbeEGVad (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 17:30:33 -0400
Date: Mon, 07 May 2018 23:30:31 +0200
In-Reply-To: <1525728090.6222.1.camel@sipsolutions.net>
References: <20180219170224.14816-1-toke@toke.dk> <20180219170224.14816-3-toke@toke.dk> (sfid-20180219_180319_201142_47E9DB27) <1525728090.6222.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH 2/3] iw: Print TXQ statistics for stations and interfaces
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <C105BD5A-5307-45D1-B91A-0E9833671B92@toke.dk> (sfid-20180507_233037_875892_28F63851)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 7 May 2018 23:21:30 CEST, Johannes Berg <johannes@sipsolutions=2Enet> w=
rote:
>On Mon, 2018-02-19 at 18:02 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
>>=20
>> +	if (header && tid >=3D 0)
>> +		pos +=3D snprintf(buf, buflen, "\n\t\tTID\tqsz-byt\t"
>> +				"qsz-pkt\tflows\tdrops\tmarks\toverlmt\t"
>> +				"hashcol\ttx-bytes\ttx-packets");
>> +	else if (header)
>> +		pos +=3D snprintf(buf, buflen, "\n\t\tqsz-byt\t"
>> +				"qsz-pkt\tflows\tdrops\tmarks\toverlmt\t"
>> +				"hashcol\ttx-bytes\ttx-packets");
>> +
>> +	if (tid >=3D 0)
>> +		pos +=3D snprintf(pos, buflen - (pos - buf), "\n\t\t%d", tid);
>> +	else
>> +		pos +=3D snprintf(pos, buflen - (pos - buf), "\n\t");
>> +
>> +	txqinfo =3D txqstats_info[NL80211_TXQ_STATS_BACKLOG_BYTES];
>> +	if (txqinfo)
>> +		pos +=3D snprintf(pos, buflen - (pos - buf), "\t%u",
>> +				nla_get_u32(txqinfo));
>
>since the header is fixed, shouldn't all of these get an else branch
>that just prints a tab or so?

Ah, right, good point=2E Didn't think about what would happen if any of th=
e fields were actually omitted=2E Will fix that as well :)

-Toke
