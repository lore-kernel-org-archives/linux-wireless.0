Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F3BC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4BDA20700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfBVOVj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:39 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:54040 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727086AbfBVOVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:37 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017384"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:32 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285590"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:32 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 17/21] wil6210: fix return code of wmi_mgmt_tx and wmi_mgmt_tx_ext
Date:   Fri, 22 Feb 2019 16:21:15 +0200
Message-Id: <1550845279-16103-18-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior David <liord@codeaurora.org>

The functions that send management TX frame have 3 possible
results: success and other side acknowledged receive (ACK=1),
success and other side did not acknowledge receive(ACK=0) and
failure to send the frame. The current implementation
incorrectly reports the ACK=0 case as failure.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  5 +++++
 drivers/net/wireless/ath/wil6210/wmi.c      | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index e8d65dd..218296e 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1274,7 +1274,12 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     params->wait);
 
 out:
+	/* when the sent packet was not acked by receiver(ACK=0), rc will
+	 * be -EAGAIN. In this case this function needs to return success,
+	 * the ACK=0 will be reflected in tx_status.
+	 */
 	tx_status = (rc == 0);
+	rc = (rc == -EAGAIN) ? 0 : rc;
 	cfg80211_mgmt_tx_status(wdev, cookie ? *cookie : 0, buf, len,
 				tx_status, GFP_KERNEL);
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c5bcb8d..d89cd41 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -3511,8 +3511,9 @@ int wmi_mgmt_tx(struct wil6210_vif *vif, const u8 *buf, size_t len)
 	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, vif->mid, cmd, total,
 		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
 	if (!rc && evt.evt.status != WMI_FW_STATUS_SUCCESS) {
-		wil_err(wil, "mgmt_tx failed with status %d\n", evt.evt.status);
-		rc = -EINVAL;
+		wil_dbg_wmi(wil, "mgmt_tx failed with status %d\n",
+			    evt.evt.status);
+		rc = -EAGAIN;
 	}
 
 	kfree(cmd);
@@ -3564,9 +3565,9 @@ int wmi_mgmt_tx_ext(struct wil6210_vif *vif, const u8 *buf, size_t len,
 	rc = wmi_call(wil, WMI_SW_TX_REQ_EXT_CMDID, vif->mid, cmd, total,
 		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
 	if (!rc && evt.evt.status != WMI_FW_STATUS_SUCCESS) {
-		wil_err(wil, "mgmt_tx_ext failed with status %d\n",
-			evt.evt.status);
-		rc = -EINVAL;
+		wil_dbg_wmi(wil, "mgmt_tx_ext failed with status %d\n",
+			    evt.evt.status);
+		rc = -EAGAIN;
 	}
 
 	kfree(cmd);
-- 
1.9.1

