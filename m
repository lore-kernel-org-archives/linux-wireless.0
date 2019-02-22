Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92D2C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 947A820700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfBVOVd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:33 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:46067 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726926AbfBVOVc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:32 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017377"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:28 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285583"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:28 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 10/21] wil6210: increase PCP stop command timeout
Date:   Fri, 22 Feb 2019 16:21:08 +0200
Message-Id: <1550845279-16103-11-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case there are connected stations, FW needs to disconnect
them before handling PCP stop. This flow can take several
seconds.
Increasing PCP stop timeout to 5 seconds to allow that.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c737a79e..19247c5 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -41,6 +41,7 @@
 
 #define WIL_WAIT_FOR_SUSPEND_RESUME_COMP 200
 #define WIL_WMI_CALL_GENERAL_TO_MS 100
+#define WIL_WMI_PCP_STOP_TO_MS 5000
 
 /**
  * WMI event receiving - theory of operations
@@ -2195,7 +2196,8 @@ int wmi_pcp_stop(struct wil6210_vif *vif)
 		return rc;
 
 	return wmi_call(wil, WMI_PCP_STOP_CMDID, vif->mid, NULL, 0,
-			WMI_PCP_STOPPED_EVENTID, NULL, 0, 20);
+			WMI_PCP_STOPPED_EVENTID, NULL, 0,
+			WIL_WMI_PCP_STOP_TO_MS);
 }
 
 int wmi_set_ssid(struct wil6210_vif *vif, u8 ssid_len, const void *ssid)
-- 
1.9.1

