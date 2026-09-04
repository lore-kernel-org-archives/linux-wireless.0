Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AC53AAF49
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 23:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788565740; cv=none; b=VvE+MEOfIl2v/P53iRk64zhogYn1oJTIOhkF+Zcvp6y87nxy0/OxIVk/BhiQkdbH7hgh+2gVQ0W2U7qmbzz5VhFlhz3ZkTSniKkTiAr2wD0dmR6M1vbIpQyyv7+1sdSyKrdex95iCXZ4lEsckaE9/NAgtP+h1Kzp3bOIXN0DYUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788565740; c=relaxed/simple;
	bh=Ala5/BLJL1vTZTT5rbnsc1HNb2XPUuq3vvbqNTEsGFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9Neqr3+6UlV3wYNkPGZq5x1qZf5Ex77J5fP5f6JbNp2UKHzSzswvHGcyKqVeZ0TXAQvmYqPT/FWlE+ALkF+FQahQQvmV6+gOHYdOkHUD8hkAlpRmSs4STSlS02f3koHh6vKI8ccc4aJkkUu/e+6XspbBOstKTodhGbuHrrzBLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=v0SOakSs; arc=none smtp.client-ip=91.218.175.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="v0SOakSs"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ala5/BLJL1vTZTT5rbnsc1HNb2XPUuq3vvbqNTEsGFM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788565735; v=1; x=1789170535;
 b=v0SOakSsLwcrG1+czFK5BX6o+NUDmnmQnkYAQ60LL+W0RvcfH9Y+gobOTuCvnJ9jMRT1PlQ1
 X1Y/UW0jMw8ESWwtM6GAg2jNgSGBqsNDIBjEZtxbCSupJsAT0gCYk2hB5MRX99ZtoDaUh51+6+/
 MAx6KxafXTk0u1/W9/xo7ilY4wjKuH/0lhyNOZZYWT6Al3UujxolEonJjkejK8X57w6N9FPW4In
 TrVrtMjv4yMkfPqQ05TMULzuMb3fhkO6i8zrhRaZ6xtASzG0s6MkdQI7QskHsnKEL6C1aqaf5vl
 RyOY1uIZ607s6+f4NByH70mPwzhHl6NWrRJ62Yy+ksk+w==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8d2a338e5845b8b9;
	Fri, 04 Sep 2026 23:48:45 +0000
X-Mizu-Trace-ID: 8d2a338e5845b8b9
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Marco Scardovi <scardracs@disroot.org>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Klara Modin <klarasmodin@gmail.com>,
	David Gow <david@davidgow.net>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt792x: fix NULL pointer dereference in mt792x_init_acpi_sar_power
Date: Fri,  4 Sep 2026 16:48:38 -0700
Message-ID: <20260904234838.19342-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904161826.5638-1-scardracs@disroot.org>
References: <20260904161826.5638-1-scardracs@disroot.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 4 Sep 2026 18:18:26 +0200, Marco Scardovi wrote:
> Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")

There is a patch for this from 25 August:

  https://lore.kernel.org/linux-wireless/20260825181712.28548-1-lucid_duck@justthetip.ca/

Klara Modin reported it, David Gow confirmed the fix on a Framework 13.

One note on the Fixes tag. The crash needs a regulatory update to run
before registration, and that only started with these:

  9b80bd9cab40  2026-06-09  mt7921 regulatory wiphy self manager
  e9f3f1cc133f  2026-06-09  mt7925 regulatory wiphy self manager

Before those it just set flags, so the 2022 commit would reach stable
kernels that never had the bug.

Your trace enters through the regulatory notifier, mine through
firmware init. I could not find mt7921_regd_notifier_work in mt76
here, so if you have a second trigger I would like to see it.

Thanks for taking this one on.

Devin
