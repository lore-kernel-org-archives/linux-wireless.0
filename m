Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.75.77.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793383720;
	b=f+oTVEJDgkyY2rIIsF3CpCR08DeoIrj3O55WIG9SmpTy7rczAU3OSfITw9Mg70FIMypp
	 luvXFg/l+0myULLM6KwpEGdMwdT1kT1rbTkkWTawaXljUGwsB8Q8luE1kb6RQ6Usi+7YW
	 Js1DzQFx8N6AmdCtDsHsutCtiOLXv+SQmaBVLgGJuQRTLD1jdYCAFT6cCrlSu0De0CayM
	 mbrzKDXqZs2AH7nX9tsiF5pH7XP92l2PxNBbwDLm16IA7YfRFf7uDAWB+VU/N21U43bDk
	 oiBN9ZjQhawng4bSeYZXHTq4THiFzVqX1gV4d1wK4/xYLG/OEMr35LdCuUnPNKeZDpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793383720;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Last-TLS-Session-Version;
	bh=wP2uKJAR/PdPYRR58NON2g95Mn0ql5N7em5CuGJSfP0=;
	b=D1WKKGxOLgat7OvR+8lYsXe2OtUM53DcBvrFsfK0Lju9BCPgKWpLbtetyQqbqeiNSFk3
	 y6oGRUn2hRhQVFP0+HeRpFPbwoilKQ8HQJdpABzmmzK1mSjoriLMdq+AkqXnvCBpv+BM3
	 yBdsDhIjB1UgXa7sdGwOa4twohaMcQCZEI/NPgNvZuGu5+RwF1PDA+NUfGpc3124ms9Og
	 YA1ZJOriQYf6zGyCjyIRcQyV7LSEw/b9xN5yeGRFfoQ7dMwIZCB5vrFL0yoj07IXY03BT
	 NkC11ab0B+CZuAHHYxq6YreUHpph6igm75FW7R8r2MeBJcV4pxD3P+GlnHkA6CDUdzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=adriel.eu;
	spf=pass smtp.mailfrom=adriel.eu;
	dkim=pass header.d=adriel.eu header.i=@adriel.eu header.a=rsa-sha256 header.s=dkim header.b=BqYndvZZ;
	arc=none smtp.remote-ip=51.75.77.166
Received: from mail.adriel.eu (mail.adriel.eu [51.75.77.166])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441B606A31F;
	Fri, 30 Oct 2026 18:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D441B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adriel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=adriel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=adriel.eu header.i=@adriel.eu header.a=rsa-sha256 header.s=dkim header.b=BqYndvZZ
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7243426194F;
	Fri, 30 Oct 2026 14:08:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=adriel.eu; s=dkim;
	t=1793383711; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding; bh=wP2uKJAR/PdPYRR58NON2g95Mn0ql5N7em5CuGJSfP0=;
	b=BqYndvZZynu4yoErIJySJAEvgQUdgHQuRJs7LYSoGsbLpmaZv0vuObuBcueAQYgf68fE82
	ZyblxR5539Oa+x2sh9E8GSaF7EOTdJmReDRK61ZO58+IiZvEBFWC4aEn4DEsvpv2+q/UKb
	U6VhmSoP5W2n0SJTxHcxvhkxBO7fOtoCsqTqMlYzOtZirfX52q/86YXkqkeE8EojdVOway
	FWqS02HP/ZBeVD93IIHpiDFk0f2Lqq9B1eqR+1IxLVn+Ttm5WB4wQ5g1ofiYqeA22ehqgW
	RTKkGTPT29O7YwMel7290bXMnVWn8HbackRafvfH6ATAuYtVmBFroHzZlscc+w==
From: Adriel Santos <adriel@adriel.eu>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next 0/2] wifi: ath11k/ath12k: fix a double free when the first fragment's descriptor copy fails
Date: Fri, 30 Oct 2026 15:07:03 -0300
Message-ID: <20261030180705.1702009-1-adriel@adriel.eu>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

In both drivers, the RX defragmentation path queues fragment 0 before it
copies the fragment's REO destination descriptor. If that GFP_ATOMIC copy
fails, the caller frees the skb while it is still queued, which leads to a
double free or a use after free plus a NULL dereference on reinjection.
Both patches move the copy before the queueing.

Patch 1 was tested on IPQ5018 on an OpenWrt backports tree, with forced
allocation failures (details in its notes); patch 2 is compile tested
only.

Both bugs were found during an LLM-assisted review of the RX fragment
handling, and an LLM coding assistant also helped write the patches and
run the bench tests described in patch 1's notes. I reviewed the
analysis, the code and the test results, and I am responsible for both
patches.

Adriel Santos (2):
  wifi: ath11k: copy the first fragment's descriptor before queuing it
  wifi: ath12k: copy the first fragment's descriptor before queuing it

 drivers/net/wireless/ath/ath11k/dp_rx.c       | 22 ++++++++++---------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 22 ++++++++++---------
 2 files changed, 24 insertions(+), 20 deletions(-)

-- 
2.47.3

