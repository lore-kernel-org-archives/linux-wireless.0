Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C33A3835
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270472; cv=none; b=mjNBQo9C4/aIiXw23IoQtxPcHV/MbkU7svIL2hN/J7rA/rcn41nuzIDwSkiede3mvoLO68zS6RgauDf0pFcTqe0HqlmGvDXg3BLgl3NNMBiIUtoVk8hStf4dMqdWcag6E5e0X/KgIPxFL8YR85cNGEwAtUU9pOluXoxoLQP3DnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270472; c=relaxed/simple;
	bh=DXHneObEFURGAmje7Og6zAxA3fF6Totm6rdxbwrFdcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3ggN7qroXfbRowQoS73dW1qqc9bP48QxYbp6ShzfGtYbv7NNbsWFzA/0aGMuVg6OCngMlvhxLmDruHUeRlIbShn6XzSycw+h3tw71AWJb66Ssr3Y/WsxEFB7tcadbU+/bPgDE9O4g74mPW7qHQsjyYGJq8IDe+2gLlKnPGt21Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=aCsYRhqt; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="aCsYRhqt"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 793A344007C
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:43 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 06B8A13C2BA;
	Wed, 11 Mar 2026 16:07:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 06B8A13C2BA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270462;
	bh=DXHneObEFURGAmje7Og6zAxA3fF6Totm6rdxbwrFdcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCsYRhqt+w5waQxesDioYs91zpG/5SzzXbtqZG/vINAjiRiXI1e/co7rDEO9x7myZ
	 dFeHp1iFainstmuLxbirqBbpr7RQ813xp0RDIcGIdJwWqVUg0okNQsNvdTbtQ9gMBB
	 66SZM+R1znMkfocmmhv+p+P+eJBv58YAdyY5g6PE=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 24/28] wifi: iwlwifi: mld: Fix NPE in flush logic.
Date: Wed, 11 Mar 2026 16:07:26 -0700
Message-ID: <20260311230730.163348-25-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260311230730.163348-1-greearb@candelatech.com>
References: <20260311230730.163348-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1773270464-QCCRQeyBNs5J
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270464;QCCRQeyBNs5J;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

It appears that sometimes the sta can be NULL, so check for
that and return early.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/sta.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 288fc4b7604e..06e064466e3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -779,6 +779,9 @@ void iwl_mld_flush_sta_txqs(struct iwl_mld *mld, struct ieee80211_sta *sta)
 
 void iwl_mld_wait_sta_txqs_empty(struct iwl_mld *mld, struct ieee80211_sta *sta)
 {
+	if (!sta)
+		return;
+
 	/* Avoid a warning in iwl_trans_wait_txq_empty if are anyway on the way
 	 * to a restart.
 	 */
-- 
2.42.0

