Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792637409;
	b=3WH4Rzs+q24Wfrth4ceTNqT141OoieRc24V2wAaciCNlim95Xn70LgQR7YlczBsXKfrZ
	 7esb7m7slzHusdyC4TrOySV1ZiyEZFZCtCTjpcqZAAozhJw352YKfnvFVgc2RTFSso5Z6
	 n8t4zHGDfZ96QOigrrQaP1gaxYzIKA1YPHKdxkKnGqn6ZDJeTDPZ0VMjAz/G/LstZMZsU
	 DKAVM3bqM7q3kflcKGB3kReq102H3S4tS3lC0JcTeXwkKX+MrMWW77sOeGzD4E22xHBW+
	 DZY6F8QavtikhkQSDxy8jFcYcnTlSPMQQstxK9VJh2lI34uYgla5h8DIcF+MyjqORjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792637409;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=FJCFbVzqe1ll1/rPyyK4zNzjb9ec5ROk/H5gzhxYU5o=;
	b=dXO7Fg3+fOPhAf1e914M4eMPYhykXtyT3x+J9MkjdD9Mb9EUI9zkYoSAoDpWXnOZYYoA
	 wZKvvDGuYxH8HyrQadr/5H0XJ6meNnIx3+eylzhUldSV7NVBKzuq5jR+WXKQBISVuJ3OJ
	 /+C0KvPM3PsDKlP7fujm1npxY9Kgdh9m+wyT0VIHJ6RzolZIsDQruEEPTmZNyorYFbVbl
	 tPv23GPA0KWS1v31h3mZ4wzlairBkiYzE/BqKB73R8llmPXEmRyKgx7To8cguHzuXeLhc
	 Wh7Kss0PKZiOlNZlGWUs7srLHCfT+DquQGyUGhvIy0cC+8mSZlsN47sI8TlBVxtuAtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ERD1RuBZ;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F64F606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F64F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ERD1RuBZ
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M2nvhmF497975, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792637397; bh=FJCFbVzqe1ll1/rPyyK4zNzjb9ec5ROk/H5gzhxYU5o=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ERD1RuBZkNGxxyDBpp7H5VvIba4zYWPLpR+0hMq0Tzk4TVvVjzOjfaby0x6hlOZuX
	 nLvhIBcUGYuBhRPhwwiUf8s9bRVEHqV+dNx6G/PD2H+hN+hZatsHucAyd4EyRj5d33
	 hpv3Nl9p1XF3Aiicb5N96DIS7QBAHmPZ+6w/qTybs/xZ6WkgF5/n/DNgxzpNuzeAz6
	 /TXlYv8qIUuTzSDgBRo6iri/NGR5vX0f2S0ebvKyswUWc/0WcoM1HXqiRIt51G3tPM
	 JG+0Za1hqc5kq2T98wLLeeZ8GMOXBj5s0k+zBhw6ELTsDv6CicCEUS1MiwLxfpXhyU
	 Kf8/sbPm+gO2Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M2nvhmF497975
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 10:49:57 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 10:49:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 10:49:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 10:49:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Jiaxin Li <18135327133@163.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 1/1] wifi: rtl8180: reject RX frames longer than
 MAX_RX_SIZE
Thread-Topic: [PATCH v3 1/1] wifi: rtl8180: reject RX frames longer than
 MAX_RX_SIZE
Thread-Index: AQHdYWVdKjIgqTJiwkGtFfS/HXRPOLcI3Q4Q
Date: Thu, 22 Oct 2026 02:49:54 +0000
Message-ID: <59bba0199d1a435f983d76a550929898@realtek.com>
References: <20261021135906.1493-1-18135327133@163.com>
 <20261021135906.1493-2-18135327133@163.com>
In-Reply-To: <20261021135906.1493-2-18135327133@163.com>
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

Jiaxin Li <18135327133@163.com> wrote:
> rtl8180_handle_rx() passes the 12-bit length field from the RX
> descriptor to skb_put() without clamping it to MAX_RX_SIZE.  The skb was
> allocated with dev_alloc_skb(MAX_RX_SIZE), so a descriptor length above
> MAX_RX_SIZE extends the skb past its allocated tailroom.
>=20
> Store the reported length in a local variable and drop the frame before
> allocating the replacement RX skb when it exceeds MAX_RX_SIZE.
>=20
> Signed-off-by: Jiaxin Li <18135327133@163.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>



