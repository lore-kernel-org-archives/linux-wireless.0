Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755154AbeBOIsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:48:23 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 04/13] ath10k: Add HTC services for WCN3990
Date: Thu, 15 Feb 2018 14:18:17 +0530
Message-Id: <1518684497-5495-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_094826_680284_CBC8C057)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 target uses 3 Copy engine(CE1/CE9/CE10) in RX path
and CE 11 for pktlog.
Add data path HTC ep services and PKTLOG services for WCN3990.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htc.c | 6 ++++++
 drivers/net/wireless/ath/ath10k/htc.h | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 492dc5b..8902720 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -542,8 +542,14 @@ static const char *htc_service_name(enum ath10k_htc_svc_id id)
 		return "NMI Data";
 	case ATH10K_HTC_SVC_ID_HTT_DATA_MSG:
 		return "HTT Data";
+	case ATH10K_HTC_SVC_ID_HTT_DATA2_MSG:
+		return "HTT Data";
+	case ATH10K_HTC_SVC_ID_HTT_DATA3_MSG:
+		return "HTT Data";
 	case ATH10K_HTC_SVC_ID_TEST_RAW_STREAMS:
 		return "RAW";
+	case ATH10K_HTC_SVC_ID_HTT_LOG_MSG:
+		return "PKTLOG";
 	}
 
 	return "Unknown";
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index a2f8814..3487759 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -248,6 +248,7 @@ enum ath10k_htc_svc_gid {
 	ATH10K_HTC_SVC_GRP_WMI = 1,
 	ATH10K_HTC_SVC_GRP_NMI = 2,
 	ATH10K_HTC_SVC_GRP_HTT = 3,
+	ATH10K_LOG_SERVICE_GROUP = 6,
 
 	ATH10K_HTC_SVC_GRP_TEST = 254,
 	ATH10K_HTC_SVC_GRP_LAST = 255,
@@ -273,6 +274,9 @@ enum ath10k_htc_svc_id {
 
 	ATH10K_HTC_SVC_ID_HTT_DATA_MSG	= SVC(ATH10K_HTC_SVC_GRP_HTT, 0),
 
+	ATH10K_HTC_SVC_ID_HTT_DATA2_MSG = SVC(ATH10K_HTC_SVC_GRP_HTT, 1),
+	ATH10K_HTC_SVC_ID_HTT_DATA3_MSG = SVC(ATH10K_HTC_SVC_GRP_HTT, 2),
+	ATH10K_HTC_SVC_ID_HTT_LOG_MSG = SVC(ATH10K_LOG_SERVICE_GROUP, 0),
 	/* raw stream service (i.e. flash, tcmd, calibration apps) */
 	ATH10K_HTC_SVC_ID_TEST_RAW_STREAMS = SVC(ATH10K_HTC_SVC_GRP_TEST, 0),
 };
-- 
1.9.1
