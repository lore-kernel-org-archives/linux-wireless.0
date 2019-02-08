Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44593C282D7
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E37C21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfBHKrX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:23 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56954 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727485AbfBHKrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:22 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gm-0002jg-NL; Fri, 08 Feb 2019 12:47:21 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:46:55 +0200
Message-Id: <20190208104712.16210-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/20] iwlwifi: mvm: add support for 32kHz external clock indication
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

In low power modes, the chip clock source for platform integrated
devices is 32kHz. It is generated internally and supplied by a crystal
oscillator. However using a 32kHz sourced from crystal oscillator
has high power penalty.

There is an option to get an external 32kHz clock from the platform. Past
experience shows that the reliability is platform dependent,
i.e. on some platforms it works good and on other it doesn’t.

Working from external clock will save 0.5 mW in sleep state, from overall
1.8mW that we have today, i.e. almost 30%.

Each OEM can enable or disable the use of the external 32kHz clock by
setting a BIOS configuration. In case the OEM configured to use 32kHz
external clock the driver will pass this indication to the FW.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 32 +++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  | 22 +++++++++++--
 .../net/wireless/intel/iwlwifi/fw/api/power.h | 13 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  7 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 ++
 .../net/wireless/intel/iwlwifi/mvm/power.c    |  7 ++--
 6 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 32d000cffe9f..405038ce98d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright (C) 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -26,6 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright (C) 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -205,3 +207,33 @@ u64 iwl_acpi_get_pwr_limit(struct device *dev)
 	return dflt_pwr_limit;
 }
 IWL_EXPORT_SYMBOL(iwl_acpi_get_pwr_limit);
+
+int iwl_acpi_get_eckv(struct device *dev, u32 *extl_clk)
+{
+	union acpi_object *wifi_pkg, *data;
+	int ret;
+
+	data = iwl_acpi_get_object(dev, ACPI_ECKV_METHOD);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	wifi_pkg = iwl_acpi_get_wifi_pkg(dev, data, ACPI_ECKV_WIFI_DATA_SIZE);
+	if (IS_ERR(wifi_pkg)) {
+		ret = PTR_ERR(wifi_pkg);
+		goto out_free;
+	}
+
+	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	*extl_clk = wifi_pkg->package.elements[1].integer.value;
+
+	ret = 0;
+
+out_free:
+	kfree(data);
+	return ret;
+}
+IWL_EXPORT_SYMBOL(iwl_acpi_get_eckv);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 7492dfb6729b..f5704e16643f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -27,7 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019       Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -67,6 +67,7 @@
 #define ACPI_WGDS_METHOD	"WGDS"
 #define ACPI_WRDD_METHOD	"WRDD"
 #define ACPI_SPLC_METHOD	"SPLC"
+#define ACPI_ECKV_METHOD	"ECKV"
 
 #define ACPI_WIFI_DOMAIN	(0x07)
 
@@ -86,6 +87,7 @@
 #define ACPI_WGDS_WIFI_DATA_SIZE	19
 #define ACPI_WRDD_WIFI_DATA_SIZE	2
 #define ACPI_SPLC_WIFI_DATA_SIZE	2
+#define ACPI_ECKV_WIFI_DATA_SIZE	2
 
 #define ACPI_WGDS_NUM_BANDS		2
 #define ACPI_WGDS_TABLE_SIZE		3
@@ -109,6 +111,17 @@ int iwl_acpi_get_mcc(struct device *dev, char *mcc);
 
 u64 iwl_acpi_get_pwr_limit(struct device *dev);
 
+/*
+ * iwl_acpi_get_eckv - read external clock validation from ACPI, if available
+ *
+ * @dev: the struct device
+ * @extl_clk: output var (2 bytes) that will get the clk indication.
+ *
+ * This function tries to read the external clock indication
+ * from ACPI if available.
+ */
+int iwl_acpi_get_eckv(struct device *dev, u32 *extl_clk);
+
 #else /* CONFIG_ACPI */
 
 static inline void *iwl_acpi_get_object(struct device *dev, acpi_string method)
@@ -133,5 +146,10 @@ static inline u64 iwl_acpi_get_pwr_limit(struct device *dev)
 	return 0;
 }
 
+static inline int iwl_acpi_get_eckv(struct device *dev, u32 *extl_clk)
+{
+	return -ENOENT;
+}
+
 #endif /* CONFIG_ACPI */
 #endif /* __iwl_fw_acpi__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 5844898ee92c..01f003c6cff9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -200,9 +200,16 @@ struct iwl_powertable_cmd {
  * @DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK:
  *	'1' Allow to save power by turning off
  *	receiver and transmitter. '0' - does not allow.
+ * @DEVICE_POWER_FLAGS_ALLOW_MEM_RETENTION_MSK:
+ *	Device Retention indication, '1' indicate retention is enabled.
+ * @DEVICE_POWER_FLAGS_32K_CLK_VALID_MSK:
+ *	32Khz external slow clock valid indication, '1' indicate cloack is
+ *	valid.
 */
 enum iwl_device_power_flags {
-	DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK	= BIT(0),
+	DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK		= BIT(0),
+	DEVICE_POWER_FLAGS_ALLOW_MEM_RETENTION_MSK	= BIT(1),
+	DEVICE_POWER_FLAGS_32K_CLK_VALID_MSK		= BIT(12),
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 28ef204c9cf7..0278f19180d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019       Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1266,6 +1266,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
 		iwl_mvm_send_recovery_cmd(mvm, ERROR_RECOVERY_UPDATE_DB);
 
+	if (iwl_acpi_get_eckv(mvm->dev, &mvm->ext_clock_valid))
+		IWL_DEBUG_INFO(mvm, "ECKV table doesn't exist in BIOS\n");
+
 	ret = iwl_mvm_sar_init(mvm);
 	if (ret == 0) {
 		ret = iwl_mvm_sar_geo_init(mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f4fc81695df1..9993337a2bbd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1104,6 +1104,8 @@ struct iwl_mvm {
 
 	/* Indicate if device power save is allowed */
 	u8 ps_disabled; /* u8 instead of bool to ease debugfs_create_* usage */
+	/* Indicate if 32Khz external clock is valid */
+	u32 ext_clock_valid;
 	unsigned int max_amsdu_len; /* used for debugfs only */
 
 	struct ieee80211_vif __rcu *csa_vif;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index df9f1d6cdf78..36f5fa1ee793 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -544,6 +544,9 @@ int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 		cmd.flags &=
 			cpu_to_le16(~DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK);
 #endif
+	if (mvm->ext_clock_valid)
+		cmd.flags |= cpu_to_le16(DEVICE_POWER_FLAGS_32K_CLK_VALID_MSK);
+
 	IWL_DEBUG_POWER(mvm,
 			"Sending device power command with flags = 0x%X\n",
 			cmd.flags);
-- 
2.20.1

