Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF67405C3F
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 12:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760275; cv=none; b=oKdb4BcDeDyxz/rcfw7QQTf79rQGXFYBWUT7Ptbus1qhcHkCOuzJa8WDvvL68LvSt88N2vYN5kwXzyswLyhmxkrkv8jxB6pJxb6OL8tIYVdWbB1qK5IzcBirv2uTALhOBGnPCHyQmZTBToS6GPaLd3Q3S4XhBu+6B9IBL41Kp64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760275; c=relaxed/simple;
	bh=MEQiUzCg83acwdXzkBH4d3ksrCoXU68yrJlDyqw8w8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTq7TqQ+2nSgMY7MrTbPPQepTMCwAKVpm6s9y48T+RNcS3jympCIWLrHviVXP86B0vamIQ8TYDGUmlanq0j++5UDFHpwPChwte54Ca5+3u1uQrMIMN9jv2Gw9GOvmJSiYxOsWkSVhk15CVmYKZzjcOWcsu72RSFxirYA4mBsPmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=woYUnhgS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="woYUnhgS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=A+G02hmHVcpztg5ZgXwqY0ZuZyT3NRGWL1xIrUSNLyQ=;
	t=1785760273; x=1786969873; b=woYUnhgStaPSQkMaQiK10T5zLp4HuYbYYrdAEOHAcEldC9s
	Tu80mn9EfwHnYr9GxXzH6w6dfh5M9VxSS2w86DBbwficp6SF8qEhf5kzWp5KbXtjv7UYGHFQQpPm2
	bBbr8RkQv6y5+cP43+1tZMYyYUdJ24Rdh/HWsXdpESYuCF5TZcqSBgTLKq7TFyUIIuPJDvsb31iZR
	b6WfKgQAv+hA5T5GtRB/OruMVxmZFVL9qDlEjh9g2pWaHvo4Vb+tbFtGsB/Zipz9MIao9BFrcXEyb
	vEJ3GtpXiZVq3PVU8ISO2UGQ4maSbMJGdETAR+KcfwdJtwF9uCeqxiF/dftibgag==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wqrp0-0000000CbZU-1iu4;
	Mon, 03 Aug 2026 14:31:10 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v2 6/8] wifi: mac80211: report to cfg80211 when no STA is known for a frame
Date: Mon,  3 Aug 2026 14:30:11 +0200
Message-ID: <20260803143005.22bb44f6d73d.I28d8146b9189c5961411ecb26b44588895de1b56@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803123004.281626-10-benjamin@sipsolutions.net>
References: <20260803123004.281626-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

This is relevant for hostapd to know whether address translation was
done on a received management frame.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0660ff18f584..edf0e7700d0f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3983,6 +3983,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		.len = rx->skb->len,
 		.link_id = rx->link_id,
 		.have_link_id = rx->link_id >= 0,
+		.no_sta = !rx->sta,
 	};
 
 	/* skip known-bad action frames and return them in the next handler */
-- 
2.55.0

