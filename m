Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:50051 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3JDGN0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 02:13:26 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix printf format string
Date: Fri, 4 Oct 2013 08:13:19 +0200
Message-ID: <1380867200-19714-2-git-send-email-michal.kazior@tieto.com> (sfid-20131004_081330_487811_B3DF6B8F)
In-Reply-To: <1380867200-19714-1-git-send-email-michal.kazior@tieto.com>
References: <1380867200-19714-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

size_t corresponds to %zu not %d. Compiler was
complaining about it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7b5dd09..bf85d34 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -402,7 +402,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
 
 	if (len < magic_len) {
-		ath10k_err("firmware image too small to contain magic: %d\n",
+		ath10k_err("firmware image too small to contain magic: %zu\n",
 			   len);
 		return -EINVAL;
 	}
@@ -429,7 +429,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 		data += sizeof(*hdr);
 
 		if (len < ie_len) {
-			ath10k_err("Invalid length for FW IE %d (%d < %d)\n",
+			ath10k_err("Invalid length for FW IE %d (%zu < %zu)\n",
 				   ie_id, len, ie_len);
 			return -EINVAL;
 		}
-- 
1.7.9.5

