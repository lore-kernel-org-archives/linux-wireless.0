Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1623CF1F2
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785951980; cv=none; b=BVGXSQP1LM/pMrb2iQtgqgmGKMYAm5Ej2v0vVlZq24qM8xDH91VXv3ETsTH3luJvuqG8xZUH/c6EUKx2ZmMKEtr/FeoeUajuaJITFk/QKL/chGBW1MHgLLp3/GOS4JrOfQKy+Bp2AJwqQ3+J1Ehl1ByFHAU9ECMd2XLGsT88Cx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785951980; c=relaxed/simple;
	bh=o7ng/cmVQXY9mla2VqJUJELwUacrCdUjhy+kH1xY3tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci92SoMb1lQVw+LIFW3RxDXxDgNlcjSofZ3uttioceChr/OSGc2BcAEel35dOy4njHaIJTnM+eUGnI3j0H5zc+UiLaImbYMrE6LKyfWhTIZKa4jXAjmgkGQMN9utm60Ks0i7QnDhJ+LsXKkpfuJgqAKUHIqEaYEgR3oVSwyYByo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=o7zfSZUC; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="o7zfSZUC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1785951974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BsTD/RLAzXhaEpkyZ9hFQJmsGqAIFu/1rRW/UG0mD3g=;
	b=o7zfSZUC++OqfF0ZQvWHS0ZKTBo8rHKoVQ/ctYZROH4rm5G9Vv9ciPpMtXqD9GnzQRQ6qI
	P8dQqwtk8RMD9eesh1dj+vErU82N1NUIpmPYGTFX7jE45mCOdmfFt9eJCkaZVhpBeajvL4
	M6MSGFSGIkmTl5F4LJDwTrpD0u4M1XneV1odwssuZrYbEIHu4EUVuxNkCdts5wSTkb1+/k
	Ir5wBBNqgDL/NNZfa9Zv4kLm+AKMqAYczzqpxlAJGLCc/+om2x8PoyMSaVrkkXplj0jdOI
	ecnMJRS83Me0RE84xduWUKgIOgKx5fmpLcfMCrqOh83GI6fZFSZATsvkuUwE2g==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Eason Lai <eason.lai@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Kun Wu <kun.wu@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Leon Yen <leon.yen@mediatek.com>,
	Litien Chang <litien.chang@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>
Subject: Re: [PATCH v1] wifi: mt76: mt7925: Fix MCU command timeouts during module unload
Date: Wed,  5 Aug 2026 10:46:00 -0700
Message-ID: <20260805174600.28064-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260805072846.1428148-1-eason.lai@mediatek.com>
References: <20260805072846.1428148-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Tested this on an MT7927 here, against a reproduction I built on
2026-08-02 when I hit the same teardown. It fixes it.

mt7925e on 7.1.5, morrownr/mt76 at 217ee83d, which carries the
unregister-deadlock change your Fixes tag names (openwrt 98c13eb564e5).
Each cycle associates WPA2 at 2412 MHz, runs a 1400-byte ICMP flood, and
rmmods with that traffic in flight, RX sampled off statistics/rx_packets
immediately before the unload at 375 to 807 pps across both arms. Both
arms built in the same directory, so only mt7925e and mt792x_lib differ
between them.

  condition              stock                      patched
  associated, 10 cycles  59-60 s, 19 timeouts each  0-1 s, none
  idle, 3 cycles         9-10 s, 3 timeouts each    0 s, none

No warnings or call traces in any window on either arm.

The idle row is worth a line in the commit message: with nothing
associated it still costs 9 to 10 seconds, so a bare rmmod does reach
this, just small enough there to read as normal teardown.

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
