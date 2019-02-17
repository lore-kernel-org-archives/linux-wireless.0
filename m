Return-Path: <SRS0=gO0h=QY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E948DC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 13:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4CCB217F5
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 13:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TSdwtecs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TSdwtecs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfBQNvh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 08:51:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55806 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbfBQNvh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 08:51:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D5F9060B11; Sun, 17 Feb 2019 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550411495;
        bh=/4eGskos/5FYuEclAyhHaF2izwtNbXtBlS6LptH/CiY=;
        h=From:To:Cc:Subject:Date:From;
        b=TSdwtecsEo8q/cSdl2WsNEMcwWDzrc3idpAI3CgpTeVRUlWfx0kEjo/4msYWYDi6p
         GDakmZa+D55zrOg4oiY6cKCZCuC6P09RjDPi/kwcSahqUd8ORiQDPXLD5sblw7BWld
         1xZrmEdcN9iphxadi8SFYznmDNktWMLIKzx3euEg=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF5E960AD8;
        Sun, 17 Feb 2019 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550411495;
        bh=/4eGskos/5FYuEclAyhHaF2izwtNbXtBlS6LptH/CiY=;
        h=From:To:Cc:Subject:Date:From;
        b=TSdwtecsEo8q/cSdl2WsNEMcwWDzrc3idpAI3CgpTeVRUlWfx0kEjo/4msYWYDi6p
         GDakmZa+D55zrOg4oiY6cKCZCuC6P09RjDPi/kwcSahqUd8ORiQDPXLD5sblw7BWld
         1xZrmEdcN9iphxadi8SFYznmDNktWMLIKzx3euEg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF5E960AD8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2] ath10k: wait for vdev delete response from firmware
Date:   Sun, 17 Feb 2019 19:21:19 +0530
Message-Id: <1550411479-32253-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When we add an interface immediately after removing
the interface the vdev deletion in firmware might not
have been completed. We need to synchronize the vdev creation
with the firmware.

Wait for vdev delete response from firmware when we
remove an interface.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
Changes from v1:
- Unlock conf_mutex in vdev delete failure case.
---
 drivers/net/wireless/ath/ath10k/core.c    |  4 +++-
 drivers/net/wireless/ath/ath10k/core.h    |  6 ++++--
 drivers/net/wireless/ath/ath10k/mac.c     | 15 +++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 12 +++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  6 +++++-
 drivers/net/wireless/ath/ath10k/wmi.h     |  4 +++-
 6 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 327a74c0..16d2d04 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -2137,6 +2137,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	complete(&ar->offchan_tx_completed);
 	complete(&ar->install_key_done);
 	complete(&ar->vdev_setup_done);
+	complete(&ar->vdev_delete_done);
 	complete(&ar->thermal.wmi_sync);
 	complete(&ar->bss_survey_done);
 	wake_up(&ar->htt.empty_tx_wq);
@@ -3093,6 +3094,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->vdev_setup_done);
+	init_completion(&ar->vdev_delete_done);
 	init_completion(&ar->thermal.wmi_sync);
 	init_completion(&ar->bss_survey_done);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 46e9c8c..ad1da95 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -511,7 +511,8 @@ struct ath10k_sta {
 	u32 peer_ps_state;
 };
 
