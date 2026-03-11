Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492873A1687
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270468; cv=none; b=iHpoJwmXbD72EbQX7XKD51i+wOfTdY8AzMdyJerjvb5O6TwxsQXND0oDh4ou8e0nDab2kuDoTXm+Y9XX7Zno0Z8B1gfZQFIppjV724YcFprkBYOviW0Hfb75N+8yyoLbPN4s/T/xG0RX2DrmjoPV4JjuMKGp1I7H0IekK4lqdV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270468; c=relaxed/simple;
	bh=FlPODiTyypEGiC3ECRQGsJi+laaCFQsZkqWtrWkDoyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnbOObRVQba0TBcmxLxa4QwzFNuAk6UGgYJ4+inbWl2TYs8AqI9KdtPCcevA/9XiFXHpe2KG7jtbGnPD1q9jtXdXXQYrXmVkO8n7LJg4oKI0931t2tl1O/Qkhi955Plo6I8vhWmWnzEJW9EJ3cdVFF9MirK39qeiSV4Y4wbYGLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=lKX4ARz2; arc=none smtp.client-ip=67.231.154.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="lKX4ARz2"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AE6D250A560
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:46 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3AD61B0006B
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:39 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 908E213C2B3;
	Wed, 11 Mar 2026 16:07:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 908E213C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270456;
	bh=FlPODiTyypEGiC3ECRQGsJi+laaCFQsZkqWtrWkDoyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKX4ARz2T8zMqAivtFFnAqxga0t3KXPwtW7dlYaByqGXtJgphXOGDy0lkxKJXAAlw
	 yYrKcZVxezfJYJBsK6+zRQStvpwrJSWSur+ol0yDmbHiYYvtV9W3Bq/Tr7o7pkgSAV
	 GmP21yTON2Lc0+TLxgfznxI+wuLN4dSk4OshmEL4=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 02/28] wifi: iwlwifi: mld: Fix un-set return value in error case.
Date: Wed, 11 Mar 2026 16:07:04 -0700
Message-ID: <20260311230730.163348-3-greearb@candelatech.com>
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
X-MDID: 1773270459-NFQt9NJDv-IG
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270459;NFQt9NJDv-IG;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Ensure 'err' is set in error return path.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 0c53d6bd9651..d44ec81d2ce4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2519,7 +2519,7 @@ iwl_mld_change_vif_links(struct ieee80211_hw *hw,
 	struct ieee80211_bss_conf *link_conf;
 	u16 removed = old_links & ~new_links;
 	u16 added = new_links & ~old_links;
-	int err;
+	int err = -EINVAL;
 
 	lockdep_assert_wiphy(mld->wiphy);
 
-- 
2.42.0

