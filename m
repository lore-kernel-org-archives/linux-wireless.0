Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50663 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EaCL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:29 -0400
Received: by mail-pb0-f42.google.com with SMTP id uo1so1386063pbc.29
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:28 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 24/40] crda: add regdb_dfs_regions
Date: Thu, 30 May 2013 19:09:13 -0700
Message-Id: <1369966169-23640-25-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042939_548415_E46BB8CD)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

These are already in dbparse.py. As it stands silicon
vendor DFS solutions group up DFS compliance requirements
into three categorical groups. Each country that requires
DFS has opted to follow one type of group category set
of rules.

CRDA was already reading the DFS regions but using
nl80211.h definitions for its parsing and printing of
these flags, its best to use our own OS agnostic
definitions.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 regdb.h |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/regdb.h b/regdb.h
index afb7284..4508621 100644
--- a/regdb.h
+++ b/regdb.h
@@ -7,6 +7,10 @@
  * WARNING: This file needs to be kept in sync with
  *  - the parser (dbparse.py)
  *  - the generator code (db2bin.py)
+ *
+ * As it is only Linux is using these so we have a direct one to
+ * one map for flags. Each respective OS flag is listed where
+ * appropriate.
  */
 
 /* spells "RGDB" */
@@ -61,8 +65,9 @@ struct regdb_file_power_rule {
 	uint32_t	max_eirp;
 };
 
-/* must match <linux/nl80211.h> enum nl80211_reg_rule_flags */
-
+/*
+ * The Linux map defined in <linux/uapi/nl80211.h> enum nl80211_reg_rule_flags
+ */
 enum reg_rule_flags {
 	RRF_NO_OFDM		= 1<<0, /* OFDM modulation not allowed */
 	RRF_NO_CCK		= 1<<1, /* CCK modulation not allowed */
@@ -78,6 +83,21 @@ enum reg_rule_flags {
 	RRF_NO_IBSS		= 1<<8, /* IBSS is not allowed */
 };
 
+/**
+ * enum regdb_dfs_regions - regulatory DFS regions
+ *
+ * @REGDB_DFS_UNSET: Country has no DFS master region specified
+ * @REGDB_DFS_FCC: Country follows DFS master rules from FCC
+ * @REGDB_DFS_ETSI: Country follows DFS master rules from ETSI
+ * @REGDB_DFS_JP: Country follows DFS master rules from JP/MKK/Telec
+ */
+enum regdb_dfs_regions {
+	REGDB_DFS_UNSET	= 0,
+	REGDB_DFS_FCC	= 1,
+	REGDB_DFS_ETSI	= 2,
+	REGDB_DFS_JP	= 3,
+};
+
 struct regdb_file_reg_rule {
 	/* pointers (offsets) into the file */
 	uint32_t	freq_range_ptr; /* pointer to a struct regdb_file_freq_range */
-- 
1.7.10.4

