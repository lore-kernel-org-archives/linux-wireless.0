Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B3C50C2BF
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897378; cv=none; b=Z8Mfcg82i5tuig8/HXipvHV8i4W2fTZ6+L6ACBpZ3T9h9Yb3K+fXnHV6uv3vTNJOlK0a2hq/hN3I6Ksv/Vv798vdhTIGt6D9b2LvG9Iw7QpmC4MBPptSaAEy3O38Lm7sIL8BmKm1ULi7i30FG9thHA/rrTATmTv4aKc0JNXFFyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897378; c=relaxed/simple;
	bh=9qS9JTPy+mY1e+fNF/djaJAkGptTaXtVVCWVvbB0t+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g1avy9jb8/7ji+/8frRa9XCtga51LN8dkUljjbB+EpbXGEz0ryxyGp7n4XZP8HA2s4PHebH+3g2yvc8Ac+NTIzH/b0Wf6LHP2YE2b84LiOSRwyyRQrOa8koE1ltI810KyLyD1zytNIuCPSz62aflRB69w3r5z/mq7nZ0L/UmwTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OlCRC4UV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OlCRC4UV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=PiojkIGorrXi8i4HXEWaSmLiEfJTIWSWduvvfHcd9kI=; t=1791897376; x=1793106976; 
	b=OlCRC4UVDkddqRUQaexaQ715FIKD4qNcu9hDLt4Kj3YnaXvFdVH8cm2imrv2s6fGB1UMzQtTh83
	A9RDW0AFGNDU7soZVxX5QDbF0TS80Hd88yo8OgTWodiM7JyH+9kNRBQnXDHFg0JhdnijxtrjG81TH
	PoOxCAs3bcpLY1m2X/3Z1PBXJ1fftnPrcr262ZGYvPtf0M9CLAXC9eL+6SgjN/WcEEdCpN3O6s2Wk
	c2digHoV3Zx77OJNUTchDb0z9hyiSAAfUg/X1+tKZj169Tmjzli8eArsF0z65mnmJiTSQXZ/62Unp
	sjH9+qwIYyYXAsf/Jyj4FI5kd36r7UIQO+Aw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcMX-0000000HQ6u-1LFb;
	Tue, 13 Oct 2026 15:16:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: clean up unused/set reg_num_devs_support_basehint
Date: Tue, 13 Oct 2026 15:16:10 +0200
Message-ID: <20261013151610.318d29c3f687.I263dd4aef57bd64c74b576eed081dfa9adca39de@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Move the variable inside the CONFIG_CFG80211_REG_CELLULAR_HINTS
block where it's actually used, and add a small helper to change
it to avoid a warning from clang that it's set but not used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 50f50e768f01..87eb581aee34 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -104,13 +104,6 @@ static struct faux_device *reg_fdev;
  */
 const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
-/*
- * Number of devices that registered to the core
- * that support cellular base station regulatory hints
- * (protected by cfg80211_mutex)
- */
-static int reg_num_devs_support_basehint;
-
 /*
  * State variable indicating if the platform on which the devices
  * are attached is operating in an indoor environment. The state variable
@@ -2053,6 +2046,13 @@ bool reg_last_request_cell_base(void)
 }
 
 #ifdef CONFIG_CFG80211_REG_CELLULAR_HINTS
+/*
+ * Number of devices that registered to the core
+ * that support cellular base station regulatory hints
+ * (protected by cfg80211_mutex)
+ */
+static int reg_num_devs_support_basehint;
+
 /* Core specific check */
 static enum reg_request_treatment
 reg_ignore_cell_hint(struct regulatory_request *pending_request)
@@ -2074,6 +2074,12 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 {
 	return !(wiphy->features & NL80211_FEATURE_CELL_BASE_REG_HINTS);
 }
+
+static void reg_update_cell_hint_num(struct wiphy *wiphy, int delta)
+{
+	if (!reg_dev_ignore_cell_hint(wiphy))
+		reg_num_devs_support_basehint += delta;
+}
 #else
 static enum reg_request_treatment
 reg_ignore_cell_hint(struct regulatory_request *pending_request)
@@ -2085,6 +2091,10 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 {
 	return true;
 }
+
+static void reg_update_cell_hint_num(struct wiphy *wiphy, int delta)
+{
+}
 #endif
 
 static bool wiphy_strict_alpha2_regd(struct wiphy *wiphy)
@@ -4179,7 +4189,7 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 		}
 
 		if (!reg_dev_ignore_cell_hint(wiphy))
-			reg_num_devs_support_basehint++;
+			reg_update_cell_hint_num(wiphy, 1);
 
 		wiphy_update_regulatory(wiphy, lr->initiator);
 		wiphy_all_share_dfs_chan_state(wiphy);
@@ -4197,8 +4207,7 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 
 	lr = get_last_request();
 
-	if (!reg_dev_ignore_cell_hint(wiphy))
-		reg_num_devs_support_basehint--;
+	reg_update_cell_hint_num(wiphy, -1);
 
 	rcu_free_regdom(get_wiphy_regdom(wiphy));
 	RCU_INIT_POINTER(wiphy->regd, NULL);
-- 
2.56.0

