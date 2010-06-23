Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56342 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0FWOpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 10:45:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: dkiran@marvell.com, Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] libertas: unmangle capability value
Date: Wed, 23 Jun 2010 10:37:25 -0400
Message-Id: <1277303846-17257-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
References: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Address fall-out from patch converting libertas to use cfg80211...

+drivers/net/wireless/libertas/cfg.c:1844:13: warning: incorrect type in assignment (different base types)
+drivers/net/wireless/libertas/cfg.c:1844:13:    expected unsigned short [unsigned] [usertype] capability
+drivers/net/wireless/libertas/cfg.c:1844:13:    got restricted __le16 [usertype] <noident>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 23c1dc6..f36cc97 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1841,7 +1841,7 @@ static int lbs_ibss_start_new(struct lbs_private *priv,
 	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 8)
 		cmd.probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
 	/* TODO: mix in WLAN_CAPABILITY_PRIVACY */
-	capability = cpu_to_le16(WLAN_CAPABILITY_IBSS);
+	capability = WLAN_CAPABILITY_IBSS;
 	cmd.capability = cpu_to_le16(capability);
 	lbs_add_rates(cmd.rates);
 
-- 
1.7.0.1

