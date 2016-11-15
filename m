Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34476 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966209AbcKOGOx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 01:14:53 -0500
Received: by mail-pg0-f51.google.com with SMTP id x23so60234531pgx.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 22:14:52 -0800 (PST)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Andy Gross <andy.gross@linaro.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v5 1/5] soc: qcom: smem_state: Fix include for ERR_PTR()
Date: Mon, 14 Nov 2016 22:06:50 -0800
Message-Id: <1479190014-11297-1-git-send-email-bjorn.andersson@linaro.org> (sfid-20161115_071501_253762_2D7611EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The correct include file for getting errno constants and ERR_PTR() is
linux/err.h, rather than linux/errno.h, so fix the include.

Fixes: e8b123e60084 ("soc: qcom: smem_state: Add stubs for disabled smem_state")
Acked-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Kalle, please merge this patch through your tree.

Changes since v4:
- New patch

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
