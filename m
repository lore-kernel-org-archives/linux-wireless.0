Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:65451 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3JOHzs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 03:55:48 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/2] ath10k: return better errno for unsupported pdev params
Date: Tue, 15 Oct 2013 09:55:32 +0200
Message-ID: <1381823732-10128-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20131015_095552_389328_0FDC6070)
In-Reply-To: <1381823732-10128-1-git-send-email-bartosz.markowski@tieto.com>
References: <1381823732-10128-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return -EOPNOTSUPP if given parameter is not supported by firmware.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ea2669b..b28bd2d3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2119,7 +2119,7 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value)
 
 	if (id == WMI_PDEV_PARAM_UNSUPPORTED) {
 		ath10k_warn("pdev param %d not supported by firmware\n", id);
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
-- 
1.7.10

