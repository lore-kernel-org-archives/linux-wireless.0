Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719810;
	b=DiZuBN6FiAGL6EPtznTEXSrxzSKMu1zEAkEtQ1QHpODTuM7mMfzesAcCVS93DOXn2TMd
	 aYBb4NcJSb/NCIOY0Gw9pivtivyTZD6Hg4blyttPKqEvZSpPlB0E8zxSgrjLBmfEuPDFO
	 Fh/YiH0ymyh7qqEdiQ3PBuNUFOCXnHtk1IeJVYPqBKB6PlGVgyXE/JxM8jbsFhtPlqwkj
	 A++azpBPR0AbAftM29v34ZaGE9QZp81gJ/w2Dc/Z6um66Rhx2gEOhJkzsfQ4NzkBqby8M
	 urlynTGfEpKx9c9pNpgyV8b0C8E7INSRIPm8ZAHsXFhxqvloZWf5ZDA9rFzZMnSLgtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719810;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ogEItddFGy1dfxgZ8OsDI8k93istC1hjwjvkHUUW+Zc=;
	b=1TkbTDyGAo7Oy1CIjBx8CZJlpohvqyuxg9nD3EV2aAVT1irt6U9KkohFEgxv3MgmgKb6
	 2iKSmhD61J58QdhmILV2Is9BzsuZPFBTgDp1JppqKfw4ChQ3mR7+mnqVaV2GSRYAzIqKP
	 j1ahNr8FdXQyaXwgl5DifnV6JjTHMLorXjVW2ppw0rPM2U81XjHb6lsWpPZmeSRSl8ezO
	 FyYlto3c47AiCjIK9NLUs09MGlRgRS27yBA/vyyc+LPj00gdwUkdDrPVZ3CK5nTuzO0R5
	 ZSqMdYJNFGqBKOWX14/b/+3JZh2KvvprKpMN/HfniqERHTSxhkcNrw5k8/wGD5rZZhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=bbN3l48F;
	arc=none smtp.remote-ip=95.215.58.183
Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90557606A337
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90557606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=bbN3l48F
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=En0uQiOngjLZ1HAaEA3BeDftVVy9jafInzYJ6k+h4uQ=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793719802; v=1; x=1794324602;
 b=bbN3l48FgduD3jch1SlWYQFE1KrzrMmZCVScgQVcTA5/2Vbi4BlfeQHIUUfRPh7MV0w59fxe
 e151FLhixxAZzdHz1mu/XVE1+isE4YQZE1OldTcSRjh1VHrfbLmniMO8rHsqp5I0+damhKJDkHr
 Tx9EDGMqcJtaJSkz6sY3xcnDsaSyim27fb+0qKKixbTedx8WK9EQM4Vu9vLzXcF2RbUabG8h/m0
 JGwioMnXETy1d8XkLBQfOvoQqnR6YVsFaQc0W7ElK5cI1huBds2YVgS3DGa0Cj4RGglZampVmjE
 t2X7QxrxRFF+EVj/JYnBqOKV11ydgC8J0ahFnJan3XOYA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 71056d8b7d6406ef;
	Tue, 03 Nov 2026 15:30:01 +0000
X-Mizu-Trace-ID: 71056d8b7d6406ef
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Aaron Beckendorf <albecken@mtu.edu>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt76: connac: honour injected HT/VHT rate and bandwidth
Date: Tue,  3 Nov 2026 08:29:54 -0700
Message-ID: <20261103152954.8781-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101202727.392683-1-albecken@mtu.edu>
References: <20261101202727.392683-1-albecken@mtu.edu>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sun, Nov 01, 2026 at 03:27:27PM -0500, Aaron Beckendorf wrote:
> This makes 20/40/80 MHz HT/VHT injection work on mt7921u/mt7925u.

mt7925 builds its own TX descriptor, so this never runs there. An
MT7925U injects at 6 Mbit/s with or without the patch.

> +				mcs = tr->idx & 0x7;
> +				nss = tr->idx >> 3;

The rate field wants the whole HT MCS index here, which is what mt7615
passes, so the mask loses the second stream. With the whole index each
HT and VHT rate below goes out as asked. MT7921AU injecting, MT7922
capturing, 100 frames per case:

  requested                 as posted       without the mask
  HT MCS 0 (20), 7 (20/40)  as requested    as requested
  HT MCS 8 (20)             HT MCS 0        HT MCS 8
  HT MCS 15 (20/40)         HT MCS 7        HT MCS 15
  VHT MCS 0 (80), 9 (40/80) as requested    as requested
  VHT MCS 7 x 2 (80)        as requested    as requested

Thanks for this. Without it every injected frame goes out at 6 Mbit/s
on these cards. I'll run v2 through the same test.

Devin
