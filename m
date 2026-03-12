Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD53FCB00
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334872; cv=none; b=eQHa47tIzRTBI6mLx1jZffgJ8VKhgE9D78cnj2885ReBw0lvOstnafmX2HcDwu6K3GtUd6yce0nOtND/11gmPdeuF38wUSOJLT44ChEQt4znGpMvjZYV5VBT4ou5uKuLOjU/LPDaMk02CcAk690MmaqpMBQmbDbWjzMUFmdmIXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334872; c=relaxed/simple;
	bh=DXHneObEFURGAmje7Og6zAxA3fF6Totm6rdxbwrFdcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKGKwhWsnZabYOoj0kVkhumfF4MzEFB/WCvgaI8jPKHydZYnNXJbR8UNb9WRTnuzv1BtRhBBCEKV+mWDAy9S/GzlMH0CSvYz1s9uh6v6qxlIOBidh5UAO2rAHZuSeuXMQ+0WVyGQgtQ8oAPMzJSE1T2CGfEV9NcTT1aFbkHu4qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=Da+5kD9V; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Da+5kD9V"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 056112800C5
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:05 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id A600413C2B0;
	Thu, 12 Mar 2026 10:01:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A600413C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334863;
	bh=DXHneObEFURGAmje7Og6zAxA3fF6Totm6rdxbwrFdcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Da+5kD9V86Fqo39gwFHqmDaOTZ0Tw4J/wiWeExd1f2QMBazrTu1qshPIIJOUtOARm
	 0AX/U4On+sTNXAC4igBUW7ZffFqfYGI1MJeyR2lOQXGctNrEVaIrLkrB3qqz9+Jphp
	 mAHP/bF6RtosXBgtPnjMCg4QnidZUGeVrbfub1VM=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 24/28] wifi: iwlwifi: mld: Fix NPE in flush logic.
Date: Thu, 12 Mar 2026 10:00:22 -0700
Message-ID: <20260312170026.285494-25-greearb@candelatech.com>
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
X-MDID: 1773334866-PdPcwDGvQAKP
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773334866;PdPcwDGvQAKP;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
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

