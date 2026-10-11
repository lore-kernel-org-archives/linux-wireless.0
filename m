Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988991B87C9
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711198; cv=none; b=HJ4TprDW4kZQbZM7aCp5fIAP89/obdiSmVuD1DreCvlN0c8cPFyBiazdUMuO9m6Sy29/fGU9CddUPYZLvJpHVfA18iuJZuLQW5O+AnrCkNFxCOmHSPSguBIbbmzD3XYdhWdzbTzz0ogIEWP+hj/6OE85V9XCJ05r4Z2e4dsLEc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711198; c=relaxed/simple;
	bh=09h7wCtZjV5CgblEdAdIUPTNlXkgLFWlELlSw7QD02w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZHtkgwZD+gzWS43/W89O258VgVca8xXKAN7hPSAw0/ff7at/YWsODTTi1MMeeSkyDkVAf5XksnNxhZ/1fQa7fl5ZWzBm1MTM4iDcPYuhIs1fY+30eRLCpAYyhrCwmX24uUvTN7AWbiOAKaqbwmKg/1MAaTAv/RbIJ/EbQmhuPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ToeIiDDR; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ToeIiDDR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=VXppRbzwEIVI4YRIbASVXtNQqjDk2aWJWvQIUKZIwDk=;
	t=1791711196; x=1792920796; b=ToeIiDDRyItqJmIcK3UQn09aHgQaerkwts7a06b/MNuxfyh
	yuL5HD8S4xkWgXOezF8HVYR3UgdecEDlBXfF79WivZbMzF15klomaczmCKb+wG4711fyxb/zmds9i
	jXy9iE+nspiwOrrYpj2uOEbFW+jQ1lUq+wkXeOG/b3jh/tEY/wxT16zLMZFT2Ru2wFsiIKSlQdHEK
	gCb9YC9/BpulcjGPwdW8HmPDrjzalei1kzynOBsRjJPF3hTQpRZk5W3nJEJR2MJv0PZHbxRTy/0TZ
	aq1yvxxRSXnytDvgAmYe3SxjcMqKgUl3DkJO7iQewupTEY7B4RjTDD6B9BIZPneQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpvd-0000000Dk5j-3GtG;
	Sun, 11 Oct 2026 11:33:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 02/10] wifi: cfg80211: drop RTNL from disconnect_work
Date: Sun, 11 Oct 2026 11:31:25 +0200
Message-ID: <20261011113308.3c7e002d1893.I31f6d1b43bb252b23b42c9b0375f557d90110dc6@changeid>
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

The RTNL here is only needed for walking the wiphy list,
which can be done under cfg80211_mutex instead, we just
need to not take it in regulatory_hint_disconnect(), of
which this is the only caller.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 2 +-
 net/wireless/reg.h | 2 +-
 net/wireless/sme.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4efb35baeb3e..50f50e768f01 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3671,7 +3671,7 @@ static bool is_wiphy_all_set_reg_flag(enum ieee80211_regulatory_flags flag)
 
 void regulatory_hint_disconnect(void)
 {
-	guard(mutex)(&cfg80211_mutex);
+	lockdep_assert_held(&cfg80211_mutex);
 
 	/* Restore of regulatory settings is not required when wiphy(s)
 	 * ignore IE from connected access point but clearance of beacon hints
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index c587079ead8f..76e7f9e8d684 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -115,7 +115,7 @@ void regulatory_hint_country_ie(struct wiphy *wiphy,
  * be respected but if a user had set the regulatory domain that will take
  * precedence.
  *
- * Must be called from process context.
+ * Must be called with cfg80211_mutex held.
  */
 void regulatory_hint_disconnect(void);
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 85076f3b3355..fde86c900f4f 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -704,10 +704,10 @@ static bool cfg80211_is_all_idle(void)
 
 static void disconnect_work(struct work_struct *work)
 {
-	rtnl_lock();
+	guard(mutex)(&cfg80211_mutex);
+
 	if (cfg80211_is_all_idle())
 		regulatory_hint_disconnect();
-	rtnl_unlock();
 }
 
 DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
-- 
2.56.0

