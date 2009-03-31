Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:23252 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762428AbZCaGrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 02:47:47 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3013394wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 23:47:45 -0700 (PDT)
Date: Tue, 31 Mar 2009 12:07:52 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Disable autosleep feature for AR9285 based chipsets.
Message-ID: <20090331063752.GA9846@myhost.users.atheros.com> (sfid-20090331_084803_695423_686336B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index b15eaf8..7d07f09 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3411,7 +3411,8 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
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
1.6.0.1

