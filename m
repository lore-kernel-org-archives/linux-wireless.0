Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33080 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933754AbcIFWSg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 18:18:36 -0400
Received: by mail-pf0-f175.google.com with SMTP id g202so55557969pfb.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2016 15:18:35 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Andy Gross <andy.gross@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v4 1/4] soc: qcom: wcnss_ctrl: Stub wcnss_ctrl API
Date: Tue,  6 Sep 2016 15:18:29 -0700
Message-Id: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org> (sfid-20160907_002001_701461_FDE1AA47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stub the wcnss_ctrl API to allow compile testing wcnss function drivers.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

There are no other pending changes colliding with this, so if Andy is okay with
this it could be merged through Kalle's tree - together with the other patches.

Marcel, with this applied we can drop the depends on QCOM_SMD from the
btqcomsmd driver as well.

Changes since v3:
- Added this patch to allow compile testing without SMD support after patch 2

 include/linux/soc/qcom/wcnss_ctrl.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/soc/qcom/wcnss_ctrl.h b/include/linux/soc/qcom/wcnss_ctrl.h
index a37bc5538f19..eab64976a73b 100644
--- a/include/linux/soc/qcom/wcnss_ctrl.h
+++ b/include/linux/soc/qcom/wcnss_ctrl.h
@@ -3,6 +3,19 @@
 
 #include <linux/soc/qcom/smd.h>
 
+#if IS_ENABLED(CONFIG_QCOM_WCNSS_CTRL)
+
 struct qcom_smd_channel *qcom_wcnss_open_channel(void *wcnss, const char *name, qcom_smd_cb_t cb);
 
+#else
+
+static inline struct qcom_smd_channel*
+qcom_wcnss_open_channel(void *wcnss, const char *name, qcom_smd_cb_t cb)
+{
+	WARN_ON(1);
+	return ERR_PTR(-ENXIO);
+}
+
+#endif
+
 #endif
-- 
2.5.0
