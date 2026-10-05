Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DD337F01B
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233405; cv=none; b=f0uCbSHHOvI7ySBSM48jvpIFDV1icpSTG6Jh4eM0ZoJ0a2PXe8ZWILCv94K+OLNnHkNTCRZzZnP+h+E3/lLEhXOKZ5phBKBEsDbXadc9IqAowwz9mYocAUFxEY/kdJAGaDY8T3B7+k6bkj/O7Nln7Dj4LcwEpH+pnV6ah/eg0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233405; c=relaxed/simple;
	bh=PhJd5I9w21yzdDnTVGBW7qDDDQJbhEjHtsf76N8Gss0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIoVo1g+90c0JgbISgJjTXEbmZmBVs1e5yH58pQkdflFHKA8ZAhjFSs0OJeNISp1v6GpyS72c63xjkUR8ciugNBrSAP7pBHiVM/u5WENSjpxnNNFzDzhYx8rrTceJD/FKHxBjiT6oFofL4a5Z1btHXKURoxYSoS8YAH5mZj7Z28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Y9eq4kZZ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Y9eq4kZZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=lGB6F+BjR2UgEctrzU16AmCtFNbI6+lCWlhIv7P/3oA=;
	t=1791233403; x=1792443003; b=Y9eq4kZZa3unmMA+hmtYciU0cyFrdkfFqUCIB3DyNXiaMQB
	6SKEN+3C5VW7mB5MXoxFURoXpq9eRpKtRXJDfm5PqLLQ/oE3XBkUQ2de/dr9YOMcTVbWll6LyJhma
	+SbunSzjsxs74+KQ/uCNIq1Kczr1EM6ZHeIcJ3aGFUwaaPNl0vnfN1QbIU2IYF6h29jDwy4VCRq4d
	Chugayx0Q+VvQA016S13j/fPyal+A2EZ32Wi1Jewj6ZJTb1nu/Q4RB3bKvK4NaBvEeqO5rHh/dvbQ
	re0SvyWmuV+vZSb/eOHFIv6rfvlzHAyfcuGy2Xx9hrq8u3el0F8Yj0YBmAN4w2rg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdH-00000005cw8-3sxZ;
	Mon, 05 Oct 2026 22:50:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/10] wifi: mac80211: don't read runt headers in injection
Date: Mon,  5 Oct 2026 22:48:00 +0200
Message-ID: <20261005224950.0f3c3e88abde.I03477f2444a9f2cb2888d00320ac7c4504f150a3@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

For injection we only check the header is in the skb
head, but e.g. ACK/CTS are really short, and we then
try to use A2 anyway. Require A1 (no S1G extension
frames) and use A2 only when present.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 34f3a4ac7278..27294466958d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2471,7 +2471,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if (skb_headlen(skb) < len_rthdr + hdrlen)
+	if (skb_headlen(skb) < len_rthdr +
+			       max_t(int, hdrlen,
+				     offsetofend(struct ieee80211_hdr, addr1)))
 		goto fail;
 
 	/*
@@ -2505,7 +2507,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		if (tmp_sdata->vif.type == NL80211_IFTYPE_MONITOR ||
 		    tmp_sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			continue;
-		if (ether_addr_equal(tmp_sdata->vif.addr, hdr->addr2)) {
+		if (hdrlen >= offsetofend(struct ieee80211_hdr, addr2) &&
+		    ether_addr_equal(tmp_sdata->vif.addr, hdr->addr2)) {
 			sdata = tmp_sdata;
 			break;
 		}
-- 
2.55.0

