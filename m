Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F224921AC
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140506; cv=none; b=oKuMIjLC+yXZWlwch9EkLtYvcnIDMB5LuFaHmYV9scwkNpyFtCFfEwHZ4wblMNEsTBMMj2CBiQoe/sjO9p1Yv59AZhF5XcGl34/Rw7Fknp5dbx2YLkuNfaFXu5UxtaZZLPo8Cb17AHgkRa/oxzW56jto3kAz5w6o7XD+uBIBm0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140506; c=relaxed/simple;
	bh=GAkLGAehrqsG08iT9FwDk7Y2W8ZyfVKWK6o1qi6sXlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fix3DYfwqfjrAOz2Xup1qkCxO9qPbc1SPXUdbB3fP+sBV38JJQJMvjNtE5yxRx4Y8DFw6BqqpWzYX+AJmZbp90jN7D6zb2FB5Bb6HldDHjyz/z76xi7vjeX8YhyvAmspIR0qlVhqeRrA1gHHStkgcEbwlxFs7cdsDBfjqR6sC20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LOZsA+sM; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LOZsA+sM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UBAFI+qUYoDu+PyyqViz/f+Yc5r9vjnhuWWJG9bDILM=;
	t=1791140502; x=1792350102; b=LOZsA+sMpHLiG7owaGmZGD0qOrbnthqjcuyof0HDdIC35/k
	mJ7lTnk7zcMSyQxlUnbvryKbH6PHHheyLwSfX26YNs4RoBoZDMmN98kT0SOtZ4I/S+nS8Ol0igaK3
	dgaYCwm/YfgjVwL83PGpK/H3GSu+N1xaUA46n0+7hOgl4R2QPQOya+IZUfyXkkEOG0k9b2iK1daSd
	tTVr6yten4Q7hjUUpMZbH2RBT4rCOP/wkUXkRqqPyOcREJb/nAb7e/HjEhanFKTLWzoMynJZOzfLc
	eaoQTCqWdm/ZAQPjYoiPtYSDLTpffaa2xPjp7azC34GjPTSGU2GTu+F3MDGWPHdw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSr-00000004Jlo-1LYw;
	Sun, 04 Oct 2026 21:01:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 17/18] wifi: ath12k: read wiphy regd under RCU
Date: Sun,  4 Oct 2026 21:01:31 +0200
Message-ID: <20261004210122.503a8e059418.Ieeec0e112066ccefeac6b746fdfd268611c2cc65@changeid>
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

