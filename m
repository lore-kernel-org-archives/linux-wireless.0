Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676005;
	b=oI6KQr5m4K9BpsNexXf0Kp07ANRYJalDei4jeLtHZQq+p7fY+LDrwJUZfxoxNYdIqcUC
	 ywkxij6GxO4SyHWYjCqlC12pRV8y+imfiJucvFpE6crW7wkq2H3G3wanErwhgwVyFH8ym
	 bsY1n5/IduYFHgWoFpuD5XVaaRflePNuU+Bt1ZeH6R9qKb3yq73j/Jw0DStwwElHtmbAz
	 KOgDWH+FZAhBvpWoDlTW3tG91CN+lOUs85Q6rEqms7wGUMdSLA0w4D5mIzudcOp5p04cp
	 1Ok0obDL4O94+QyJxYxFg2VS8oGwnkK3mXHKV8eQaYJynUwdvjrUzVgLxWX96BA38jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676005;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=oTzxNjNvedBemKTDj6yGseHCQTs1NpwXkh8k9G7UfEk=;
	b=K1VKzzQ3u9HX/jQ4Frl0q87QuGcRNsBfUzuDAy5W6e+2OK7t2Z3eSHScqW07JWk5+GXh
	 MTWnU121sSOSDOQ1CoXVWO5vTx9vLZwsHEW+GoK7+CmxZvmxCHJ3MCVate1TcWinF18IC
	 Gi47sry/57Fm5ictpc+RLLrUyCTzykYUjGjEMXzuJAetR0WWWX46HHZs5gedN6h/zH9Ve
	 WRlkcvhIqPK3jC9PLjuUcvJVhtNtCzUDePGkEO//aQX9fGQZ/xk1/SUMEAwF6Z2//PQLF
	 1hJooKNn2AGKSTxMZMoLVLJL6OkPFxo8lciOGsF+hw7M2vrbrtQ8zbDPvqyv7jrH5BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="O/NRm2X1";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAA0606A32D;
	Tue,  3 Nov 2026 03:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AAA0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=O/NRm2X1
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33JhNmA2697069, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793675984; bh=oTzxNjNvedBemKTDj6yGseHCQTs1NpwXkh8k9G7UfEk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=O/NRm2X1Ne9PryN/GNJuu7V889ty0YYW3Wdb24BHOO2T2+ahRTZXwQCipz1SMGImj
	 1P/Kf3MOPaXRNa17ipQYVgvkQqeIYdBhXAtoUvwJPyaTsaeCZjdthQoad8WZv8CGsa
	 dvZv8Vaq8E9oJdu4BD5PjUBEXg0zkQlsut5jzIdqeGDb/cudWZvFyzXJUsuu8AKURs
	 cSWz+xIVrHzLHEDoznvyF30yKUN0/7X+3oagRnKIgS/7qP/KORhIIoUycErG1p8ntQ
	 h4S78NFSC4dxqpswWkYqZ/RWv5v67rtUZTpHGNG7H8xSg7TSE254ZW3qt235HA1Aq8
	 tfNBjhbkmPloA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33JhNmA2697069
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:19:43 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:19:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:14:43 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:14:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hungyu Lin <dennylin0707@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<luka.gejak@linux.dev>, <fiona.klute@gmx.de>, <kvalo@kernel.org>, Hungyu Lin
	<dennylin0707@gmail.com>
Subject: Re: [PATCH] wifi: rtw88: 8703b: avoid converting RX SNR twice
In-Reply-To: <20261010183629.39748-1-dennylin0707@gmail.com>
References: <20261010183629.39748-1-dennylin0707@gmail.com>
Message-ID: <b943b334-2507-4c0c-bb73-9b35e76866f8@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:14:38 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Hungyu Lin <dennylin0707@gmail.com> wrote:

> query_phy_status_ofdm() divides the SNR report by two when filling
> pkt_stat->rx_snr, then shifts it again when updating dm_info->rx_snr.
> This halves the SNR used for diagnostics and average statistics.
> 
> Store the raw report in pkt_stat->rx_snr and convert it only when
> updating dm_info->rx_snr, as the other chip drivers do.
> 
> Fixes: 61a486bcd782 ("wifi: rtw88: Add rtw8703b.c")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

c3ae9e68e138 wifi: rtw88: 8703b: avoid converting RX SNR twice

---
https://github.com/pkshih/rtw.git

