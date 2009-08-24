Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:39311 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZHXNme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 09:42:34 -0400
Date: Mon, 24 Aug 2009 15:42:36 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mwl8k: fix inverted error test in mwl8k_bss_info_changed()
Message-ID: <20090824134236.GC6102@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 41a708c..4d3353c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2617,7 +2617,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 	priv->capture_beacon = false;
 
 	rc = mwl8k_fw_lock(hw);
-	if (!rc)
+	if (rc)
 		return;
 
 	if (info->assoc) {
-- 
1.5.6.4