-#define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5 * HZ)
+#define ATH10K_VDEV_SETUP_TIMEOUT_HZ	(5 * HZ)
+#define ATH10K_VDEV_DELETE_TIMEOUT_HZ	(5 * HZ)
 
 enum ath10k_beacon_state {
 	ATH10K_BEACON_SCHEDULED = 0,
@@ -1058,6 +1059,7 @@ struct ath10k {
 
 	int last_wmi_vdev_start_status;
 	struct completion vdev_setup_done;
+	struct completion vdev_delete_done;
 
 	struct workqueue_struct *workqueue;
 	/* Auxiliary workqueue */
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4dd64f3..02c17f4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1022,6 +1022,7 @@ static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 	arg.channel.max_antenna_gain = channel->max_antenna_gain * 2;
 
 	reinit_completion(&ar->vdev_setup_done);
+	reinit_completion(&ar->vdev_delete_done);
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
@@ -1071,6 +1072,7 @@ static int ath10k_monitor_vdev_stop(struct ath10k *ar)
 			    ar->monitor_vdev_id, ret);
 
 	reinit_completion(&ar->vdev_setup_done);
+	reinit_completion(&ar->vdev_delete_done);
 
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
@@ -1412,6 +1414,7 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	reinit_completion(&ar->vdev_setup_done);
+	reinit_completion(&ar->vdev_delete_done);
 
 	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
 	if (ret) {
@@ -1448,6 +1451,7 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif,
 	lockdep_assert_held(&ar->conf_mutex);
 
 	reinit_completion(&ar->vdev_setup_done);
+	reinit_completion(&ar->vdev_delete_done);
 
 	arg.vdev_id = arvif->vdev_id;
 	arg.dtim_period = arvif->dtim_period;
@@ -5397,6 +5401,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
 	struct ath10k_peer *peer;
+	unsigned long time_left;
 	int ret;
 	int i;
 
@@ -5438,6 +5443,15 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		ath10k_warn(ar, "failed to delete WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
+	if (test_bit(WMI_SERVICE_SYNC_DELETE_CMDS, ar->wmi.svc_map)) {
+		time_left = wait_for_completion_timeout(&ar->vdev_delete_done,
+							ATH10K_VDEV_DELETE_TIMEOUT_HZ);
+		if (time_left == 0) {
+			ath10k_warn(ar, "Timeout in receiving vdev delete response\n");
+			goto out:
+		}
+	}
+
 	/* Some firmware revisions don't notify host about self-peer removal
 	 * until after associated vdev is deleted.
 	 */
@@ -5488,6 +5502,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	ath10k_mac_txq_unref(ar, vif->txq);
 
+out:
 	mutex_unlock(&ar->conf_mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 90617e1..642d770 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -222,6 +222,13 @@ static int ath10k_wmi_tlv_event_bcn_tx_status(struct ath10k *ar,
 	return 0;
 }
 
+static void ath10k_wmi_tlv_event_vdev_delete_resp(struct ath10k *ar,
+						  struct sk_buff *skb)
+{
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_DELETE_RESP_EVENTID\n");
+	complete(&ar->vdev_delete_done);
+}
+
 static int ath10k_wmi_tlv_event_diag_data(struct ath10k *ar,
 					  struct sk_buff *skb)
 {
@@ -524,6 +531,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_VDEV_STOPPED_EVENTID:
 		ath10k_wmi_event_vdev_stopped(ar, skb);
 		break;
+	case WMI_TLV_VDEV_DELETE_RESP_EVENTID:
+		ath10k_wmi_tlv_event_vdev_delete_resp(ar, skb);
+		break;
 	case WMI_TLV_PEER_STA_KICKOUT_EVENTID:
 		ath10k_wmi_event_peer_sta_kickout(ar, skb);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 298d917..872da8e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -310,6 +310,8 @@ enum wmi_tlv_event_id {
 	WMI_TLV_VDEV_STOPPED_EVENTID,
 	WMI_TLV_VDEV_INSTALL_KEY_COMPLETE_EVENTID,
 	WMI_TLV_VDEV_MCC_BCN_INTERVAL_CHANGE_REQ_EVENTID,
+	WMI_TLV_VDEV_TSF_REPORT_EVENTID,
+	WMI_TLV_VDEV_DELETE_RESP_EVENTID,
 	WMI_TLV_PEER_STA_KICKOUT_EVENTID = WMI_TLV_EV(WMI_TLV_GRP_PEER),
 	WMI_TLV_PEER_INFO_EVENTID,
 	WMI_TLV_PEER_TX_FAIL_CNT_THR_EVENTID,
@@ -1557,6 +1559,8 @@ wmi_tlv_svc_map(const __le32 *in, unsigned long *out, size_t len)
 	       WMI_SERVICE_SAP_AUTH_OFFLOAD, len);
 	SVCMAP(WMI_TLV_SERVICE_MGMT_TX_WMI,
 	       WMI_SERVICE_MGMT_TX_WMI, len);
+	SVCMAP(WMI_TLV_SERVICE_SYNC_DELETE_CMDS,
+	       WMI_SERVICE_SYNC_DELETE_CMDS, len);
 }
 
 static inline void
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1f82f10..b941240 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -208,6 +208,7 @@ enum wmi_service {
 	WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
 	WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT,
 	WMI_SERVICE_THERM_THROT,
+	WMI_SERVICE_SYNC_DELETE_CMDS,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -483,6 +484,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
 	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
+	SVCSTR(WMI_SERVICE_SYNC_DELETE_CMDS);
 	default:
 		return NULL;
 	}
-- 
2.7.4

