Received: from mail.berlin.ccc.de (mail.berlin.ccc.de [195.160.173.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39463B0AD7
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 13:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.160.173.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788095410; cv=none; b=LRHIjrhMTJcAt9i1KnbOePSDHQXWwNzUS21gSr1xyoUiV9tRzaVUNlc9a5bsLZLVOxniUA7LDXWruovXzVTY02xXcEiOuBTWloh9L1FUrUp6SPTYKGQ+cWhlJ1bZ1m6ZA778pNFMDYoBLdSjZloKPrNk35eG2ahLQ2N4eFSLYN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788095410; c=relaxed/simple;
	bh=mhkgHT9iV0YRYwCXEwrxtH8mOLWWVASGFkhqksnLN0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FmvaARsBOzf+ThegE3mB+T0GkbuwEOVUguuaG0XbJojmNnF597Q9tIkhO+Zz1t1xnII3XDhEJ2VYt9IeK4SDdnOpULYyTZMUOH6UaPE2gWXpa6n3+mjZhTOksTJf3QvRbxy0AtWwtzyQop1EBhqMdIa32wmnUUp3apK9AsS1nyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=berlin.ccc.de; spf=pass smtp.mailfrom=berlin.ccc.de; dkim=pass (2048-bit key) header.d=berlin.ccc.de header.i=@berlin.ccc.de header.b=J43j21qR; arc=none smtp.client-ip=195.160.173.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=berlin.ccc.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berlin.ccc.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berlin.ccc.de header.i=@berlin.ccc.de header.b="J43j21qR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=berlin.ccc.de; h=from:to
	:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=default; bh=mhkgHT9iV0YRYwCXEwrxtH
	8mOLWWVASGFkhqksnLN0A=; b=J43j21qRUIiYM/mHoNuW558DeXxS39h7Wt1b4r
	9hn4TN+ogDnxducQdVI2PYp3QpZKvDRyJ8JBRrxDI5Eo0u80xraqUWvOP0eyQ4LY
	SqfBSiddQ9HNCHZHwpIrGLrpAGIga4UncJU1WXGbdgZBRWMqTKSdtoFEmpmIT1N0
	aZ0TyNLak040ZIVKKiXOKjTdO/R0SYMEz04ev8RYgxNm5MiwDowpXj6JENJBUy6p
	2ByHNHWVQfWcYhZDBH7+VEzjhV7XMCRbo6zF64aMjJUsusXFGzAxxs1QWvhr5z7X
	IxZJlsSfsIN8qYnK4mKbqvUkBVDHmbGevVTtVakDVUjF4PEg==
Received: (qmail 43146 invoked from network); 30 Aug 2026 13:03:23 -0000
Received: from mail.berlin.ccc.de (HELO mail.berlin.ccc.de) (aprl@berlin.ccc.de)
  by mail.berlin.ccc.de with SMTP; 30 Aug 2026 13:03:23 -0000
From: April John <aprl@berlin.ccc.de>
To: linux-wireless@vger.kernel.org
Cc: miriam.rachel.korenblit@intel.com,
	April John <aprl@acab.dev>
Subject: [PATCH 1/2] wifi: iwlwifi: mld: add KUnit tests for TLC rate helpers
Date: Sun, 30 Aug 2026 15:03:22 +0200
Message-ID: <20260830130323.187435-1-aprl@berlin.ccc.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: April John <aprl@acab.dev>

Add tests for iwl_mld_get_highest_fw_mcs() covering the 2-bit VHT
MCS field extraction for different NSS values, and for
iwl_mld_get_eht_max_nss() covering the min() of the peer RX and own
TX NSS capabilities.

Signed-off-by: April John <aprl@acab.dev>
---
 .../wireless/intel/iwlwifi/mld/tests/Makefile |   1 +
 .../wireless/intel/iwlwifi/mld/tests/tlc.c    | 138 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mld/tlc.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mld/tlc.h  |   6 +
 4 files changed, 149 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mld/tests/tlc.c

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile b/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
index efa61638b8ee..2af1fb838520 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 iwlmld-tests-y += module.o hcmd.o utils.o link.o rx.o agg.o link-selection.o
 iwlmld-tests-y += chan_load_thresh.o
+iwlmld-tests-y += tlc.o
 
 ccflags-y += -I$(src)/../
 obj-$(CONFIG_IWLWIFI_KUNIT_TESTS) += iwlmld-tests.o
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tests/tlc.c b/drivers/net/wireless/intel/iwlwifi/mld/tests/tlc.c
new file mode 100644
index 000000000000..704a1bb1a5ea
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tests/tlc.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * KUnit tests for TLC rate-selection helper functions
+ *
+ * Copyright (C) 2026 Intel Corporation
+ */
+#include <kunit/test.h>
+
+#include "tlc.h"
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
+struct highest_fw_mcs_case {
+	const char *desc;
+	int nss;
+	u16 rx_mcs_map;
+	int expected_mcs;
+};
+
+static const struct highest_fw_mcs_case highest_fw_mcs_cases[] = {
+	{
+		.desc = "NSS 1 supports MCS 0-7",
+		.nss = 1,
+		.rx_mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_7,
+		.expected_mcs = IWL_TLC_MNG_HT_RATE_MCS7,
+	},
+	{
+		.desc = "NSS 1 supports MCS 0-8",
+		.nss = 1,
+		.rx_mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_8,
+		.expected_mcs = IWL_TLC_MNG_HT_RATE_MCS8,
+	},
+	{
+		.desc = "NSS 1 supports MCS 0-9",
+		.nss = 1,
+		.rx_mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_9,
+		.expected_mcs = IWL_TLC_MNG_HT_RATE_MCS9,
+	},
+	{
+		.desc = "NSS 2 supports MCS 0-9",
+		.nss = 2,
+		.rx_mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_9 << 2,
+		.expected_mcs = IWL_TLC_MNG_HT_RATE_MCS9,
+	},
+	{
+		.desc = "NSS 4 supports MCS 0-8",
+		.nss = 4,
+		.rx_mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_8 << 6,
+		.expected_mcs = IWL_TLC_MNG_HT_RATE_MCS8,
+	},
+};
+
+KUNIT_ARRAY_PARAM_DESC(highest_fw_mcs_cases, highest_fw_mcs_cases, desc);
+
+static void test_highest_fw_mcs(struct kunit *test)
+{
+	const struct highest_fw_mcs_case *tc = test->param_value;
+	struct ieee80211_sta_vht_cap vht_cap = {
+		.vht_mcs.rx_mcs_map = cpu_to_le16(tc->rx_mcs_map),
+	};
+
+	KUNIT_EXPECT_EQ(test, tc->expected_mcs,
+			iwl_mld_get_highest_fw_mcs(&vht_cap, tc->nss));
+}
+
+static struct kunit_case highest_fw_mcs_test_cases[] = {
+	KUNIT_CASE_PARAM(test_highest_fw_mcs, highest_fw_mcs_cases_gen_params),
+	{},
+};
+
+static struct kunit_suite highest_fw_mcs_tests = {
+	.name = "iwl_mld_highest_fw_mcs_tests",
+	.test_cases = highest_fw_mcs_test_cases,
+};
+
+kunit_test_suite(highest_fw_mcs_tests);
+
+struct eht_max_nss_case {
+	const char *desc;
+	u8 rx_nss;
+	u8 tx_nss;
+	u8 expected_nss;
+};
+
+static const struct eht_max_nss_case eht_max_nss_cases[] = {
+	{
+		.desc = "RX limited",
+		.rx_nss = 0x02,
+		.tx_nss = 0x80,
+		.expected_nss = 2,
+	},
+	{
+		.desc = "TX limited",
+		.rx_nss = 0x0f,
+		.tx_nss = 0x30,
+		.expected_nss = 3,
+	},
+	{
+		.desc = "Equal",
+		.rx_nss = 0x05,
+		.tx_nss = 0x50,
+		.expected_nss = 5,
+	},
+	{
+		.desc = "Both zero",
+		.rx_nss = 0x00,
+		.tx_nss = 0x00,
+		.expected_nss = 0,
+	},
+	{
+		.desc = "Both max",
+		.rx_nss = 0x0f,
+		.tx_nss = 0xf0,
+		.expected_nss = 15,
+	},
+};
+
+KUNIT_ARRAY_PARAM_DESC(eht_max_nss_cases, eht_max_nss_cases, desc);
+
+static void test_eht_max_nss(struct kunit *test)
+{
+	const struct eht_max_nss_case *tc = test->param_value;
+
+	KUNIT_EXPECT_EQ(test, tc->expected_nss,
+			iwl_mld_get_eht_max_nss(tc->rx_nss, tc->tx_nss));
+}
+
+static struct kunit_case eht_max_nss_test_cases[] = {
+	KUNIT_CASE_PARAM(test_eht_max_nss, eht_max_nss_cases_gen_params),
+	{},
+};
+
+static struct kunit_suite eht_max_nss_tests = {
+	.name = "iwl_mld_eht_max_nss_tests",
+	.test_cases = eht_max_nss_test_cases,
+};
+
+kunit_test_suite(eht_max_nss_tests);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tlc.c b/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
index b6c2fa3664cb..72ddb788ad3e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
@@ -161,7 +161,7 @@ static u8 iwl_mld_get_fw_sgi(struct iwl_mld_tlc_sta_capa *capa)
 	return sgi_chwidths;
 }
 
-static int
+VISIBLE_IF_IWLWIFI_KUNIT int
 iwl_mld_get_highest_fw_mcs(const struct ieee80211_sta_vht_cap *vht_cap,
 			   int nss)
 {
@@ -183,6 +183,7 @@ iwl_mld_get_highest_fw_mcs(const struct ieee80211_sta_vht_cap *vht_cap,
 
 	return 0;
 }
+EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_get_highest_fw_mcs);
 
 static void
 iwl_mld_fill_vht_rates(struct iwl_mld_tlc_sta_capa *capa,
@@ -316,7 +317,7 @@ iwl_mld_get_eht_mcs_of_bw(enum IWL_TLC_MCS_PER_BW bw,
 	}
 }
 
-static u8 iwl_mld_get_eht_max_nss(u8 rx_nss, u8 tx_nss)
+VISIBLE_IF_IWLWIFI_KUNIT u8 iwl_mld_get_eht_max_nss(u8 rx_nss, u8 tx_nss)
 {
 	u8 tx = u8_get_bits(tx_nss, IEEE80211_EHT_MCS_NSS_TX);
 	u8 rx = u8_get_bits(rx_nss, IEEE80211_EHT_MCS_NSS_RX);
@@ -325,6 +326,7 @@ static u8 iwl_mld_get_eht_max_nss(u8 rx_nss, u8 tx_nss)
 	 */
 	return min(tx, rx);
 }
+EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_get_eht_max_nss);
 
 #define MAX_NSS_MCS(mcs_num, rx, tx) \
 	iwl_mld_get_eht_max_nss((rx)->rx_tx_mcs ##mcs_num## _max_nss, \
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tlc.h b/drivers/net/wireless/intel/iwlwifi/mld/tlc.h
index c7ff209c9ab6..269d0f2a61ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tlc.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tlc.h
@@ -23,4 +23,10 @@ int iwl_mld_send_tlc_dhc(struct iwl_mld *mld, u8 sta_id, u32 type, u32 data);
 void iwl_mld_tlc_update_phy(struct iwl_mld *mld, struct ieee80211_vif *vif,
 			    struct ieee80211_bss_conf *link_conf);
 
+#if IS_ENABLED(CONFIG_IWLWIFI_KUNIT_TESTS)
+int iwl_mld_get_highest_fw_mcs(const struct ieee80211_sta_vht_cap *vht_cap,
+			       int nss);
+u8 iwl_mld_get_eht_max_nss(u8 rx_nss, u8 tx_nss);
+#endif
+
 #endif /* __iwl_mld_tlc_h__ */

base-commit: 4a2610a5a9fcf77eaad82bb030ec77ec5e381db8
-- 
2.53.0

