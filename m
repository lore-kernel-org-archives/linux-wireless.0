Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbeHOMSY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 08:18:24 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, briannorris@chromium.org,
        niklas.cassel@linaro.org, bjorn.andersson@linaro.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v5 4/6] firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
Date: Wed, 15 Aug 2018 14:56:35 +0530
Message-Id: <20180815092637.11455-5-govinds@codeaurora.org> (sfid-20180815_112703_740314_C2968EF7)
In-Reply-To: <20180815092637.11455-1-govinds@codeaurora.org>
References: <20180815092637.11455-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WLAN related VMID's to support wlan driver to set up
the remote's permissions call via TrustZone.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 include/linux/qcom_scm.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index b401b962afff..da63d84e1e91 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010-2015, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2010-2015, 2018, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -33,6 +33,8 @@ struct qcom_scm_vmperm {
 
 #define QCOM_SCM_VMID_HLOS       0x3
 #define QCOM_SCM_VMID_MSS_MSA    0xF
+#define QCOM_SCM_VMID_WLAN       0x18
+#define QCOM_SCM_VMID_WLAN_CE    0x19
 #define QCOM_SCM_PERM_READ       0x4
 #define QCOM_SCM_PERM_WRITE      0x2
 #define QCOM_SCM_PERM_EXEC       0x1
-- 
2.17.0
