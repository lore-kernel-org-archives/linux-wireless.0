Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1F74477EC
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425030; cv=none; b=HnHGmC9AI2LUUgfbdcuscBAxkcI9eAeoIhTd1o+MSugYLl0OlzXkwQAujcm/hkoHaN/CI+OICt7jL01MzxfG9HeYTlVXGbypZfkC4KaIlPdSvXtwCUllzuVeCt51oxEVCmaKqVfyg02ys7S7MFsgizmmyBVkZ0w/LvOF2s1MaEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425030; c=relaxed/simple;
	bh=6dG5N1i2YdWAGuK6ZK30WdsKvz48pHJpThM7XL2UIi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHHzHRZ5fpX2+eu1S6AckNgAK4agArGi5aJMOVYWB3Oq6tlmPYWfkhSM2CCiiMJd22nv8ALfBM0++MrJjREaF7DTQ29NhCn61DiPeMjQOgbP4sog/qrWiuk+eqzS4hAuNSHiFyxgknYHSVsH1giBHPTY1x9+DFB9vOHA6IGD2uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=khzV2DOH; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="khzV2DOH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1785425025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dG5N1i2YdWAGuK6ZK30WdsKvz48pHJpThM7XL2UIi0=;
	b=khzV2DOHaAVObpRQxnyGRKqAzmIyHRe+MT+R6jIae5f/8z92QEurH6GqYMnN+vV9A0bGGk
	wehPIbyKbYv6HjINv0m1hibBw5XyB4fRe/+cYZTcmCdMF8Pxi70sjJsNB19ePjbq+XiKsY
	v3yyDOhQ+aBx50s1FTsVG5E0c8sDXeDHSmqSVYUvpaQDBqH/im+V+Ty/mMLn6y7V2HgBEB
	Np3j5vTMbvBiSyD5w2arAkqMHzssxBciDGFDjVPUg7O1RYqWANg9YN+g9ao9vywLwJzZj9
	kRVd3ivSwP3LBO+L4tHyhD18yFiKcOUIt/yg1ght82uPp9sbfNbzCL6vsegONg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bert Karwatzki <spasswolf@web.de>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in unregister path
Date: Thu, 30 Jul 2026 08:22:02 -0700
Message-ID: <20260730152202.225117-1-lucid_duck@justthetip.ca>
In-Reply-To: <CABXGCsO07SExb+Z0PeN6MZ1fKC24Tvn3ehSyeQc-3qFC7jM7dQ@mail.gmail.com>
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com> <20260730050428.GA73812@sol> <CABXGCsO07SExb+Z0PeN6MZ1fKC24Tvn3ehSyeQc-3qFC7jM7dQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The token IDR race is convincing, and TXRX_NOTIFY reaching it before
mt76_rx() is the part I would have missed.

Send the v2 through when you have it and I will test it.

Devin
