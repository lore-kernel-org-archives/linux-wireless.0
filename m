Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40D61A0B15
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 03:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789876164; cv=none; b=TahvbYz2jrVv3Q6SLW/upIZnnpjEB78f/ugkyqfZcXdg0ajqLMKRej9voFtdzG25E+4lQKAx06W2dAEiNRs5+I1j8Mk508jdfAW0fcj+JIvc3mnddOOY0yixjFk3+YcTWH1LMfofrkqJ7WfuXL17uvcQYtOwK56utVsYcmyytgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789876164; c=relaxed/simple;
	bh=8tIQ0S7jyLanjgsT+/AQf2DFwUVOBpd95+f9sHDtt4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDtPcwqzFB3L0r580ejeZZIMv18Npj/GaVR+SP+5sdu/6FC4AMChtqkdKYzOZTfquklopnNiyNL24OfPbWuPhLBejLUWi3mc2CWnkZRxPUqqb7qSN4YxR0BiqesP9rgcl9zqcjkZste2kQtwHx7jucJsGpfNoPrXVXjhyqrrmdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=vmUDhVGj; arc=none smtp.client-ip=91.218.175.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="vmUDhVGj"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8tIQ0S7jyLanjgsT+/AQf2DFwUVOBpd95+f9sHDtt4o=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789876159; v=1; x=1790480959;
 b=vmUDhVGj00l43S/QW961TuRHUxxHFxffVUUNNFnildCOsnfg9R7uUtQjrPKwTHpDOEFfbNQk
 4fOsLql6VlZpkVP2Q8MaCH+4FSKqHFrpeHB10V9Lfb9si+YCsAZKiEvdEDuE5CobNJJaOFLIjn/
 1TGe/OiBhEaMKiSWmvAdgHjDRO8LZ7WiPPxZhVYvw5hFg4DqxDc4rBnx0SFu0Gbg7IA3KO9MFGh
 GyUysxPEZsjYbE9cEo7s49/y2HGtvGiZcNq/DhJLFqTOhqtVWo9AgOMeb0ksBFxqOTFhLcVmEle
 JgSKMYXrDyMNZya0btqvaWHKPMh5OzPDVM+HkTz5SwIyQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e762d4409d191228;
	Sun, 20 Sep 2026 03:49:09 +0000
X-Mizu-Trace-ID: e762d4409d191228
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	nbd@nbd.name,
	lorenzo@kernel.org,
	Shiji Yang <yangshiji66@outlook.com>
Subject: Re: [RFC 1/2] wifi: mt76: disable NAPI before deleting in dma_cleanup
Date: Sat, 19 Sep 2026 20:49:07 -0700
Message-ID: <20260920034907.199687-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916204750.1439984-1-greearb@candelatech.com>
References: <20260916204750.1439984-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 9/16/26 13:47, Ben Greear wrote:
> +		napi_disable(&dev->napi[i]);
>  		netif_napi_del(&dev->napi[i]);

Ben,

The warning and the softirqd spin are both real, and your 2/2 looks like
the right place for them.

On 1/2 there is a snag. mt7921e and mt7925e already stop RX themselves,
and they do it early:

	mt76_unregister_device()
	napi_disable() on each rx queue
	tx_token_put()
	mt792x_dma_cleanup()

It has to be early. A poll still in flight can come back with a transmit
status and take an entry out of the table tx_token_put() is tearing
down. By the time the shared cleanup runs RX is already stopped, so a
second disable there just sits:

	task in D state, refcount -1
	napi_disable_locked <- mt76_dma_cleanup <- mt7925_pci_remove

That was on MT7927. The USB parts tear down a different way and never
arrive, which is probably why this is easy to miss.

Would putting the disable next to the IRQ and tasklet work in your 2/2
cover mt7996? That keeps it where the driver already knows whether it
has stopped RX.

Devin
