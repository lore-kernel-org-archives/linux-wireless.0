Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91080C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F0E21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfBHKri (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57068 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727649AbfBHKri (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:38 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gw-0002jg-Qh; Fri, 08 Feb 2019 12:47:31 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:06 +0200
Message-Id: <20190208104712.16210-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/20] iwlwifi: dbg_ini: enable ignore consecutive trigger feature
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Enable ignore consecutive trigger feature which allows to configure the
driver to skip consecutive triggers from the same type.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c |  3 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h | 37 +++++++++------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 8d1416e8a203..202f96e9ca0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1484,8 +1484,7 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 	if (id == FW_DBG_TRIGGER_FW_ASSERT)
 		id = IWL_FW_TRIGGER_ID_FW_ASSERT;
 
-	if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)) ||
-	    !fwrt->dump.active_trigs[id].active)
+	if (!iwl_fw_ini_trigger_on(fwrt, id))
 		return NULL;
 
 	trigger = fwrt->dump.active_trigs[id].trig;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 16656949b505..a199056234d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -162,9 +162,9 @@ iwl_fw_dbg_trigger_stop_conf_match(struct iwl_fw_runtime *fwrt,
 }
 
 static inline bool
-iwl_fw_dbg_no_trig_window(struct iwl_fw_runtime *fwrt, u32 id, u32 dis_ms)
+iwl_fw_dbg_no_trig_window(struct iwl_fw_runtime *fwrt, u32 id, u32 dis_usec)
 {
-	unsigned long wind_jiff = msecs_to_jiffies(dis_ms);
+	unsigned long wind_jiff = usecs_to_jiffies(dis_usec);
 
 	/* If this is the first event checked, jump to update start ts */
 	if (fwrt->dump.non_collect_ts_start[id] &&
@@ -181,11 +181,12 @@ iwl_fw_dbg_trigger_check_stop(struct iwl_fw_runtime *fwrt,
 			      struct wireless_dev *wdev,
 			      struct iwl_fw_dbg_trigger_tlv *trig)
 {
+	u32 usec = le16_to_cpu(trig->trig_dis_ms) * USEC_PER_MSEC;
+
 	if (wdev && !iwl_fw_dbg_trigger_vif_match(trig, wdev))
 		return false;
 
-	if (iwl_fw_dbg_no_trig_window(fwrt, le32_to_cpu(trig->id),
-				      le16_to_cpu(trig->trig_dis_ms))) {
+	if (iwl_fw_dbg_no_trig_window(fwrt, le32_to_cpu(trig->id), usec)) {
 		IWL_WARN(fwrt, "Trigger %d occurred while no-collect window.\n",
 			 trig->id);
 		return false;
@@ -222,24 +223,22 @@ _iwl_fw_dbg_trigger_on(struct iwl_fw_runtime *fwrt,
 })
 
 static inline bool
-_iwl_fw_ini_trigger_on(struct iwl_fw_runtime *fwrt,
-		       const enum iwl_fw_dbg_trigger id)
+iwl_fw_ini_trigger_on(struct iwl_fw_runtime *fwrt,
+		      enum iwl_fw_ini_trigger_id id)
 {
-	struct iwl_fw_ini_active_triggers *active =
-		&fwrt->dump.active_trigs[id];
-	u32 ms;
+	struct iwl_fw_ini_trigger *trig;
+	u32 usec;
+
 
-	if (!fwrt->trans->ini_valid)
-		return false;
 
-	if (!active->active)
+	if (!fwrt->trans->ini_valid || id >= IWL_FW_TRIGGER_ID_NUM ||
+	    !fwrt->dump.active_trigs[id].active)
 		return false;
 
-	ms = le32_to_cpu(active->trig->ignore_consec);
-	if (ms)
-		ms /= USEC_PER_MSEC;
+	trig = fwrt->dump.active_trigs[id].trig;
+	usec = le32_to_cpu(trig->ignore_consec);
 
-	if (iwl_fw_dbg_no_trig_window(fwrt, id, ms)) {
+	if (iwl_fw_dbg_no_trig_window(fwrt, id, usec)) {
 		IWL_WARN(fwrt, "Trigger %d fired in no-collect window\n", id);
 		return false;
 	}
@@ -247,12 +246,6 @@ _iwl_fw_ini_trigger_on(struct iwl_fw_runtime *fwrt,
 	return true;
 }
 
-#define iwl_fw_ini_trigger_on(fwrt, wdev, id) ({		\
-	BUILD_BUG_ON(!__builtin_constant_p(id));		\
-	BUILD_BUG_ON((id) >= IWL_FW_TRIGGER_ID_NUM);		\
-	_iwl_fw_ini_trigger_on((fwrt), (wdev), (id));		\
-})
-
 static inline void
 _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 				struct wireless_dev *wdev,
-- 
2.20.1

