Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8652A45516A
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754908; cv=none; b=gXuQmuidqFp0JLWRPWxZYavbF0zLRh2cGTZdZkH1d+JiCdYpD7//Ra4uacwzstISOufyUJyrKj0WV1B0C6WUZCmVujnbFxQ/0W8MOPDLkWEYyTbUh70j4IqO0gwS0g7GspKfI8yMJGI+tP18uLfRfzOJLUdMyG8XAB8C4EkHJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754908; c=relaxed/simple;
	bh=/PyOECYzu/Oqg9JjNutsycWZquRs5nXm5RqPSIDOo7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=btsrBW3bOSw6FbG+zlZMB2vox1iidWNe1bh6a0XNpGNOWy+YPoZ8Wd1X9ZREO1862ZGLlc3HZLUtZe1HdlFqy3usDmPbnIEGhgQuw2Umz5oepzPDUoxEfqvHjhBmZtfOhhGMIQQ76g4ESGArIF9Jtc89nOnbIW/HtN/w/L+kuJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D2EsuMXy; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D2EsuMXy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754907; x=1822290907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/PyOECYzu/Oqg9JjNutsycWZquRs5nXm5RqPSIDOo7s=;
  b=D2EsuMXydYK86pLb/vyuEHpwFiFOBecnrYuTY+z2wSoP6BRQJu82EumG
   00dGzrZPwi6GtTjLFEQBr6UQYV4VWTD4W4bSW+L2MatVxNkRgIMz8nutZ
   GdaZxrbeX8MSBEoiENnr1ku+E5HjXoe2Vztmbpmd/Ef298e4BxZXjdxn5
   Vx6VycDj8X0patOwmHjs+dZHQf2Kz74jBuPgpMrn6NOEMDGZiNVXBMZPI
   PAzJj9h/4Mk4XOwCM/WMXom8xs9rOPTlvGGWQ+CQk182z78T5MKKD9ov1
   jSVIolyRLhImZ5xBc9b3hsSaYCdSlxemK0DIc1nC3GWCItZqC1xLBMzmU
   w==;
X-CSE-ConnectionGUID: RI5fHvj0Q0WY5lfON/A3ZA==
X-CSE-MsgGUID: iPhBCHu8RtmyAPN4yqzuZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296833"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296833"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:06 -0700
X-CSE-ConnectionGUID: 41Pfb32PTNa7GpgUHBT0xA==
X-CSE-MsgGUID: kbFXTWPEQJacxqFb5f/zlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962954"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:05 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Daniel Gabay <daniel.gabay@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: mld: test TX gp2 timestamps
Date: Wed, 30 Sep 2026 10:56:41 +0300
Message-Id: <20260930104825.7e04e9dc5e70.Ia0ead71cdc521a3c5db80bfd2e11a718692b3ab2@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
References: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Daniel Gabay <daniel.gabay@intel.com>

