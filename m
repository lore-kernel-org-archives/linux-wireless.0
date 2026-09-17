Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADC633689A;
	Thu, 17 Sep 2026 00:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789605036; cv=none; b=XaTHNRfMcIsspVWrrmQTAOR/1Lu0Kwaakp3P9z0FXs0r8qIMLvzTnSguhozpQr8619t9b05v3JCCvtjP3j57dImUCcxUIQIDxrdTC8UQNrmT8OW48TjjRfftVryKf/bBXuiz3fInuNa1Wub493xT9L64uolO1OT7U/wfv27TxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789605036; c=relaxed/simple;
	bh=pE7ADaI3lT7QXyQrFmvFoIb1gXc9bYUdBZzdgC7ZkSY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bG2nVToOvXU4MlMXF8cB8DROwEcBXHPPRbbrnfyEhFKO7CxQC1z2Xo/8VmjyTG5E1LLZOHS6ya5L79G3DmzM5TaWea1Ga5pbMjgEU+qKLhhcJPYW2wLFVV75PoOYgknoSg3P7sVR/cnKFdQ4UcpNn/VrgC+Il73516/nejR8bes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DPQ4ds/t; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DPQ4ds/t"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68H0US2802858962, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789605029; bh=pE7ADaI3lT7QXyQrFmvFoIb1gXc9bYUdBZzdgC7ZkSY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=DPQ4ds/tC9xJz0XRaN967rioGGsQKtIUgXbJdhrtsiUy0RpR4ZHKW4KaLYwCS27R7
	 +QphNrMhg9PTk9xHMMdOmHYWSN0yjzUhQNVUjVcVmTUI+4ztxB1ert7+L5WlF+0s8u
	 k7XGx6cERMFsbmAPO2yoYI50r+yySG4VHsy9zcVr3/jDfvbE9LtmCEYL3fW4H3zBxN
	 AbInqutfdCWaB/zv6plR1ZRvhAzGxoECsrRY2Syo19BXl7SBnypB8L2ZWdBchiN36E
	 Qix84naLoJxeYAhiSC4BR3HjUvhPaevBUTsi5DNtByJQp5dT8kYzJJJMkLc0w2cBJN
	 0nXaeiHKWcxiA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68H0US2802858962
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 17 Sep 2026 08:30:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 08:30:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 17 Sep 2026 08:30:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Maxim Skokov <skokovmaksimevg@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: rtw89: BT connect state differs between scoreboard and bt_info on
 RTL8851B
Thread-Topic: rtw89: BT connect state differs between scoreboard and bt_info
 on RTL8851B
Thread-Index: AQHdRQ2CnV7TRht53kG/awfFcwERqbbPDZQAgAFwrJD//6sOAIABwvFg
Date: Thu, 17 Sep 2026 00:30:29 +0000
Message-ID: <776cd43f75f14571943462bd5fc6cb64@realtek.com>
References: <20260915122625.6341-1-skokovmaksimevg@gmail.com>
 <20260915123718.7239-1-skokovmaksimevg@gmail.com>
 <25270f2066784a02806daa352643be53@realtek.com>
 <20260916053228.10042-1-skokovmaksimevg@gmail.com>
In-Reply-To: <20260916053228.10042-1-skokovmaksimevg@gmail.com>
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

Maxim Skokov <skokovmaksimevg@gmail.com> wrote:
>=20
> The sink was connected and playing for all of the
> above, and WL stayed in STA mode, retrying association without completing
> it.

To be clear. The problem you encountered was failed to connect an AP, or
this was newly introduced by the patch I shared?

>=20
> Is BTC_BSCB_BT_CONNECT expected to be set by BT firmware on this chip? If
> not, status.map.connect will keep being overwritten from the scoreboard
> after _update_bt_info() has written it from the mailbox.

The BTC_BSCB_BT_CONNECT should be set by BT firmware. The internal BT
expert is helping to dig the cause.


