Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17217 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbcIBFaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 01:30:30 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <arnagara@codeaurora.org>,
        "Ashok Raj Nagarajan" <arnagara@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix reporting channel survey data
Date: Fri, 2 Sep 2016 10:59:53 +0530
Message-ID: <1472794193-20774-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160902_073034_443118_A846CCE2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When user requests for survey dump data, driver is providing wrong survey
information. This information we sent is the survey data that we have
collected during previous user request.

This issue occurs because we request survey dump for wrong channel. With
this change, we correctly display the correct and current survey
information to userspace.

Fixes: fa7937e3d5c2 ("ath10k: update bss channel survey information")
Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0bbd0a0..1fa3c17 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6538,7 +6538,7 @@ static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
 		goto exit;
 	}
 
-	ath10k_mac_update_bss_chan_survey(ar, survey->channel);
+	ath10k_mac_update_bss_chan_survey(ar, &sband->channels[idx]);
 
 	spin_lock_bh(&ar->data_lock);
 	memcpy(survey, ar_survey, sizeof(*survey));
-- 
1.9.1
