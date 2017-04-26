Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36817 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937220AbdDZWEu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 18:04:50 -0400
Received: by mail-pf0-f172.google.com with SMTP id 194so6942075pfv.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 15:04:50 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>
Subject: [PATCH 2/2] arm64: dts: apq8016-sbc: Correct WLAN LED default-trigger
Date: Wed, 26 Apr 2017 15:04:44 -0700
Message-Id: <20170426220444.10539-2-bjorn.andersson@linaro.org> (sfid-20170427_000625_146565_A2B39868)
In-Reply-To: <20170426220444.10539-1-bjorn.andersson@linaro.org>
References: <20170426220444.10539-1-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX status trigger of the wlan interface is named phy0tx, so this
updates the default-trigger for the WLAN LED to use that instead.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Note that without patch 1/2 this trigger does not fire - but there's also no
harm in picking the two patches through separate trees.

 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
index 5d83b02b7c4a..21a8f5ce8955 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
@@ -178,7 +178,7 @@
 			led@5 {
 				label = "apq8016-sbc:yellow:wlan";
 				gpios = <&pm8916_mpps 2 GPIO_ACTIVE_HIGH>;
-				linux,default-trigger = "wlan";
+				linux,default-trigger = "phy0tx";
 				default-state = "off";
 			};
 
-- 
2.12.0
