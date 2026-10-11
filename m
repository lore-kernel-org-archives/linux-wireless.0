Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD4E390C85
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711201; cv=none; b=kteEz/w9EOstULkaZX2PXXecGirDu2izyupzIdS+CIDn9V6/6Wk0RJ2Lw40VBAkwrKIe8rrz+lNvN9n8a+oc1a/p8c/62zqMxwx9CUePDiAh6JHtHFVlq6Bow5s99GBH5OpyprE0k/MVPlxvb2rGIFek6lJl1G/gFXpSDYedwek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711201; c=relaxed/simple;
	bh=diE45cQID40bxype5T2cmqyDH0Prf7JXPXvRALt46ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGYcvrKW6baItEAAAx6ddFnG2O2PD4pYC8Z/izyUOIyQf7CkeYU+E4a8IHYGi9NEoKwu2BV5VWIs6Urb7xBUF3c9CE59/Ox2hACKOzPDfx2t9EEgWXutm5ihQvlvSFYKRopLt48e9YpUEAF50ukFFyksyNUuAMDZrVYfGTfz/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=oTYHoVQR; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="oTYHoVQR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=t7vOeLazJUQkQwPNr3DgZG+RihxPHlaZBJxT2WqWlIk=;
	t=1791711200; x=1792920800; b=oTYHoVQRm8+MLNGMvtTjO1+pIeBXFgjZccjYIHa0JrUezcJ
	j8nYtoAh/yZpxaT6zx5F6VU0j5HmlFa4K3+ylqAYpi71PPOvCabTsooSxMGqQf/1qtohjrM4jCkAd
	Azns3NTpuLJPf3oBF6bZn6mGZPY6axGG5c86mu8jMcgpggfOlMUhoVqK5CD9F1wJ5J1W+am9Ovk7d
	cMReIM+dGb4w/ZwhVr/LqNZ3VP3aCQCAu7sjdBpAYSMqupytCWQLqovmLNvqPd1K2rhlfJKHUCtCO
	Th3ZXUb8FnTCkr02nK4Ge+8WpI5d4CkHHuRSbtY9dZ5eeR6E9QFhkJafqRhkHOnA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpvh-0000000Dk5j-17jq;
	Sun, 11 Oct 2026 11:33:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 08/10] wifi: cfg80211: check wiphy name in wiphy_register()
Date: Sun, 11 Oct 2026 11:31:31 +0200
Message-ID: <20261011113308.20e9fccb29da.I3a32d7fcfba5fd7b4ee378aa182d87e46f98c6e6@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011093308.49945-12-johannes@sipsolutions.net>
References: <20261011093308.49945-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We currently check names already in wiphy_new_nm(), but
that could technically race when two are registered at
the same time. Currently that only happens with hwsim,
which probably can't race, but it's confusing.

Do the check later, with cfg80211_mutex held, so it'll
always be precise.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c9ad4f72e70d..09fb40fa67b0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -660,33 +660,13 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	/* atomic_inc_return makes it start at 1, make it start at 0 */
 	rdev->wiphy_idx--;
 
-	/* give it a proper name */
-	if (requested_name && requested_name[0]) {
+	/* remember the name, used/checked during registration */
+	if (!requested_name || !requested_name[0] ||
+	    dev_set_name(&rdev->wiphy.dev, "%s", requested_name)) {
 		int rv;
 
-		mutex_lock(&cfg80211_mutex);
-		rv = cfg80211_dev_check_name(rdev, requested_name);
-
-		if (rv < 0) {
-			mutex_unlock(&cfg80211_mutex);
-			goto use_default_name;
-		}
-
-		rv = dev_set_name(&rdev->wiphy.dev, "%s", requested_name);
-		mutex_unlock(&cfg80211_mutex);
-		if (rv)
-			goto use_default_name;
-	} else {
-		int rv;
-
-use_default_name:
-		/* NOTE:  This is *probably* safe w/out holding rtnl because of
-		 * the restrictions on phy names.  Probably this call could
-		 * fail if some other part of the kernel (re)named a device
-		 * phyX.  But, might should add some locking and check return
-		 * value, and use a different name if this one exists?
-		 */
-		rv = dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+		rv = dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d",
+				  rdev->wiphy_idx);
 		if (rv < 0) {
 			kfree(rdev);
 			return NULL;
@@ -1240,7 +1220,14 @@ int wiphy_register(struct wiphy *wiphy)
 	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	wiphy_lock(&rdev->wiphy);
-	res = device_add(&rdev->wiphy.dev);
+
+	/* use default name if the requested one isn't good */
+	res = cfg80211_dev_check_name(rdev, dev_name(&rdev->wiphy.dev));
+	if (res)
+		res = dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d",
+				   rdev->wiphy_idx);
+	if (!res)
+		res = device_add(&rdev->wiphy.dev);
 	if (res) {
 		wiphy_unlock(&rdev->wiphy);
 		mutex_unlock(&cfg80211_mutex);
-- 
2.56.0

