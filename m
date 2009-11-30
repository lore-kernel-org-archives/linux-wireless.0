Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57164 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZK3RNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:13:50 -0500
Date: Mon, 30 Nov 2009 18:13:56 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/12] mwl8k: don't overwrite mwl8k_vif::bssid until after disassociation
Message-ID: <20091130171356.GN20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disassociating, mac80211 zeroes vif->bss_info.bssid before
calling our ->bss_info_changed(), but we need the BSSID to remove the
hardware station database entry for our AP, so we can't clear our
local copy of the BSSID until after we've done that.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ca6162b..f80cef9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3025,9 +3025,6 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
 	int rc;
 
-	if (changed & BSS_CHANGED_BSSID)
-		memcpy(mwl8k_vif->bssid, info->bssid, ETH_ALEN);
-
 	if ((changed & BSS_CHANGED_ASSOC) == 0)
 		return;
 
@@ -3041,6 +3038,8 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		memcpy(&mwl8k_vif->bss_info, info,
 			sizeof(struct ieee80211_bss_conf));
 
+		memcpy(mwl8k_vif->bssid, info->bssid, ETH_ALEN);
+
 		/* Install rates */
 		rc = mwl8k_update_rateset(hw, vif);
 		if (rc)
-- 
1.5.6.4
