Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34600 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754355AbcKISC4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 13:02:56 -0500
Received: by mail-pf0-f180.google.com with SMTP id n85so130379566pfi.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2016 10:02:56 -0800 (PST)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Andy Gross <andy.gross@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] soc: qcom: smem_state: Fix include for ERR_PTR()
Date: Wed,  9 Nov 2016 10:02:51 -0800
Message-Id: <1478714571-4841-2-git-send-email-bjorn.andersson@linaro.org> (sfid-20161109_190337_249442_0FB0E66F)
In-Reply-To: <1478714571-4841-1-git-send-email-bjorn.andersson@linaro.org>
References: <1478714571-4841-1-git-send-email-bjorn.andersson@linaro.org>
In-Reply-To: <201611092150.OxpAuHow%fengguang.wu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The correct include file for getting errno constants and ERR_PTR() is
linux/err.h, rather than linux/errno.h, so fix the include.

Fixes: e8b123e60084 ("soc: qcom: smem_state: Add stubs for disabled smem_state")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Andy, I don't see anything else going into v4.10 for smem_state.h. So if you
are okay I would like Kalle to pick this patch through his tree and be able to
merge my wcn36xx patches for v4.10.

 include/linux/soc/qcom/smem_state.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/soc/qcom/smem_state.h b/include/linux/soc/qcom/smem_state.h
index 7b88697929e9..b8478ee7a71f 100644
--- a/include/linux/soc/qcom/smem_state.h
+++ b/include/linux/soc/qcom/smem_state.h
@@ -1,7 +1,7 @@
 #ifndef __QCOM_SMEM_STATE__
 #define __QCOM_SMEM_STATE__
 
-#include <linux/errno.h>
+#include <linux/err.h>
 
 struct device_node;
 struct qcom_smem_state;
-- 
2.5.0
