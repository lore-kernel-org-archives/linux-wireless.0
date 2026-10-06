Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5223B27E7
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281227; cv=none; b=uj/eISZCOrsqKRdzJo2dMWQf96yYnc+yLXgYEaje6kM9VKFJ1PhgtZhomPv6XMXy8D2gRdOfYSFxaCyB89Eg1tpMv0EClKWE1P00jnP9o6tU6NmxnCwPfOhYExlEnlwsuyUoJ0mf43h/LbYruWfGv+VuCmT52aX5TBCt3SvIUpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281227; c=relaxed/simple;
	bh=VBQziM5Kb2ylNov5w0HpYA/D2uGgjn485PDH/vl+3oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw/cEb4Uxy9/tLwEiOQUVkOooOwmOiHN2YF1At+GX6WfE4zo5DpiIjP62nR7X9yxKUHw/VDwg9ACJs8LaoNZKyfEiIzsrTCcZVLEXhP12ZRRozu+X28yBXLe0DoIEnjzf9OYB/wyTSfhBte3tsk4v7x5mXxifkOU8NoWelsYfFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=wl/pgMOg; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="wl/pgMOg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=CakEnpsVrJZG7xZHHlw/EISNowWrGGCa9yzKXZGGE7k=;
	t=1791281225; x=1792490825; b=wl/pgMOgGJY7msKSXszFdjdRzFe7CMg2tF14AkkESS4QT7f
	h8EWT0coQhaqtdHRHVWbDnG48D/i46aZKtpc+jMStqiZkzdY5YO5OAF2PU9rqplej1NnRJw0bFTXB
	L2RJQw69t4+Gu80Lo8hJKXrE9pWXes3TRHERG+7o6rGS6b3t2rq6CIFVuva9vN7xC3hW55KMPkEZm
	li4f38ZKDo3MhXkp/0KMVYuZQ0T3VyqQH9cG7FbkOcKPdjLGWgPTm3Sq/4WyiSjqfMtVXUBksJx6o
	/gAnQnZWSKP5PUAvs6iKG4QiJUPT8ynWCeh0sH1MjR9T39My2dbIVJw/GF6lydyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24c-00000006XqW-2ydM;
	Tue, 06 Oct 2026 12:07:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 01/19] wifi: cfg80211: reg: protect regdb pointer with RCU
Date: Tue,  6 Oct 2026 12:03:59 +0200
Message-ID: <20261006120655.7c261d237cae.If21cf0af3b0d7e8c62c45ece5dc654b30c9d7757@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

