Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792634238;
	b=Bmh+tFlsM2LY5C+kQ830tVLM+9+IHspx7qQyPXRuLr1+VzQcjHQoHYC9gDez1jOavUqR
	 IUZHVQmbEQR4qhua8hHeIXl3Q/ghM8wh1rOEwIfKxgqnfBGydSIKAlkToT2gHR6cokIci
	 kqqBxBqWcKhoWHRkn1g4e4Mr/wVNzGEQ0m4HWtxFWBq+3dzK/K0nvMpCj6jxwMtExj6Qh
	 i+HoC3bcL9FsY60XVyshRYRQvIh5WqhEQyQBM8Ohn5Gxfy3ffAr22rlFs62bP3LxaeUJb
	 6cPseilsBd/MrL4E0cbbloCbKZlHowGFNaTqDfP7qbXsd7q4lMtgrQxBITx+2ID7z4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792634238;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=wYxGzKCCa2yPfbDGbArkQyPL1l0u8zPPbvHLEtaCmgg=;
	b=tpSNc+BRyFP/Krq+00dqKtIE8hHiKlBVOL366RGW0/W8HiIgiJ44UwU1In7cfPEaNJUw
	 zKq6Riatm7TC1VL3VSO6s5AGHIi8m9u5HVMTxa+5xr0GG38zKQ9HoHy5jCGRZ0oe1tcOl
	 vkb0zvUHDTtDXWQVZloJy3/WbVjmPniHrbs6qAWwNaYE0LTZdMrESWPQdb829RQftS4xS
	 Eyua0YKkcuIxbp0rD9e/lWu0hBNM4SXA4wI4AzijymY2jTl+hkxk+Jwt5LiPrJ/+7SC8a
	 veGjoM0LWx5fC+tZ/ZxR47DWHIXIqh7ExHD4RymjzvWGiOwZzj8ibCxgxZ80LW5+ocw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ljZg7vcO;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DF9606A330;
	Thu, 22 Oct 2026 01:57:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2DF9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ljZg7vcO
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M1v95R1458945, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792634229; bh=wYxGzKCCa2yPfbDGbArkQyPL1l0u8zPPbvHLEtaCmgg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ljZg7vcOOYpbfZGsczFubyTuKWqjhFl352Hkx43/6MjyZVIwe57A5a1gCQx9+P1Hc
	 sB0qYZ6pn2UjfqZ6eHqtZkX3He/7lJ5LReQ0Js7gx20cUxa/CDTXn6NH1PRYk+fpBY
	 1nGrLOTBKT3psgU4uQ3eb1ukVf/KTZ09dk6xkxKHQiO60tn5VjXSQPqBQZNC+5F0Lv
	 1eDUX45jRENJYciMzNIJQH852pls1KtW/oSCp83J6ef7KGWi1HAvKhAyES4YMwg3oB
	 Mtxqfx4NNaj7/jlkye/o1nZGfqejKbCYRJagX11hFuWgTetqyKhJ8Fb/91RB4dHjP3
	 adjExjT6FA0HQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M1v95R1458945
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 09:57:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 09:57:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 09:57:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v8 3/3] wifi: rtw88: time the countdown downloads
 from the TBTT
Thread-Topic: [PATCH rtw-next v8 3/3] wifi: rtw88: time the countdown
 downloads from the TBTT
Thread-Index: AQHdYVG5djpPj/fIckGJSuvv3erNy7cIzouA
Date: Thu, 22 Oct 2026 01:57:08 +0000
Message-ID: <c800f60296574fde830eced728ec0096@realtek.com>
References: <20261021114543.4132776-1-mehmet.fide@gmail.com>
 <20261021114543.4132776-4-mehmet.fide@gmail.com>
In-Reply-To: <20261021114543.4132776-4-mehmet.fide@gmail.com>
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
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
> The countdown downloads are queued one beacon interval apart, with no
> relation to the TBTT. A download that runs late past the next TBTT
> leaves a count out of the air.
>=20
> Queue each download 10 ms after the next TBTT, read from the TSF, so it
> may run late by almost a beacon interval; a later one is followed by
> the next at once. A TSF jump, an IBSS merge or a reset, restarts the
> schedule from the next TBTT.
>=20
> A TBTT just before the start may already have sent the first count; it
> is taken as the one that did, so no count is sent twice.
>=20
> The USB chips raise no TBTT interrupt, so the TSF register is read. The
> beaconing interface is always on port 0: rtw_core_port_switch() moves
> an AP there, an IBSS runs alone.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


