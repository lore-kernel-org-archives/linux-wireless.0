Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19593 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2IDODs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:03:48 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	xijin luo <xijin@qca.qualcomm.com>
Subject: [PATCH 1/8] ath9k_hw: Fix invalid MCI GPM index access/caching
Date: Tue, 4 Sep 2012 19:33:32 +0530
Message-ID: <1346767419-12359-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120904_160351_590277_07DBDAE5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

There is a possibility that AR_MCI_GPM_1 register can
return 0xdeadbeef and this results in caching of invalid
GPM index in ar9003_mci_is_gpm_valid. Ensure we
have appropriate checks to avoid this.

Cc: xijin luo <xijin@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 9a34fca..995b866 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1327,6 +1327,10 @@ u32 ar9003_mci_get_next_gpm_offset(struct ath_hw *ah, bool first, u32 *more)
 
 	if (first) {
 		gpm_ptr = MS(REG_READ(ah, AR_MCI_GPM_1), AR_MCI_GPM_WRITE_PTR);
+
+		if (gpm_ptr >= mci->gpm_len)
+			gpm_ptr = 0;
+
 		mci->gpm_idx = gpm_ptr;
 		return gpm_ptr;
 	}
@@ -1371,6 +1375,10 @@ u32 ar9003_mci_get_next_gpm_offset(struct ath_hw *ah, bool first, u32 *more)
 			more_gpm = MCI_GPM_NOMORE;
 
 		temp_index = mci->gpm_idx;
+
+		if (temp_index >= mci->gpm_len)
+			temp_index = 0;
+
 		mci->gpm_idx++;
 
 		if (mci->gpm_idx >= mci->gpm_len)
-- 
1.7.0.4

