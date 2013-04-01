Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46714 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab3DAWhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 18:37:53 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath: Let user know which keycache method is complaining.
Date: Mon,  1 Apr 2013 15:37:29 -0700
Message-Id: <1364855849-30825-1-git-send-email-greearb@candelatech.com> (sfid-20130402_004617_066834_421CDDE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should make the warning messages more useful.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/key.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 5c54aa4..1816b4e 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -45,7 +45,8 @@ bool ath_hw_keyreset(struct ath_common *common, u16 entry)
 	void *ah = common->ah;
 
 	if (entry >= common->keymax) {
-		ath_err(common, "keycache entry %u out of range\n", entry);
+		ath_err(common, "keyreset: keycache entry %u out of range\n",
+			entry);
 		return false;
 	}
 
@@ -91,7 +92,8 @@ static bool ath_hw_keysetmac(struct ath_common *common,
 	void *ah = common->ah;
 
 	if (entry >= common->keymax) {
-		ath_err(common, "keycache entry %u out of range\n", entry);
+		ath_err(common, "keysetmac: keycache entry %u out of range\n",
+			entry);
 		return false;
 	}
 
@@ -133,7 +135,8 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 	u32 keyType;
 
 	if (entry >= common->keymax) {
-		ath_err(common, "keycache entry %u out of range\n", entry);
+		ath_err(common, "set-entry: keycache entry %u out of range\n",
+			entry);
 		return false;
 	}
 
-- 
1.7.3.4

