Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28950 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1HYOpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 10:45:03 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k_hw: Fix slottime with coverage class
Date: Thu, 25 Aug 2011 20:15:22 +0530
Message-ID: <1314283522-6143-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110825_164507_935881_6D61E29B)
In-Reply-To: <1314283522-6143-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1314283522-6143-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit b6ba41bb27eb9810d54e2301355ce56fd0e94a1a updates
acktimeout wihout updating slottime when coverage class is defined
as per IEEE 802.11-2007 17.3.8.6.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d4dce6b..9936b68 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1012,7 +1012,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	}
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
+	slottime = ah->slottime + 3 * ah->coverage_class;
+	acktimeout = slottime + sifstime;
 
 	/*
 	 * Workaround for early ACK timeouts, add an offset to match the
-- 
1.7.6.1

