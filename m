Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46954 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391321AbeIVCd2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 22:33:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id t20-v6so3005783ply.13
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 13:42:54 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: add missing sanity check on diag download
Date: Fri, 21 Sep 2018 13:42:41 -0700
Message-Id: <20180921204241.34316-1-briannorris@chromium.org> (sfid-20180921_224257_699002_D70B633E)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_hw_diag_fast_download() generally has good boundary checking, but
it misses verifying that the next metadata header actually fits in the
remaining buffer space. Add such a check.

Fixes: 39501ea64116 ("ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/hw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 2c2870e3e84d..af8ae8117c62 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -1044,6 +1044,12 @@ int ath10k_hw_diag_fast_download(struct ath10k *ar,
 	left = length - sizeof(*hdr);
 
 	while (left > 0) {
+		if (left < sizeof(*metadata)) {
+			ath10k_warn(ar, "firmware segment is truncated: %d\n",
+				    left);
+			ret = -EINVAL;
+			break;
+		}
 		base_addr = __le32_to_cpu(metadata->addr);
 		base_len = __le32_to_cpu(metadata->length);
 		buf = metadata->data;
-- 
2.19.0.444.g18242da7ef-goog
