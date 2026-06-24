Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337CB188596
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 03:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782271911; cv=none; b=uguZExmhgLUMFv590fbb2bUXp8FkQVf8P12fuQ19EmgC8116Rdu3YQlq1uv4iD5ri6euOAtHMI3a8kQaG7+FomLTxWIqp89vwHCjIgkNpvbcStZFLwEuPn5Vs5CriYXR2DhgzcoK4V8Blr5B14PvoE/eMYpmJgitVdK7SK3CfqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782271911; c=relaxed/simple;
	bh=JpOS3+PhzRpY+cjPpPjbMHL1H+dnvUhY5o3zciKGtgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcfXNqcR9iIA/j5o3vFbJFwC52BwBlxAx3pNTajlUFM0VK94HqDmHIE9vDFYhJBbrB9Dbqzu2fgRfAxbN28GlfYwalPt8AeRfRTGxkd6TdT2pqRZO8y7c7YXxSxXw4XErZ9266qdn6BCK3joBb4qFHNZBlrL7jYc6d42CN2hJQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=O5FSVNP5; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="O5FSVNP5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1782271906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpOS3+PhzRpY+cjPpPjbMHL1H+dnvUhY5o3zciKGtgA=;
	b=O5FSVNP5b4dlvDdDqUfisGctV6dkiQR39yNAnqkoEKVXM+dqW7wMwyMg+KTNkyJ6tGxIf2
	s7Ng6mQTC7mZlA7MDYd+leFlJ8mk2/N3BE6KWWJ733DT/Qpiqtn/IKAxnX1myGML2/ay8D
	mTSqjzdrVjPYu7mFPvW2RZqf88Yr+OiyjaeEtUMrcjT5KncXIQWmHp1fFoiBoxEFC8aSNE
	QY2YZ0OA2/8PgOJg6uBtISl/74J2c7LVSnLDHgfKhTnkbG9mBidQ/CmKojkYDfGXDQGXUS
	xRfLyPMnJH+HHkA6tJtvDBxuSUJqs8+VO2kzl8To3R5jQUZVd+YYoJAsXbfWKg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Sean Wang <sean.wang@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: Re: [PATCH 1/2] wifi: mt76: mt7927: set band index for sniffer mode
Date: Tue, 23 Jun 2026 20:31:35 -0700
Message-ID: <20260624033135.121054-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260613225144.2414283-1-sean.wang@kernel.org>
References: <20260613225144.2414283-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Tested on a real MT7927 (Filogic 380, PCIe). Two monitors on different
bands capture at the same time with the series, and drop back onto one
band without it.

I tried each patch on its own too. [1/2] by itself still collapses both
monitors onto one channel. With [2/2] they stay apart, but then one of
them stops capturing, so it looks like both are needed.

Single-band monitor and a normal station connection were both fine.

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
