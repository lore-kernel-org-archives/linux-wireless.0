Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhcavspool01.kulnet.kuleuven.be ([134.58.240.193]:39053 "EHLO
	cavspool01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752419AbbHCNvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 09:51:54 -0400
Received: from cavuit01.kulnet.kuleuven.be (rhcavuit01.kulnet.kuleuven.be [134.58.240.129])
	by cavspool01.kulnet.kuleuven.be (Postfix) with ESMTP id F33651357A
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2015 15:46:16 +0200 (CEST)
From: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
To: mcgrof@do-not-panic.com, linux-wireless@vger.kernel.org
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Subject: [PATCH 1/1] ath: Make ath_opmode_to_string understand OCB mode
Date: Mon,  3 Aug 2015 15:45:41 +0200
Message-Id: <1438609541-24239-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be> (sfid-20150803_155157_602798_9EC60525)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make ath_opmode_to_string return "OCB" for NL80211_IFTYPE_OCB. Currently
it will return "UNKNOWN".

Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
---
 drivers/net/wireless/ath/debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/debug.c b/drivers/net/wireless/ath/debug.c
index 508eccf..d59d83e 100644
--- a/drivers/net/wireless/ath/debug.c
+++ b/drivers/net/wireless/ath/debug.c
@@ -40,6 +40,8 @@ const char *ath_opmode_to_string(enum nl80211_iftype opmode)
 		return "P2P-CLIENT";
 	case NL80211_IFTYPE_P2P_GO:
 		return "P2P-GO";
+	case NL80211_IFTYPE_OCB:
+		return "OCB";
 	default:
 		return "UNKNOWN";
 	}
-- 
1.7.1

