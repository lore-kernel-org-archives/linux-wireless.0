Received: from mail-139-mta251.mxyeet.net (mail-139-mta251.mxyeet.net [23.172.139.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5B4AA3F1
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.172.139.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211382; cv=none; b=n+gv0hIZWbZ7f3z9mxrtKd+8tI/ryyh6BoGX/U0nqWh3yNFUMdRrDz7DHM/oBY+ai37oUImYU6AWLjFpV6y33T6tk0gzAyEjc0CCoKeHDmh/EtXrAvbcty/bDYNXR3ZY5Ktf35VfuvZohhkWJuRKVyKGHh1F41Pv1V/CAsxoYUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211382; c=relaxed/simple;
	bh=9YGDjY1vYVijQB92yUeELjAVI0R337sPyorF2am+YUY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=STLCPF3p4y45l08c7DdzzN/OQQlDK098msGNWJHCwNbfr6byVS4nSo8vG4xwuCbHoqYjIj0/7hghqhnnBoK46kDZkmBN3+GENaawJbWbHXA2qAeUMQscBnCuwyDtWJeoaKcmhXzN+THfxMgMpPoypIdzp/IPLZyXAGA3Qy3UGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev; spf=pass smtp.mailfrom=endrik.dev; dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b=4TQ04GJc; arc=none smtp.client-ip=23.172.139.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=endrik.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b="4TQ04GJc"
Received: from lu-shared04.cpanelplatform.com [2602:faa9:3000::1006] (Authenticated sender: relay@mxyeet.net)
 by mail-139-mta251.mxyeet.net (MailFilter Outbound) with ESMTPSA id 1a10c84748e00089d7.002
 for <linux-wireless@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 05 Oct 2026 14:42:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=endrik.dev;
	s=default; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=g22i9c42czROMUzVLasefPbOfPkxQ+xpmXjci54RXu8=; b=4TQ04GJcdmZyMYCPl58nhTEC+i
	uJZJitngO2gHu5VDJGWQjP/DBqC6XIC0XaH7T/3k4jDy9EW/fQTcwI2ffJG15yejkXBgKy9o8iTDq
	4rAIZ9a/uUg+GOe7nqMyOWtae5sXgXqtvjVaYk2iMGZk0S8867sQ2r9xgkZDOCNY9Lq+9OpCg58hM
	iqYVNCc9AMYeHc9B4im5o5VmiHWaUb+1UUdljzRIiMUdMeR6T7gVZmA+qbPd69BItZzAuNSdrsmwD
	zmhZwIQGmT6kb5KjZkUHkhNSSvogh6AHPAI5VvqBk9zqFFuYdWHQOMbWu1oi4SiGk4may7S8Ni3yu
	l36eVFgA==;
Received: from 85-253-174-246.ip.elisa.ee ([85.253.174.246]:43792 helo=noether.localdomain)
	by lu-shared04.cpanelplatform.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <git@endrik.dev>)
	id 1xDjtv-00000003E8N-3NmA;
	Mon, 05 Oct 2026 16:42:47 +0200
From: Endrik Einberg <git@endrik.dev>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Endrik Einberg <git@endrik.dev>
Subject: [PATCH v2] wifi: iwlwifi: mld: include VI packets in low latency detection
Date: Mon,  5 Oct 2026 17:42:25 +0300
Message-ID: <20261005144225.170280-1-git@endrik.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-From-Rewrite: unmodified, there is a forwarder that points to the actual sender.
X-AuthUser: endrik@endrik.dev
X-NCN-Id: qrBpiUCfTMOkjygEbw==

iwl_mld_is_vo_vi_pkt() checks whether the mapped access category
is less than IEEE80211_AC_VI.
Since mac80211 defines IEEE80211_AC_VO as 0 and IEEE80211_AC_VI as 1,
this only matches voice traffic and excludes video traffic.

This was discovered during Wi-Fi troubleshooting with LLM assistance,
then confirmed through runtime testing and manual code inspection.
Synthetic video-priority UDP traffic did not automatically
activate low-latency mode, whereas voice-priority traffic did
(observed through the iwlmld debugfs state).

Include IEEE80211_AC_VI as intended,
matching behaviour of iwlmvm's iwl_mvm_calc_tcm_stats().
Explicitly specify the two values to match,
avoiding such issues from enum value comparison in the future.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Endrik Einberg <git@endrik.dev>
---
Changes in v2:
- Match IEEE80211_AC_VO and _VI explicitly, as suggested by Miri.
- Describe how the issue was discovered and confirmed.

 drivers/net/wireless/intel/iwlwifi/mld/low_latency.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
index a4ddc32e2860..e7482623111c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
@@ -257,7 +257,8 @@ static bool iwl_mld_is_vo_vi_pkt(struct ieee80211_hdr *hdr)
 	if (tid >= IWL_MAX_TID_COUNT)
 		return false;
 
-	return tid_to_mac80211_ac[tid] < IEEE80211_AC_VI;
+	return tid_to_mac80211_ac[tid] == IEEE80211_AC_VI ||
+	       tid_to_mac80211_ac[tid] == IEEE80211_AC_VO;
 }
 
 void iwl_mld_low_latency_update_counters(struct iwl_mld *mld,
-- 
2.53.0

