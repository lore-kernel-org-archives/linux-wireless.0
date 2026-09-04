Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852D2324B22
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533787; cv=none; b=vCx3qp4Qx8ikoOeP+CXVAcAIFoN5FDbVnh4PIfFdK5EzLFCVqRwOa/FhODHGAbS3QlT2cKkNBDtdxyiCq4v9QsI14RpCnUsa/TQ520xOlDs8CEF+uzRW4GBT8LbECqG/MCJPTsw9i8LAi0jTzfrjJtbny8xgc5u3mPDhw9LKgPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533787; c=relaxed/simple;
	bh=xipREGjBhUYLPraKWe3eKqhpD+1W41qGbrR1eao1TCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWLVAOl61rGCwgxJnhp2p9/IhuK1tgNah8h/lCp6XVvzV6PRhbX3JlO7MvbHbaeKPT6Suqjda8nnmLk2n42IH0NB5khmFs2p/JyX5MK2pSYvOWqHkPKgym29v12j8VOgIlLjB5EV2k+OwNGL85Uiony4N3qNMUQqZ5rDsWMAPtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uTXNNskm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uTXNNskm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=pJPx50ju/WzzvqaBgzhK+XGnime6W9MmemHfRqVnuS8=;
	t=1788533785; x=1789743385; b=uTXNNskmXaan4STmBpcSNe97RhCqGBZIGCjWc3JCNU0zeQY
	QrrvWQPwu1Y7zWeEdhS36KzRAKHixAZQRoEAdWmW4YufyL6YxospOvzksYwatFvlzGGESsMWqGVW2
	AeG0am1sKP0mN6TtTm0zrAPQwZsE7JLognhQ5Z1Pely86lbJ+8vw9UIb1w4prfL58EuJF/dx5v0Ey
	OmAwi7GWTyrLYZAvphuED9sIiVMwWtlrdfOaBPU05THXwUMLDSpeVa/pyncKJn5tlFX3qvZrkO7DD
	t8M0Y+hlGyiWO+kuaeuUjxP1sVqm+IUkSgZxxab97VqKZLjdT23DQ+SRM27NngKg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VL4-00000001SUL-2Z1V;
	Fri, 04 Sep 2026 16:56:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+abff43d2d045e37c0bb2@syzkaller.appspotmail.com
Subject: [PATCH wireless 1/8] wifi: cfg80211: don't get the radio mask for netdev-less wdevs
Date: Fri,  4 Sep 2026 16:55:01 +0200
Message-ID: <20260904165614.2056a8b7dc91.I7412c5062d8166ad6c81ee7252cec49dea19a60f@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145614.423902-10-johannes@sipsolutions.net>
References: <20260904145614.423902-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

cfg80211_calculate_bi_data() calls rdev_get_radio_mask() with
wdev->netdev, which can be NULL and then crashes in mac80211.

To avoid that, invert the order of checks since wdev->netdev
is always valid for beaconing interfaces.

Assisted-by: LLM
Fixes: abb4cfe3661a ("wifi: cfg80211: extend interface combination check for multi-radio")
Reported-by: syzbot+abff43d2d045e37c0bb2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=abff43d2d045e37c0bb2
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 3e584d0ca3e2..408ebb10924f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2477,16 +2477,15 @@ static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
 		if (wdev->valid_links)
 			continue;
 
+		wdev_bi = cfg80211_wdev_bi(wdev);
+		if (!wdev_bi)
+			continue;
+
 		/* skip wdevs not active on the given wiphy radio */
 		if (radio_idx >= 0 &&
 		    !(rdev_get_radio_mask(rdev, wdev->netdev) & BIT(radio_idx)))
 			continue;
 
-		wdev_bi = cfg80211_wdev_bi(wdev);
-
-		if (!wdev_bi)
-			continue;
-
 		if (!*beacon_int_gcd) {
 			*beacon_int_gcd = wdev_bi;
 			continue;
-- 
2.55.0

