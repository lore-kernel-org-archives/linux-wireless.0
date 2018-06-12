Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:43549 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932555AbeFLLji (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 07:39:38 -0400
Received: by mail-lf0-f67.google.com with SMTP id n15-v6so35473933lfn.10
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2018 04:39:38 -0700 (PDT)
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
Date: Tue, 12 Jun 2018 13:39:06 +0200
Message-Id: <20180612113907.15043-2-niklas.cassel@linaro.org> (sfid-20180612_134013_305115_8A1B3361)
In-Reply-To: <20180612113907.15043-1-niklas.cassel@linaro.org>
References: <20180612113907.15043-1-niklas.cassel@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ATH10K_SNOC builds just fine with COMPILE_TEST, so make that possible.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 54ff5930126c..6572a43590a8 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -42,7 +42,8 @@ config ATH10K_USB
 
 config ATH10K_SNOC
 	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
-	depends on ATH10K && ARCH_QCOM
+	depends on ATH10K
+	depends on ARCH_QCOM || COMPILE_TEST
 	---help---
 	  This module adds support for integrated WCN3990 chip connected
 	  to system NOC(SNOC). Currently work in progress and will not
-- 
2.17.1
