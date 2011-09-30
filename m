Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48087 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab1I3GCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 02:02:03 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: set pci_express capability true for AR9480
Date: Fri, 30 Sep 2011 11:31:28 +0530
Message-ID: <1317362488-4816-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110930_080208_618831_46BE5B83)
In-Reply-To: <1317362488-4816-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1317362488-4816-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

the AR_SREV register does not seems to indicate whether AR9480 is
pci_express capable or not though the other information like macVersion
etc can be obtained properly. this fix is essential as ASPM won't be intialized
and its related driver functionality ath9k_hw_configpcipowersave won't be
called

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f2de7ee..56ba6a8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -284,7 +284,12 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 		ah->hw_version.macVersion =
 			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
 		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
-		ah->is_pciexpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
+
+		if (AR_SREV_9480(ah))
+			ah->is_pciexpress = true;
+		else
+			ah->is_pciexpress = (val &
+					     AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
 	} else {
 		if (!AR_SREV_9100(ah))
 			ah->hw_version.macVersion = MS(val, AR_SREV_VERSION);
-- 
1.7.0.4

