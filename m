Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54E92264CA;
	Mon, 12 Oct 2026 05:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784610; cv=none; b=kl1DZnTAnIA4qmJH1O8NYv69BqIGUVFBR467u2uZG7DH4gvsqdgKdccm203oozBlq7jm27n1VzgsDkIvGEYDibZKILWgKDHnkIKmnZHYgn4343OuRzuzP5d8rErH1lgfEugXEioKXLMUnzw0nwPH6mEBNrX43FAmgwGKEKZ28aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784610; c=relaxed/simple;
	bh=BBkb9w8b4G2XxjHlo2GSEvttdtqjw3KXXK4K7NkeoWM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ut0s93BO7xlc5RyoEkaqbHF1LH1q2VIgZIEcfPF7Kuw9PT880E1Cn3e1XzKhwDCOtf1tSrLrLe8nbsEzamoto/FCNHc07TJzgggZynoOOvua0E3zDtJWMQLFUIubTDoBvxTTR/kWNKiL44wzjGgDVblYA/uKCiUjskx3pM/ajzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=AlLsA+s1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="AlLsA+s1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C5uTdV53578152, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791784589; bh=BBkb9w8b4G2XxjHlo2GSEvttdtqjw3KXXK4K7NkeoWM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=AlLsA+s1WcbYZyA4cn9Oi0VfOtQmneG/wzwWmXw3s2Kk2JI6yaVVh1edHre1a3XSh
	 sfs+H9Fu12zGG9SL5pOtxejSrTsSPpYq59WZccyNPyMNEMg1hjQqZsD7GUNfCJ2rpl
	 f7JZ/wBlRZPzaGfdi70BGvrE0eJEsVFyArEWYOlJA65i8z37qYSxVbvOLWShPMMfPt
	 c092pKuE0WeUJJ6jhA8pK7rT1U71dAaomfxmq5lDUPX51J7ryYcbFvpgBzizET1kFu
	 CmXsUv8GttP9MebLFXpXYNnBXRe3EzImXhoLufX4K92zDsDWaLU/vzRzHrIIxydk1v
	 N1uYqrCwU9f2g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C5uTdV53578152
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 13:56:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 13:56:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 13:56:36 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hungyu Lin <dennylin0707@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"luka.gejak@linux.dev" <luka.gejak@linux.dev>, "fiona.klute@gmx.de"
	<fiona.klute@gmx.de>, "kvalo@kernel.org" <kvalo@kernel.org>
Subject: RE: [PATCH] wifi: rtw88: 8703b: avoid converting RX SNR twice
Thread-Topic: [PATCH] wifi: rtw88: 8703b: avoid converting RX SNR twice
Thread-Index: AQHdWOZU4k0UEhQ/50KrHxjy0CjtLbb5auIQ
Date: Mon, 12 Oct 2026 05:56:36 +0000
Message-ID: <95d9c1abf62d42269f1f3f90a2db2c2e@realtek.com>
References: <20261010183629.39748-1-dennylin0707@gmail.com>
In-Reply-To: <20261010183629.39748-1-dennylin0707@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hungyu Lin <dennylin0707@gmail.com> wrote:
> query_phy_status_ofdm() divides the SNR report by two when filling
> pkt_stat->rx_snr, then shifts it again when updating dm_info->rx_snr.
> This halves the SNR used for diagnostics and average statistics.
>=20
> Store the raw report in pkt_stat->rx_snr and convert it only when
> updating dm_info->rx_snr, as the other chip drivers do.
>=20
> Fixes: 61a486bcd782 ("wifi: rtw88: Add rtw8703b.c")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


