Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151FB477289
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194759; cv=none; b=azoqF/7BYbo5tbxnqJbQlBPyGfiere+zl/UZyqhZwzuP6nR4CAeTQ/WFYFqvXuIAl8VA7ZDotg+4pQzjTj342ULgfe3uJClDqMOWXoVart/p3DLohS8SXBt0X7UWuttrP8a+2pbcwjnbmtXbc2DnuML0E6bzka3JMHcgFpmGLg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194759; c=relaxed/simple;
	bh=GAkLGAehrqsG08iT9FwDk7Y2W8ZyfVKWK6o1qi6sXlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byqc17cd7mwg84461z85bZkUTb0gJJV2yA/XnQivJ6Hcx4caK35d3Std4L0d6Colu7NCjkq72zZBavLbSLyrs1jIaB+X6cnKOglPww+AESXZZ/zPOwUwcrB4G0S7JO7M0iSGdXutSPpreBcTeQnRdb2fC5LneXmlcgNXNJ1ij+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=v/5Sj7ET; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="v/5Sj7ET"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UBAFI+qUYoDu+PyyqViz/f+Yc5r9vjnhuWWJG9bDILM=;
	t=1791194758; x=1792404358; b=v/5Sj7ETo5bLDpBLh7zCMMsexy2z3y5p98t6h5joKNtJIAm
	Aw0jYWCh5of3O+I1EFAvjZdi1PC2UG99iCQ4FckD0EaKh0Y58ZU0XyeukYkHMkDXhvJkAX2DmbPxb
	m2akkzdNHuEX9MvqrGLIsuwBznaBGcuU21lPMpyA5BSGUKiS4gF2rP0ekmVrsGLswhhnhPwfCZBgq
	FniQGnAAbBKlthRBAXeOvV3SkE+uXfbyrUJ4JhWC25i1NEwMG0AaJrbPQsxwKmrD+jeBgLWT6QFuC
	1t22nSlvw2LtAGp1+eS5PHLtQqnsqBzsgl+JlVKeA3W7VJUwuULt+vLpVYZP0/LA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZz-00000005Bml-2uQ4;
	Mon, 05 Oct 2026 12:05:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 17/18] wifi: ath12k: read wiphy regd under RCU
Date: Mon,  5 Oct 2026 12:03:44 +0200
Message-ID: <20261005120526.cc05b8c9d1a5.Ieeec0e112066ccefeac6b746fdfd268611c2cc65@changeid>
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

