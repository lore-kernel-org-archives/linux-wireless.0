Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074C144C4FE
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760194; cv=none; b=c0ABWghVFC4hpqZMeW/gkx9aJmafQgWP6kGIownLVcNyTVln5Ka5LLUhi0KRXJlRWq8PO0vbmYBKa1D/rsM38NaMGq2JET5JW3D3BJYf3FtKt1LKilE7JDiy8CCpDHolCzlfuG7UHAsLpB++RDBAI+8f098tkmZytyDtLFoNOhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760194; c=relaxed/simple;
	bh=4n16P0lps1nwpVxJvjwFHgEl2EBxhPRT8GdWiaSfqjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M4Ecl0eqxe1hbV/YTSyWnERXpNhNDDeaK5mjHvTTnHxwwz+JktcwE6tKIaLBPlFmJOoHWW1yLu09uSO+ACTm+LB/JD+zQMhNOI+wpQu7ZeXZFZSju2KF6lpDv9uHK9rWb1Xn4GC5p2C3+Njg7AAyld+4mK69/btbtcXr1p7GKYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJw9OBA4; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJw9OBA4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790760194; x=1822296194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4n16P0lps1nwpVxJvjwFHgEl2EBxhPRT8GdWiaSfqjA=;
  b=JJw9OBA4/aabqfCYkOzkAvzMLRDp0iUqQ1qKG+sKoq5ur5bwdQU9Ai7A
   wjC8u8G2YjBt8f12AbIMfzh5d4zqNuDNnJw/LrpFnctNX17tqJf299X+k
   O5V9cT/L7Jx+jCNHbgjx+frjJ5LGutaKljhhyRfjVQ+H4s4kLp35iHDHu
   w49O0+NiqA39ONBpu393TLZYde53yYWDyMbnSvpAzUrffyUSb+VqiQUx7
   RHmBVL7E2nfqTZjSMT0zGeEXNdt62hwkQFBc/HZouUnuneKMk8zwt/1N7
   jxggzB/Kvgo3m9lI4PZaZH8IzR4UIRuB2zFPMtUae/anprP7iaPQP3wE6
   g==;
X-CSE-ConnectionGUID: oDPcXwPmT2ewX3YOZuODEA==
X-CSE-MsgGUID: lcgT8W19ShqcfhMGUa4NPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102020378"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102020378"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:23:13 -0700
X-CSE-ConnectionGUID: P0haV4hzQnSSc/E2y+F25g==
X-CSE-MsgGUID: +eFcHzXfR+a5Wo62AjHdMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275202775"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:23:11 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 3/5] wifi: iwlwifi: honor the per-channel 320 MHz regulatory flag
Date: Wed, 30 Sep 2026 12:25:05 +0300
Message-Id: <20260930122439.08094e4c344f.Ic0a4bf544fd6ebaf1fc62b40bf463bd289e58cf0@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
References: <20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When support for the MCC update response version 8 was added, the API
change was implemented only partially. That version introduced two new
pieces of information about 320 MHz: the global capability
REG_CAPA_V5_320MHZ_ALLOWED and a per-channel bit, BIT(12), in the
channel flags carried by the response. Only the former was picked up.
BIT(12) kept its previous meaning in the driver, NVM_CHANNEL_DC_HIGH,
a leftover from old devices that nothing used, so the new bit was
silently dropped.

The two are not equivalent, the per-channel bit can be more restrictive
than the global capability. When that happens, cfg80211 is told that
320 MHz is allowed, mac80211 builds a 320 MHz channel context, and the
firmware rejects the resulting PHY_CONTEXT_CMD and asserts with
0x200014FC.

Rename the bit to NVM_CHANNEL_320MHZ and set NL80211_RRF_NO_320MHZ for
the channels that don't have it, so that we cap the bandwidth at
160 MHz instead of asserting the firmware. The bit is checked in every
band, so that a future band that supports 320 MHz is covered as well.

Fixes: e9b63341dc15 ("wifi: iwlwifi: update response for mcc_update command")
Assisted-by: GitHub-Copilot:claude-opus-5
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221675
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  6 ++---
 .../wireless/intel/iwlwifi/iwl-nvm-parse.h    |  7 ++++--
 .../wireless/intel/iwlwifi/tests/nvm_parse.c  | 24 +++++++++++++++----
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 863d5e358152..f4df00514fb1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -106,8 +106,6 @@ static const u16 iwl_unii9_nvm_channels[] = {
 #define IWL_NVM_NUM_CHANNELS_EXT	51
 #define IWL_NVM_NUM_CHANNELS_UHB	110
 #define IWL_NVM_NUM_CHANNELS_UNII9	ARRAY_SIZE(iwl_unii9_nvm_channels)
-#define NUM_2GHZ_CHANNELS		14
-#define NUM_5GHZ_CHANNELS		37
 #define FIRST_2GHZ_HT_MINUS		5
 #define LAST_2GHZ_HT_PLUS		9
 #define N_HW_ADDR_MASK			0xF
@@ -280,7 +278,7 @@ static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
 		      CHECK_AND_PRINT_I(40MHZ),
 		      CHECK_AND_PRINT_I(80MHZ),
 		      CHECK_AND_PRINT_I(160MHZ),
-		      CHECK_AND_PRINT_I(DC_HIGH),
+		      CHECK_AND_PRINT_I(320MHZ),
 		      CHECK_AND_PRINT_I(VLP),
 		      CHECK_AND_PRINT_I(AFC));
 #undef CHECK_AND_PRINT_I
