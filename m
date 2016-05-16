Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbcEPTYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 15:24:11 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 4/6] wil6210: fix dma mapping error cleanup in __wil_tx_vring_tso
Date: Mon, 16 May 2016 22:23:33 +0300
Message-Id: <1463426615-15523-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160516_212436_511137_E42760B7)
In-Reply-To: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case we fail to map one of the TSO SKB fragments, we need to
clear all the mapped descriptors, from swhead to swhead+descs_used-1.

Change the desc index calculation to
i = (swhead + descs_used - 1) % vring->size;
to prevent unmpping of (swhead + descs_used) descriptor that wasn't
mapped.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 483e063..f2f6a40 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1594,7 +1594,7 @@ mem_error:
 	while (descs_used > 0) {
 		struct wil_ctx *ctx;
 
-		i = (swhead + descs_used) % vring->size;
+		i = (swhead + descs_used - 1) % vring->size;
 		d = (struct vring_tx_desc *)&vring->va[i].tx;
 		_desc = &vring->va[i].tx;
 		*d = *_desc;
-- 
1.8.5.2

