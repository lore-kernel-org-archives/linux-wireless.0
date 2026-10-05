Received: from mta1.migadu.com (out-222.mta1.migadu.com [95.215.58.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC07247DD76
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791219388; cv=none; b=sFVajfz8beYEFnkZ5Bc3HVwX3QsDmlbykJcmg1m8HxW+BGU1z/kOSUFZ0JPzilK7abSnywf0RzEyi4XGLK+EgA6tTxz7kVW66oitk4CKVHjBeboDjaz+JThISzO5Vzj8gbDZ4d7BqkV4f+/poI+5ZLzTQwRHEHArUEseTyEchAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791219388; c=relaxed/simple;
	bh=3EkFb2rmMItvPU09Xj3/yToO50k6JsJJgTdjvGqh2xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rWGZ59hbgTt0TaNPOSV5w+w47GMuFM3qGwRWn6U5cYvqrbPIXxPKMxk6yIhg6g93ogeit0GZ7tgo6hJdWxqDtjR2Q5zJpd/NiBERuM8M7Zx/oPmBXEwYFlTLBgTxRwcI83rlmZbmm6eKUMHuQUvmOpOZHCjdY3+r4rd9d+nXCYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=ZFtR6Sbg; arc=none smtp.client-ip=95.215.58.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="ZFtR6Sbg"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3EkFb2rmMItvPU09Xj3/yToO50k6JsJJgTdjvGqh2xU=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791219383; v=1; x=1791824183;
 b=ZFtR6SbgZg/nDmQYTZB1BLD6EZ73Gcdq+qgslN2/aFjmFWiP2kUWvAWjBnrN4xzoctwe6/HR
 PW/CZRZ87PYKTN0h+W88tJZP/BkM4f2kKPhUIqlJBkTJMU/6obFdKSqoBg3IQfLi3+72ehDvuc9
 CQL27ZboyJVgLG38hVlzGUfY/M7Biuvv39VuNELw450q0GV42lA2m1tDu3KGpmWPGwMAhcL/ReZ
 HyxzQamxpKI8sTw6BjynNNLWg33ypN7oO99t6frGuNBgi9jA0a6rzXIXXVpPSyv944IeV7y/8hP
 IXPKSTBTp/wgixfKxJKbPUdrpoSAuBUy0xtcMBd1+czSg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 60ac52aa7a996f8e;
	Mon, 05 Oct 2026 16:56:23 +0000
X-Mizu-Trace-ID: 60ac52aa7a996f8e
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Quentin Herique <quentinherique07@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: Re: [BUG] mt7925e/MT7927: panic in mt76_dma_add_buf when hw_scan runs after a failed WFSYS reset
Date: Mon,  5 Oct 2026 09:56:20 -0700
Message-ID: <20261005165620.218829-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAK8JKts+x7ioj2omw+hrQrKtRDbZ3yCYXavVpfjodOG6ro7t9w@mail.gmail.com>
References: <CAK8JKts+x7ioj2omw+hrQrKtRDbZ3yCYXavVpfjodOG6ro7t9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sun, 04 Oct 2026 12:52:54 +0200, Quentin Herique wrote:
> Workaround in place: blacklist mt7925e. I can test patches on this
> machine.

This should be fixed from 7.2.6 by f544bcba4721 (mainline
915672c5ae32). Its DMA index check is in the shared mt76 code, so it
covers the 7925 driver too. The drv_pmctrl patch you mention is in
Felix's fixes pull request.

Devin
