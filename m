Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792977128;
	b=1gEJ/XqQcPjE9mB8joDIBeNuIazn+ML3LLnh4ovdBkJwYUi6HuyvD5gJKMS5uFQCIh2j
	 IU6yHqpHJUJhPeLonNsKX075ZJTCkvseEQrn8uhSN8y4EEKWbzrN7fMthcmcS18a0zmVk
	 UAI6YDLFtFHEeWVXi1VXZVAY8xnz4ydEc1QAJoKJePupPDmtX9B4Q3N0oSorsKelC0OKH
	 XSaAZKK983eeWHHlJZlsDpH4fM7DbI1OFky9j5tHt6BBzg4lfafwjyEszmNT51P42Pf7j
	 Zb1l4SufTJr2gUYvEqhQy0gF48WU4Ys9qNZZQ4dcjtuQx9sEYNYN0JLQ+vxaw3QY7nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792977128;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/Vo0OMuSaDO/H3O6tzdFw0Cxs72b62Txtu4BXOLWidw=;
	b=3h3BnzDkOTX/RIVj39F8LsBn43jprKHrdoSmUr2iSoACUIbdArq5lALwYfrI0+3+DODU
	 XSKY3tBVZpMK0WcGo1VHHLbU9ayM+BBoLfrxQy6mKy0w8BJL/ASOUsXlDOyH34p4Jus/w
	 ubpIg2LTViFGDr0wANEQqDCbZW1TvHa8qWFpC4MaRbJ+uB22++9UcTyGYyOLAKQLw/YYF
	 3QygdIiE+5IbYk7Pv3H0wcpdROPbOwYhDAJUJe7w7Ya6wHMB9uAlEP1BFdgrIy5Z/JI/n
	 lSGwXNniAniB2CYOzr0w3Q397959Yb63n3K3qB4WW8V8/FiZl+na364df5iUN6lR7pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GNImmbwa;
	arc=none smtp.remote-ip=95.215.58.199
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1555606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 01:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1555606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GNImmbwa
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e4q6md8y3gvSn1L2GOVKpkCcmtKjI7Ho25c80BwSm+s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792977124; v=1; x=1793581924;
 b=GNImmbwamHLEuw+Ni2afNFPQFkc82NALK7WiElvXQhQ8x08iZe1INi/iQ5X+P03dzBe4ydzP
 zrojLK/Lj3iWZkj/fKBr4G3oCbzZK7nHd0xgt/urC4Kt1V1amhyy9+wSAuBJfA7XqpgA6s/5tKt
 FNxs5oI3f4t18FZ5dI+ch+ok=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 78f07ac51e919c2a;
	Mon, 26 Oct 2026 01:12:04 +0000
X-Mizu-Trace-ID: 78f07ac51e919c2a
X-Migadu-Flow: FLOW_OUT
From: Yi Cong <cong.yi@linux.dev>
To: lucid_duck@justthetip.ca,
	jasonvhodge@gmail.com
Cc: emery.hsin@mediatek.com,
	linux-wireless@vger.kernel.org,
	mingyen.hsieh@mediatek.com,
	nbd@nbd.name,
	sean.wang@mediatek.com,
	yu-ching.liu@mediatek.com
Subject: Re: [BUG] wifi: mt76: mt7925e: resume fails with -110 on MT7927, occasional system hang
Date: Mon, 26 Oct 2026 09:11:45 +0800
Message-Id: <20261026011145.3431585-1-cong.yi@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261024001637.22946-1-lucid_duck@justthetip.ca>
References: <20261024001637.22946-1-lucid_duck@justthetip.ca>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 23 Oct 2026 17:16:37 -0700, Devin Wittmayer <lucid_duck@justthetip.ca> wrote:
>
> Jason Hodge wrote:
> >   mt7925e 0000:03:00.0: PM: dpm_run_callback(): pci_pm_resume returns -110
> >   mt7925e 0000:03:00.0: PM: failed to resume async: error -110
>
> Yi Cong posted a patch for these same two errors on October 22:
>
> https://lore.kernel.org/linux-wireless/20261022085100.132368-1-cong.yi@linux.dev/
>
> When the resume handshake times out, the driver already resets the card
> to recover it, but still hands -110 to the PM core. The patch reports
> success once that reset is scheduled. It applies cleanly to 7.2.11.
> I've added Yi Cong to Cc.
>
> Thanks for the detailed report and the unload workaround.
>
> Devin

It does look like the same issue I encountered,
although I only see it on some ARM platforms,
likely related to their power management policies.
In my case, the driver just reset; system didn't hang.

You can try applying this patch to see if it resolves
the problem.

Regards,
    Yi Cong
