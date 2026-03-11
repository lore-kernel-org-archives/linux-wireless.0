Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE0F3A3826
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270470; cv=none; b=GGpHHODOz1f9MGy3Yc9B+nFivjIUSwMKesfwE0sCgKO1jjv6WaNQh6/RHx91a+xANPr7IKYUWs0K9FkOzM8j5kcUuKpGVhzjVi83HBij5QVPZyW/s5U2tW1rUy1m3FyhgGVYVySbCDeRmlXVnPFIh2WgF2ZoPAAgeNilLXMkxW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270470; c=relaxed/simple;
	bh=i1sEQmIz4477p553jwVc3TMiO9TS1jrgdgt158XCl5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5LvlSkGEcFTauBalKsaeUO+Eu+4C3qBa945hNLNgp9NgZRrcnCJDkYb60gSzN1iZZrTtaguf1uE+SQyMDhbd0SfUwzxqpj8AAblyJ3B/i4vug6XrpVo6W1vm30DxcYvWE1/fp1xaoDkiJ+bIpkWgtVNT4oZZN+Ub7zvGjptXEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=K7z1xxAs; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="K7z1xxAs"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8839C9C005A
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:43 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 5FF4E13C2B7;
	Wed, 11 Mar 2026 16:07:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 5FF4E13C2B7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270461;
	bh=i1sEQmIz4477p553jwVc3TMiO9TS1jrgdgt158XCl5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7z1xxAsn1XmRoAAQzNJzRwPsi0Ct7W6ZwBPjd6PLroi8jNjK5G9GajeWFkWNFyiA
	 rIu9uaRyb614+Kah8f5xbwFMB+h+cLBaM99/S5Qu06JTYNhsRI0HqWd0BWcplp9GYg
	 0k6BLSVjhAEf9Ora5Q422bVK9pBGUP9o/1Cf8qO4=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 21/28] wifi: iwlwifi: mld: Protect from null mld_sta
Date: Wed, 11 Mar 2026 16:07:23 -0700
Message-ID: <20260311230730.163348-22-greearb@candelatech.com>
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
X-MDID: 1773270464-My1HvLtQIX_n
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270464;My1HvLtQIX_n;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Torture tests were crashing here, protect against a null
mld_sta.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index aa4d391ffc00..badaceb120b3 100644
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

