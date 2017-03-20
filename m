Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:33081 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756006AbdCTXo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 19:44:59 -0400
Received: by mail-pg0-f51.google.com with SMTP id n190so84775219pga.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 16:44:58 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Andy Gross <andy.gross@linaro.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Brown <david.brown@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org
Subject: [PATCH 3/3] soc: qcom: smd-rpm: Add msm8996 compatibility
Date: Mon, 20 Mar 2017 16:35:44 -0700
Message-Id: <20170320233544.1656-3-bjorn.andersson@linaro.org> (sfid-20170321_004526_689651_0A1CD362)
In-Reply-To: <20170320233544.1656-1-bjorn.andersson@linaro.org>
References: <20170320233544.1656-1-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the RPM driver transitioned to RPMSG we can reuse the SMD-RPM
driver ontop of GLINK for 8996, without any modifications.

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
