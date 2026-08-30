Received: from mail.berlin.ccc.de (mail.berlin.ccc.de [195.160.173.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38BC38D41A
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 13:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.160.173.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788095410; cv=none; b=g4nmE92/y063AsTF74cGYN13k5yU8TCphBtEa2TihqxAsv08PC2Fg3Tv9KCCsdEIlT3x6MEMNwNF6Cq3dvJRInf/hfOFbMdDKnJjyQup44eJMRAkge10W3FGnqa9lYOsSEnMvEjLJ9QgCCoeJF9AFYBFAemSm4GJ4JE61M/+R4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788095410; c=relaxed/simple;
	bh=FHy0zfuDU8rVCKS3xZuZmqIsIjmJPSZEuzwijVujv8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx7ocj130XUk4D+ktFi/48nI1Va/pBvgx0LmdPmTMP3DpkTxJqi92l5CyLfDUGxbRu2hVNmDD8Q4E+MdMRxlSlUYylQ0pEdK3gFwVgkI9f7iVSJ965t10OYNho+ExILEwDPGvx9JbFVsgkkpOHehCp++z/slCinSrQ0WN9hqr+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=berlin.ccc.de; spf=pass smtp.mailfrom=berlin.ccc.de; dkim=pass (2048-bit key) header.d=berlin.ccc.de header.i=@berlin.ccc.de header.b=wretImG7; arc=none smtp.client-ip=195.160.173.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=berlin.ccc.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berlin.ccc.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berlin.ccc.de header.i=@berlin.ccc.de header.b="wretImG7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=berlin.ccc.de; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:mime-version
	:content-transfer-encoding; s=default; bh=FHy0zfuDU8rVCKS3xZuZmq
	IsIjmJPSZEuzwijVujv8Y=; b=wretImG7XyRvuSllFXZUWaPBWXgurWHtJ3E/oS
	oKaq5vhdox4UuadtKnLZWiOISGRcyLZyM1oN/zKr3cZD7Gok/CoAk7VNivXcU468
	UcEe8ngopeUcfZRN1yqcHs5i8e4LwMGkIDFPRf6kpWqVRqIac/el+EOQttgU/lcX
	k0DQ17jpc3RXXuB5q+A1oE04ZCuIQTzLp80/j64qhyUih3HOYLtb973erzGySmTV
	LjhoM36t4c6fm+NmuZ7TlTd1ofdit5Y0o2iKub+++mxZsxDRli9s0jKr8mqTiqkb
	8JchetKHJWTyXjldEf47tr19MQUyT3w/mu8FoY5SV1YTOKpQ==
Received: (qmail 43180 invoked from network); 30 Aug 2026 13:03:23 -0000
Received: from mail.berlin.ccc.de (HELO mail.berlin.ccc.de) (aprl@berlin.ccc.de)
  by mail.berlin.ccc.de with SMTP; 30 Aug 2026 13:03:23 -0000
From: April John <aprl@berlin.ccc.de>
To: linux-wireless@vger.kernel.org
Cc: miriam.rachel.korenblit@intel.com,
	April John <aprl@acab.dev>
Subject: [PATCH 2/2] wifi: iwlwifi: mld: add KUnit test for HE PPE parsing
Date: Sun, 30 Aug 2026 15:03:23 +0200
Message-ID: <20260830130323.187435-2-aprl@berlin.ccc.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260830130323.187435-1-aprl@berlin.ccc.de>
References: <20260830130323.187435-1-aprl@berlin.ccc.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: April John <aprl@acab.dev>

Add tests for iwl_mld_he_get_ppe_val() covering both the single-byte
extraction path and the cross-byte path where a 3-bit value spans a
byte boundary.

Signed-off-by: April John <aprl@acab.dev>
---
 drivers/net/wireless/intel/iwlwifi/mld/sta.c  |  3 +-
 drivers/net/wireless/intel/iwlwifi/mld/sta.h  |  4 +
 .../wireless/intel/iwlwifi/mld/tests/Makefile |  2 +-
 .../wireless/intel/iwlwifi/mld/tests/sta.c    | 86 +++++++++++++++++++
 4 files changed, 93 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mld/tests/sta.c

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 7957ac11b0cd..fd0cee9a92b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -121,7 +121,7 @@ static u8 iwl_mld_get_uapsd_acs(struct ieee80211_sta *sta)
 	return uapsd_acs | uapsd_acs << 4;
 }
 
-static u8 iwl_mld_he_get_ppe_val(u8 *ppe, u8 ppe_pos_bit)
+VISIBLE_IF_IWLWIFI_KUNIT u8 iwl_mld_he_get_ppe_val(u8 *ppe, u8 ppe_pos_bit)
 {
 	u8 byte_num = ppe_pos_bit / 8;
 	u8 bit_num = ppe_pos_bit % 8;
@@ -146,6 +146,7 @@ static u8 iwl_mld_he_get_ppe_val(u8 *ppe, u8 ppe_pos_bit)
 
 	return res;
 }
+EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_he_get_ppe_val);
 
 static void iwl_mld_parse_ppe(struct iwl_mld *mld,
 			      struct iwl_he_pkt_ext_v2 *pkt_ext, u8 nss,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.h b/drivers/net/wireless/intel/iwlwifi/mld/sta.h
index 98d693235c66..8659bb7bf6cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.h
@@ -300,4 +300,8 @@ void iwl_mld_remove_nan_mgmt_sta(struct iwl_mld *mld,
 void iwl_mld_remove_nan_mcast_data_sta(struct iwl_mld *mld,
 				       struct iwl_mld_int_sta *sta);
 
+#if IS_ENABLED(CONFIG_IWLWIFI_KUNIT_TESTS)
+u8 iwl_mld_he_get_ppe_val(u8 *ppe, u8 ppe_pos_bit);
+#endif
+
 #endif /* __iwl_mld_sta_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile b/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
index 2af1fb838520..3201dce9a5b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tests/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 iwlmld-tests-y += module.o hcmd.o utils.o link.o rx.o agg.o link-selection.o
 iwlmld-tests-y += chan_load_thresh.o
-iwlmld-tests-y += tlc.o
+iwlmld-tests-y += tlc.o sta.o
 
 ccflags-y += -I$(src)/../
 obj-$(CONFIG_IWLWIFI_KUNIT_TESTS) += iwlmld-tests.o
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tests/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/tests/sta.c
new file mode 100644
index 000000000000..675408661af2
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tests/sta.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * KUnit tests for STA capability helper functions
+ *
+ * Copyright (C) 2026 Intel Corporation
+ */
+#include <kunit/test.h>
+
+#include "sta.h"
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
+struct ppe_val_case {
+	const char *desc;
+	u8 ppe[2];
+	u8 ppe_pos_bit;
+	u8 expected_val;
+};
+
+static const struct ppe_val_case ppe_val_cases[] = {
+	{
+		.desc = "Aligned in byte 0",
+		.ppe = { 0b111, 0 },
+		.ppe_pos_bit = 0,
+		.expected_val = 7,
+	},
+	{
+		.desc = "Unaligned in byte 0",
+		.ppe = { 0b00111000, 0 },
+		.ppe_pos_bit = 3,
+		.expected_val = 7,
+	},
+	{
+		.desc = "Highest non-crossing position",
+		.ppe = { 0b11100000, 0 },
+		.ppe_pos_bit = 5,
+		.expected_val = 7,
+	},
+	{
+		.desc = "Value in byte 1",
+		.ppe = { 0, 0b00000011 },
+		.ppe_pos_bit = 8,
+		.expected_val = 3,
+	},
+	{
+		.desc = "Cross-byte at bit 6",
+		.ppe = { 0b01000000, 0b00000001 },
+		.ppe_pos_bit = 6,
+		.expected_val = 5,
+	},
+	{
+		.desc = "Cross-byte at bit 7",
+		.ppe = { 0b10000000, 0b00000011 },
+		.ppe_pos_bit = 7,
+		.expected_val = 7,
+	},
+	{
+		.desc = "Cross-byte all zeros",
+		.ppe = { 0, 0 },
+		.ppe_pos_bit = 6,
+		.expected_val = 0,
+	},
+};
+
+KUNIT_ARRAY_PARAM_DESC(ppe_val_cases, ppe_val_cases, desc);
+
+static void test_he_get_ppe_val(struct kunit *test)
+{
+	const struct ppe_val_case *tc = test->param_value;
+	u8 ppe[] = { tc->ppe[0], tc->ppe[1] };
+
+	KUNIT_EXPECT_EQ(test, tc->expected_val,
+			iwl_mld_he_get_ppe_val(ppe, tc->ppe_pos_bit));
+}
+
+static struct kunit_case ppe_val_test_cases[] = {
+	KUNIT_CASE_PARAM(test_he_get_ppe_val, ppe_val_cases_gen_params),
+	{},
+};
+
+static struct kunit_suite ppe_val_tests = {
+	.name = "iwl_mld_ppe_val_tests",
+	.test_cases = ppe_val_test_cases,
+};
+
+kunit_test_suite(ppe_val_tests);
-- 
2.53.0

