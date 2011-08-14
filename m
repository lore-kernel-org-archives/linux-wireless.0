Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48060 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1HNLic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 07:38:32 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath6kl: Minor cleanup in min_hdr_len computation
Date: Sun, 14 Aug 2011 17:08:34 +0530
Message-ID: <1313321916-29685-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110814_133835_397978_C8A3AD6F)
In-Reply-To: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
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
1.7.0.4

