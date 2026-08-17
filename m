Received: from mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ED72C3255
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 01:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786930918; cv=none; b=ZowEPd9LZiD5BL7Sub1OX3SJMWY+yQYZoW28JwRf1Z35IvEPKMM6ApyIJjD+Iso9+Yn86usaBPBabiT3CL0Vgx+fRKiWSL+fgmKkMqIJ6M51KFcwEs+/FVqWc6LvYImBK7GPw1FrTsY1Cw2doDH1o4THLWuHrDIXNDs7116Y4qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786930918; c=relaxed/simple;
	bh=DJCwPNFqhWi0MlleUBlxxtcVRk7WJHfmQEnRLHVll7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCEmsp2G7aq4JQVb4QFicOgTdzFZFHz296CIOD9yMYaxmZqTw8l+IG3JvInwdBE8t+NJpFFk3Msy9Pd24A6oqzV9DrsHdh0x6ky5OmEAfp8PSax33dBLyKGqVDyGN9Iv/y4Uy12jKxIB7GbTl4Wac8NjPPNZfI9EiilM1zF259w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=WQbntDE4; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="WQbntDE4"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DJCwPNFqhWi0MlleUBlxxtcVRk7WJHfmQEnRLHVll7o=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786930913; v=1; x=1787535713;
 b=WQbntDE41wWZcCE2vzxXd/WPh0dnFICgsq6jl7PjdQqILe6/IYDjlbtpksuEas89qeon1gRV
 Eac0gjMl9yM5py3pVAlfbv/8cwnaFzXDXdfzQX1jJeLo8XTJZ0Yd00i9tNPIYcnbV1Y7hOiDzK9
 oKb2O+5IrgOI3itS1vLohFNMVvazXfpKzbcrTSLykqByZ8tDhRSMBMQQWTnQpMLOc3w/fMY52bA
 4f9fVIUU/jX60zFPrD8V7QktK+XV3vlNrMrWFz/ph/O1jMwlhOqSYI9gkw9MB08tIQ0/EUS9e0M
 gWNTBzc5cELpDonYfHURKYxoJzgIe5MiDdqz0xJUD7TKg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 10df0a6bf6b43069;
	Mon, 17 Aug 2026 01:41:43 +0000
X-Migadu-Flow: FLOW_OUT
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
Subject: Re: [PATCH v1] wifi: mt76: mt792x: fix memory leak in USB TX path
Date: Sun, 16 Aug 2026 18:41:40 -0700
Message-ID: <20260817014140.68399-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <af39515e4277cb0c8079ed172ac8e0fccc106063.camel@mediatek.com>
References: <20260805073812.1433126-1-eason.lai@mediatek.com> <20260806222922.30384-1-lucid_duck@justthetip.ca> <af39515e4277cb0c8079ed172ac8e0fccc106063.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following up on the first hunk. Looking at that path again, there is a failure
behind it I did not account for on 08-06.

mt76_skb_adjust_pad() calls skb_pad(), which frees the skb on failure, and
today mt76u_tx_queue_skb() correctly returns without touching it. Routing that
exit to err_free_skb: frees it a second time. Special casing does not help,
since skb_cow_head() on the same exit also returns -ENOMEM and is safe.

The prerequisite, in mt76_skb_adjust_pad():

	-	if (skb_pad(last, pad))
	+	if (__skb_pad(last, pad, false))

It reaches mt7925 and SDIO too, so probably its own patch ahead of yours.

Worth flagging as well: mt76s_tx_queue_skb is not a model here, it has the same
two exits and the same missing free.

I have mt7921u here if you want a v2 tested.

Devin
