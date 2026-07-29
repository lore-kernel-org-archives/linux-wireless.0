Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5BC33DED9
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 06:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785305854; cv=none; b=ojAyu9EneBfyy4z/lWnsoom3EEgKlD7Q3xNLCVKKSgcg3xst7oI/1hik7stA5lmviL7oEAgeQniooxTlURoqBB+NIrBvNdRxomH5f2UiCWlyXwZa5QLQV9jy2LHaekT3GRdZk++xXhumIutJp8gTVnpK+HdgUre8acdFp0LjIaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785305854; c=relaxed/simple;
	bh=6dqSmJBdunI9uNnMgG65m2ctsm3rG4IUOln2+/VVVb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttk7T1tJLQYC0a4H1DCBB3MWmeCuLonrDZ36Kjv+ToKCY84tKku1eldO+Cew4A+YnLBVfBd8KwOZG3ENUVchjwZyi36j9o/gAhow15VS1DcgKpdrp2MefoppMmpQBqy50tOcZVakqII10qI5O0e9RDfKiAEtMJP5WReAd07BK0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=q+4R/ap2; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="q+4R/ap2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1785305849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OvO5s+R2HKQPErzDdWyzgK0nJnxYViSLLiMX38PoGIQ=;
	b=q+4R/ap2h+VMcgd5LEYtjUHUddOkLP0zPfUGTGfwszlchUH5G5zzo+w4dccQU+p0weAn75
	CCMPXh+ygxK7KEcFq+iPLmxNn6RGNIeH0gjWWUF2DRM9NLLAgtLTvNNsW/ohsDUK5xSFh4
	UrZs//E2rDwQXi61Zxv7KP+81dNVIXmOl4pAosy0GdZRoEQjJIZWQcDidFTyJHCfun+qL5
	uFh26yPTZb/xinfDZMnMFhuCMcln+vxJYWXNfQIxkOoje+lgY3XV7peeXj14Ufji6MrADC
	Sw+ZlWmGRzD7k7PG7+81eGpYrXg3LoqLcXNkd0wiYrwXs1Z9XO8MCyLw1FpGfg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bert Karwatzki <spasswolf@web.de>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	sean.wang@mediatek.com,
	shayne.chen@mediatek.com
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in unregister path
Date: Tue, 28 Jul 2026 23:17:23 -0700
Message-ID: <20260729061723.40895-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>

Confirmed on two more cards here, one of them an MT7927, which I do not think
has come up in this thread yet.

This one cost me both machines today, mid driver work. Each went to garbled
colour and froze hard on the way down, power button only.

Same base commit either side, nothing else changed between the two builds:

  MT7927 / mt7925e, kernel 7.1.5    stock: rmmod hangs    patched: returns in 0s
  MT7922 / mt7921e, kernel 7.0.5    stock: rmmod hangs    patched: returns in 0s

Stock leaves the task in D and the module at refcount -1:

  napi_disable_locked+0xdd/0xf0
  napi_disable+0x25/0x40
  mt76_dma_cleanup+0x16a/0x340 [mt76_git]
  mt7925_pci_remove+0xe5/0x1a0 [mt7925e_git]

Patched, rmmod returns immediately and the card comes back on a reload. sysrq-w
puts usleep_range_state right above napi_disable_locked on both, and nothing
warns while it is stuck, no hung task and no lockup.

How I tested, since it was not a mainline tree. Both kernels predate
13b7e6a96a00 so their in-tree mt76 is clean, and I used the out-of-tree build
instead, morrownr at 905c0d79, which is where the _git suffix comes from. Your
mt7921 hunk applied verbatim. The mt7925 one did not, only because that tree
carries an mlo_pm_work cancel that is not upstream yet, so I took out the same
three lines by hand. Mainline matches your base exactly, so nothing needs
rebasing on your end.

Two things from reading around it. These two sites look like the only ones that
double up, since every other napi_disable in the tree is a suspend or a reset
that turns it back on straight after. And USB looks clear, because
mt792xu_cleanup goes via mt76u_queues_deinit and never reaches
mt76_dma_cleanup, so this may well be PCIe only.
