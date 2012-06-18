Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43090 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2FRGHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:07:06 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: fix incorrect profile type manupulation
Date: Mon, 18 Jun 2012 11:36:58 +0530
Message-ID: <1339999618-2717-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120618_080710_594156_01B405BC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two MCI interrupts are generated while adding A2DP and headset profiles
with different types and same connection handle. While disconnecting,
only one MCI interrupt is generated with last added profile type value
for both profiles.

While adding second profile type decrement first one.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 7d34a50..ebd7c12 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -233,8 +233,21 @@ static void ath_mci_process_profile(struct ath_softc *sc,
 	struct ath_mci_profile_info *entry = NULL;
 
 	entry = ath_mci_find_profile(mci, info);
-	if (entry)
+	if (entry) {
+		/*
+		 * Two MCI interrupts are generated while connecting to
+		 * headset and A2DP profile, but only one MCI interrupt
+		 * is generated with last added profile type while disconnecting
+		 * both profiles.
+		 * So while adding second profile type decrement
+		 * the first one.
+		 */
+		if (entry->type != info->type) {
+			DEC_PROF(mci, entry);
+			INC_PROF(mci, info);
+		}
 		memcpy(entry, info, 10);
+	}
 
 	if (info->start) {
 		if (!entry && !ath_mci_add_profile(common, mci, info))
-- 
1.7.4.1

