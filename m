Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1HWIRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:17:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 2/7] ath6kl: Minor cleanup in min_hdr_len computation
Date: Tue, 23 Aug 2011 11:16:41 +0300
Message-ID: <1314087406-29188-3-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110823_101710_132532_72BC6665)
In-Reply-To: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index d546051..fb67c24 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1065,9 +1065,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		return;
 	}
 
-	min_hdr_len = sizeof(struct ethhdr);
-	min_hdr_len += sizeof(struct wmi_data_hdr) +
-		       sizeof(struct ath6kl_llc_snap_hdr);
+	min_hdr_len = sizeof(struct ethhdr) + sizeof(struct wmi_data_hdr) +
+		      sizeof(struct ath6kl_llc_snap_hdr);
 
 	dhdr = (struct wmi_data_hdr *) skb->data;
 
-- 
1.7.1

