Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F913FBECC
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334869; cv=none; b=Iomiy2sihctMlB8xpsBkZu4yagaCWdTBwOJr19shImoArIgMS7In0xFTM4t/Ny8XjVnMppDVy9/m95hQxL8LRDAgok2A76MtCot8PJcSGhyA6Lie2PS79TxmsCLR+ziapuKGEDb8OyaxdfE3pyqgzJf0AzPi2Xj9omkW8XO/EOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334869; c=relaxed/simple;
	bh=ngFDQ0cAIO7qZXeGoGzYmHTsZtk9XY2mOwfcW+xjLn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bp7009c+BnLOu/b3ogt4cevgxEzMizlr8KrWVjozWtKaqqyG7/J/kAanuZ6ETsKWH4ltaFlvg9Kru1w0Wf03kvuBU4tuEKoej5NhZaATyWySdINFQvNw4FDCr/Wo/5IQX5xLUDaEiDjpUpJy5Ont78mUYRB370A95gx1pgVEjPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=MDzqaHh9; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="MDzqaHh9"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CF107280070
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:04 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id EA7B213C2BF;
	Thu, 12 Mar 2026 10:01:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com EA7B213C2BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334863;
	bh=ngFDQ0cAIO7qZXeGoGzYmHTsZtk9XY2mOwfcW+xjLn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDzqaHh961EISbx5EvVySvePohTJJnKUdDtaDcitgmfJM9te+Ag88FeZwyGkXEUS2
	 mmtv4BPPc+w67/JLTV7lbVSLoSxpcImrVobJEPnaQp/SJ6ZBrBQ5Jg2jUD/RQfaegq
	 elz9FWKoudAxprmp8hguUeyGKvcakcukbpSwl76M=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 21/28] wifi: iwlwifi: mld: Protect from null mld_sta
Date: Thu, 12 Mar 2026 10:00:19 -0700
Message-ID: <20260312170026.285494-22-greearb@candelatech.com>
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
X-MDID: 1773334865-jrl7J3zZzafU
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773334865;jrl7J3zZzafU;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Torture tests were crashing here, protect against a null
mld_sta.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 1557aa2a4866..43bc73764dcd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1911,6 +1911,7 @@ static void iwl_mld_mac80211_flush(struct ieee80211_hw *hw,
 	iwl_mld_add_txq_list(mld);
 
 	for (int i = 0; i < mld->fw->ucode_capa.num_stations; i++) {
+		struct iwl_mld_sta *mld_sta;
 		struct ieee80211_link_sta *link_sta =
 			wiphy_dereference(mld->wiphy,
 					  mld->fw_id_to_link_sta[i]);
@@ -1919,7 +1920,8 @@ static void iwl_mld_mac80211_flush(struct ieee80211_hw *hw,
 			continue;
 
 		/* Check that the sta belongs to the given vif */
-		if (vif && vif != iwl_mld_sta_from_mac80211(link_sta->sta)->vif)
+		mld_sta = iwl_mld_sta_from_mac80211(link_sta->sta);
+		if (vif && (!mld_sta || vif != mld_sta->vif))
 			continue;
 
 		if (drop)
-- 
2.42.0

