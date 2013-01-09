Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:58795
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755584Ab3AIKit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 05:38:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] ath9k_htc: Fix memory leak
Date: Wed,  9 Jan 2013 16:07:48 +0530
Message-Id: <1357727868-3892-1-git-send-email-sujith@msujith.org> (sfid-20130109_113853_169987_B8967E28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

SKBs that are allocated in the HTC layer do not have callbacks
registered and hence ended up not being freed, Fix this by freeing
them properly in the TX completion routine.

Cc: <stable@vger.kernel.org>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 4a9570d..aac4a40 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -344,6 +344,8 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 			endpoint->ep_callbacks.tx(endpoint->ep_callbacks.priv,
 						  skb, htc_hdr->endpoint_id,
 						  txok);
+		} else {
+			kfree_skb(skb);
 		}
 	}
 
-- 
1.8.1

