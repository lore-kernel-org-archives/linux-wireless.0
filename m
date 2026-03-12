Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF3335BDC4
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334867; cv=none; b=idQ+tNC2Z848PFmiaobJUCoNvCftf/g0WXE0Z2I6U0c67E7VnBVzkDWs7DVlsPUTuHq1gsdR36o6QwmLAd+yfsW0S8TvhLCy2o2wlasV+8nBw86AwphC8ZXzuenQMZwF1v9qkMnLpzO4pY2eOHRvUAB+ihMp38zijpzAjuMh2Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334867; c=relaxed/simple;
	bh=Y9G1kZkFpa7y5DiJr93H6gacj9VRsFt33X3grcAPVcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHk5OETl33hYMw0knpegCsUhclPhHtWya7i/W0Bj4xtqJJeLWmyNEJxKO5Qa3OsSOFlsbZ3UiNQ2ed7sU8XdVXa4FdTwJCE498GjBfMHtM0bM7++4e3HHOhWhoinv9AUfhISL9JYJ0gpaUH9GRdS76UxZ4s86ICH4pgNlFDeQgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=jVRiTR1M; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="jVRiTR1M"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 57645340090
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 17:01:03 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 68A5E13C2BC;
	Thu, 12 Mar 2026 10:01:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 68A5E13C2BC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773334860;
	bh=Y9G1kZkFpa7y5DiJr93H6gacj9VRsFt33X3grcAPVcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVRiTR1M7p6gRB8sgenuAuzTDT+hzY96RujbHAuyC5PNkqtjPfcA876DPjJZBBifR
	 bUilzYOAfO+4wGgWZsYvZGOjkMt6rt21alyjPIRIrNbV7Rt0RV9iPsza1AbtdULneq
	 N0xqhB0xfNmVtbtxUtsztl8YqfGQ9AgEu3FesgEM=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next v2 11/28] wifi: iwlwifi: mld: Fix stale reference in fw_id_to_link_sta
Date: Thu, 12 Mar 2026 10:00:09 -0700
Message-ID: <20260312170026.285494-12-greearb@candelatech.com>
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
X-MDID: 1773334864-6275gWux6p3U
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773334864;6275gWux6p3U;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
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

