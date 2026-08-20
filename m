Received: from mta1.migadu.com (out-24.mta1.migadu.com [95.215.58.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12A435E93E
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 23:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787267825; cv=none; b=CMpQg2wfzYdeqkhXzDvDybqCvpL3AgOZrl1FFupp91VltVlnrQMta7ryKoDvyjRW+n+0OCcRMSf0c6nnxKTF2TIA3JtlAXv02tdwGpCxNJyRr28ZKnFHkystl+7JnOWu639wRIFmTqf0OPiXO3xnQpBjb2nryDnLOHnW3LCPLlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787267825; c=relaxed/simple;
	bh=5guak/l5UyDzlzPmHmh7n4osKYDtyW2ixRiNRrlsVf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZc+alNpML7pZdrf6TbYK07yjwh1JTZD5+oEGC2/Vi4/XKZ/5TXWMnTSKovACz699IjnL88hjKzkrFRRC7EwJWGJPi+nQt6zr3a0I8y5Z4breY0vtQTovs/3ymQL79gg3890NTgVcToYSA0UCRJIZsAbKft/7A+UGSeCxpzMoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=in3SMw6V; arc=none smtp.client-ip=95.215.58.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="in3SMw6V"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5guak/l5UyDzlzPmHmh7n4osKYDtyW2ixRiNRrlsVf4=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787267820; v=1; x=1787872620;
 b=in3SMw6VyM5Uf8XmGD2+iV73AO0EWiRd3g1fqLmoUNm74kSFI3ZrjklFZ9LoSs+szeO/fgw3
 OiS4bZNHBXTus4w0ltvdw8m+wy1YSxoHf2oCsr5roZMxTBF9fw3rzQuOEAf1NktptW2On+j8Ju3
 o+eGCnc3uLB2yEYAn4Mm9Z/Ngs09mfjUj1LyTkIW0cZeIxMMHZoSTj4Jr0VKoBBKRHY2xJQbgDU
 Cob7EY9gjT36MU8UDYva9miSl/peJbUll93nlp4KZOF7U2XzDAzflB+32VpYT5/9W25Kbgxtq5b
 Waq0cTJ0nOf61jGVkbL8iQBMJGmjXwJnxrFn3bzCSPRZg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (187.15.154.68)
	by smtp.migadu.com with ESMTPS id c467778d2f607571;
	Thu, 20 Aug 2026 23:16:50 +0000
X-Mizu-Trace-ID: c467778d2f607571
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Benjamin Berg <benjamin@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Benjamin Berg <benjamin.berg@intel.com>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org
Subject: Re: [PATCH wireless-next v3 2/8] wifi: mac80211: change public RX API to use link stations
Date: Thu, 20 Aug 2026 16:15:04 -0700
Message-ID: <20260820231504.137503-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <1bdf4b7d-2f05-4ae3-8304-60697d2c849d@oss.qualcomm.com>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net> <20260819155703.af6d319e6b61.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid> <1bdf4b7d-2f05-4ae3-8304-60697d2c849d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Aug 20, 2026 at 10:56:14AM -0700, Jeff Johnson wrote:
> The fix is trivially `= NULL`.

That does fix the first frame in a batch, but it cannot fix the ones after
it. The initialiser runs once, at entry, and mt76_rx_complete() reuses the
same variable for every frame and again in the A-MSDU loop. So once a frame
with a wcid has written a station into it, the next frame without one keeps
that station rather than reading NULL.

That is the case I measured on an MT7922. Sixteen frames out of roughly
4000 were handed a leftover station, and every one had a wcid-bearing frame
ahead of it in the same batch, so an initialiser would not have caught any
of them.

Clearing it on the no-wcid path inside mt76_rx_convert() covers both.

Devin
