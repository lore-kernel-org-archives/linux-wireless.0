Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C92D9484
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391760; cv=none; b=taQFhQN/ndmhEQVb2EHNI7FR0/TwbnkJOUGSOLrWn54g3uKua2hg8OL8ZbvhfjHxCnNZ5G7Iuw24BhvwLv+U+r8BqgC3uJTggyrjhy6PNm2Zi8CaPXpFb2CgWLIEaFaBN8ENF82Qvvza4FiokC50BrdtpuqeJK1so5neV0raSoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391760; c=relaxed/simple;
	bh=HJuvcNu4HAVT67MDCsJXc3/YILFQdaFOw8wc2VWnHuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owAf8ci0ar3+TX5mXrNaxsfS9F9uAlGYq4Tq2mESt/pOPubo0m2M1GZP9aCKQivLcT/u3UD/vPV9HhHtf4iHjHnvoeHHIPz5Vnfcg3NwC/6QMDmtgDn6RX/3wKMHHyxbnpiOyS47SD5LEkxJUgdd1qkmka2uEhNkVTg43RjyPzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V2v3jFiZ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V2v3jFiZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HJuvcNu4HAVT67MDCsJXc3/YILFQdaFOw8wc2VWnHuQ=;
	b=V2v3jFiZP5nw3oaIJLKPGcfV+JHSygRSryE9BoV3QtBsZD1GlvH8yvnt5y9as+1LRU0hNy
	n7TQRxF9m/4TLbGv+9c0d4iAcj8vibTYmsq7fCJ0HWnR6HkpfGK8c8thFX76yjOw/TDX8t
	ueE4ryvO+0ClT21cJSau8NP9ohPpc1w=
From: luka.gejak@linux.dev
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH 04/19] wifi: rtw88: fw: handle the RTL8723BS management TX reports
Date: Thu, 30 Jul 2026 06:08:49 +0000
Message-ID: <20260730060903.30187-2-luka.gejak@linux.dev>
In-Reply-To: <45f43cd2-af91-48a0-a0b5-5862824109ec@gmail.com>
References: <45f43cd2-af91-48a0-a0b5-5862824109ec@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 25/07/2026 01:53, Bitterblue Smith wrote:
> This is not right. 0x12 and 0x32 are not C2H IDs, they are the first
> byte of the C2H_CCX_TX_RPT payload.

You are right. Every C2H event this chip sends carries a known id,
0x03 among them, so the existing handler already covers these. The
patch is dropped in v2.

> Since this patch changes the way C2H_WLAN_RFON is handled, it might
> be responsible for some "failed to leave lps" messages? Maybe extending
> the timeout (patch 3/19) is not necessary after all?

It is not. Patch 3 is dropped as well. Instrumenting the report path
shows payload[6] & 0xfc matching the sequence number the driver
enqueued, 32 out of 32 times, with the existing decode.

Best regards,
Luka Gejak
