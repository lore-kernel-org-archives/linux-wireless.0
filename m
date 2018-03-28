Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37040 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753684AbeC1O0z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 10:26:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 17:26:50 +0300
Message-Id: <20180328142650.9377-1-luca@coelho.fi> (sfid-20180328_162657_767751_09ECC035)
In-Reply-To: <20180328141157.5427-1-luca@coelho.fi>
References: <20180328141157.5427-1-luca@coelho.fi>
Subject: [PATCH 11/14] iwlwifi: api: Add geographic profile information to MCC_UPDATE_CMD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Some geographic profiles require specific handling.  For example ETSI
profile requires special channel access handling.  Add geographic
profile information to MCC_UPDATE response to allow it.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 3fd07bc80f54..37c57bcbfb4a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -310,6 +312,17 @@ struct iwl_mcc_update_resp_v1  {
 	__le32 channels[0];
 } __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_1 */
 
+/**
+ * enum iwl_geo_information - geographic information.
+ * @GEO_NO_INFO: no special info for this geo profile.
+ * @GEO_WMM_ETSI_5GHZ_INFO: this geo profile limits the WMM params
+ *	for the 5 GHz band.
+ */
+enum iwl_geo_information {
+	GEO_NO_INFO =			0,
+	GEO_WMM_ETSI_5GHZ_INFO =	BIT(0),
+};
+
 /**
  * struct iwl_mcc_update_resp - response to MCC_UPDATE_CMD.
  * Contains the new channel control profile map, if changed, and the new MCC
@@ -320,7 +333,8 @@ struct iwl_mcc_update_resp_v1  {
  * @cap: capabilities for all channels which matches the MCC
  * @source_id: the MCC source, see iwl_mcc_source
  * @time: time elapsed from the MCC test start (in 30 seconds TU)
- * @reserved: reserved.
+ * @geo_info: geographic specific profile information
+ *	see &enum iwl_geo_information.
  * @n_channels: number of channels in @channels_data (may be 14, 39, 50 or 51
  *		channels, depending on platform)
  * @channels: channel control data map, DWORD for each channel. Only the first
@@ -332,10 +346,10 @@ struct iwl_mcc_update_resp {
 	u8 cap;
 	u8 source_id;
 	__le16 time;
-	__le16 reserved;
+	__le16 geo_info;
 	__le32 n_channels;
 	__le32 channels[0];
-} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_2 */
+} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_3 */
 
 /**
  * struct iwl_mcc_chub_notif - chub notifies of mcc change
-- 
2.16.2
