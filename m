Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:35682 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZDNKvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 06:51:11 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2549195rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 03:51:10 -0700 (PDT)
Date: Tue, 14 Apr 2009 16:21:01 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath9k: Disable autosleep feature for AR9285 based
	chipsets.
Message-ID: <20090414105101.GB3850@myhost.users.atheros.com> (sfid-20090414_125115_370635_26ED895C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 24299e6..524f19c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3376,7 +3376,8 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	    (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) ||
 	    (ah->hw_version.macVersion == AR_SREV_VERSION_9160) ||
 	    (ah->hw_version.macVersion == AR_SREV_VERSION_9100) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280))
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9285))
 		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
-- 
1.6.2.3

