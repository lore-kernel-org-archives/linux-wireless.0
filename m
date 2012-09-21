Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48595 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2IUOne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 10:43:34 -0400
From: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Check for valid endpoint ID
Date: Fri, 21 Sep 2012 20:13:09 +0530
Message-ID: <1348238589-9747-1-git-send-email-c_ppitch@qca.qualcomm.com> (sfid-20120921_164336_810002_EF06C8B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Endpoint ID is checked to make sure it is valid.

Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index e867193..7ef159d 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -699,6 +699,10 @@ void ath6kl_tx_complete(struct htc_target *target,
 					  list);
 		list_del(&packet->list);
 
+		if (WARN_ON_ONCE(packet->endpoint == ENDPOINT_UNUSED ||
+				 packet->endpoint >= ENDPOINT_MAX))
+			continue;
+
 		ath6kl_cookie = (struct ath6kl_cookie *)packet->pkt_cntxt;
 		if (WARN_ON_ONCE(!ath6kl_cookie))
 			continue;
-- 
1.7.9.5

