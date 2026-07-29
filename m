Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D344E1A2C0B
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785287250; cv=none; b=IYNNt0Is8HtE3lFZdVmbqa+IUI7gl+T6aA/lGXdQjZWGPgCbkXQj9dGqAmtsFehlAku1fvhHFA6iWWOiFjbsCMG2qAFm2X76SDReQ0JierVcmTSXfE3fUHrzQSfh2PNN9lRtKQAd6Tc3LPVHi7836+OTExbWUTmbpQoqLxqmUFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785287250; c=relaxed/simple;
	bh=ayIuWc7UucFsvFWD17KRfhafjScmEIFhBA8rXeE4th4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urI16PuLVnnn85/oHPz8252NLVgEhexq99s0ZKOZURnjENqY0Pp2Xf/+gNIyCo3PaSxlxBqVjWp+4NJeQ80UdYTTRPsX50KHNGm6gqpM0QrpUgiyHkTSvC4+as8hgtlmx2Exxw9IVRlCUYdZb/xJVRD9CWJYSEl0/aCmykIwF7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=ZFKNJorg; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="ZFKNJorg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1785287246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sydcfWPhI8RrOjPZI25NYNGABzLR+V6YjfyNPpoYA4E=;
	b=ZFKNJorgBdSiZYAN6w6LWK/ovB/wsdP3fUHNn1eBvKB45Tl4+NKOgwQx3qXE7DIjbdKlQ7
	PArHkOEPagzHxRtTSKcRT8G4DBevZrcU+/ptyinEFZIRNWliQ5NhtQyJvUhig4BryH893h
	I0f3pExyrrALwOM/CFEbc7D4sr99LKwxx7+rPPePVevgxwQDQlIoLJI57jQkRJ9LL9JaLS
	2qgEWPANCStxXvKjT4R6Rqk+JSkBDTWRAExmOMejQNghR0/o6BezjQYNx7ZT8ZlLKoj493
	R2/JH5PXo483/8TDjXqf7sq2sSW1ujBFw0YiYjxO0xPq2KryaU9ESCHIvZ7JpQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org,
	Shayne Chen <shayne.chen@mediatek.com>
Subject: Re: [PATCH] wifi: mt76: mt7925: cancel mlo_pm_work on stop
Date: Tue, 28 Jul 2026 18:07:19 -0700
Message-ID: <20260729010719.20631-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260627202946.25598-1-lucid_duck@justthetip.ca>
References: <20260627202946.25598-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Felix,

Today I just verified the last sentence of that commit message is wrong. I previously wrote:

  mt7925_ops backs both the PCIe and USB drivers, so this covers both.

It does not. mt7925u_probe() overwrites the stop entry with mt792xu_stop, so mt7925_stop() never
runs on USB. I traced a teardown on an mt7925u adapter with the patch applied:
mt792xu_stop runs, mt7925_stop does not.

I have also now reproduced the original warning on mt7925u, on a tree with no cancel at all,
which I was not able to do in June:

  workqueue: cannot queue mt7925_mlo_pm_work [mt7925_common] on wq phy10

So the patch covers the PCIe path only. If dd84a549868f has not gone up yet, dropping that one
sentence would be enough. The USB path still needs the cancel. There is one in usb.c already,
but it sits in mt7925u_suspend(), and rmmod and unplug go through .disconnect =
mt792xu_disconnect().

Devin
