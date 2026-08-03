Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227DF1DFFB
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766399; cv=none; b=XRY3elVkoWORV3B14LSKKNPchVEzPsea7ZeedY9DvTK0PhnEone7c2FvjlLqmzhDLgyuIo+f2PaQgB6AhJP3v0XGR4LdNkl0TvvEh5KZJDHeQLd4GHRxu0W/EPUBed4QTf4TjINBxuJDrOseoQSRjFXa2CxWXmeFwHHxVxzJYa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766399; c=relaxed/simple;
	bh=Y0yIsenAM3jlClJLtnIRbQAYxKKzx50AJSf/9W95Cpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcBHYH3oK52/rwMBtGirNqEHwF+4BqQQI7679MmistKBTzeLjsoKGnQfc1SkE8SNLCsHJ81EHz9AokFa3xYH2rrQY4NHfw/A689Fec5kwxy/VbBMBsbQSQ1y3jAO+gtJUiLUcqFlbm3IBmFXqHWWN2AV7V4ExCqoVQTZEM4zY5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TZ5Wonnv; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TZ5Wonnv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=8eTAJMRnBlX6hdB9VU72LrvfA5HnGx7AMYXFZkh20eA=;
	t=1785766397; x=1786975997; b=TZ5WonnvjeBmolEcyHrCnxq2kg+9oDaQ0oF1bi2zaa11Nx/
	995edobrlNZEsBmlcd1Obs9HyYIv6G8Jd0myLw0PKoKKSnNpGcABGkQrXcMGFzwRNDBELpnUKwCqJ
	MhNa/O4ilKUZZjZLjos87Pki2vzW+1YsNWOsoneTyp01YB6IwSoPo1D0w30SERiKgmXL5v/c/SF+Q
	GzxDlD2t+Araz6TTG+BhqGp/23gpjViv6RERfxHLHs9fK4M5KgQxfmcAaqs1HE3l6jvjbGbKaPypB
	1bR1rlJs92SbSmutOVMPUmyqR7/6efeoYKZwfEfYJ3hEXoqPLveM9h0YtkKnstJA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPk-0000000G4Ws-2m68;
	Mon, 03 Aug 2026 16:13:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/7] wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup
Date: Mon,  3 Aug 2026 16:08:37 +0200
Message-ID: <20260803141309.292711-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803141309.292711-9-johannes@sipsolutions.net>
References: <20260803141309.292711-9-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In ieee80211_build_hdr(), IEEE80211_TX_CTL_REQ_TX_STATUS is checked
in ctrl_flags, which is wrong - IEEE80211_TX_CTL_REQ_TX_STATUS is in
info->flags, so the check is for IEEE80211_TX_CTRL_PORT_CTRL_PROTO
instead. This works out OK because the only place setting _that_ at
a point before this gets called is in fact ieee80211_tx_control_port()
which was intended here. This is actually needed for correctness, if
jt were checking info->flags instead, TDLS would fill/leak the status
frames created here.

However, we can just fix it by using the cookie instead, that'll be
set for PREAUTH frames via ieee80211_tx_control_port() as well, and
no other frames.

Additionally, the code also erroneously set it, but that just caused
preauth frames to get it set, since storing the ACK SKB will also set
the correct flag. Drop this assignment entirely.

Fixes: a7528198add8 ("mac80211: support control port TX status reporting")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a1e2c9e1565..6c2ee181a3a7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2945,8 +2945,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (unlikely(!multicast &&
-		     (sk_requests_wifi_status(skb->sk) ||
-		      ctrl_flags & IEEE80211_TX_CTL_REQ_TX_STATUS)))
+		     (sk_requests_wifi_status(skb->sk) || cookie)))
 		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
 						  cookie);
 
@@ -6554,9 +6553,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	if (unencrypted)
 		flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
-	if (cookie)
-		ctrl_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-
 	flags |= IEEE80211_TX_INTFL_NL80211_FRAME_TX;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-- 
2.55.0

