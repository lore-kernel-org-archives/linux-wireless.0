Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36364 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753429AbdC1F0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 01:26:45 -0400
Received: by mail-pg0-f50.google.com with SMTP id g2so61245720pge.3
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 22:26:44 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Andy Gross <andy.gross@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Brown <david.brown@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org
Subject: [PATCH v2 3/3] soc: qcom: smd-rpm: Add msm8996 compatibility
Date: Mon, 27 Mar 2017 22:26:35 -0700
Message-Id: <20170328052635.26670-3-bjorn.andersson@linaro.org> (sfid-20170328_072903_202060_9EF508CB)
In-Reply-To: <20170328052635.26670-1-bjorn.andersson@linaro.org>
References: <20170328052635.26670-1-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the RPM driver transitioned to RPMSG we can reuse the SMD-RPM
driver ontop of GLINK for 8996, without any modifications.

Acked-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/soc/qcom/smd-rpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/smd-rpm.c b/drivers/soc/qcom/smd-rpm.c
index 0dcf1bf33126..c2346752b3ea 100644
--- a/drivers/soc/qcom/smd-rpm.c
+++ b/drivers/soc/qcom/smd-rpm.c
@@ -225,6 +225,7 @@ static const struct of_device_id qcom_smd_rpm_of_match[] = {
 	{ .compatible = "qcom,rpm-apq8084" },
 	{ .compatible = "qcom,rpm-msm8916" },
 	{ .compatible = "qcom,rpm-msm8974" },
+	{ .compatible = "qcom,rpm-msm8996" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qcom_smd_rpm_of_match);
-- 
2.12.0
