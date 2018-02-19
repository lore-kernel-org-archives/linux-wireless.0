Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59810 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752828AbeBSMvd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:51:33 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:48:47 +0200
Message-Id: <20180219124847.27169-14-luca@coelho.fi> (sfid-20180219_135145_167948_C65B00B3)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 13/13] cfg80211: Add API to allow querying regdb for wmm_rule
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

In general regulatory self managed devices maintain their own
regulatory profiles thus it doesn't have to query the regulatory database
on country change.

ETSI has recently introduced a new channel access mechanism for 5GHz
that all wlan devices need to comply with.
These values are stored in the regulatory database.
There are self managed devices which can't maintain these
values on their own. Add API to allow self managed regulatory devices
to query the regulatory database for high band wmm rule.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 28 ++++++++++++++++++++++++++
 net/wireless/reg.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7d49cd0cf92d..647cb33e738a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6,6 +6,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014 Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -4653,6 +4654,33 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
  */
 const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
 
+/**
+ * DOC: Internal regulatory db functions
+ *
+ */
+
+/**
+ * reg_query_regdb_wmm -  Query internal regulatory db for wmm rule
+ * Regulatory self-managed driver can use it to proactively
+ *
+ * @alpha2: the ISO/IEC 3166 alpha2 wmm rule to be queried.
+ * @freq: the freqency(in MHz) to be queried.
+ * @dbptr: pointer where the regdb wmm data is to be stored (or %NULL if
+ *	irrelevant). This can be used later for deduplication.
+ * @rule: pointer to store the wmm rule from the regulatory db.
+ *
+ * Self-managed wireless drivers can use this function to  query
+ * the internal regulatory database to check whether the given
+ * ISO/IEC 3166 alpha2 country and freq have wmm rule limitations.
+ *
+ * Drivers should check the return value, its possible you can get
+ * an -ENODATA.
+ *
+ * Return: 0 on success. -ENODATA.
+ */
+int reg_query_regdb_wmm(char *alpha2, int freq, u32 *ptr,
+			struct ieee80211_wmm_rule *rule);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7c7c0e0f8d9d..1896394c6e7f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -878,6 +878,60 @@ static void set_wmm_rule(struct ieee80211_wmm_rule *rule,
 	}
 }
 
+static int __regdb_query_wmm(const struct fwdb_header *db,
+			     const struct fwdb_country *country, int freq,
+			     u32 *dbptr, struct ieee80211_wmm_rule *rule)
+{
+	unsigned int ptr = be16_to_cpu(country->coll_ptr) << 2;
+	struct fwdb_collection *coll = (void *)((u8 *)db + ptr);
+	int i;
+
+	for (i = 0; i < coll->n_rules; i++) {
+		__be16 *rules_ptr = (void *)((u8 *)coll + ALIGN(coll->len, 2));
+		unsigned int rule_ptr = be16_to_cpu(rules_ptr[i]) << 2;
+		struct fwdb_rule *rrule = (void *)((u8 *)db + rule_ptr);
+		struct fwdb_wmm_rule *wmm;
+		unsigned int wmm_ptr;
+
+		if (rrule->len < offsetofend(struct fwdb_rule, wmm_ptr))
+			continue;
+
+		if (freq >= KHZ_TO_MHZ(be32_to_cpu(rrule->start)) &&
+		    freq <= KHZ_TO_MHZ(be32_to_cpu(rrule->end))) {
+			wmm_ptr = be16_to_cpu(rrule->wmm_ptr) << 2;
+			wmm = (void *)((u8 *)db + wmm_ptr);
+			set_wmm_rule(rule, wmm);
+			if (dbptr)
+				*dbptr = wmm_ptr;
+			return 0;
+		}
+	}
+
+	return -ENODATA;
+}
+
+int reg_query_regdb_wmm(char *alpha2, int freq, u32 *dbptr,
+			struct ieee80211_wmm_rule *rule)
+{
+	const struct fwdb_header *hdr = regdb;
+	const struct fwdb_country *country;
+
+	if (IS_ERR(regdb))
+		return PTR_ERR(regdb);
+
+	country = &hdr->country[0];
+	while (country->coll_ptr) {
+		if (alpha2_equal(alpha2, country->alpha2))
+			return __regdb_query_wmm(regdb, country, freq, dbptr,
+						 rule);
+
+		country++;
+	}
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL(reg_query_regdb_wmm);
+
 struct wmm_ptrs {
 	struct ieee80211_wmm_rule *rule;
 	u32 ptr;
-- 
2.15.1