@@ -1631,6 +1629,8 @@ u32 iwl_nvm_get_regdom_bw_flags(const u16 *nvm_chan,
 		flags |= NL80211_RRF_NO_80MHZ;
 	if (!(nvm_flags & NVM_CHANNEL_160MHZ))
 		flags |= NL80211_RRF_NO_160MHZ;
+	if (!(nvm_flags & NVM_CHANNEL_320MHZ))
+		flags |= NL80211_RRF_NO_320MHZ;
 
 	if (!(nvm_flags & NVM_CHANNEL_ACTIVE))
 		flags |= NL80211_RRF_NO_IR;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index 9ebb72d3726a..7b11682f5d45 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -10,6 +10,9 @@
 #include "iwl-nvm-utils.h"
 #include "mei/iwl-mei.h"
 
+#define NUM_2GHZ_CHANNELS		14
+#define NUM_5GHZ_CHANNELS		37
+
 /**
  * enum iwl_nvm_sbands_flags - modification flags for the channel profiles
  *
@@ -82,7 +85,7 @@ struct iwl_reg_capa {
  * @NVM_CHANNEL_40MHZ: 40 MHz channel okay
  * @NVM_CHANNEL_80MHZ: 80 MHz channel okay
  * @NVM_CHANNEL_160MHZ: 160 MHz channel okay
- * @NVM_CHANNEL_DC_HIGH: DC HIGH required/allowed (?)
+ * @NVM_CHANNEL_320MHZ: 320 MHz channel okay
  * @NVM_CHANNEL_VLP: client support connection to UHB VLP AP
  * @NVM_CHANNEL_AFC: client support connection to UHB AFC AP
  * @NVM_CHANNEL_VLP_AP_NOT_ALLOWED: UHB VLP AP not allowed,
@@ -101,7 +104,7 @@ enum iwl_nvm_channel_flags {
 	NVM_CHANNEL_40MHZ			= BIT(9),
 	NVM_CHANNEL_80MHZ			= BIT(10),
 	NVM_CHANNEL_160MHZ			= BIT(11),
-	NVM_CHANNEL_DC_HIGH			= BIT(12),
+	NVM_CHANNEL_320MHZ			= BIT(12),
 	NVM_CHANNEL_VLP				= BIT(13),
 	NVM_CHANNEL_AFC				= BIT(14),
 	NVM_CHANNEL_VLP_AP_NOT_ALLOWED		= BIT(15),
diff --git a/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c b/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c
index 853911900bfd..5a50807e3181 100644
--- a/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/tests/nvm_parse.c
@@ -2,7 +2,7 @@
 /*
  * KUnit tests for NVM parse
  *
- * Copyright (C) 2025 Intel Corporation
+ * Copyright (C) 2025-2026 Intel Corporation
  */
 #include <kunit/static_stub.h>
 #include <kunit/test.h>
@@ -12,7 +12,9 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 static const struct nvm_flag_case {
 	const char *desc;
+	int ch_idx;
 	u16 nvm_flags;
+	struct iwl_reg_capa reg_capa;
 	u32 reg_rule_flags;
 	u32 set_reg_rule_flags;
 	u32 clear_reg_rule_flags;
@@ -36,6 +38,20 @@ static const struct nvm_flag_case {
 		.clear_reg_rule_flags = NL80211_RRF_ALLOW_6GHZ_VLP_AP |
 					NL80211_RRF_NO_6GHZ_VLP_CLIENT,
 	},
+	{
+		.desc = "Allow 320 MHz on a 6 GHz channel that reports it",
+		.ch_idx = NUM_2GHZ_CHANNELS + NUM_5GHZ_CHANNELS,
+		.nvm_flags = NVM_CHANNEL_320MHZ,
+		.reg_capa = { .allow_320mhz = true, },
+		.clear_reg_rule_flags = NL80211_RRF_NO_320MHZ,
+	},
+	{
+		.desc = "Restrict 320 MHz on a 6 GHz channel without the bit",
+		.ch_idx = NUM_2GHZ_CHANNELS + NUM_5GHZ_CHANNELS,
+		.nvm_flags = 0,
+		.reg_capa = { .allow_320mhz = true, },
+		.set_reg_rule_flags = NL80211_RRF_NO_320MHZ,
+	},
 };
 
 KUNIT_ARRAY_PARAM_DESC(nvm_flag, nvm_flag_cases, desc)
@@ -43,11 +59,11 @@ KUNIT_ARRAY_PARAM_DESC(nvm_flag, nvm_flag_cases, desc)
 static void test_nvm_flags(struct kunit *test)
 {
 	const struct nvm_flag_case *params = test->param_value;
-	struct iwl_reg_capa reg_capa = {};
 	u32 flags = 0;
 
-	flags = iwl_nvm_get_regdom_bw_flags(NULL, 0, params->nvm_flags,
-					    reg_capa);
+	flags = iwl_nvm_get_regdom_bw_flags(NULL, params->ch_idx,
+					    params->nvm_flags,
+					    params->reg_capa);
 
 	if ((params->set_reg_rule_flags & flags) != params->set_reg_rule_flags)
 		KUNIT_FAIL(test, "Expected set bits:0x%08x flags:0x%08x\n",
-- 
2.34.1

