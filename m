Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664326;
	b=LCbTNEyx0kih4pfsSteNfa4ZM4Oz6Ogg4g5uRjJWY5cZimALtE8l/CUcSBEbjmkU7OYs
	 zgn/q2wD6ifytbHkQfzz7aagxhgNaoG7MbKmDWUcochFPX9ZFt+RR7CLW3lpN04kpBcMl
	 KAhO77UWXTPyCobWdRmWvSL/3n1BAELiJKs7GUQWjcRvnsjjBh4Pf5lbs5TEgtL6Egv8s
	 r6Was+fVcLLdjJZ7YISTzFNIhCHAAK/vDPuh8KtSVWiab7Xz9L1z2bMOK7x/IvYDRxTbR
	 n+caETLqjUJwOkDQcRIACDrhA8VfIlQTbFeDnWARJ15U/OZ/YNZnlLFaXj+MA1bZjRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664326;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PiojkIGorrXi8i4HXEWaSmLiEfJTIWSWduvvfHcd9kI=;
	b=YuIpiBX61V8vAZiTFL/9+PZCzOu99f2YP/PmJc/9Rb33zpeOkMY8WoCiQsOYJ8ZWtatm
	 uEiB6PVzTuobv3MT03oHSnnFGLIIym1VDHbofcybfEHv8zZPQHUte3LExNxmsbmC3sDGB
	 UXkoQmSp8CXD5MU+AB/0hYbuCXg4NXfKbaISO+HYk5JTKLOcYFGxa1JuiyOho4RoakmeY
	 mhAHdcMf9blcQHlqY7EdMy+v9It3x4wnjrV47v7OGJU2WEVhvod3YBMwQvqMZM+TNVOpg
	 QNPeuG1xAtMvpGoRxxkZGXQrDBBlu5UfndtcAEFBqF9EkW+EAeJr/1ZdvZM03XMaEHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=pzsEFTYX;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69F2606A31F
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=pzsEFTYX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=PiojkIGorrXi8i4HXEWaSmLiEfJTIWSWduvvfHcd9kI=;
	t=1792664325; x=1793873925; b=pzsEFTYXLPG1VrZK4DRkM9EPnK025tknUkVfvrKqSN9wV5N
	fvPUxU1FHgtBnZzJ7Z52PVYudLoNkRGIGMw1bPSUMhnsTB9ATHKnLJFhnVo0CIeRB0ZAmb922Vrqz
	kgdrTVgEAnLTSEGW7KPVmZE877i9rT8JRLQMBHaW2F6qXDnaRcXO1gYGnkERxwF8mm/XYCnQ8u1PK
	14NaHdaVVItiLlTJQBS26oUD+8Ev5cWXPpWAn0k5JSSGfRFJcjRcaxVaSNj7I8TxE64ZCaMKeIPeb
	m4bP8S3KpLBz/h/KEyl6Lhb+xVT0g8OEde4hhbwSja8ihvk6EGoHlsFWFNSSCNFg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpsh-00000004Ifb-29YE;
	Thu, 22 Oct 2026 12:18:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/6] wifi: cfg80211: clean up unused/set reg_num_devs_support_basehint
Date: Thu, 22 Oct 2026 12:15:32 +0200
Message-ID: <20261022121836.a40c06285d1f.I263dd4aef57bd64c74b576eed081dfa9adca39de@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022101836.148512-8-johannes@sipsolutions.net>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
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

