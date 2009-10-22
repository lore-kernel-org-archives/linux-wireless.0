Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59617 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZJVSxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:48 -0400
Date: Thu, 22 Oct 2009 20:21:38 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 25/28] mwl8k: add AP firmware handling to ->start()
Message-ID: <20091022182138.GA1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 815f73f..b2c68b2 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2712,12 +2712,17 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	if (!rc) {
 		rc = mwl8k_cmd_802_11_radio_enable(hw);
 
-		if (!rc)
-			rc = mwl8k_cmd_set_pre_scan(hw);
+		if (!priv->ap_fw) {
+			if (!rc)
+				rc = mwl8k_enable_sniffer(hw, 0);
 
-		if (!rc)
-			rc = mwl8k_cmd_set_post_scan(hw,
-					"\x00\x00\x00\x00\x00\x00");
+			if (!rc)
+				rc = mwl8k_cmd_set_pre_scan(hw);
+
+			if (!rc)
+				rc = mwl8k_cmd_set_post_scan(hw,
+						"\x00\x00\x00\x00\x00\x00");
+		}
 
 		if (!rc)
 			rc = mwl8k_cmd_setrateadaptmode(hw, 0);
@@ -2725,9 +2730,6 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		if (!rc)
 			rc = mwl8k_set_wmm(hw, 0);
 
-		if (!rc)
-			rc = mwl8k_enable_sniffer(hw, 0);
-
 		mwl8k_fw_unlock(hw);
 	}
 
-- 
1.5.6.4
