Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44931 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab2COHpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 03:45:47 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath6kl_sdio: Initialize sg_sz to fix a compilation warning
Date: Thu, 15 Mar 2012 13:15:41 +0530
Message-ID: <1331797541-2888-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120315_084550_434857_3113EFEE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix uninitialized variable warning on compilation.

sdio.c:333: warning: 'sg_sz' may be used uninitialized in this function

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5a03082..fe6c9d8 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -335,7 +335,7 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 {
 	struct hif_scatter_req *s_req;
 	struct bus_request *bus_req;
-	int i, scat_req_sz, scat_list_sz, sg_sz, buf_sz;
+	int i, scat_req_sz, scat_list_sz, sg_sz = 0, buf_sz;
 	u8 *virt_buf;
 
 	scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);
-- 
1.7.0.4

