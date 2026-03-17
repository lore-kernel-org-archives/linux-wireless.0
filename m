Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378332D7393
	for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2026 21:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773784329; cv=none; b=Y5rnCuGnMvuRUIilzMicGuMB7FILWw2JhtqwuZTqPTEENyEbc9ND/vEmUcNEC9wJsAc+o2Zn6pvZ9uZyJPTOUBPC+0/7YwtCGtH5FOGCb7XA10X3TWgv0Ie23DYuVW2qR4XTzrJveNK4otiJvCR42SASRjxnd0TR4N4Wx7Dbtdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773784329; c=relaxed/simple;
	bh=b97wXvolFR+e8uTxUV44AIrk4klW4uv/w8rxmuRBTvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXviXKQ73mdwqcasRfTpiFC8tlRgND0JMJ9p4LB/fR5M0kSfHoFSc7ltk+Jr0SefGzwPyNvSCzup64ctzcWPLxe9qrVHu3SCDUJ+bGmiV3w0TGE7K7GcqKYvj4qcKxGCbD0xPcGHQe2U05xsgGYarH6VBYCan++yiiFFf9KzS2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=McNzcTmJ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="McNzcTmJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1773784324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b97wXvolFR+e8uTxUV44AIrk4klW4uv/w8rxmuRBTvM=;
	b=McNzcTmJC/2il2UOCI/lu+tEQ/UnzmIk/CqheZbms3XrfXVudpE2Sqp1z2HIv5bVLqwZb4
	SJhalPo3N3PXezbvWJ3XLI2z8fAuvTpyJNRO3iJRcXdB5SYKMQ+ICd82QhaPJIzGuSaBUx
	f0R5GIaoRWO51l69I3uR1RZSknF8vtv14benj6MKNUR/9ML6i2Pkr4jDCfUtI7g+WMMOfs
	OeN6b9tzCB286cOHGF3wIz/md6LNP3rmjwWuvWVaI4ZB5qQ4ON0S8cGVjn9meD6IPsPYCL
	wYiSYjMv79B/FxMt5xwg+oV5kSD5KUoB1Lr7Hl7csz/3dQT8oCy7iGm6EgA4Pg==
From: Lucid Duck <lucid_duck@justthetip.ca>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	sean.wang@kernel.org,
	lorenzo@kernel.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] wifi: mt76: mt7921: fix txpower reporting from rate power configuration
Date: Tue, 17 Mar 2026 14:51:58 -0700
Message-ID: <20260317215158.152921-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260317173016.136975-2-lucid_duck@justthetip.ca>
References: <20260317173016.136975-2-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I missed adding the stable tag. This bug has been present since the
mt7921 driver was introduced, so it should be backported to maintained
stable kernels:

Cc: stable@vger.kernel.org
Fixes: 1c099ab44727 ("mt76: mt7921: add MAC support")

Sorry for the oversight.

Lucid Duck
