Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6657 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaLANiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:38:55 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 6/9] wil6210: fix warning in pointer arithmetic
Date: Mon, 1 Dec 2014 15:35:27 +0200
Message-ID: <1417440927-27230-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143858_877630_008C9B3E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some compilation environments, result of pointer arithmetic interpreted as int
while in others it is long int. Force conversion to long.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/fw_inc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 2658455..d4acf93 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -446,7 +446,7 @@ static int wil_fw_load(struct wil6210_priv *wil, const void *data, size_t size)
 		if (size >= sizeof(*hdr)) {
 			wil_err_fw(wil, "Stop at offset %ld"
 				   " record type %d [%zd bytes]\n",
-				   (const void *)hdr - data,
+				   (long)((const void *)hdr - data),
 				   le16_to_cpu(hdr->type), hdr_sz);
 		}
 		return -EINVAL;
-- 
2.1.0

