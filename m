Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37423 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2KSQjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:52 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051722eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/15] wlcore: set active psm on association
Date: Mon, 19 Nov 2012 18:39:26 +0200
Message-Id: <1353343170-26516-12-git-send-email-eliad@wizery.com> (sfid-20121119_174527_322426_1AC06CCC)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default ps mode of the fw is auto, while the default
ps mode of mac80211 is active (ps off).
In order to sync them, configure active ps on association.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e1f0606..0dd0ec1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2534,6 +2534,15 @@ static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 					   ACX_KEEP_ALIVE_TPL_VALID);
 	if (ret < 0)
 		goto out;
+
+	/*
+	 * The default fw psm configuration is AUTO, while mac80211 default
+	 * setting is off (ACTIVE), so sync the fw with the correct value.
+	 */
+	ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE);
+	if (ret < 0)
+		goto out;
+
 out:
 	return ret;
 }
-- 
1.7.6.401.g6a319

