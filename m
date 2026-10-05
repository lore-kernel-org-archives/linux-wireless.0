Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BFA4756AE
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195072; cv=none; b=Pr8q9UibJPCwWI3Q+w5ibhSTMtKsW5SHOwHlgVawcciNIIATDcwqyEtsoGdoJTKxudg9rUImBDlLnYtjLSMl+4lO/2irtJVFzehvj/irqEGXOfG9KZfb+6P2d3HrVb7L79uAihQfTolNRG5VIlfNOm9Wf9si33nFrvkKcRDi3SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195072; c=relaxed/simple;
	bh=9DhGBoOxRNJax4ksPpzaTEK3e9Qvnq0snSldFx5oftY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkY3EjhP6gq+eEWURQpany4bwsjRaGqN1n2MU6w25tNBNbDvQ+IvOIeWxXuhXOsuhS5EHK3tbh8DlInsXCRua+6VWjccrYwzgncGclI0iqrYyQn4lVK2SLaQin57fVd7u+OwuIeh9SYsatlaNTRHeg8Xbfb2nrEK2l5XLn1IbAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LLgKxAoV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LLgKxAoV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=LShJebxBfNk6KiqePaUGOv7b4Ev6hpAS4jYWM/sQzwk=;
	t=1791195070; x=1792404670; b=LLgKxAoV6f2P+7l1O5wdTi/o695Doo6KrYix2YtzMHf1TfV
	pTCKpnBYGyvXepVF/cXGlz2NOhmS235EdlTkB9DyFbsGL0YCsucyA3M6ke03/kWgifqvEM8mlmJn+
	esZMA1IUOddxXEQTrT3V2658dJZhsQMzohH9K+CX8WxQFqL+uxprZCD2H5y/uaokK9KZW221iAdCG
	EOk+RYy+KZ+ijZx3Yh43aacsB17wUdHiBL6IqnoWxVOFSNpV7cx4m82XLdBcBnIK77iwkPbuoVqzN
	v7YSA8hdBSuREdogtqhPxBGmzwb0WHB0LDrUAEz6F/qBNBveGEk3NlgGmTq8faDQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff1-00000005CGx-30to;
	Mon, 05 Oct 2026 12:11:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 07/13] wifi: cfg80211: make cookie counter atomic
Date: Mon,  5 Oct 2026 12:06:23 +0200
Message-ID: <20261005121057.93634d03f514.I83ec404d833100a798181234c797c558400c7145@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005101057.1992330-15-johannes@sipsolutions.net>
References: <20261005101057.1992330-15-johannes@sipsolutions.net>
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
index 0e05d4247bea..07d7a68a7cfc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -83,7 +83,9 @@ struct cfg80211_registered_device {
 	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
-	u64 cookie_counter;
+
+	/* atomic for unlocked users */
+	atomic64_t cookie_counter;
 
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
@@ -171,10 +173,10 @@ cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 
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

