Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB76385539
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391768; cv=none; b=ZO1ftTPaomjtlqTjRLFLKdW98spJdDQrdxfflWQnohgE3SdZc4CO4LOoi69v7+mf4yRaRfaFY8tx6PLxF9FzsZoKrrfMK3sn4+MXV//u0fsBaOj5gXAS5FMV2h4tdxYBQO8QDMa4lJ4WKV7Gf0oAj81Lij3o/Eix0ig3T0JPXx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391768; c=relaxed/simple;
	bh=1OQNI8ay0i2fV+Cg+4EHIsjsYXKAsrVSCfkMWnE6tJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6ErtKa3aKp3S2ZwySJDUnK/XvI3KKWMkuW+yJ8iTuudn6gI2xHzATiv2G/OJQKNtdaxD753Pq6CEjqcc8so+NequXVupCdRH1QktsUDF/ScN4wqacHrxxOSeJ+Om7ZuQUkOA8hMX64Ey3Yuk9u16/M00FplY9fn4BQkK6mBSmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LheSsUoK; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LheSsUoK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1OQNI8ay0i2fV+Cg+4EHIsjsYXKAsrVSCfkMWnE6tJ0=;
	b=LheSsUoKCf/6tKJ/ZSVWB3IUBLwDVLqt5KtP4BaXIHd2Nt9dPoceHdmZbjMSw6daL8MXNx
	fbj3xLMYDEk82Hn+Lcy30VHq57UWkq1b/3UPB7B64gD0QXEnACW1PZeb2Y9K3PJTJ6i0I9
	2LyRkTLyv3T9aB4RzJ7ift+fDAx/SCA=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 13/19] wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
Date: Thu, 30 Jul 2026 06:08:54 +0000
Message-ID: <20260730060903.30187-7-luka.gejak@linux.dev>
In-Reply-To: <8ded63af-64cf-484b-977b-e4458278f9c1@gmail.com>
References: <8ded63af-64cf-484b-977b-e4458278f9c1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 14:25, Bitterblue Smith wrote:
> Why does it apply to the others?

It does not have to. v2 scopes the change to this chip and leaves the
other SDIO parts writing the status word back unchanged.

Best regards,
Luka Gejak
