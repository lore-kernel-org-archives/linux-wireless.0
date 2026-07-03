Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F45331D759;
	Fri,  3 Jul 2026 03:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783050744; cv=none; b=jQ9l0mXlrJKimFcHhq1cZ0sknARj8kAID3HJs+oLsnHY/DMf1Oh5e1mYmnn9Zt+Nskxlok0Sl2014dygqbbys2Q9FMscYjtpq7XkQP6Fjplk3yuLBH1D+Olcj2FAOCyncVAv4C/PL7/wD6L2wjHpoFf5yuvcXCiKAfUplieIilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783050744; c=relaxed/simple;
	bh=UC2pC2Hha1+W/l4dNJ/f/2nbIvFil6kpxgdWmmvhtfA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=HsE1ACm1dtbVRThYPGJIv6snwYGagYdaNL1Xsm5XnUJLGhooDaiF365yKRy+dLeNmo88JQCyOtT8LltQlAPPFpxjKacijf56KJJII+sSOentnfDKDn9bKllLEjMxs0IqW48rN9OENk/W0zVhZj7C8sgKngH/fOOiuiUZQuxzleU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dh5kk+bm; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dh5kk+bm"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6633prjE72425883, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783050713; bh=IQs4TD/VNInSJjAkKFzSM4IzRVEYFtXQWdMycpUjGxI=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=dh5kk+bmv7YRgTtYZL033F8r6cLBmidifPkSuuhgDFLT7l4tlDAM1ZEBb9JsL2bxg
	 QKOeVE0YJTuI+wrhEVGMVCklgB3lS9E4d4mlHx/Uo9gA+ID8iB97kJZaSiZ30B8Glb
	 KxWzrsdNydU6T+cRVWPlXWeMU6R2ZsBovX1Ka2r8jwBKP7S1x5jR25hjCWmwfUDPmo
	 IKrnBtwmzo9VYA3T5Oc52laVbzN/NznCDJn9+bVlaeIyJjNRxuJORM7V+1nZwZkydy
	 jJ+z6lGT7Gsta+xX/asmEIqwVX0dnLSruZjkGpQlPVv9basmrqsjSR93um2UZeS6he
	 l5kCUqvxkrSmA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6633prjE72425883
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 3 Jul 2026 11:51:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 11:51:53 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 11:51:52 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Jul 2026 11:51:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Dmitry Morgun <d.morgun@ispras.ru>, Ping-Ke Shih <pkshih@realtek.com>
CC: Dmitry Morgun <d.morgun@ispras.ru>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: Re: [PATCH rtw-next v3] wifi: rtw89: check return values in rtw89_ops_start_ap()
In-Reply-To: <20260629094452.8709-1-d.morgun@ispras.ru>
References: <20260629094452.8709-1-d.morgun@ispras.ru>
Message-ID: <096ddbd7-652d-4355-8ac4-a91b331c6628@RTKEXHMBS03.realtek.com.tw>
Date: Fri, 3 Jul 2026 11:51:47 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Dmitry Morgun <d.morgun@ispras.ru> wrote:

> Several functions called in rtw89_ops_start_ap() may fail to allocate
> skb or fail to send H2C command to firmware, returning -ENOMEM or an
> error code. Their return values are ignored, so subsequent commands
> are executed with incorrect state.
> 
> Check the return values and propagate errors.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: a52e4f2ce0f5 ("wifi: rtw89: implement ieee80211_ops::start_ap and stop_ap")
> Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

a8cddb62c573 wifi: rtw89: check return values in rtw89_ops_start_ap()

---
https://github.com/pkshih/rtw.git

