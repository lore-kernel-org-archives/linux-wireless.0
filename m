Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA23C43331
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C814C2067B
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573612041;
	bh=/n033tAcWZldeMXOsgVbpUniNKRtBHljCjRdA4VUUMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zxW3rr5wluTiiqrbA8FOe6N1cRsCrCs8u1GgzykbpnGaNWP3dETJxK4pJYw1+qNWy
	 vFtOrq/FuZrgwe922WBYi3B4XPspBdo6X933zAXeEvnpv4cY/FAwcIYDVNdYPuKd78
	 aLMkwcqE1GyhoJwvFu0PfnUdCNvdkJUdhKtmas9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfKMBvC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727588AbfKMBu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 771CB222CE;
        Wed, 13 Nov 2019 01:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609857;
        bh=/n033tAcWZldeMXOsgVbpUniNKRtBHljCjRdA4VUUMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPfb/Pk1qi9BCsQPj0vgquF6OTQk7L/lD16SXZN+jwtl+yh0L+o2tyzWreSDVJi5S
         ToPzXwcCzhjI56GjT7B5jKS8QYc/e+7igfe6YwMEgwiLSVzgIi56lq9jXuV2CgbvtT
         eYtXFEIiTu3M+hiMJDnRaYi9qEcVq/eQb6y4WNt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 025/209] ath10k: fix vdev-start timeout on error
Date:   Tue, 12 Nov 2019 20:47:21 -0500
Message-Id: <20191113015025.9685-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 833fd34d743c728afe6d127ef7bee67e7d9199a8 ]

The vdev-start-response message should cause the
completion to fire, even in the error case.  Otherwise,
the user still gets no useful information and everything
is blocked until the timeout period.

Add some warning text to print out the invalid status
code to aid debugging, and propagate failure code.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c  | 19 ++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h  |  8 +++++++-
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9feea02e7d373..5c9fc4070fd24 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1003,6 +1003,7 @@ struct ath10k {
 
 	struct completion install_key_done;
 
+	int last_wmi_vdev_start_status;
 	struct completion vdev_setup_done;
 
 	struct workqueue_struct *workqueue;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1419f9d1505fe..e95bb397e1c96 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -967,7 +967,7 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 	if (time_left == 0)
 		return -ETIMEDOUT;
 
-	return 0;
+	return ar->last_wmi_vdev_start_status;
 }
 
 static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9f31b9a108507..bf74aff9510be 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3247,18 +3247,31 @@ void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_vdev_start_ev_arg arg = {};
 	int ret;
+	u32 status;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_START_RESP_EVENTID\n");
 
+	ar->last_wmi_vdev_start_status = 0;
+
 	ret = ath10k_wmi_pull_vdev_start(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse vdev start event: %d\n", ret);
-		return;
+		ar->last_wmi_vdev_start_status = ret;
+		goto out;
 	}
 
-	if (WARN_ON(__le32_to_cpu(arg.status)))
-		return;
+	status = __le32_to_cpu(arg.status);
+	if (WARN_ON_ONCE(status)) {
+		ath10k_warn(ar, "vdev-start-response reports status error: %d (%s)\n",
+			    status, (status == WMI_VDEV_START_CHAN_INVALID) ?
+			    "chan-invalid" : "unknown");
+		/* Setup is done one way or another though, so we should still
+		 * do the completion, so don't return here.
+		 */
+		ar->last_wmi_vdev_start_status = -EINVAL;
+	}
 
+out:
 	complete(&ar->vdev_setup_done);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 36220258e3c7e..e341cfb3fcc26 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6642,11 +6642,17 @@ struct wmi_ch_info_ev_arg {
 	__le32 rx_frame_count;
 };
 
+/* From 10.4 firmware, not sure all have the same values. */
+enum wmi_vdev_start_status {
+	WMI_VDEV_START_OK = 0,
+	WMI_VDEV_START_CHAN_INVALID,
+};
+
 struct wmi_vdev_start_ev_arg {
 	__le32 vdev_id;
 	__le32 req_id;
 	__le32 resp_type; /* %WMI_VDEV_RESP_ */
-	__le32 status;
+	__le32 status; /* See wmi_vdev_start_status enum above */
 };
 
 struct wmi_peer_kick_ev_arg {
-- 
2.20.1

