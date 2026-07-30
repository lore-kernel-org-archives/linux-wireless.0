Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9654B3B14D0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397545; cv=none; b=C1oWQ6BfAn157gU9Oiizq/hCUSNdd41oshZMxnSAFKAHkRze6cc/8laTv5z+M3vs8jf7FCX3u1qWxxkf5SC+NsFoil4DioNaACb9nmFHq++NlC2S2RRyFSS6v1Ejd9Brn2s7WmLljEUCMG7NnRgePgQ3PNwoXMgiklJf0BjYCSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397545; c=relaxed/simple;
	bh=NYL9+Iko3h1c8Lb5N8PGSC8gdoJvO5OQVvnG7myu1uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY/YooPr9y7TplOkLsDG7Xac2qqTVxZkMPfGLabXNqdMM0J0HggVqeWlHI+COdZqpp71UPwq7zM7UbIuBEdxHjbmmnhxN4obUGklLpR4hmKVeT2B29GwA//XLI1nenZWH4rDaKjv6f+GSIP268qKFXJ2Kz7e9CyKbL70iiuA4Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NP28lxgz; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NP28lxgz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4oNLn/1Y830os5QOR7ahPtstkBoQ4YTu0H/L7jtWBs=;
	b=NP28lxgzn7pM+j74b3z0aeMcfsJ+DfuSUiKvBQYz3CImyw3OT8ZlMF4SfV0xM9l8OQ2DPX
	U7PnxMrMu6VUSjSkHXfBkLUyEEBoOmEAmVVmAjcS7vgRB3+R5xN3/RUg/6SKfeeQFsdLCV
	2W9PllFDLAtEUn9j1rigwjaN1dPzNzc=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 08/11] wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
Date: Thu, 30 Jul 2026 07:45:01 +0000
Message-ID: <20260730074504.19725-7-luka.gejak@linux.dev>
In-Reply-To: <2d3e396f1e184e6eac0a232578d0761c@realtek.com>
References: <2d3e396f1e184e6eac0a232578d0761c@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 08:59, Ping-Ke Shih wrote:
>> +               rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST |
>> +                                      REG_SDIO_HIMR_CPWM1;
> 
> align the REG_*

Fixed.

>> +       if (rtw_is_8723bs(rtwdev))
>> +               rtw_write8_set(rtwdev, REG_RXDMA_MODE, 3 << 2);
> 
> I think you are setting burst count?  rtw_write8_mask()?
> 
> #define BIT_DMA_BURST_CNT	GENMASK(3, 2)

Yes, that is the burst count. Now

  rtw_write8_mask(rtwdev, REG_RXDMA_MODE, BIT_DMA_BURST_CNT, 0x3);

>> +       /* RTL8723BS keeps raising the interrupt after resume if undefined
> 
> comment style

Fixed, along with the rest of the series.

Best regards,
Luka Gejak
