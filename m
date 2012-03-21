Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64977 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab2CUJVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 05:21:44 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V3] ath6kl: Dump htc header when invalid Rx frame length is detected
Date: Wed, 21 Mar 2012 14:52:16 +0530
Message-ID: <1332321736-26881-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120321_102148_125941_73E6FD26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dump htc header along with the warning message when the request
to Rx with invalid frame length is detected.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V2 - Leave a space before htc_hdr
V3 - Don't split the debug message

 drivers/net/wireless/ath/ath6kl/htc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 4849d99..4dc3228 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1353,7 +1353,9 @@ static int ath6kl_htc_rx_setup(struct htc_target *target,
 					sizeof(*htc_hdr));
 
 	if (!htc_valid_rx_frame_len(target, ep->eid, full_len)) {
-		ath6kl_warn("Rx buffer requested with invalid length\n");
+		ath6kl_warn("Rx buffer requested with invalid length htc_hdr:eid %d, flags 0x%x, len %d\n",
+			     htc_hdr->eid, htc_hdr->flags,
+			     le16_to_cpu(htc_hdr->payld_len));
 		return -EINVAL;
 	}
 
-- 
1.7.0.4

