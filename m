Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49876 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab0ABJbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 04:31:44 -0500
Date: Sat, 2 Jan 2010 10:31:42 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mwl8k: fix configure_filter() memory leak on error
Message-ID: <20100102093142.GS1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If there was an error acquiring the firmware lock in
mwl8k_configure_filter(), we would end up leaking the multicast
command packet prepared by mwl8k_prepare_multicast().

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 59d4915..59f9210 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3157,8 +3157,10 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 	/* Clear unsupported feature flags */
 	*total_flags &= FIF_ALLMULTI | FIF_BCN_PRBRESP_PROMISC;
 
-	if (mwl8k_fw_lock(hw))
+	if (mwl8k_fw_lock(hw)) {
+		kfree(cmd);
 		return;
+	}
 
 	if (priv->sniffer_enabled) {
 		mwl8k_enable_sniffer(hw, 0);
-- 
1.5.6.4
