Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A103C465
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2026 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773969520; cv=none; b=CsYpsWxHAlrVV5oIKEV1oLln/SK0WdfEyhBz6ZsRCQGZeDOjW6uJzlSiEwN3/hEuB40rGPSl6F1ItVWfbPD2yOSB+gARuD44mVFXJgKNtYvlzX3CVVKDDe9+d2uAWM76s4WGutPk3+QQnYBTUuhdVDYarFQKNCjwOnIn5JrVAb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773969520; c=relaxed/simple;
	bh=Jvothlz+wfPxedCpCKUTvZl8/DOXcxdI1a5GR5EJ458=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUcQ7M3rkJSAUWmbTrPPg4K0QTNhdiVjNazFZYBLZan8J9zMSFKdNnV187Nxi/pQbyEXPB1VG2remZrpLvJcAvfr/hmhOL0T7HAQd0apaY0RNQ+JwQkNbarvL/J2X3rX6dbf8NOqMaHbzXnKCthIDENPXRJj9AlWYh612RrPj6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=aTXykOmx; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="aTXykOmx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1773969506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jvothlz+wfPxedCpCKUTvZl8/DOXcxdI1a5GR5EJ458=;
	b=aTXykOmx6NOdxm3/0DbOt3iSc3DBlfrZdawMf96zUTLWbWiTaUArNTC4nMFDmw2TNm8QTj
	G8YVHuLQs3fU6nthGqCDFMOT2LgAKNnseVg/P2sr++agvvJuN9WszxQr1nn4g4rmcToKC/
	NcFIyUhTpvhS9CHaYXxldkiCge5EJb9Hrc0D18oN8DvDySCJgXnQeEV01bdzgpOycgDkIB
	jq12MqtyCaY8D43vBNfVwIZQplY2iH1MbWkJBw2sfAooHiQBvwwmJ6FE+TL/+ihiEyHhXh
	YApmEStehnU70c3I9+9nU8sz6g8EY+pTsaDB9Rv2WD/msdBmYjLT3oiZmDS6Tw==
From: Lucid Duck <lucid_duck@justthetip.ca>
To: sean.wang@kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	morrownr@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] wifi: mt76: mt7921: fix txpower reporting from rate power configuration
Date: Thu, 19 Mar 2026 18:17:27 -0700
Message-ID: <20260320011727.77939-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260319203854.30479-1-lucid_duck@justthetip.ca>
References: <20260319203854.30479-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Note for stable backport: this patch uses mt76_tx_power_path_delta()
which was introduced in commit 56e38675c5bd ("mt76: support power delta
calculation for 5 TX paths"). That commit renamed the older
mt76_tx_power_nss_delta() and is needed as a prerequisite for the
backport to compile.

For stable kernels that don't have 56e3867, a trivial substitution of
mt76_tx_power_nss_delta for mt76_tx_power_path_delta produces identical
results for 1-4 chain devices (the lookup tables match exactly).

Reported-by: sam8641 (compile failure on 6.12.74)
