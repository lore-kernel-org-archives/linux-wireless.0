Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:40154 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKKFVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 00:21:46 -0500
Date: Tue, 11 Nov 2014 16:21:28 +1100
From: James Cameron <quozl@laptop.org>
To: linux-wireless@vger.kernel.org, Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: simplify ad hoc join capability info
Message-ID: <20141111052127.GA18499@us.netrek.org> (sfid-20141111_062151_944217_A836729A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While preparing an ad-hoc start command, the capability info bitmap is
needlessly set from the command, and then the ESS bit cleared.

Change to set the bitmap directly without reference to the command.

Signed-off-by: James Cameron <quozl@laptop.org>
---
 drivers/net/wireless/mwifiex/join.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 8d6c259..411a6c2 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -880,9 +880,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	/* Set Capability info */
 	bss_desc->cap_info_bitmap |= WLAN_CAPABILITY_IBSS;
-	tmp_cap = le16_to_cpu(adhoc_start->cap_info_bitmap);
-	tmp_cap &= ~WLAN_CAPABILITY_ESS;
-	tmp_cap |= WLAN_CAPABILITY_IBSS;
+	tmp_cap = WLAN_CAPABILITY_IBSS;
 
 	/* Set up privacy in bss_desc */
 	if (priv->sec_info.encryption_mode) {
-- 
1.9.1


-- 
James Cameron
http://quozl.linux.org.au/
