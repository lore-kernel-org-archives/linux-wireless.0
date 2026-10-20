Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792460902;
	b=c/N0mxwX+uA8kdr8/eDyvrXb1xpUmvI9AXZoYVdF4nkSkVrQjehQvhgTd8aAkbrmNCgz
	 4PHRTbkhp7Get+YiTzxeY9o5lndSZr8KIAJ/t8giL3VN5Uqwoj7/RJYFtY4kOq/7iR2oD
	 NyOqd4ulpK7s2oHFpd4KWf8GlnLtc0GvcoBKvy8eVSGYddej7vm0hJBzS8jqJrFHfQWe0
	 RzkZ1fPckFq3joLqm9WQt78yPzqwCEjxK/Bcr6YC6alOHP4H5IH18bh7Bm/bzDjVV6CKz
	 5BNDxF5y1fAIs6hWnwfB9medOVX8UiBxgzYfrFQABt8m4uu9HyYoD7N7E0cxsn7CaDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792460902;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=otP8PFpD2mqwoHzL9Okmm5HXHVYcZk11YLP3TZLrwXQ=;
	b=RVQzUfU5AFFgzTzXFPZMiYdkPLAHclXiD14X7RuWX+GUIn0ZmcILY3s9L5cYtCXLTz/S
	 oq718158d1P9QMDiyVkYXCCj4zs5LiwYNMhkr7VEfSJ+a6MPFfAy5otABkZKzpHxzBQSO
	 LtrnYg3i7hqVVb9mMsuHY3R8zLC3nwiSb9bsfnOzo9MPzDZC04jixBFnfgtHvChIVsDyN
	 PLpUgVB3b5iq5PJCgC5PpvBWT//ty6j9lYjAFKxTmTDyRQadglGKosSHWY76t5ym2P3my
	 9yvggXfJbUJi3+KNqNZOZTzHkcLBD/WBTzYKtw9ZlZ45lvXhH/Cl1jZjrZwLmlN/zUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=BFnDrK8v;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A38606A319;
	Tue, 20 Oct 2026 01:48:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11A38606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=BFnDrK8v
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69K1mE6V12556592, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792460894; bh=otP8PFpD2mqwoHzL9Okmm5HXHVYcZk11YLP3TZLrwXQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=BFnDrK8v1tySsBEAVSAMe3wz6x1ZGPZqR0owsV7HyaTn7IA4erIY4xo/o/2X/RCu6
	 NgXBIgV0b1YL0kcIdbs/qmqm0vcX7XZ/xvvdwa5kv5p418mB1D5P2jEJrS9kU49WVq
	 MT90pDkkPYvaqjN6YXcrVUAAtfeZIzxnN2K7iUVoSJnQoHFekQRtdNj0ietZm2iytb
	 j9LhUtqtnxn9NGMnc4Seap3Xsjunx1T32w8KM+Ull3Le8qKV9BPVyE6JI1wlLwaLAZ
	 TSUBiWpmNuyTNSGw9w+GkUashokxM7wAKlkwgnnrv/edWwI79LlMg5jgp6TmyKRGB2
	 6TLMi9EHXd5hA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69K1mE6V12556592
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 20 Oct 2026 09:48:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 09:48:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 20 Oct 2026 09:48:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdWuS02ghpGGHw90yaRSTFSDbFibcEOBOw///UiICAAIlYUP//nzSAgAF6XrA=
Date: Tue, 20 Oct 2026 01:48:13 +0000
Message-ID: <9aac793dbdcf4c4d99800418c16a7346@realtek.com>
References: <f4aea8175e4f4082afd50fa94787137d@realtek.com>
 <20261019105643.3282423-1-mehmet.fide@gmail.com>
In-Reply-To: <20261019105643.3282423-1-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> Hi Ping-Ke,
>=20
> On 2026-10-19, Ping-Ke Shih wrote:
> > It'd be better to see every count stays on the air. Will you implement
> > to handle TBTT events? Can you share a draft first or a separate patch
> > (e.g. patch 3/3 to improve missing count)?
>=20
> The USB chips raise no TBTT interrupt, so the countdown work reads the
> TSF and queues itself for 10 ms after the next TBTT. That gives a
> download about 80 ms to run late before a beacon goes out without it;
> one later than that is still followed by its successor at once, as in
> v6. A TSF that moved by more than a beacon interval, an IBSS merge or
> a reset, restarts the schedule from the TBTT ahead.
>=20
> On the 8821CU the downloads land 13 to 22 ms after the TBTT; with a
> 60 ms delay on every second download the sniffer saw 9, 8, 7, 6, 5,
> 4, 3, 2, 1 for count 10, with 95 ms it saw 9, 8, 8, 6, 6, 4, 4, 2, 2,
> and the AP switched at the same time in all cases.

Do the 60 / 95 ms delay here to substitute 10ms of
" delay =3D csa_tbtt + 10ms - read_tsf();" below?

I think 10ms is reasonable. Not sure what is the purpose of 60/95ms ?

>=20
> The idea, on top of 2/2:
>=20
>         /* csa_start: the first download goes with the TBTT ahead */
>         tsf =3D read_tsf(rtwvif->port);     /* 64 bit, 0x560 for port 0 *=
/
>         csa_tbtt =3D tsf - tsf % beacon_int;

FYI.=20
Use proper functions to do 64-bit arithmetic, like div_u64_rem().

>         csa_queue();
>=20
>         /* csa_queue, after every download */
>         csa_tbtt +=3D beacon_int;           /* the TBTT this download is =
for */
>         delay =3D csa_tbtt + 10ms - read_tsf();
>         if (delay > beacon_int + 10ms || delay < -beacon_int)
>                 /* the TSF moved (IBSS merge, reset): start over */
>                 csa_tbtt =3D next TBTT after now, delay =3D csa_tbtt + 10=
ms - now;
>         queue_delayed_work(csa_beacon_work, max(delay, 0));
>=20
> So a download on time runs 10 ms after its TBTT;

Can you measure this on USB 2.0 port with some traffic?
My concern is that low speed port with traffic results in missing countdown=
.
But it might be equal or better than v6, not worse.

> one late by less
> than ~80 ms still makes the next beacon; one later than that gets a
> delay of zero for its successor, the catch-up of v6. Nothing else
> changes, the download and ieee80211_csa_finish() stay as they are.
>=20
> One thing I do not have: the TSF registers of the ports other than 0,
> for an AP that comes up next to a station interface. rtw88 only names
> REG_USTIME_TSF; is it 0x568 for port 1, and where are ports 2 to 4?

See rtw_hal_get_tsftr_by_port() [1]

[1] https://github.com/kimocoder/88x2cu/blob/main/hal/hal_com.c#L13181

> If this is the way you want it, it becomes patch 3/3 of v7 with 1/2
> and 2/2 unchanged.

It is nice to me that the sniffer saw perfect countdown. Do you have
any concern about reading TSF as parameters of CAS work delay?

Ping-Ke

