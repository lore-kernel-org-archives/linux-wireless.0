Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:13467 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdL0UCl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Dec 2017 15:02:41 -0500
From: <ryanhsu@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <ryanhsu@qti.qualcomm.com>
Subject: [PATCH] ath10k: add sanity check to ie_len before parsing fw/board ie
Date: Wed, 27 Dec 2017 12:02:11 -0800
Message-ID: <1514404931-9078-1-git-send-email-ryanhsu@qti.qualcomm.com> (sfid-20171227_210245_424200_F55E5AE7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qti.qualcomm.com>

Validate ie_len after the alignment padding before access the buffer
to avoid potential overflow.

Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 042175a..2f24c17 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1240,7 +1240,10 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 		len -= sizeof(*hdr);
 		data = hdr->data;
 
-		if (len < ALIGN(ie_len, 4)) {
+		/* jump over the padding */
+		ie_len = ALIGN(ie_len, 4);
+
+		if (len < ie_len) {
 			ath10k_err(ar, "invalid length for board ie_id %d ie_len %zu len %zu\n",
 				   ie_id, ie_len, len);
 			ret = -EINVAL;
@@ -1279,8 +1282,6 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 			goto out;
 		}
 
-		/* jump over the padding */
-		ie_len = ALIGN(ie_len, 4);
 
 		len -= ie_len;
 		data += ie_len;
@@ -1412,6 +1413,9 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 		len -= sizeof(*hdr);
 		data += sizeof(*hdr);
 
+		/* jump over the padding */
+		ie_len = ALIGN(ie_len, 4);
+
 		if (len < ie_len) {
 			ath10k_err(ar, "invalid length for FW IE %d (%zu < %zu)\n",
 				   ie_id, len, ie_len);
@@ -1517,9 +1521,6 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 			break;
 		}
 
-		/* jump over the padding */
-		ie_len = ALIGN(ie_len, 4);
-
 		len -= ie_len;
 		data += ie_len;
 	}
-- 
1.9.1
