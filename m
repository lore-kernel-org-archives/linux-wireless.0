Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF534AA1F1
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150316; cv=none; b=KSVgxPIin8Mo0cKqRIe5ECGK9hCXeUjiZe85W046EX5KFsWv01D0s9rylMNXVNAwh63sEFTCOyYOFSLYooklaup4h93v1M2jJbOgTq6R37uo4TlXKMqSqGF/RNojORpYBZOH9y1j1k385qyurHvKqJSNlRW8pOKGd0ok93eUKC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150316; c=relaxed/simple;
	bh=sDiNFttyqxvqMHa8DT0XkvjJAtHvZwgTD8qFrBaBCDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgL+2Y+I98RpuJHeIE797dGXeOTwEuPPeLC48ycscR56jPQzgBszZTJs0xICYIiA764EDpf2wryDDLZo0veNCuejnwBGkHNC2PyZMh7UHKjFpdsZ5CUr9H+yS9i9sjXd1GBiUBo+ViQwhLpkbl1LlxzSyJfbOYIIzvFcKPxEcMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Uzy7xCFD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Uzy7xCFD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MqLhyzUSlfUcw2h9Z8dTCf632yUHpwqhxtdx2nJkKyI=;
	t=1791150314; x=1792359914; b=Uzy7xCFDHnc6UVZaRZ/218yTYiMhqGE9oRE2fghWcvJJfjn
	vQeOPq0lSVrB/RXZXGArsJpqkPEapLo+ZFzBysTA/jOc7Ru2hH/d9vbrW9g7/rjrvullLtcMxGB8i
	OZ/xi8I0QivzbNhVLa9KsSvJGFDbhdah+bB2AGcb6Hb92zD/JXGHA1j5nIBGbSyFz8h31b+LCcBl6
	9WH8hDv2q+rCG2+h65HknWTNCDuOtIY2m6lMyNUsWBXWHfhEKYANJsaC201gwbxDKiBZ1PFwkLQns
	0fEQj2RULzu17w9DwvMyqKj8pAI4PtwrR3KG7iXyQxftibmxIjuiK+u5mYuaF97Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU19-00000004OqT-49OP;
	Sun, 04 Oct 2026 23:45:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 05/12] wifi: cfg80211: make cookie counter atomic
Date: Sun,  4 Oct 2026 23:40:51 +0200
Message-ID: <20261004234504.16cb3efd0cd2.I83ec404d833100a798181234c797c558400c7145@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The cookie counter is currently protected by the
wiphy mutex, but in order to be able to transmit
management frames without holding that, we need
to assign cookies atomically.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index dfcb9ed5035b..90d59bac4701 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -82,7 +82,9 @@ struct cfg80211_registered_device {
 	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
-	u64 cookie_counter;
+
+	/* atomic for unlocked users */
+	atomic64_t cookie_counter;
 
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
@@ -170,10 +172,10 @@ cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 
 static inline u64 cfg80211_assign_cookie(struct cfg80211_registered_device *rdev)
 {
-	u64 r = ++rdev->cookie_counter;
+	u64 r = atomic64_inc_return(&rdev->cookie_counter);
 
 	if (WARN_ON(r == 0))
-		r = ++rdev->cookie_counter;
+		r = atomic64_inc_return(&rdev->cookie_counter);
 
 	return r;
 }
-- 
2.55.0

