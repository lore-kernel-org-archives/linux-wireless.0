Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793684954;
	b=2fuItnOBTjOZxx4h7OPcJbHw9Y9bnvWZ+V01GMXWf45x9mJl2eGCEc+rrlCiEDWcOswP
	 wQBr99YSYc28hd6OZnFqzX7dTeCDje8mFwt/uo/4omFwFFR3DeO4uR7rzfqJOsRGm5/yY
	 Q6ozzleQAaVDol2QVMH2r+5Vn1/g2IYH3fF6sEGJgmyhN/8QqtxmPjhUxCygQJDLGrnIL
	 W+2NcXH5PN5ii6FyoOxQBeRXbzunmg/pPrGf7ASb73JkeuqJexhB7PYJFw0yGiYSxz36H
	 i/a45VIImSltedeoJcTJiUwd2s1nI1fowhC0gw3ViOByO8Lwl4J1npxjVfmu+UdK+xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793684954;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=SLyhkDh9JuWFxsRkyBCNBYa0D2q+FUx9Ee8ZaNKL5ng=;
	b=fbXCMjjdCKX+pvJUuUo1ZAbc9srKrqhzJ3QI2PzF5iD4jJ2lz/KrodcJpZGf3M1EX0b1
	 MBoTK5Bt09Zt8jGUS8o7uyLWZmSjFA2Pk0GgSPeiNjJdGKAkoO3/TYjN1D0f8OFQM3ZR3
	 NMV9/aZVZiJ94QgFxIiNfnkvFFJKgPP35Q2swXrXcZHZks00oE97Glk9IkxhNnNyt0bdk
	 5yIQYjv7WmD5rla4htUbPDkTO1ArAjbzX26VrPul9RdrLok1pNI/8ypLyVICVhjJhtv3E
	 1OD//7JFRV+jnIaNicEYngy5W4oK+vYZDehSAzfU9yHmvsx1JtKA3GIxkw1090Ov3Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fC2noAyf;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D54606A324;
	Tue,  3 Nov 2026 05:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35D54606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fC2noAyf
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A35mVYZ12773890, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793684911; bh=SLyhkDh9JuWFxsRkyBCNBYa0D2q+FUx9Ee8ZaNKL5ng=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=fC2noAyfzwmOIntdMM39cktwLO5h3WMr3StEKuKPq8667DGrpnAE6dCGQU7Qq5J8K
	 CAL1vVW0NtTp7kWLqwBktOsoVyO5PjFJpPL7ahOD3KUYs7Z109Exz0d54X1mZ666DG
	 583K5BSOcdDKdSp2eDy3+7i4y+eWGqS05eWLPhdfp0IRUHsEdW2Mt74pAf4+lxGDMW
	 HZ3mBKOEqYah4O8pi7iLwlnIncEA6Nf6Hjdxvn9rJiE6tCRCELbFMNB9BCDoC/naU0
	 1aGPluyInAwihW7nU+cnyW5eFOL5DdF7BVGqYK8hYdtosTq8XYOZTVrvWhyTt1Y9ZL
	 wFn0B3j6fPP0g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A35mVYZ12773890
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 13:48:31 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 13:48:31 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 13:48:28 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 13:48:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ho Jie Feng <hjf3108@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Ho Jie Feng <hjf3108@gmail.com>, "Luka
 Gejak" <luka.gejak@linux.dev>, Sascha Hauer <s.hauer@pengutronix.de>, "Hans
 Ulli Kroll" <linux@ulli-kroll.de>, Kalle Valo <kvalo@kernel.org>, neo_jou
	<neo_jou@realtek.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rtw-next v4] wifi: rtw88: usb: don't report the aggregation buffer as a frame
In-Reply-To: <20261102033244.9330-1-hjf3108@gmail.com>
References: <20261102033244.9330-1-hjf3108@gmail.com>
Message-ID: <0e09718c-b73a-412f-bc80-f89cf1228474@RTKEXHMBS03.realtek.com.tw>
Date: Tue, 3 Nov 2026 13:48:23 +0800
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

Ho Jie Feng <hjf3108@gmail.com> wrote:

> When rtw_usb_tx_agg_skb() has more than one frame queued, it copies them
> into a new buffer. That buffer was also handed to mac80211, as one
> additional TX completion.
> 
> Report TX status only for the original frames, and free the aggregate
> buffer without passing it to mac80211.
> 
> In the case the ieee80211_purge_tx_queue is called, the frame is
> passed to ieee80211_report_used_skb. Since it fulfills none of the
> conditions within the function, the frame is freed as normal without
> a TX status in that case too
> 
> Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

62e69ef45567 wifi: rtw88: usb: don't report the aggregation buffer as a frame

---
https://github.com/pkshih/rtw.git