reg_query_regdb_wmm() is only used by iwlwifi, but even when
it was introduced was already broken, as it reads the global
db without any locking (drivers can't really guarantee any).
Certainly iwlwifi doesn't since it calls it for FW messages.
Therefore, it can race against regdb updates. The function
uses a local pointer, but doesn't help.

Use RCU to protect the regdb pointer to fix that, and update
the documentation to mention this (and do some cleanups).

Fixes: 19d3577e35e0 ("cfg80211: Add API to allow querying regdb for wmm_rule")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 12 ++++++------
 net/wireless/reg.c     | 41 +++++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 05c625d9e076..92f0dcc4a35f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8236,20 +8236,20 @@ bool regulatory_pre_cac_allowed(struct wiphy *wiphy);
  */
 
 /**
- * reg_query_regdb_wmm -  Query internal regulatory db for wmm rule
- * Regulatory self-managed driver can use it to proactively
- *
+ * reg_query_regdb_wmm -  Query internal regulatory db for WMM rules
  * @alpha2: the ISO/IEC 3166 alpha2 wmm rule to be queried.
  * @freq: the frequency (in MHz) to be queried.
- * @rule: pointer to store the wmm rule from the regulatory db.
+ * @rule: pointer to store the WMM rule from the regulatory db.
  *
- * Self-managed wireless drivers can use this function to  query
+ * Self-managed wireless drivers can use this function to query
  * the internal regulatory database to check whether the given
- * ISO/IEC 3166 alpha2 country and freq have wmm rule limitations.
+ * ISO/IEC 3166 alpha2 country and freq have WMM rule limitations.
  *
  * Drivers should check the return value, its possible you can get
  * an -ENODATA.
  *
+ * This uses RCU internally so can be called in just about any context.
+ *
  * Return: 0 on success. -ENODATA.
  */
 int reg_query_regdb_wmm(char *alpha2, int freq,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b7ef479a74f0..27ba860f0391 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -590,7 +590,7 @@ static inline int call_crda(const char *alpha2)
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
 /* code to directly load a firmware database through request_firmware */
-static const struct fwdb_header *regdb;
+static const struct fwdb_header __rcu *global_regdb;
 
 struct fwdb_country {
 	u8 alpha2[2];
@@ -892,16 +892,19 @@ static int __regdb_query_wmm(const struct fwdb_header *db,
 
 int reg_query_regdb_wmm(char *alpha2, int freq, struct ieee80211_reg_rule *rule)
 {
-	const struct fwdb_header *hdr = regdb;
 	const struct fwdb_country *country;
+	const struct fwdb_header *regdb;
 
+	guard(rcu)();
+
+	regdb = rcu_dereference(global_regdb);
 	if (!regdb)
 		return -ENODATA;
 
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
 
-	country = &hdr->country[0];
+	country = &regdb->country[0];
 	while (country->coll_ptr) {
 		if (alpha2_equal(alpha2, country->alpha2))
 			return __regdb_query_wmm(regdb, country, freq, rule);
@@ -970,15 +973,13 @@ static int regdb_query_country(const struct fwdb_header *db,
 
 static int query_regdb(const char *alpha2)
 {
-	const struct fwdb_header *hdr = regdb;
+	const struct fwdb_header *regdb = rtnl_dereference(global_regdb);
 	const struct fwdb_country *country;
 
-	ASSERT_RTNL();
-
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
 
-	country = &hdr->country[0];
+	country = &regdb->country[0];
 	while (country->coll_ptr) {
 		if (alpha2_equal(alpha2, country->alpha2))
 			return regdb_query_country(regdb, country);
@@ -990,6 +991,7 @@ static int query_regdb(const char *alpha2)
 
 static void regdb_fw_cb(const struct firmware *fw, void *context)
 {
+	const struct fwdb_header *regdb;
 	int set_error = 0;
 	bool restore = true;
 	void *db;
@@ -1003,6 +1005,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	rtnl_lock();
+	regdb = rtnl_dereference(global_regdb);
 	if (regdb && !IS_ERR(regdb)) {
 		/* negative case - a bug
 		 * positive case - can happen due to race in case of multiple cb's in
@@ -1011,11 +1014,11 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 		 * Either case, just restore and free new db.
 		 */
 	} else if (set_error) {
-		regdb = ERR_PTR(set_error);
+		rcu_assign_pointer(global_regdb, ERR_PTR(set_error));
 	} else if (fw) {
 		db = kmemdup(fw->data, fw->size, GFP_KERNEL);
 		if (db) {
-			regdb = db;
+			rcu_assign_pointer(global_regdb, db);
 			restore = context && query_regdb(context);
 		} else {
 			restore = true;
@@ -1040,7 +1043,7 @@ static int query_regdb_file(const char *alpha2)
 
 	ASSERT_RTNL();
 
-	if (regdb)
+	if (rcu_access_pointer(global_regdb))
 		return query_regdb(alpha2);
 
 	alpha2 = kmemdup(alpha2, 2, GFP_KERNEL);
@@ -1058,8 +1061,8 @@ static int query_regdb_file(const char *alpha2)
 
 int reg_reload_regdb(void)
 {
+	const struct fwdb_header *db, *old;
 	const struct firmware *fw;
-	void *db;
 	int err;
 	const struct ieee80211_regdomain *current_regdomain;
 	struct regulatory_request *request;
@@ -1080,9 +1083,7 @@ int reg_reload_regdb(void)
 	}
 
 	rtnl_lock();
-	if (!IS_ERR_OR_NULL(regdb))
-		kfree(regdb);
-	regdb = db;
+	old = rcu_replace_pointer_rtnl(global_regdb, db);
 
 	/* reset regulatory domain */
 	current_regdomain = get_cfg80211_regdom();
@@ -1103,6 +1104,11 @@ int reg_reload_regdb(void)
 
 out_unlock:
 	rtnl_unlock();
+
+	if (!IS_ERR_OR_NULL(old)) {
+		synchronize_rcu();
+		kfree(old);
+	}
  out:
 	release_firmware(fw);
 	return err;
@@ -4390,6 +4396,7 @@ void regulatory_exit(void)
 {
 	struct regulatory_request *reg_request, *tmp;
 	struct reg_beacon *reg_beacon, *btmp;
+	const struct fwdb_header *db;
 
 	cancel_work_sync(&reg_work);
 	cancel_crda_timeout_sync();
@@ -4419,8 +4426,10 @@ void regulatory_exit(void)
 		kfree(reg_request);
 	}
 
-	if (!IS_ERR_OR_NULL(regdb))
-		kfree(regdb);
+	/* RCU is irrelevant on the way out */
+	db = rcu_dereference_protected(global_regdb, true);
+	if (!IS_ERR_OR_NULL(db))
+		kfree(db);
 	if (!IS_ERR_OR_NULL(cfg80211_user_regdom))
 		kfree(cfg80211_user_regdom);
 
-- 
2.55.0

