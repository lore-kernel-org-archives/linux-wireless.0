Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3193 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaLBJvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:51:48 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 07/10] wil6210: fix warning in pointer arithmetic
Date: Tue, 2 Dec 2014 11:51:29 +0200
Message-ID: <1417513889-18572-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141202_105152_626189_8EB8C291)
In-Reply-To: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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