Add KUnit tests for the gp2 estimate: timestamp arithmetic and
u32 wraparounds, zero offsets, zero timestamp handling, and the expiry
and refresh thresholds driven by valid_until. Exercise the thresholds
with jiffies near wraparound.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Assisted-by: LLM
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/mld/tests/Makefile |   2 +-
 .../wireless/intel/iwlwifi/mld/tests/tx-gp2.c | 154 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mld/tx.h   |   5 +
 4 files changed, 162 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mld/tests/tx-gp2.c

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile b/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
index efa61638b8ee..730185be3fa8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 iwlmld-tests-y += module.o hcmd.o utils.o link.o rx.o agg.o link-selection.o
-iwlmld-tests-y += chan_load_thresh.o
+iwlmld-tests-y += chan_load_thresh.o tx-gp2.o
 
 ccflags-y += -I$(src)/../
 obj-$(CONFIG_IWLWIFI_KUNIT_TESTS) += iwlmld-tests.o
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tests/tx-gp2.c b/drivers/net/wireless/intel/iwlwifi/mld/tests/tx-gp2.c
new file mode 100644
index 000000000000..535140eb17c4
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tests/tx-gp2.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * KUnit tests for TX gp2 timestamp handling
+ *
+ * Copyright (C) 2026 Intel Corporation
+ */
+#include <kunit/test.h>
+
+#include "mld.h"
+#include "tx.h"
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
+static const struct tx_gp2_case {
+	const char *desc;
+	u32 est_gp2_us;
+	u32 est_host_us;
+	u32 tx_host_us;
+	long valid_for;
+	u32 expected_gp2_us;
+	bool expected_refresh;
+} tx_gp2_cases[] = {
+	{
+		.desc = "zero offset is valid",
+		.est_gp2_us = 2000,
+		.est_host_us = 2000,
+		.tx_host_us = 3500,
+		.valid_for = IWL_MLD_TX_GP2_VALID_PERIOD,
+		.expected_gp2_us = 3500,
+	},
+	{
+		.desc = "gp2 behind host",
+		.est_gp2_us = 2000,
+		.est_host_us = 10000,
+		.tx_host_us = 11500,
+		.valid_for = IWL_MLD_TX_GP2_VALID_PERIOD,
+		.expected_gp2_us = 3500,
+	},
+	{
+		.desc = "gp2 ahead of host",
+		.est_gp2_us = 10000,
+		.est_host_us = 2000,
+		.tx_host_us = 3500,
+		.valid_for = IWL_MLD_TX_GP2_VALID_PERIOD,
+		.expected_gp2_us = 11500,
+	},
+	{
+		.desc = "gp2 wraps after the estimate",
+		.est_gp2_us = U32_MAX - 999,
+		.est_host_us = 1000,
+		.tx_host_us = 2500,
+		.valid_for = IWL_MLD_TX_GP2_VALID_PERIOD,
+		.expected_gp2_us = 500,
+	},
+	{
+		.desc = "host time wraps after the estimate",
+		.est_gp2_us = 5000,
+		.est_host_us = U32_MAX - 999,
+		.tx_host_us = 500,
+		.valid_for = IWL_MLD_TX_GP2_VALID_PERIOD,
+		.expected_gp2_us = 6500,
+	},
+	{
+		.desc = "gp2 landing on 0 is reported as 1",
+		.est_gp2_us = U32_MAX - 1499,
+		.est_host_us = 1000,
+		.tx_host_us = 2500,
+		.valid_for = IWL_MLD_TX_GP2_VALID_PERIOD,
+		.expected_gp2_us = 1,
+	},
+	{
+		.desc = "within the refresh margin: still timestamped",
+		.est_gp2_us = 2000,
+		.est_host_us = 10000,
+		.tx_host_us = 11500,
+		.valid_for = IWL_MLD_TX_GP2_REFRESH_MARGIN - 1,
+		.expected_gp2_us = 3500,
+		.expected_refresh = true,
+	},
+	{
+		.desc = "outside the refresh margin: no refresh",
+		.est_gp2_us = 2000,
+		.est_host_us = 10000,
+		.tx_host_us = 11500,
+		.valid_for = IWL_MLD_TX_GP2_REFRESH_MARGIN + 1,
+		.expected_gp2_us = 3500,
+	},
+	{
+		.desc = "at the refresh threshold",
+		.est_gp2_us = 2000,
+		.est_host_us = 10000,
+		.tx_host_us = 11500,
+		.valid_for = IWL_MLD_TX_GP2_REFRESH_MARGIN,
+		.expected_gp2_us = 3500,
+		.expected_refresh = true,
+	},
+	{
+		.desc = "last valid tick",
+		.est_gp2_us = 2000,
+		.est_host_us = 10000,
+		.tx_host_us = 11500,
+		.valid_for = 1,
+		.expected_gp2_us = 3500,
+		.expected_refresh = true,
+	},
+	{
+		.desc = "validity reached: leave the frame unstamped",
+		.est_gp2_us = 2000,
+		.est_host_us = 10000,
+		.tx_host_us = 11500,
+		.valid_for = 0,
+		.expected_refresh = true,
+	},
+	{
+		.desc = "validity passed: leave the frame unstamped",
+		.est_gp2_us = 2000,
+		.est_host_us = 10000,
+		.tx_host_us = 11500,
+		.valid_for = -1,
+		.expected_refresh = true,
+	},
+};
+
+KUNIT_ARRAY_PARAM_DESC(tx_gp2, tx_gp2_cases, desc);
+
+static void test_tx_gp2(struct kunit *test)
+{
+	/* Pin time near wraparound to exercise wrapped validity deadlines. */
+	const unsigned long now =
+		ULONG_MAX - IWL_MLD_TX_GP2_REFRESH_MARGIN - 1;
+	const struct tx_gp2_case *test_case = test->param_value;
+	u32 delta_us = test_case->est_gp2_us - test_case->est_host_us;
+	unsigned long valid_until = now + test_case->valid_for;
+	bool refresh = !test_case->expected_refresh;
+	u32 timestamp;
+
+	timestamp = iwl_mld_tx_gp2_from_est(delta_us, valid_until,
+					    test_case->tx_host_us, now,
+					    &refresh);
+	KUNIT_EXPECT_EQ(test, timestamp, test_case->expected_gp2_us);
+	KUNIT_EXPECT_EQ(test, refresh, test_case->expected_refresh);
+}
+
+static struct kunit_case tx_gp2_test_cases[] = {
+	KUNIT_CASE_PARAM(test_tx_gp2, tx_gp2_gen_params),
+	{}
+};
+
+static struct kunit_suite tx_gp2_test_suite = {
+	.name = "iwl_mld_tx_gp2",
+	.test_cases = tx_gp2_test_cases,
+};
+
+kunit_test_suite(tx_gp2_test_suite);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index aac7d43bffd1..fc501ac0c1f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -29,7 +29,7 @@ static u32 iwl_mld_tx_gp2_host_us(void)
 /* Returns the gp2 for the TX command, or 0 to leave the frame unstamped.
  * Sets @refresh when the estimate expired or is about to.
  */
-static u32
+VISIBLE_IF_IWLWIFI_KUNIT u32
 iwl_mld_tx_gp2_from_est(u32 delta_us, unsigned long valid_until, u32 host_us,
 			unsigned long now, bool *refresh)
 {
@@ -46,6 +46,7 @@ iwl_mld_tx_gp2_from_est(u32 delta_us, unsigned long valid_until, u32 host_us,
 	/* 0 means no timestamp; use 1 for a valid wrapped value. */
 	return gp2 ?: 1;
 }
+EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_tx_gp2_from_est);
 
 static u32
 iwl_mld_tx_gp2_timestamp(struct iwl_mld *mld)
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.h b/drivers/net/wireless/intel/iwlwifi/mld/tx.h
index 0a9a2e4abcab..a376e8c9c500 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.h
@@ -106,4 +106,9 @@ void iwl_mld_tx_gp2_init(struct iwl_mld *mld);
 void iwl_mld_tx_gp2_start(struct iwl_mld *mld);
 void iwl_mld_tx_gp2_stop(struct iwl_mld *mld);
 
+#if IS_ENABLED(CONFIG_IWLWIFI_KUNIT_TESTS)
+u32 iwl_mld_tx_gp2_from_est(u32 delta_us, unsigned long valid_until,
+			    u32 host_us, unsigned long now, bool *refresh);
+#endif
+
 #endif /* __iwl_mld_tx_h__ */
-- 
2.34.1

