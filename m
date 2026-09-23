Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8618379993
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 02:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129799; cv=none; b=csaig2cKYrB5ifmH4N9uyZ94zS1lyoAutOa9pvIagmLFfn9OO1hSwevV+BpFFfloNoMBRXuuiLcqR954BG+IOIx8CqhPZUq63EdRXvjPBUOENhEFZ4YO7Xuf3uTkmpKZOPsA9cy9gzfLNji9QZ++dGC6lWSflKP5Gj0XM33qNPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129799; c=relaxed/simple;
	bh=0DCpPvAupsU3RIxryamkcUtgrfYMewvOk9P9cwqRJnQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=Js2z9+MgfxPFIjHxCgxiYcLi458aA+cWpWRTDjHhyG4KzFqiIbgoD5OtAC1SR+qOFNhJS6GpbA2NBz8d6CKz3jBLavlub1BevgVcnXdjf9D7pJYHmD+9kTL6YQSkXaDqj+Uy5Nz2Q3sQIfzStwIbhgViE3nVoB2/dvrq8ZaqnOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=JlJMWCYs; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="JlJMWCYs"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N2GXdR44165343, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790129793; bh=T0wSzEJzp76FVldYYtWiqrMudcUEI2OVLTqS1YQL4LA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=JlJMWCYs1uyT/mfDpIsHGzNCTgiSbX7X9BIUPbjlgA/IjYkAlt/sholACon+m9FIN
	 V6kmq6zrjpLvLXVWnZ1/iCFMGLlt5V52Z3SKwdPwZMw7kkwpiaOslyAcegSF4dmM99
	 MecVWkalVScg3h582Qi1GRMmoHQ2e8kI9xjwtSe24hSLNlZ8MrTbWwNrPYx5lbKI9e
	 GSkXq7u9n5zUQ8VFTDVPBrHNlp2VP5vZ6p/DHZAGhD3AiCRxrOQ18mrDC6LDDhyCcJ
	 wmUgV2tlEVzLjZmsVcLrq/RmFeNmGFumGFmpwhdU/GPTQNReNtRfminOnHA9EXb2Q3
	 w37n/Q6ySyw0Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N2GXdR44165343
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 10:16:33 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 10:16:27 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 10:16:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <lkp@intel.com>, <wenjie.tsai@realtek.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: correct dependency of the multicolor LED
In-Reply-To: <20260918021113.25481-1-pkshih@realtek.com>
References: <20260918021113.25481-1-pkshih@realtek.com>
Message-ID: <a65f09fa-4d7e-4f1b-86ec-fadf07e81a03@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 23 Sep 2026 10:16:27 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The rtw89 depends on multicolor LED module, but for the case multicolor
> LED is module and rtw89 is built-in driver, like
> 
>   CONFIG_LEDS_CLASS_MULTICOLOR=m
>   CONFIG_RTW89=y
>   CONFIG_RTW89_LEDS_MC=y
> 
> The linker reports error:
> 
>   ld.lld: error: undefined symbol: led_classdev_multicolor_register_ext
> 
> Avoid this case, and summerize the supported combination as below
> 
>   CONFIG_LEDS_CLASS_MULTICOLOR  y      m    m
>   CONFIG_RTW89                  y/m    m    y
>   support                       O      O    X
> 
> Fixes: 721d90c8509a ("wifi: rtw89: add multicolor LED support for RTL8852CU valve board")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609172315.ZYoKvKBS-lkp@intel.com/
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

398660e43ed9 wifi: rtw89: correct dependency of the multicolor LED

---
https://github.com/pkshih/rtw.git

