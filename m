Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548323A1691
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270468; cv=none; b=uGxxJiLvEXVq+afIVXkwz6xYiF/fcBPuVOXJ0OL6hLNpWPJYFg38P9+6VteznagjNksSVXqg1bLp2rTAuoDBDc2rN51JyzAoozowxaLCXC69EJjy6+i4CNVjduVxjQPQ8/fu0xWdcEYYMFKW+9+8xHk9SFvfSRvEiadn64lExwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270468; c=relaxed/simple;
	bh=Y9G1kZkFpa7y5DiJr93H6gacj9VRsFt33X3grcAPVcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ko2opx7gD51n8nhSoAvb7MaFf56B107eP5gcqg0q04FScRIAW1S6sJEmArkdzNeqQcsQuJygvodD35ACZIXZ5hFebU7NEsK7ywSX9NLJ8BBk/jXNMrC0H6CxXE6aNjzJp+sxf+eFaaTPUXVcIAOvAnUk3rFILR1WLojS88JhObI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=gbgcNNCH; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="gbgcNNCH"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9B7298C0075
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:41 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id A695613C2BC;
	Wed, 11 Mar 2026 16:07:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A695613C2BC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270458;
	bh=Y9G1kZkFpa7y5DiJr93H6gacj9VRsFt33X3grcAPVcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbgcNNCHpTKIBG8iee5HSlF4u5kajKXNoPwsPuj1Bzd4n4sXBddHkogSOvkA4y/az
	 jVuOcLmFfyAn3gVd+3DgP1SkhZj3dFSkw3268StASpoc+kAv/rMB8YTD3Cicomsm2E
	 U+rXTZGrXrpr+qTk6lT6+c4owK0dD5TMfy30k3jE=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 11/28] wifi: iwlwifi: mld: Fix stale reference in fw_id_to_link_sta
Date: Wed, 11 Mar 2026 16:07:13 -0700
Message-ID: <20260311230730.163348-12-greearb@candelatech.com>
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
X-MDID: 1773270462-vo3fbmuUXi0u
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270462;vo3fbmuUXi0u;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

If memory cannot be allocated, clear the fw_id_to_link_sta so there
is not a dangling pointer that may later be accessed and cause
use-after-free.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/sta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 6b7a89e050e6..c478cee570a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -540,8 +540,10 @@ iwl_mld_add_link_sta(struct iwl_mld *mld, struct ieee80211_link_sta *link_sta)
 		mld_link_sta = &mld_sta->deflink;
 	} else {
 		mld_link_sta = kzalloc_obj(*mld_link_sta);
-		if (!mld_link_sta)
+		if (!mld_link_sta) {
+			RCU_INIT_POINTER(mld->fw_id_to_link_sta[fw_id], NULL);
 			return -ENOMEM;
+		}
 	}
 
 	mld_link_sta->fw_id = fw_id;
-- 
2.42.0

