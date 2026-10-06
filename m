Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DB33DDDD7
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281240; cv=none; b=IDEo3HOJn3rWbxUmxyo7NkNEYAIROlm6LObkNsGxf265lIflIQhIB7H6NtEdQ5EJwIW0eThThvPyvTeCJ8pVIggSrrhHBBhVYZYjtdUSri3REfyV4dxuwKFKJ0xFUSS4iooP1sRgu5hbMnyuhe2Jdr8u8T3qnvzYL4FyBAbO/bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281240; c=relaxed/simple;
	bh=GAkLGAehrqsG08iT9FwDk7Y2W8ZyfVKWK6o1qi6sXlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W72+HKRhoSm0lELBllPFR127SWIp2H4kcO4c7RpypzByXcGz9SXitXRpcMZGz8GDFT6ac2zCfQvVvpXz38elvK73v/jEVlb7TKdph0eWFOJqeoZ5sdds+3f01lEgpd8nKV2Y88u+0B0NcQOEScRH3mcpSemUGsMkoeZb0khSkb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ihHYv7tc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ihHYv7tc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UBAFI+qUYoDu+PyyqViz/f+Yc5r9vjnhuWWJG9bDILM=;
	t=1791281237; x=1792490837; b=ihHYv7tctDKzO8pkvlk6nbXx6S/glByHiR/7qdltIpK5huX
	Bfe0POCLGA+HwZzxLfx8h6cmUIswWM/x1uJmuu4gWEUbngk1rob7JLC789ZTgVc9QEhB7CAK59oSH
	DHkTt/x+oKmvHhVBQA5NeI4xLVgj4i0vVqvDfCgWIH5CrvbjgWjmJL4he5Y0XlvvtNlwgmVGHw7qg
	T/4ws/Trzr4BSJK3FIuIxaZ7zmIXope6aFJQe7l4yVQllXHZGXv2XXsquJ2z/eKPj9vC9H97SBEBV
	OYC4pmy9DkXuuBwsYM8KpBA1D+4I+IDukX5PC3FcI9fDckIDilfm/s3k94zZjwiQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24p-00000006XqW-1SBU;
	Tue, 06 Oct 2026 12:07:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 18/19] wifi: ath12k: read wiphy regd under RCU
Date: Tue,  6 Oct 2026 12:04:16 +0200
Message-ID: <20261006120655.b59589afb302.Ieeec0e112066ccefeac6b746fdfd268611c2cc65@changeid>
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
 drivers/net/wireless/ath/ath12k/reg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
index 89abf2e87ad1..d7065fa73c50 100644
--- a/drivers/net/wireless/ath/ath12k/reg.c
+++ b/drivers/net/wireless/ath/ath12k/reg.c
@@ -33,7 +33,9 @@ static bool ath12k_regdom_changes(struct ieee80211_hw *hw, char *alpha2)
 {
 	const struct ieee80211_regdomain *regd;
 
-	regd = rcu_dereference_rtnl(hw->wiphy->regd);
+	guard(rcu)();
+
+	regd = get_wiphy_regdom(hw->wiphy);
 	/* This can happen during wiphy registration where the previous
 	 * user request is received before we update the regd received
 	 * from firmware.
-- 
2.55.0

