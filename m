Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34058C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 04:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0454B2075E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 04:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KivkmIPN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mMhaO1oM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfCTEsr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 00:48:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbfCTEsr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 00:48:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9E56C60DAA; Wed, 20 Mar 2019 04:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553057325;
        bh=2+jlSqLlcsXjClkkQ2hBOeEWGtgRqr6zNzE4sr2bLKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KivkmIPN0eKnXN22lfABwfoTWTVGzuwd/VjhHUceZQAHAEj+PqpZuXs/YRC5uC/FN
         wqnnYURs2O4INN0pXRTSJ0rWpIfg7Rd1GnsON7oawEi0vB+Bvo7/vrFs+WkA8fM6uo
         FdrexCA+j5QB/3dY2tOEgbMqHAOsPBiMOJzSC1CA=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E6C360E3E;
        Wed, 20 Mar 2019 04:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553057324;
        bh=2+jlSqLlcsXjClkkQ2hBOeEWGtgRqr6zNzE4sr2bLKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMhaO1oMVT62uzQ4o5vDkF/8rAYCvWlg7m1wxNgqNjyJ00sN1EkR2bVMELPSPa93D
         iflld6iylZMcv7znBfPGC2oIFsO6GdPAs/+TRRI8Ww0ycCavrCaTANzEyWcKU3FiJW
         1MoqpCP68llUYxQBYNRU/mj9tjsTApRl5LzMiGVI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E6C360E3E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 2/2] ath10k: Add xo calibration support for wifi rf clock
Date:   Wed, 20 Mar 2019 10:15:11 +0530
Message-Id: <20190320044511.12172-3-govinds@codeaurora.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320044511.12172-1-govinds@codeaurora.org>
References: <20190320044511.12172-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PMIC XO is the clock source for wifi rf clock in integrated wifi
chipset ex: WCN3990. Due to board layout errors XO frequency drifts
can cause wifi rf clock inaccuracy.
XO calibration test tree in Factory Test Mode is used to find the
best frequency offset(for example +/-2KHz )by programming XO trim
register. This ensure system clock stays within required 20 ppm
WLAN rf clock.

Retrieve the xo trim offset via system firmware (e.g., device tree),
especially in the case where the device doesn't have a useful EEPROM
on which to store the calibrated XO offset (e.g., for integrated Wifi).
Calibrated XO offset is sent to fw, which compensate the clock drift
by programing the XO trim register.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c  | 12 ++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.c | 11 +++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 37b3bd629f48..99c140a6628d 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -302,10 +302,16 @@ static int ath10k_qmi_send_cal_report_req(struct ath10k_qmi *qmi)
 	struct wlfw_cal_report_resp_msg_v01 resp = {};
 	struct wlfw_cal_report_req_msg_v01 req = {};
 	struct ath10k *ar = qmi->ar;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	struct qmi_txn txn;
 	int i, j = 0;
 	int ret;
 
+	if (ar_snoc->xo_cal_supported) {
+		req.xo_cal_data_valid = 1;
+		req.xo_cal_data = ar_snoc->xo_cal_data;
+	}
+
 	ret = qmi_txn_init(&qmi->qmi_hdl, &txn, wlfw_cal_report_resp_msg_v01_ei,
 			   &resp);
 	if (ret < 0)
@@ -636,6 +642,7 @@ ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
 	struct wlfw_ind_register_resp_msg_v01 resp = {};
 	struct wlfw_ind_register_req_msg_v01 req = {};
 	struct ath10k *ar = qmi->ar;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	struct qmi_txn txn;
 	int ret;
 
@@ -646,6 +653,11 @@ ath10k_qmi_ind_register_send_sync_msg(struct ath10k_qmi *qmi)
 	req.msa_ready_enable_valid = 1;
 	req.msa_ready_enable = 1;
 
+	if (ar_snoc->xo_cal_supported) {
+		req.xo_cal_enable_valid = 1;
+		req.xo_cal_enable = 1;
+	}
+
 	ret = qmi_txn_init(&qmi->qmi_hdl, &txn,
 			   wlfw_ind_register_resp_msg_v01_ei, &resp);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 54efe6be8f1d..7cfd17beb7b0 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -20,6 +20,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 
 #include "ce.h"
@@ -1189,6 +1190,16 @@ static int ath10k_snoc_resource_init(struct ath10k *ar)
 		ar_snoc->ce_irqs[i].irq_line = res->start;
 	}
 
+	ret = device_property_read_u32(&pdev->dev, "xo-cal-data",
+				       &ar_snoc->xo_cal_data);
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc xo-cal-data return %d\n", ret);
+	if (ret == 0) {
+		ar_snoc->xo_cal_supported = true;
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "xo cal data %x\n",
+			   ar_snoc->xo_cal_data);
+	}
+	ret = 0;
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 2b2f23cf7c5d..25383de8f17d 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -91,6 +91,8 @@ struct ath10k_snoc {
 	struct ath10k_clk_info *clk;
 	struct ath10k_qmi *qmi;
 	unsigned long int flags;
+	bool xo_cal_supported;
+	u32 xo_cal_data;
 };
 
 static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

