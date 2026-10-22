Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640946;
	b=iD3MD99GqdVo8pI9iktBweoCXM2yFMZpPThZLZJGQ2cyMxZB3AD9rToRnIqd/8HmDr5b
	 DSUDndVxUtT/KnZ0zUqfutWLctp3xng19X0ejqocaRkA64hMdCS4Vf6KVcW7B217LvqHa
	 iIrZ+o6crp/LO+itI2m2KwalyRcD8d1GX03UTJs5ZlJPRCNQ2MDefjyXUeqN7AvCp6SDd
	 ykSxgB/kIHUwq7Mnwf8IiE+mfYDk7vMw1TAeH46wFrQJZ4xV0Z1FcXurt9jbIfgw45BK3
	 WxgmfIl6ATWEmVpr1R7whk32sIfNt8CGE/Fx7phP7qAg3pR8Km8VFH/Fjx+tX0+NuoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640946;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=LmqgZiFbRAvIkPr1jApL88Sp8XKHBPCBhtR5scBhfNA=;
	b=iJrKssP8FTTWrbMPxPrAy9vXx40OX9o1axpl0SWpTdLwBQUNnLFpz641FWhelvO0rmDV
	 TRMZQU+HgC7ycRODaQOuk6UZkh3Bb/L2dHyaZtfDye8SiTfnORMJ5rqg1tyvNK9cW0J2o
	 ZQ+7bAcfaXBVA5gb6oktJpJn0lmR8eT7G2I1nu23xPsZa9faZzhgxtREwWtDwuVB5Zi84
	 9t8Gh65Izr3Gs1xoFJ8sMnRiE07I8+5SY37iatsxkaep9r2hLtZMA/EIZVVVyEmXzLVNF
	 rSRMTEar461XsJYbIOKoMcJ80LShb4kQDxt3jvZgdL/BXRUPDIeAZYnaeEKeBTFMeaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="nWb+lQF/";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0944606A31A;
	Thu, 22 Oct 2026 03:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0944606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=nWb+lQF/
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M3n0F71575595, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792640941; bh=LmqgZiFbRAvIkPr1jApL88Sp8XKHBPCBhtR5scBhfNA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=nWb+lQF/rifEr2sK22hyX7BuRLrMJ22prS02avnx8ERFlOAUOEkxSSxJusl/E4FMc
	 9zAR3eAuaks1vMV48oxMnYdEhgC+pjln2jn0VnztVQHAnx7w2Az9spFFYLMkKsfRJa
	 R6qjjYszxF6pykcZb60DcRvS6wI4ScicFlBO3W/khi0fcnkySSLVVcRLu8Yr3zrY+Z
	 BZ68O3gziBHuF+R7XNYxCbbRp3V4U0WxlCVp9UNG7YepTLzK01BodYv7OJqq29Dmty
	 bOqZshSg8XmiwF/nfaJnNXXBMz4sf0zqoRYV3Q31pRlYhfikuqiwKoOZqPRejfHQvS
	 qyJp6UHjtAYoQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M3n0F71575595
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 11:49:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 11:49:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 11:49:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 11:49:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the
 rings are reset
Thread-Topic: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when
 the rings are reset
Thread-Index: AQHdWO4MPV0dG/pKrEyzZWvhd4YBNrb5eb7AgAINFoCAAMEoQIAEANAAgAPLA9CAAz37AIABqy0w
Date: Thu, 22 Oct 2026 03:49:01 +0000
Message-ID: <74b5ab33c8a3445ea45d2f5d0c8d7387@realtek.com>
References: <3c588aeae8f74a8caa39aa2852bce437@realtek.com>
 <20261021101356.1976617-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261021101356.1976617-1-abdurrahmankaradag19@gmail.com>
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

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> > I need your help to summarize the dumps. I don't have much time to
> > analyze them. Sorry.

I meant if you have more dumps in the future, please analyze them and
give us summary.

> They fall into two main groups: stalled TX rings, and a dead link
> despite continuing ring progress. In the first the hardware read index
> stops advancing while the ring fills behind it, and in a couple it had
> filled and the queue was stopped - the state v4 clears. In this group
> recovery was observed only after reconnect or interface down/up. The
> second group is the larger one and I have nothing for it; that is what
> the monitor capture would be for. The patch does not claim to address
> every link loss.

Let's me clarify two groups are:

1. stalled TX ring causing queue_stopped flag raised
2. link (connection) loss (not clear yet)

Ping-Ke

