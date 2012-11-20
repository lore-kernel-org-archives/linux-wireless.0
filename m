Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KTLUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:23 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:23 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 07/11] wlcore: set active psm on association
Date: Tue, 20 Nov 2012 13:20:07 +0200
Message-Id: <1353410411-18833-8-git-send-email-eliad@wizery.com> (sfid-20121120_122028_589779_AAD264CF)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default ps mode of the fw is auto, while the default
ps mode of mac80211 is active (ps off).
In order to sync them, configure active ps on association.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 55dce4a..e393cea 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2614,6 +2614,12 @@ static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * The default fw psm configuration is AUTO, while mac80211 default
+	 * setting is off (ACTIVE), so sync the fw with the correct value.
+	 */
+	ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE);
+
 	return ret;
 }
 
-- 
1.7.6.401.g6a319

