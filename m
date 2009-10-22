Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49152 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbZJVShI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:08 -0400
Date: Thu, 22 Oct 2009 20:19:53 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 07/28] mwl8k: enforce FIF_BCN_PRBRESP_PROMISC when no STA interfaces are active
Message-ID: <20091022181953.GI1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When FIF_BCN_PRBRESP_PROMISC is not set, we enable the hardware's BSS
filter so that we'll only see packets destined for our BSS.  But if no
STA interfaces have been configured, we would end up passing the BSSID
00:00:00:00:00:00 into the POST_SCAN command, which actually disables
the hardware's BSS filter, as it's not a valid BSSID.

Fix this by passing in 01:00:00:00:00:00 instead (the criterion is
that the OUI part of the BSSID must be nonzero), and add comments to
explain what PRE_SCAN and POST_SCAN do.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cc58ecb..53447f6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2705,12 +2705,23 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 		return;
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
+			/*
+			 * Disable the BSS filter.
+			 */
 			mwl8k_cmd_set_pre_scan(hw);
-		else {
+		} else {
 			u8 *bssid;
 
-			bssid = "\x00\x00\x00\x00\x00\x00";
+			/*
+			 * Enable the BSS filter.
+			 *
+			 * If there is an active STA interface, use that
+			 * interface's BSSID, otherwise use a dummy one
+			 * (where the OUI part needs to be nonzero for
+			 * the BSSID to be accepted by POST_SCAN).
+			 */
+			bssid = "\x01\x00\x00\x00\x00\x00";
 			if (priv->vif != NULL)
 				bssid = MWL8K_VIF(priv->vif)->bssid;
 
-- 
1.5.6.4
