Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55983 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab1JNM6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 08:58:12 -0400
Received: by ggnb1 with SMTP id b1so348532ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 05:58:11 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 3/5] ath6kl: Add SDIO polling method into menu
Date: Fri, 14 Oct 2011 13:50:44 +0100
Message-Id: <1318596646-19495-4-git-send-email-sangwook.lee@linaro.org> (sfid-20111014_145815_280149_33037A6B)
In-Reply-To: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
References: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the initial developement stage, sometimes we need SDIO polling
method due to SDIO Interrupt problems. This patch adds selection
option into kernel menu

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/net/wireless/ath/ath6kl/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index 3d5f8be..7e530b8 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -13,3 +13,11 @@ config ATH6KL_DEBUG
 	depends on ATH6KL
 	---help---
 	  Enables debug support
+
+config ATH6KL_SDIO_POLL
+        bool "Atheros ath6kl debugging with SDIO polling"
+        depends on ATH6KL
+        ---help---
+          Enables SDIO polling for debugging when SDIO's probem
+          happens. This is tested only with HW2.0. By default
+          polling time interval is 10ms
-- 
1.7.4.1

