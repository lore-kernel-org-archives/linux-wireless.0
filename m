Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B38451995
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 16:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786985137; cv=none; b=uJqYV4KYcQDiaOPrqedsAxaO4T0lSPQf7bc7FhxRZsLer93jAM870L0Oxe0O7RmJEU6emxV/x+0qNYZ8mLASRnqi+WqNyWOXcNPgIOT5uXYale0T+pf+AYLRegffNtoms75k8dQbSem8Q8BM5fG215e0Vx0Z4toPcCqAAL4gG+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786985137; c=relaxed/simple;
	bh=+KG+iiGRdylcb+xJMSMtImIGNJiqrfPHBleDHvNir4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaHYP2g3KyGi/b+/7IxWIrEzH6rd5gwN+9pluhCBA7SIAKz0I+l5pgdiVYWKXZiqIT8+7sxKSxAwCWw5Netaz1BJzGJrNfbNFZnqmpJWj/Id6eMDTU1UOZ2zomtUrcSzy1DMHalriEE1RL3CKPrHUrIkOjjLZ6yhnChNZkcssfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=sttFaVnA; arc=none smtp.client-ip=95.215.58.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="sttFaVnA"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+KG+iiGRdylcb+xJMSMtImIGNJiqrfPHBleDHvNir4w=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786985124; v=1; x=1787589924;
 b=sttFaVnA95D1eaZFP0/bTI9pGuwDndrufnGGouD6KgTWQXcJCIssGmcUGV87XDAx5fgy6DlL
 Yxec77sgNjhbQ004nZ1Q7M5aCrgWPcorZDOD520q28mGdvKfSmws1mWmYbbWq3yD8kipueszN5j
 2Dr8JRMmLKRJcBOHC4Oskwsj8LxfZOqoUev8BaLaOHEuY0323D8VgXKpGBpcAUtXehWcth6TwQ3
 2ic2iv6QkUC4E1XlykYyZGkfxpc9XHwUaXiNSUEKen9ey0Rz9duFC/vxTOo1aqPoPZAXEoCr82v
 HJrZAvYbbsYkHT0EIkl49bxsXm6WKBTw94yxhMx0SctHw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora.lan (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 366244d03d620435;
	Mon, 17 Aug 2026 16:45:14 +0000
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Eason Lai <eason.lai@mediatek.com>,
	nbd@nbd.name,
	lorenzo@kernel.org
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	kun.wu@mediatek.com,
	deren.wu@mediatek.com,
	sean.wang@mediatek.com,
	quan.zhou@mediatek.com,
	ryder.lee@mediatek.com,
	leon.yen@mediatek.com,
	litien.chang@mediatek.com,
	jb.tsai@mediatek.com
Subject: Re: [PATCH v2] wifi: mt76: mt792x: fix memory leak in USB TX path
Date: Mon, 17 Aug 2026 09:45:06 -0700
Message-ID: <20260817164506.13333-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817090157.168089-1-eason.lai@mediatek.com>
References: <20260817090157.168089-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2026-08-17 at 09:23 +0000, Eason Lai wrote:
> If you have time, please help test the v2 on mt7921u.

Done, on an MT7921AU. Unpatched, the socket fills after 111 zero-length
frames and is still blocked 20 s later. With both patches it runs 3000 with
no block, and the driver still rejects all 3000, so only the cleanup changed.

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>

That is the tx_prepare_skb exit. The other two never fired in any arm, and
the buffer-setup one cannot fire here at all, since mac80211 caps the
fragment count below the table size. Those two hunks are untested.

One correction from the 16th: mt76s_tx_queue_skb's prepare exit already
frees, from your July patch. Only its queue-full exit still misses it.

Before this lands. The two patches are not marked as a series, and this one
does not say it needs the skb_pad change first. I tried it alone and it
still passes, because the frame returns before the padding runs, so passing
alone proves nothing. Worth sending both as one series.

The skb_pad patch also needs my sign-off under the Co-developed-by, or
checkpatch objects:

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>

And it is worth Cc: stable. The Fixes goes back to 2018, and on mt7921 and
mt7925 USB this silently kills wpa_supplicant with the link still up, so
nothing notices until a group rekey. The reporter there hit it on different
hardware and ran the equivalent change:

Closes: https://github.com/morrownr/mt76/issues/83

Devin
