Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33872 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753794AbdL1THr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 14:07:47 -0500
Received: by mail-lf0-f67.google.com with SMTP id y78so40500130lfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 11:07:46 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 3/3] ath10k: bugfix: add USB case in ath10k_core_probe_fw
Date: Thu, 28 Dec 2017 20:06:45 +0100
Message-Id: <20171228190645.25773-4-erik.stromdahl@gmail.com> (sfid-20171228_200754_995417_C3BD35A8)
In-Reply-To: <20171228190645.25773-1-erik.stromdahl@gmail.com>
References: <20171228190645.25773-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 51444d34a06c..fe9341c97f31 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2427,6 +2427,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		break;
 	case ATH10K_BUS_PCI:
 	case ATH10K_BUS_AHB:
+	case ATH10K_BUS_USB:
 		memset(&target_info, 0, sizeof(target_info));
 		ret = ath10k_bmi_get_target_info(ar, &target_info);
 		if (ret) {
-- 
2.15.1
