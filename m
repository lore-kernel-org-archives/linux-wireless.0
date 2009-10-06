Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42493 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188AbZJFVQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 17:16:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/4] iwmc3200wifi: support ETHTOOL_GPERMADDR
Date: Tue,  6 Oct 2009 17:07:17 -0400
Message-Id: <1254863240-14780-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwmc3200wifi/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index d668e47..170f337 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -637,6 +637,8 @@ static int __iwm_up(struct iwm_priv *iwm)
 		IWM_ERR(iwm, "MAC reading failed\n");
 		goto err_disable;
 	}
+	memcpy(iwm_to_ndev(iwm)->perm_addr, iwm_to_ndev(iwm)->dev_addr,
+		ETH_ALEN);
 
 	/* We can load the FWs */
 	ret = iwm_load_fw(iwm);
-- 
1.6.2.5

