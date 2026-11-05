Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863501;
	b=2ecG6NUkaR3Cwx1E1kd03/1tFeiprYi0pQwexGpyKPQKKbLh6RzTz/4VDDtUAxRrGx2D
	 iEuPYqt8HLERk1RmyM4sPJX3wd3aCOznYD58v+rtymuudBKncyOn9jaV/cp/qgiWv5/Bs
	 yz7ZF29KKt2v/uY+beDlgeIfzFqGEjShqvPW0poE/lU3xJFONlIbHA14Cxgk5RlfmH4t1
	 ucvVzbtRwCc1aG1TJZDZfB9yzzDjV/S3SdRO+V0gDzRhJY2dGbks56+GuzrfTf3m9bBNW
	 PvboqfEVbxth/pGwMcVJIQ4Du+pJrVmsOZHo6Ow8Kv8KyQednpa6xZ81MS7SSbByGzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863501;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rwSXrp7wWww5a/SGAeXxUVdwq0yhUyGUoLszs1NCcjc=;
	b=kdXecVGhzAzHr3d7ayNoZonuA/mASlaOnlWtiqRsce6+dXirvylKjLJAvTHczLDNP6gA
	 TxvHgHF2IsqnEAG6kmgg0sl5LIqJw/hLsn5NX3Xng4iHLW3dUIyn5nGKqKgSabSj0ZMfV
	 Dj9lKLhBACzp2sF5Vpgqr1eata89BSYh4//1GHRNfJCsC8KsUiXu3f/e4LYixvmDRe4f+
	 ggB4MfbUtpquBSW+6t/K4QllpPxs652206mrkpgxjVazJ8yBN/18fL65yAN4JazoIbeS0
	 0h+TCx6ZyF8uviJtHcll6AnrbO5Qy77bmDB6WRw1oSVzRHXPf+KH8fz/d3r9ZheamFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=N8TX6e79;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB54E606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=N8TX6e79
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=rwSXrp7wWww5a/SGAeXxUVdwq0yhUyGUoLszs1NCcjc=;
	t=1793863499; x=1795073099; b=N8TX6e797i0IER5tXQB16xDCwQiDszd3xLerivBY7Jseex9
	Wm60OZNxPDPl9WggEd4UrN5sESBpKgmXq9BgON77XaGdfUyDLvp25oZFFBYPYgBZfyS9dSBUIlHzF
	99/pXdoyH7BfIH7sSKfs+IY7LK9ETgHCMSDqqfzkSKJfIN5w0i0RJW5+d5dDGaT066qprCChEgh+W
	TbD4by3fssOeVckhsNvVIx/tlMJmI/kUNnwvCD7GYetbMSy7eup312pbCaRzr7s/eT7JzATv1eB6P
	ixfxjhSPhyzgtmVO+cJCaOTtgkRaesgS/YcelCLgYHYyhJ6wTixPpHTTwL29fJTA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOrqB-00000007Ped-3NId;
	Thu, 05 Nov 2026 08:24:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 1/6] wifi: cfg80211: clean up unused/set reg_num_devs_support_basehint
Date: Thu,  5 Nov 2026 08:23:49 +0100
Message-ID: <20261105082451.147d23123dc9.I263dd4aef57bd64c74b576eed081dfa9adca39de@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105072451.1710800-8-johannes@sipsolutions.net>
References: <20261105072451.1710800-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
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
index 5460b3117d5f..2bf3bcd8809b 100644
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
@@ -2055,6 +2048,13 @@ bool reg_last_request_cell_base(void)
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
@@ -2076,6 +2076,12 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
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
@@ -2087,6 +2093,10 @@ static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 {
 	return true;
 }
+
+static void reg_update_cell_hint_num(struct wiphy *wiphy, int delta)
+{
+}
 #endif
 
 static bool wiphy_strict_alpha2_regd(struct wiphy *wiphy)
@@ -4181,7 +4191,7 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 		}
 
 		if (!reg_dev_ignore_cell_hint(wiphy))
-			reg_num_devs_support_basehint++;
+			reg_update_cell_hint_num(wiphy, 1);
 
 		wiphy_update_regulatory(wiphy, lr->initiator);
 		wiphy_all_share_dfs_chan_state(wiphy);
@@ -4199,8 +4209,7 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 
 	lr = get_last_request();
 
-	if (!reg_dev_ignore_cell_hint(wiphy))
-		reg_num_devs_support_basehint--;
+	reg_update_cell_hint_num(wiphy, -1);
 
 	rcu_free_regdom(get_wiphy_regdom(wiphy));
 	RCU_INIT_POINTER(wiphy->regd, NULL);
-- 
2.56.0

