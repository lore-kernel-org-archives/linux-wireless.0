Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42497 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab1BGVpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 16:45:00 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/7] ath9k:  Print channel-type in chan-change dbg message.
Date: Mon,  7 Feb 2011 13:44:33 -0800
Message-Id: <1297115078-27773-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 70bb871... 1447887... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 70bb871..1447887 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1677,8 +1677,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		else
 			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
 
-		ath_dbg(common, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
-			curchan->center_freq);
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Set channel: %d MHz type: %d\n",
+			curchan->center_freq, conf->channel_type);
 
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
 					  curchan, conf->channel_type);
-- 
1.7.2.3

