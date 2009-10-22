Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59626 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZJVSxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:49 -0400
Date: Thu, 22 Oct 2009 20:21:36 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 24/28] mwl8k: add AP firmware handling to ->configure_filter()
Message-ID: <20091022182136.GZ1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0e26a96..815f73f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3013,6 +3013,16 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 	struct mwl8k_cmd_pkt *cmd = (void *)(unsigned long)multicast;
 
 	/*
+	 * AP firmware doesn't allow fine-grained control over
+	 * the receive filter.
+	 */
+	if (priv->ap_fw) {
+		*total_flags &= FIF_ALLMULTI | FIF_BCN_PRBRESP_PROMISC;
+		kfree(cmd);
+		return;
+	}
+
+	/*
 	 * Enable hardware sniffer mode if FIF_CONTROL or
 	 * FIF_OTHER_BSS is requested.
 	 */
-- 
1.5.6.4

