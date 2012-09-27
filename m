Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:41123 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2I0Kin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:43 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 18/31] wlcore: allow up to 3 running STA interfaces in combinations
Date: Thu, 27 Sep 2012 13:37:56 +0300
Message-Id: <1348742289-6587-19-git-send-email-luca@coelho.fi> (sfid-20120927_125552_695264_2C86D388)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This allows us to have a p2p-management interface (in STA mode),
as we as a group dedicated interface.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 09f0e44..7b825e8 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5180,7 +5180,7 @@ static void wl1271_unregister_hw(struct wl1271 *wl)
 
 static const struct ieee80211_iface_limit wlcore_iface_limits[] = {
 	{
-		.max = 2,
+		.max = 3,
 		.types = BIT(NL80211_IFTYPE_STATION),
 	},
 	{
@@ -5195,7 +5195,7 @@ static const struct ieee80211_iface_combination
 wlcore_iface_combinations[] = {
 	{
 	  .num_different_channels = 1,
-	  .max_interfaces = 2,
+	  .max_interfaces = 3,
 	  .limits = wlcore_iface_limits,
 	  .n_limits = ARRAY_SIZE(wlcore_iface_limits),
 	},
-- 
1.7.10.4

