Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D243FBEAC
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334867; cv=none; b=YktVXPnI808+xt9ZjladJibELY6ciFyS+BN9CpgWmCsEiicNBeVSUbaGtBSza+ib4Jiiiefa3oRhcplOsigWKQ2qSNoSz3N98kn1zVe6G5xh/ztRH3VPbEx6zHIdpJxigAF25quTWb2XRAmuqkaiTg4cw6Y88h/WR/zWMy+80PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334867; c=relaxed/simple;
	bh=gNRD0rEqOB0gM9zwBE03cN1xzYsnS1g//pftpskP4kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw8j6OSsXYnMDGYLEb5Qwfb7NgruP0YnQjJMMN9JKWwGstBJgUzmZeOWl6TZObdZpQNymdC7mGmSfvv8Un25SVg6BksoJALIxB/PYQx29kGWhpbLr0ma2eUZZ0vouGrR4RBFu75iIlQGBdiS8izVvKsvQO3BCQDprIkeWby9Pmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=mpzW73dr; arc=none smtp.client-ip=148.163.129.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="mpzW73dr"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D0528400067
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:03 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 9ED4313C2B5;
	Thu, 12 Mar 2026 10:01:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 9ED4313C2B5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334861;
	bh=gNRD0rEqOB0gM9zwBE03cN1xzYsnS1g//pftpskP4kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpzW73drlZm/q5vQajwxNfgZhZjmJQ6CuNZr6XHASQInrGLnmlNwe7LUCyUS75rG6
	 VsFsm/p/BquHzT169lIp2KTBofTY68SVG8b36vjz4tqXGgmWgTtG26SUCjFPmXjSkM
	 sT3OPg5L5D07+xXC4AyOdjst29Ly2EPBU1a0InHc=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 16/28] wifi: iwlwifi: mld: Check for null in iwl_mld_wait_sta_txqs_empty
Date: Thu, 12 Mar 2026 10:00:14 -0700
Message-ID: <20260312170026.285494-17-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260312170026.285494-1-greearb@candelatech.com>
References: <20260312170026.285494-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1773334864-Dq03SioA1kin
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773334864;Dq03SioA1kin;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

I saw some crashes here in eMLSR torture test, looks like mld_txq
was NULL, so add check.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 6338ca46f68e..288fc4b7604e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -789,7 +789,7 @@ void iwl_mld_wait_sta_txqs_empty(struct iwl_mld *mld, struct ieee80211_sta *sta)
 		struct iwl_mld_txq *mld_txq =
 			iwl_mld_txq_from_mac80211(sta->txq[i]);
 
-		if (!mld_txq->status.allocated)
+		if (!mld_txq || !mld_txq->status.allocated)
 			continue;
 
 		iwl_trans_wait_txq_empty(mld->trans, mld_txq->fw_id);
-- 
2.42.0

