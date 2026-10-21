Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792546623;
	b=M+305eb86XdjH5XrIFGnTYMXwqBwOtE+fWloumx4SFVq5Qx3DcHjd7dDqGsfAHIs090k
	 zDZ9Xe1hZtL1BYZih488Hoyw9Sh21pE5W8gnIiBLuZVh0etDdYf6t1ZVtEQDBox4N2RKk
	 3lnREew0Cex64h5GkkR11ilYdFuLpkPelk4HMknhuXzhvnxDgPYgMwjz49y5Ic2m5i+VS
	 tjot1chAFWzjXdbHzzbG+E6NVP9KB68tmvJ/ti3lMULhrkQnlGheG05AGRsrPid1Fib7b
	 He8dPbuEHjbBZ5ZN6pcvNzYmYmQHoBSpJ0RrYdlbAftPtjWqDNWykSBwbXphjzem8sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792546623;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=/lDiNcUiC5q+0PknEKsvmaM9R/wVHzZz7vuKtAZ0xCU=;
	b=uvtpW7raXqhSrKiUhg3vI7AZstLddH7ELcjNeBToM+NDp8tCMQ0wysIRVJoWbmqrSYo7
	 qR/OgO1TC21pqmY2Etwifml0FKP0w+b7LX3b6plyRii3xWl+z975HbAOnQVAcjy31DO2I
	 7cOGAj3KuwivBRxDB27fMlpWSvGtS+TzFu9xo+ftbztNcHvUDXuIY8VU/LDh0wt8gDDWz
	 bIGTEwvrso2UueicFDXtaXfzHaPkTvd1Nd5n6CHcsoFPb6tpWo3/c0360PKdeqAXEpuvV
	 GtqNVSMZ61tBQthdPSoFfyisOLoTlzy+9cIQy0BiFBuQK3wmPYODIrPQcVtdsPIS0vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fcSCaUss;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4454B606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 01:37:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4454B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fcSCaUss
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L1arbJ73564321, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792546613; bh=/lDiNcUiC5q+0PknEKsvmaM9R/wVHzZz7vuKtAZ0xCU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=fcSCaUssYlf15vLUSUyH6j0dEBi/yQFMxLYFw6yv0DDcvBtNOBrCC1D7MSFqPpuFj
	 P4D6Oa+I40dZ1r7hzlLdIyX0HWE/Cs9sBanNphEwM4WbdF8Sa7D3yYnYwY0AT6GEjv
	 gMQXvljvJLSa0unfyzzvGXP1BrFWjrpjf/FRf1JkmXYYEsGRDuawRbHQFD04quPkAg
	 S9WQdoLV/7F1Tcqx8Z+tVY5F/JzwcJunri0nrPjnbBpQxtDEQDLY6zy3xAOxoapO2Z
	 ssjtp/03+7ulpKc7nCqlWM01/26hlzNH2PS1LtXDEfdBuKzDKhrHmE4qrToECnvdxO
	 Lf/XglYUa9SnQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L1arbJ73564321
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 09:36:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 09:36:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 09:36:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Jiaxin Li <18135327133@163.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtl8180: reject RX frames longer than
 MAX_RX_SIZE
Thread-Topic: [PATCH v2] wifi: rtl8180: reject RX frames longer than
 MAX_RX_SIZE
Thread-Index: AQHdYItNBExRLdBy2Ei6tAheIcUZ6bcHN9Og
Date: Wed, 21 Oct 2026 01:36:52 +0000
Message-ID: <d34e4cc538314c3e906d22f1b5506c44@realtek.com>
References: <20261020115938.1433-1-18135327133@163.com>
In-Reply-To: <20261020115938.1433-1-18135327133@163.com>
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
> @@ -255,7 +255,13 @@ static void rtl8180_handle_rx(struct ieee80211_hw *d=
ev)
>                         goto done;
>                 else {
>                         struct ieee80211_rx_status rx_status =3D {0};
> -                       struct sk_buff *new_skb =3D dev_alloc_skb(MAX_RX_=
SIZE);
> +                       struct sk_buff *new_skb;
> +                       u32 rx_len =3D flags & 0xFFF;

nit: in reverse X'mas.

> +
> +                       if (unlikely(rx_len > MAX_RX_SIZE))
> +                               goto done;
> +
> +                       new_skb =3D dev_alloc_skb(MAX_RX_SIZE);
>=20
>                         if (unlikely(!new_skb))
>                                 goto done;
