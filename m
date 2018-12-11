Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC464C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 05:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FC3E2054F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 05:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F7+y3BX9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AihYVaXZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FC3E2054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbeLKFjD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 00:39:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbeLKFjD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 00:39:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2DEDE60D88; Tue, 11 Dec 2018 05:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544506742;
        bh=g7y8paYr8Pg/CF9n0MQzM1EBqOKix3Hacl/3QulmF4w=;
        h=From:To:Cc:Subject:Date:From;
        b=F7+y3BX9BD7EwPcIxBT+ZpXRpenrWk4OfKNXeLEXsOU3A5S6Lz9+nxZAL7ScJ4s2G
         lyr2DNqoau8ZLXQRoGQ+Uo+lzmCLFTh12Yc1NbVJkdGBrCdCvwnUfbLHBVKSoqcCNh
         aDQMf0c+XMxyCYVqoI7mqgmd6G+K7Sfw2t9KCqYc=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0DE561421;
        Tue, 11 Dec 2018 05:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544506741;
        bh=g7y8paYr8Pg/CF9n0MQzM1EBqOKix3Hacl/3QulmF4w=;
        h=From:To:Cc:Subject:Date:From;
        b=AihYVaXZKbGh64w4be0rSPT+xaYoMby6DknWXtMA0GBemaSH+O7PyxRks9L7hGBUE
         HbgR4nT1+0L2Kwgkf7w6984yqvAF820bVUedB+EI80oVvrukhR1sqQnUh1iLMn5/NM
         LYrJ9khqhIvctRIUWW8zvgKhbeYmDnb58EJ4aUL4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0DE561421
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Skip sending quiet mode cmd for WCN3990
Date:   Tue, 11 Dec 2018 11:08:53 +0530
Message-Id: <20181211053853.3557-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

HL2.0 firmware does not support setting quiet mode.
If the host driver sends the quiet mode setting
command to the HL2.0 firmware, it crashes with the
below signature.

fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN RT:207a:PC=b001b4f0

The quiet mode command support is exposed by the firmware
via thermal throttle wmi service. Enable ath10k thermal
support if thermal throttle wmi service bit is set.
10X firmware version supports this feature by default, hence
set this service bit by default.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Co-developed-by: Govind Singh <govinds@codeaurora.org>
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c    | 19 +++++++++++++------
 drivers/net/wireless/ath/ath10k/debug.c   |  5 +++--
 drivers/net/wireless/ath/ath10k/mac.c     |  3 ++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  3 +++
 drivers/net/wireless/ath/ath10k/wmi.h     |  1 +
 5 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 22cbe9a2e646..2bdb632b7b1a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2621,6 +2621,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		goto err_hif_stop;
 	}
 
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X,
+		     ar->normal_mode_fw.fw_file.fw_features)) {
+		set_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map);
+	}
 	/* Some firmware revisions do not properly set up hardware rx filter
 	 * registers.
 	 *
@@ -2919,11 +2923,13 @@ static void ath10k_core_register_work(struct work_struct *work)
 		goto err_debug_destroy;
 	}
 
-	status = ath10k_thermal_register(ar);
-	if (status) {
-		ath10k_err(ar, "could not register thermal device: %d\n",
-			   status);
-		goto err_spectral_destroy;
+	if (test_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map)) {
+		status = ath10k_thermal_register(ar);
+		if (status) {
+			ath10k_err(ar, "could not register thermal device: %d\n",
+				   status);
+			goto err_spectral_destroy;
+		}
 	}
 
 	set_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags);
@@ -2964,7 +2970,8 @@ void ath10k_core_unregister(struct ath10k *ar)
 	if (!test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags))
 		return;
 
-	ath10k_thermal_unregister(ar);
+	if (test_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map))
+		ath10k_thermal_unregister(ar);
 	/* Stop spectral before unregistering from mac80211 to remove the
 	 * relayfs debugfs file cleanly. Otherwise the parent debugfs tree
 	 * would be already be free'd recursively, leading to a double free.
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 15964b374f68..02988fc378a1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2578,8 +2578,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("pktlog_filter", 0644, ar->debug.debugfs_phy, ar,
 			    &fops_pktlog_filter);
 
-	debugfs_create_file("quiet_period", 0644, ar->debug.debugfs_phy, ar,
-			    &fops_quiet_period);
+	if (test_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map))
+		debugfs_create_file("quiet_period", 0644, ar->debug.debugfs_phy, ar,
+				    &fops_quiet_period);
 
 	debugfs_create_file("tpc_stats", 0400, ar->debug.debugfs_phy, ar,
 			    &fops_tpc_stats);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c5130fa264eb..b8a5ec40b949 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4800,7 +4800,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ath10k_regd_update(ar);
 
 	ath10k_spectral_start(ar);
-	ath10k_thermal_set_throttling(ar);
+	if (test_bit(WMI_SERVICE_THERM_THROT, ar->wmi.svc_map))
+		ath10k_thermal_set_throttling(ar);
 
 	ar->radar_conf_state = ATH10K_RADAR_CONFIRMATION_IDLE;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index bf8a4320c39c..e07e9907e355 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1564,6 +1564,9 @@ wmi_tlv_svc_map_ext(const __le32 *in, unsigned long *out, size_t len)
 	SVCMAP(WMI_TLV_SERVICE_SPOOF_MAC_SUPPORT,
 	       WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	       WMI_TLV_MAX_SERVICE);
+	SVCMAP(WMI_TLV_SERVICE_THERM_THROT,
+	       WMI_SERVICE_THERM_THROT,
+	       WMI_TLV_MAX_SERVICE);
 }
 
 #undef SVCMAP
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 58e33ab9e0e9..66222eeaba4c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -205,6 +205,7 @@ enum wmi_service {
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	WMI_SERVICE_TX_DATA_ACK_RSSI,
 	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	WMI_SERVICE_THERM_THROT,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

