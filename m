Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8505641684D
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 06:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503961; cv=none; b=nsE1/n5p+zTTUJxw6YbW7G+CCayELM47Wy7bCIp/BSiZi/HPUORaPj/ehqc1youUte4ZeBxeAj2yK5obNlTWtnMi3fzAhJQiuTi5SAjaIQ0zW6vlGojlbKPioRr6e3SFilQBLWO/eMhak2/LUwYy80tpT7M+VzPmvMOo37ds3q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503961; c=relaxed/simple;
	bh=YGvx98Tz2FML0LvjF/Dg0WhaeyNHH+kTPvoeQxEpaqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXOJvBmwxoW3AeVuC53sTTRqYqzOTX4sQer1CDlbg31wekD33FFId680LHdipEZ4bgJj5h10N4KI0Lxhg/PlTqth/0zYKosfYCj3zGjm1WUozwKPaVTF83+eNVZLo1MRUJTLMzsxYfmefF1zYCsJBmrO3k1aXlvteCo0e9Bysgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=oKKJy/rs; arc=none smtp.client-ip=95.215.58.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="oKKJy/rs"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YGvx98Tz2FML0LvjF/Dg0WhaeyNHH+kTPvoeQxEpaqE=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788503956; v=1; x=1789108756;
 b=oKKJy/rsiAfMv5d0LEd0O5J01zukYQejc6s2JRMaYfrC8R2X//xZ5zaJ2pfefK+5BR81hkrV
 z63HxolL/qQA5XXTNXf9k5kkiNHBOEiKfUPtb8bdBO87lj8bhp1Ii1TpZDGx2+C+4gTQ0LE2657
 WwJvVOgBqsT4NVmAmU90Np7vcguFTbfgCABZslKwHH3aK+tZckqCf0DfaIa7NdmAPXH4U4xHYZK
 DkYSk9a+9LUbHOVIEs2iwvh9fJDn3Q7AfyAO5KgpOzKo2qdjd9l0zplFjrLXOA6MK3RjK0AL9Jj
 gsAJLsrZcmE3i8NA8h8vnF+gcFspNBMJ09u5B7YSEoJLA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a199b6197a3cee6e;
	Fri, 04 Sep 2026 06:39:06 +0000
X-Mizu-Trace-ID: a199b6197a3cee6e
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Mario Stanski Jr <mario@getscale.com.br>
Cc: linux-firmware@kernel.org,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	regressions@lists.linux.dev,
	jb.tsai@mediatek.com,
	jwboyer@kernel.org,
	nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com
Subject: Re: [REGRESSION] mt7925e: firmware 20260813113118 causes severe low-RSSI 5 GHz loss
Date: Thu,  3 Sep 2026 23:38:57 -0700
Message-ID: <20260904063857.55152-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAJe=AAkCeK=-pVve0Ffw_k0UBp4_AiO5BwQ1d2yG-pVe8B0U4Q@mail.gmail.com>
References: <CAJe=AAkCeK=-pVve0Ffw_k0UBp4_AiO5BwQ1d2yG-pVe8B0U4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the A/B, and for publishing the hashes. They made this quick
to set up on my side.

Unfortunately, try as I might, I cannot reproduce it. Same ASIC revision
79250000 and HW/SW 0x8a108a10 as yours, both firmware pairs hash-matched
to the SHA-256s you gave, 5 GHz at -70 to -79 dBm against a WPA2 AP on
5765.

Eight arms: two in-tree kernels, an out-of-tree mt76 from 30 August so
the driver is 7.3 era, power save off to match yours, idle and loaded,
and a ten minute soak with a continuous pull underneath.

  gateway packet loss   0% in every arm, roughly 1000 packets
  gateway rtt           11 to 121 ms average
  1 MB HTTPS probes     3 of 3 completed in every arm
  25 MB pull            1.4 to 2.05 MB/s

None of that argues with your result. You held everything but the blobs
and got a clean separation, and I would trust that over my negative.

What it does suggest is that the firmware on its own is not enough on
this silicon at this signal, so the rest of it is in what I could not
match. Your board is an AMD RZ717, 14c3:0717, where mine is an AzureWave
14c3:7925. Your regulatory domain is BR, where mine is pinned to CA by
the AP's country IE. Your link is VHT40 on 5805 and mine is HE on 5765.

If anyone else on an RZ717 has seen this, that would narrow it quickly.

Devin
