Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C4D476CF4
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194758; cv=none; b=mSjFyIxrHVqSWgSsOpKW7u/22UFvi0TqE2AoVweqqKhid2hxHssa2Ca7uU4OVZtITQb6fK+cIIhwKtULihSoEXgExOBtfGue6aG3R/lie8KbM4bHFs32FqMaLVpknxLuFUm0b+Uu4PKMmauOZiaB/2oyA3D7qoH62mKhhOnxYwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194758; c=relaxed/simple;
	bh=SGM7lnP6/dBQPjv2j8nq0gm3v0TYT12q+c0eS0z0pX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbzuEnfKPZpwuuJcqBj9qTXeHkwg33KNc2ydgKgQrVldZPVGSdA/tCi9yovALNvS1JPeh0rgzWBUbVV3ZYXLUwYG8BqEMoWa5lH9q37hGYgNA1qI5bETWvoQ85OG6kfeaQ/7ga8jcLbwCAOLuuVWyMs/EcUqrhz1GXxjWvvkNZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=TRTqFX7c; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="TRTqFX7c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6e5Ey+JGOY8K7UXJBodCnqQEw4ryEfOvjfqazgk592Y=;
	t=1791194757; x=1792404357; b=TRTqFX7cZ4VfGgZPkGfpbdH/XYrPWjqPRf2sK3JYl8dt2il
	udBEn2Qm/lVwdOdCn8l2QdWYhOEyNqtuko1i3JfR3nApfYQJtxP85MYj6AedP2btqR9LX1kZJCE3+
	wxik/xIt/ODRq0K5lXKvkQ4/clCc0Y+dKG6HMx5gMZiLjhloxgCFW67yS3QstTlNkyq6S6pAUz5xz
	E1rHVlra//LJP782iEVMhP4JxYD3FcVBL3HvbX+mMznt7rl0OQSUaFIzTGOKK5UDk9cngkykCBe6j
	b8ok1rF+wx7KRd0ksAM7yzGtkb3/4oltIBnxsb1mID0egkLKoAIkYWYYsUdX9QdA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZy-00000005Bml-1V5y;
	Mon, 05 Oct 2026 12:05:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 16/18] wifi: ath11k: read wiphy regd under RCU
Date: Mon,  5 Oct 2026 12:03:43 +0200
Message-ID: <20261005120526.d40183aa0969.I92dbc5e611309de4ea3bc11fefea609a5f2d0af4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005100525.1991059-20-johannes@sipsolutions.net>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
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

