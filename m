Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0EF2F7F14
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 06:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788072130; cv=none; b=qK9kWOMlFkJNM7RH11kRZk/YzZzm6i8s7QKQMwJP6TIbzYWqtj4zgOMgX+wpqBvqUQVu23cDZ5nktSnKexImtQPgyuszMQAx4Lwe5E+4qZyY0loZxSH9zUMcO9wnWmJqxGqk2b7rKYE0ipewcXkX6j+XmIgX27MyF7iDMZw8REo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788072130; c=relaxed/simple;
	bh=BSvuPWNInRSNN0xT6NPa8YHVirxgprFPCBEG8neHW0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PpeMCEZSckfVDjjqlDhQOls66pZH4Igw+ZZYWyTHajcnw9WP09UNdPi7rbuZaaMbShZt0VTHxVkKCjd5PEY4DNHEovW+5GorQIh1GXhXmxtaUAtcyc7IX3z3jlQG/5JKfvXC9YtFOE6p50Sc5Fvo1iX/Nx+5D5RvvgtwMO8l2Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=ELPGBrYl; arc=none smtp.client-ip=91.218.175.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="ELPGBrYl"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BSvuPWNInRSNN0xT6NPa8YHVirxgprFPCBEG8neHW0I=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788072124; v=1; x=1788676924;
 b=ELPGBrYlBkEjAPxZwNZXI0+WLqCbAhaaTHRoyCjqzlfr+K7t83eNZ1rQc9DLwbtNrPzRZaZ8
 udPnHL3GgqJ1aHwlQ0OCgwTLFX6UGfaSkWy+iBJcKQ7TqTr50+RtdiP9kH/PHONZLNGFniG/fua
 2Ye1rn+AxvZdGzEWlb/kesAQORR+kEpVUwqH4A0uDP/ZzwJzgxs/0SjS441z5GCw7Spcw3DZcR3
 ZT5XlEah4tW6L3e9NkJYO4OcVuxk58WcEaVEZo+tTDbD/pSVF64cBhOQFuRV0hUd8s50V7yL1Ka
 eAK7KRbEeQ+1S6jBkxRj59GPLR4h08CCcv/m+YlUoMCiw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 36d2ef1c74f41eac;
	Sun, 30 Aug 2026 06:42:04 +0000
X-Mizu-Trace-ID: 36d2ef1c74f41eac
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH wireless 0/2] wifi: mt76: the same lock inversion in suspend and resume
Date: Sat, 29 Aug 2026 23:41:59 -0700
Message-ID: <20260830064201.92285-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Follow-up to the config-path fix taken on 10 August. Suspend and resume
do the same thing and were missed. One word each, four sites.

Devin Wittmayer (2):
  wifi: mt76: mt7921: fix the lock inversion in suspend and resume
  wifi: mt76: mt7925: fix the lock inversion in suspend and resume

 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 16 ++++++++--------
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.55.0

