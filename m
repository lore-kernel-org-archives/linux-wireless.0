Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0CC490BF2
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140505; cv=none; b=pOo3Cbth3rbqAjfT4ZDJLptrpbXTTTaypA10pqLlYmuCIvCXDL5pPECENUcEoB2W1PQ86xcLypey5tcxWN49JDq1wZe3VNj0z4Tx6Uhr+9ASbwmw6BJ0MyjVddHe1jWK4k/JssiB8FK7tHq51eJI6GjWWKH6iSl6tPTSO+L7uTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140505; c=relaxed/simple;
	bh=SGM7lnP6/dBQPjv2j8nq0gm3v0TYT12q+c0eS0z0pX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugG1xUOsF1yzORUwHJkJyz7FhhaiiGwAVZ4YEsJMJY0tjcjYdFBURymL+M1Iu0VKldr0Sa5ZgdeKAHyRtcLyWS94ceHdBP7Yy9jGp+1c/2aZKwioBdpFonddkcubNhBQwLxeo0A3ah2XfQHZQL6uofmNyijw0uXFDEZJHr/VJwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cDzSm34B; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cDzSm34B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6e5Ey+JGOY8K7UXJBodCnqQEw4ryEfOvjfqazgk592Y=;
	t=1791140500; x=1792350100; b=cDzSm34B0YOkZKHevc9n5FSW7+VMvYgnaC8Cqa6uk9/lzDA
	bMDznnV/b6OwoinnbIvGAwXRqTXBx4/6eR1h+93YYOUAsNSwcuM/vRLgPqAL4Q8NXiJ3MwT7s7ROw
	+GBk2KQRzu7SnIoRur7zQo0mUxFocxNlarVIDXYBrfdaeGZUqlTaDmpFsuUOhQ6N5iWCcGRrtKeHu
	NVc64+e1rLMN90N5QKu6zzZGzm0Soq8bKO4JWIRCaGVbgFinnqb0hrr9WYn+8GkxEe+GxjKlNRwob
	pptVl3FQLQXsN4hM8LIIMOUFUZdiFafL2esVdNk9hAMzFLfolw1qa0t0cSTrY78w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSq-00000004Jlo-2d0d;
	Sun, 04 Oct 2026 21:01:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 16/18] wifi: ath11k: read wiphy regd under RCU
Date: Sun,  4 Oct 2026 21:01:30 +0200
Message-ID: <20261004210122.7019d4258e07.I92dbc5e611309de4ea3bc11fefea609a5f2d0af4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
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

