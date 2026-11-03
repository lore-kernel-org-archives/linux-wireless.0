Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674446;
	b=dk+xZO8OQknQOqOZQyKA2DVb5wtUEqNvhVA98jT20L/ijE/DgAcsMki7r4LQJZAMwKDD
	 58MHVQ2SsvQk7rFv1a5y7x0blbK+0zIyj7RDY/HmXZGKe2o1DWSAzDTsgAQo8rnccGmFj
	 w87rZDyI0yVmNEHrq5G1un3DbmTP82Y7Lap94AtRgIzL012xmvJwEqX0ORRcmvC/6h0Uv
	 7B8HkhYVcs2Dy/dDpg0jO6cyWY+7J57bALrG3I8Lm38m+o9/IrcKkHcW/bpFQxhCUwKOn
	 7FVMqkmUiRDJjQcsq+Wssya9nLX5oZ2Snh+726cQX+SA+ZfNSMpFI2O/LLQWn3Ml0sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674446;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	bh=FrlaeHLvfKPLlpcwPcVzUEAFu05ZmpfHA+kxEtqmMNo=;
	b=RNUQvwCvIB7fqKSbhHeMDStYs6LVI54jxsJwHT/IhwouKT1BCt4b2eKoufmMhsHdM5iH
	 TI3V+AT9ALEQSJACArUpWldTYS0WkJz2c8ypB0W8YeFZLAcv5jHAE9G6Wq33oBubRpCIH
	 QiG0q5NTc/3edCqMkSp0TyczPtdNkhF8bT9gWpQwnIA8e6XaEdB9FqGgdX1frN+BTVQf5
	 2cMXaMltwPEj1UhTk2YbWLbn/5spkhi+DKiP+PMH2SUYe2MGbWUO0CzNvN5C75MR7HETw
	 odBSPGCJ2myCJizwVX3AtCwUqcBEsjh43ZHgBPzB0ixAdqUrVANeoGu4AmiXkOXEfww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=N59y5HFf;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50AD606A324;
	Tue,  3 Nov 2026 02:54:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A50AD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=N59y5HFf
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A32rhGqB2683649, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793674425; bh=FrlaeHLvfKPLlpcwPcVzUEAFu05ZmpfHA+kxEtqmMNo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=N59y5HFfsN6qwpDk8wEeL409AfZywW10u+Tvz3tR5/TcTgSmaTErhQzCrTpDAgjJx
	 Q9xj59e/JTK2FkA7Hx7+um5TpY9m/gHOaJyT7xDnWNOnxDfr/2GRqYbjuZzNDamS+h
	 QzGkBQNKYBjb8Mu0OLjMwCMUG0igTEr5RFxGaVf4Otudcd7HpONZCuecfklJscIZy3
	 YswgIQRqhwUC4m0csxqUkO7l99pTfoTS1N9xLeMA+ns/ZCiF8DeVA2443XUVu3GqXX
	 TATKIWNJrKudf8ESB/h75juI18LKGai8tpB6PRYjHCJsbhNrjqeuoeeXLZgwrzZpo0
	 4+l5sWRWCBcOg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A32rhGqB2683649
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 10:53:45 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:53:38 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 10:53:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hungyu Lin <dennylin0707@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<phhuang@realtek.com>, <luka.gejak@linux.dev>, <rtl8821cerfe2@gmail.com>,
	<johannes.berg@intel.com>, <u.kleine-koenig@baylibre.com>
Subject: Re: [PATCH] wifi: rtw88: sdio: copy RX status after updating the frequency
In-Reply-To: <20261009014941.29137-1-dennylin0707@gmail.com>
References: <20261009014941.29137-1-dennylin0707@gmail.com>
Message-ID: <507b0302-f47e-4e60-9b26-b56d33ed3b12@RTKEXHMBS03.realtek.com.tw>
Date: Tue, 3 Nov 2026 10:53:38 +0800
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

> rtw_sdio_rx_skb() copies rx_status to the skb before calling
> rtw_update_rx_freq_for_invalid(). If the frequency is corrected, the skb
> still carries the old value when it is passed to mac80211.
> 
> Move the copy after the frequency update, as the PCI and USB RX paths
> already do.
> 
> Fixes: 53ed4b25a79a ("wifi: rtw88: 8822c: Parse channel from IE to correct invalid hardware reports")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

c76f73c36343 wifi: rtw88: sdio: copy RX status after updating the frequency

---
https://github.com/pkshih/rtw.git

