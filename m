Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F9347FB16
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865189; cv=none; b=A9dyfECkAJubzlh9fJFS2S/EASwrclUjmrv+UhSDix/yGsr7QSmNfg/s9ncnjL2qn0+NE0q04OjTkBUCP3dEbVdcn/91p/4YoN3jjl7mkUgKKsF55hVOVvDI0/uN/aXFl9ZcXF1Bt11e4b2TW6/TbqSKYlga5iG24MVkA3FJmzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865189; c=relaxed/simple;
	bh=JAPBxqHkelGcSiVMBuRG3cWm4XKFkI9ICYGuwQ7hfK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZC/cHsTZD0NOlBXQbpF/qkzzFmiM9VJMvcPF4pAJhwQUEmX0ATtQb/qHnxlV7+W0zROeabWnetRO5ZJ5sbq11wVUlKnlp919pUIhdIKwbJNN6t72EVvW/4AugT0GUj3iLTRqCbMhepQQBvHexmFLPj2S627SNzqwyQv5d99zIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=SAU6lsCa; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="SAU6lsCa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1785865174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAPBxqHkelGcSiVMBuRG3cWm4XKFkI9ICYGuwQ7hfK0=;
	b=SAU6lsCaDOaezARoVe0EhVKNDu/GoMcvYyZnYf+srBUMpOhI4g8cgHcB2U7+ivdWbgq17/
	nqRpMTd4S+C9+xk2WHN5no9Ku2d2c89it0vJze8pSBP0AiQy8C1DymtW2kTnOZKvSB08Jq
	mPJOLhJ5RixfamGhugNMQrK9fvZ3VUH2CvfMrtWYGujsW/P0ZBshZDzZk350QOpc2JZ+Ko
	gIjBkx/WwmXR9bj7kEnwxDRQ3uRxI0lLsiUCJ6R05csG5tTPcoZf78HkJag7IcuDXy8qR9
	0jSQEnmmMIV+ss73kRFIZ5ibAx3jXqNgOdukkyhc2/tWEjIblRz1gAHxz+G7Xg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bert Karwatzki <spasswolf@web.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] Revert "wifi: mt76: Disable napi when removing device"
Date: Tue,  4 Aug 2026 10:39:28 -0700
Message-ID: <20260804173928.13547-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
References: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The revert works here. Module unload, reboot and poweroff all work again
on an MT7922 / mt7921e, and the USB path is unchanged.

Applied on top of 7.2-rc5 with PROVE_LOCKING on a second MT7922 /
mt7921e machine, independently confirming your result. Before the revert
the first rmmod never returns: D state, refcount -1, and the same stack
you posted, taken from /proc/pid/stack and sysrq-w. With it applied, 40
of 40 load and unload cycles finish with rmmod in 0.3-0.4 s, three more
with the interface associated and receive traffic in flight all finish
under a second, and a graceful reboot and a poweroff with the driver
bound both complete normally.

mt7921e disables the same instances in its suspend and reset paths as
well, so I ran three cycles of each and unloaded after every one, to be
sure those paths leave the instances in a state the remaining disable in
mt7921e_unregister_device() still handles. They do. No warnings and no
lockdep reports in any of these runs.

Same host and kernel, USB control: mt7925u reaches mt76u_queues_deinit()
rather than mt76_dma_cleanup(), and 10 of 10 cycles on each side of the
revert behave the same.

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
