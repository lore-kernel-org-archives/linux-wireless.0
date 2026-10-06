Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B5D3DDAF5
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281239; cv=none; b=YFdGQpjUj5pl6gN7ImbIGXtQRtPuBczyGdw1cGH3I+Vcdc7U/LSTfIRLI0/zWjOvOgOO2MvqTg1KRr8Ra8r1L57iN1X5kaqyOa5X7IJvko6hpR5bSPfAB9eiZyvJrxYn1jAY/jG6gVNWXDC7j3CSi+zLhRuK6Q5YdtDZ1lSi9rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281239; c=relaxed/simple;
	bh=SGM7lnP6/dBQPjv2j8nq0gm3v0TYT12q+c0eS0z0pX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR0IZgzrkwtbgdB8HxmXkFl1wEnjP18qPPlznXofpC4595Zs5zLU1M3SkweKyLJ4U2bfwJBWsanrcdid1UjLCu+U8s0kDhFoWsDyLGTZTwApsLxwTkqaw+MxXI5ovkTTatMRNtSWOzYR/+GHsLl3OWA9KF4qD8pZN5Une9CAaPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rWVcfH04; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rWVcfH04"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6e5Ey+JGOY8K7UXJBodCnqQEw4ryEfOvjfqazgk592Y=;
	t=1791281237; x=1792490837; b=rWVcfH04aAUd3IU1OSpacHEe4gISEUcM0WkbZ4KS+rXsdj/
	tNvXdJ7xUx8YZmC7k31jsk5eCJE95el8nz69qyZehPHbVwRJDRjHqNANWqzl0JlhgWbKANVjkKjst
	blYxWH25RbON6M1lEcCGI9XlSmMGi0P2oYtNkHy9skUWmBE03SwCyKBGFn2pc4WNaEZ2ah0t5Y37K
	S9D2SXRVOAwDC4YJrKDzZvW+L4Th+bXef248dc9D2EV5oPx9bHs4adGicRGRO2hwoUahLVGiDPBye
	0zVqd9TfhbML8dufPqo+9VDaipHqVu9Dnqa1TbEF+MZM82n5rhlTbO0aZCp/Q6Qw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24o-00000006XqW-35Hg;
	Tue, 06 Oct 2026 12:07:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 17/19] wifi: ath11k: read wiphy regd under RCU
Date: Tue,  6 Oct 2026 12:04:15 +0200
Message-ID: <20261006120655.2959e1a05eb0.I92dbc5e611309de4ea3bc11fefea609a5f2d0af4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Part of the RTNL removal here means the notifier will no
longer hold the RTNL, so rcu_dereference_rtnl() can't be
used any more. Use an RCU critical section which works
either way, we don't have access to the cfg80211_mutex
in the drivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath11k/reg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index 0879a132b67c..1030e119fd90 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -33,7 +33,9 @@ static bool ath11k_regdom_changes(struct ath11k *ar, char *alpha2)
 {
 	const struct ieee80211_regdomain *regd;
 
-	regd = rcu_dereference_rtnl(ar->hw->wiphy->regd);
+	guard(rcu)();
+
+	regd = get_wiphy_regdom(ar->hw->wiphy);
 	/* This can happen during wiphy registration where the previous
 	 * user request is received before we update the regd received
 	 * from firmware.
-- 
2.55.0

