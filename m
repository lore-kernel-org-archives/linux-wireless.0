Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EBFC433F5
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Feb 2022 08:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbiBYIqo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Feb 2022 03:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238601AbiBYIqm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Feb 2022 03:46:42 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CC3235319
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2022 00:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645778771; x=1677314771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vqWY9/rbKVCqvD3Eg6vHChDIW5QC7U0HRyQcATZeaPw=;
  b=fDD4ovFkcfAAuI6RZPLVPdCoGp/Geg7W0wscxtICwUQ34BO/4UjnQx75
   E455Rqa5Q8eUlv2ZGXN67VZ/ld9MtkXFyhoMFBpWXLwN+LNacdMbOUSOI
   yqoDNglSL7M0bdU8kKXG8vYJzVIWZ/NDnXRsT3aW2xVD3xij6VAVitmv6
   s=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 25 Feb 2022 00:46:10 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:46:10 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 25 Feb 2022 00:46:10 -0800
Received: from wgong-HP3-Z230-SFF-Workstation.qca.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 25 Feb 2022 00:46:08 -0800
From:   Wen Gong <quic_wgong@quicinc.com>
To:     <ath11k@lists.infradead.org>
CC:     <linux-wireless@vger.kernel.org>, <quic_wgong@quicinc.com>
Subject: [PATCH v7 3/4] ath11k: Add hw-restart option to simulate_fw_crash
Date:   Fri, 25 Feb 2022 03:45:47 -0500
Message-ID: <20220225084548.19534-4-quic_wgong@quicinc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225084548.19534-1-quic_wgong@quicinc.com>
References: <20220225084548.19534-1-quic_wgong@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add hw-restart to directly restart wlan. Like UTF mode start it will
restart hardware and download firmware again.

Usage:
1. Run command:
   echo hw-restart > /sys/kernel/debug/ath11k/qca6390\ hw2.0/simulate_fw_crash
   echo hw-restart > /sys/kernel/debug/ath11k/wcn6855\ hw2.0/simulate_fw_crash
2. wlan will be restart and do recovery process and success.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03003-QCAHSPSWPL_V1_V2_SILICONZ_LITE-2

Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index c0ebdb1262f0..7375defb0f23 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -557,6 +557,10 @@ static ssize_t ath11k_write_simulate_fw_crash(struct file *file,
 		ret = ath11k_wmi_force_fw_hang_cmd(ar,
 						   ATH11K_WMI_FW_HANG_ASSERT_TYPE,
 						   ATH11K_WMI_FW_HANG_DELAY);
+	} else if (!strcmp(buf, "hw-restart")) {
+		ath11k_info(ab, "user requested hw restart\n");
+		queue_work(ab->workqueue_aux, &ab->reset_work);
+		ret = 0;
 	} else {
 		ret = -EINVAL;
 		goto exit;
-- 
2.31.1

