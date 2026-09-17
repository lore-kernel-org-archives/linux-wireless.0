Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543AE53446B
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660117; cv=none; b=SbMvV+33RNM1VQ6cK/cu8kvKwc1JU5jfdHZljrUvLqZdy8CM5c8K/U/KlXxbPf6TSoOief6Snrr3hzr5ujcFbjxIxEdylhTHuSGch3zE+TAFiQahU7I44E4zSwcdg0CdZlgm45UTpRlx9QhtJqUV1wHxoyfWAF6pvdFaEEWXP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660117; c=relaxed/simple;
	bh=OT+/yVmtxXayw7zlWQbeNg/PbunauEOYNtUr4VfcRoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPi9G4y2t/F2PCqyXovoM5OGtRpBdqtelCwQ0cbPWM/a+MlSeXpsJIQsyseXZpOAryHdG4q3+QEtdtQ84gi3JMeaWwnwd5e4V/W+ojHms+ZBWG35tIpGtEIMjACfZyFdatISvDNDGs6nBan+OS14kdNzUQQBOHYRUIRPhKNKXtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=OFTx8xd1; arc=none smtp.client-ip=91.218.175.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="OFTx8xd1"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OT+/yVmtxXayw7zlWQbeNg/PbunauEOYNtUr4VfcRoM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789660106; v=1; x=1790264906;
 b=OFTx8xd1g7y/PvhGL955VupUMsKVhJMRZDcgUfGJJS4N1ZYHU5bHS4JdTyhRl6OQFHW3ogV0
 pUEHU6goNMlnXAGicxJ1eE0qdLZ38Faw+gwkKsW2cS9+T8pi8iEwnCiYh/ZyBj+ocPO4DQaWDO7
 29oAR4F3ETNLJT7+O7lzszMxPQ0LzL9U2bq0h9C6AEaA3nkwofvVfa58cdYSztSIlPU6oRqBn6p
 vvUImpm/BUFqIbE8k57Pre0s14JhX3fYRXQNx2C3xlXg1JimV1tfxDRwn3CVyfxRaLPuZJRttAH
 TuvG7JNuzJrxp1jkLBoPsxYQtSazh42CzmTy2YIk8MIKA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 925e810515962063;
	Thu, 17 Sep 2026 15:48:16 +0000
X-Mizu-Trace-ID: 925e810515962063
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	nbd@nbd.name,
	lorenzo@kernel.org,
	eason.lai@mediatek.com,
	angelogioacchino.delregno@collabora.com
Subject: Re: [PATCH] wifi: mt76: Fix skb reference leak on USB/SDIO tx_queue_skb error paths
Date: Thu, 17 Sep 2026 08:48:13 -0700
Message-ID: <20260917154813.5823-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917122058.2150817-1-vulab@iscas.ac.cn>
References: <20260917122058.2150817-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wentao,

Thanks for catching this. The USB half is already fixed and the patch is
sitting in Felix's tree:

	Eason Lai, "wifi: mt76: fix memory leak in USB TX path"
	v5 posted 14 September, Fixes: b40b15e1521f, same as your USB half

It does not cover the SDIO side you are patching, so that half is still
open. One thing to fold in before you respin: frames the driver wants
transmit status for go into a per-station table, and freeing one outright
leaves the table pointing at it.

	mt7921_usb_sdio_tx_prepare_skb  asks for status every HZ/4 per
					station, then puts the frame in
					that station's table
	mt76_tx_status_skb_get		sweeps what is still in there and
					reads a flag and a timestamp out
					of each entry

Eason's version marks the frame done and leaves it for that sweep to
reclaim.

Devin
