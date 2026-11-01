Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793504684;
	b=XIk0YinmQo9ThYhrkQA53qSpbPpmXNjDjhdC+bjWqiW3UkDoSLZbQ1x/KHCjthrCzjof
	 EaCkXy8jpffLAKWFtKS7iiYbCVLXaUZoHu3naQflo+ZNhWVsbG6DqGsDMXAw5MBzOZe58
	 h2l/RG+x3xL+Fs42aHi+Rn8c9XjQRzatXy85dbFN+lANAeWAWsw3CyHq9yfDuHS1lroh4
	 orDuD85Mb7IieYVk3IzqN5vvozeHTPoYO4jnEXHMlWkkS0UjwW4PQfIdswJFuKgGGDnug
	 md5/Aw9+fP5k/64+s0/eHT17Zpk6Q5qXDtmBqpCfW6OT997Xi0fPdBk3HhHTmrW/ldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793504684;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=3NX0nEmrDMRcK2qb2zALY4YGB6wA9H4jDy5kL7Ko/AI=;
	b=e8Z45N8bFodeLytWF4HD8q7VjaSpFFAxPDU+SDZ3ijxIcNPPAN1sshDdpIcfenFP6veT
	 fc56QX7AfqxjS+gczf6Y6PYLuhYm9jdgqdFgxd5ZBYLLrSZW9V+OmOlrSsOOzTYU/Iz4d
	 BqbQxvOk5AWmVcY6f5lGJeZPlRFGBdXg7Dpi0s5UTpkBXKSzvCh/RkbBH7t3WMoVwsp5S
	 zjK10dl5HSUcYs2asLNxs2OBh3FQLFh3pdisVLK3zVcQClKNkLjcMNDMrmRsy5N9zPbKR
	 CteM/nXCggx+3qDnRI5mmIWNyO1jNj+g2tmy+K/i7PAO/fvTUXMOiTFYAzdvAYiYW5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=VxHqxSNA;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D58606A324;
	Sun,  1 Nov 2026 03:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6D58606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=VxHqxSNA
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A13iDiM51007663, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793504653; bh=3NX0nEmrDMRcK2qb2zALY4YGB6wA9H4jDy5kL7Ko/AI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=VxHqxSNAppv6MRhiJStSxpK+ZjDKRQgNW0I3nrWmExg31gs0Q0KJ0zfsOt6Oky+CY
	 yNgB2NYliPx0RK8G+01qt/S1i/znBkNx/DMKacFoOX4ey9DYrgLh/3Xmya/Px5Mz4E
	 ZMJzO02hEsYgSP27HFCkYSlq6p/oQv+xwVOM7TK3yVaZVNksMaVw9bapwAAVHhxvrF
	 SvQILInGL3T09pr4DHhq6IQYyN8XPPjZb1apEqsIQqjwBrwWVJAn+we54CanPAjYjB
	 a+2k3AtgwWjvxaPqrY9eVL/J4Jm9Kb0FDaMyk6Dy34yCOO7eF7wuoZKgy4Yldvy1Z4
	 38c7mu9LAhAAw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A13iDiM51007663
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 1 Nov 2026 11:44:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 1 Nov 2026 11:44:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Sun, 1 Nov 2026 11:44:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ho Jie Feng <hjf3108@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Kalle
 Valo" <kvalo@kernel.org>, neo_jou <neo_jou@realtek.com>, Hans Ulli Kroll
	<linux@ulli-kroll.de>, Sascha Hauer <s.hauer@pengutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
Thread-Index: AQHdaI9vizk2vXuz70+nFp0lnrRycrcYkErA
Date: Sun, 1 Nov 2026 03:44:13 +0000
Message-ID: <2d53d5420be945fc9bdfbea5542b61db@realtek.com>
References: <20261030165451.365591-1-hjf3108@gmail.com>
In-Reply-To: <20261030165451.365591-1-hjf3108@gmail.com>
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

Ho Jie Feng <hjf3108@gmail.com> wrote:
> When rtw_usb_tx_agg_skb() has more than one frame queued, it copies them
> into a new buffer. That buffer was also handed to mac80211, as one
> additional TX completion.
>=20
> Report TX status only for the original frames, and free the aggregate
> buffer without passing it to mac80211.

The rtw_usb_write_port() might be failed and call ieee80211_purge_tx_queue(=
)
to purge txcb->tx_ack_queue list. Should we check if the tail skb of
txcb->tx_ack_queue (or just check skb_head) is drv_frame=3Dtrue?

> @@ -431,6 +436,9 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb=
, struct sk_buff_head *list
>                 goto queue;
>         }
>=20
> +       /* report TX status only for the original frames */
> +       rtw_usb_get_tx_data(skb_head)->drv_frame =3D true;

If we can just check drv_frame by skb_head, just declare a local
   struct rtw_usb_tx_data *skb_head_tx_data.

> +
>         while (skb_iter) {
>                 unsigned long flags;
>


