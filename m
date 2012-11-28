Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58463 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2K1JnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:13 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3507315wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:13 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Yair Shapira <yair.shapira@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/20] wlcore: disable elp sleep while in plt mode
Date: Wed, 28 Nov 2012 11:42:38 +0200
Message-Id: <1354095769-8724-10-git-send-email-arik@wizery.com> (sfid-20121128_104321_490837_5F503524)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

We now disable elp sleep during plt mode to allow normal operation of
plt tools such as calibrator.

Having elp_sleep enabled during plt mode is actually not required and
in fact it disrupt plt operations such as rx statistics etc...

This is based on wl12xx (R5) commit 5cf0fe31ab

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/ps.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 9b7b6e2..db7d902 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -82,6 +82,10 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 	struct wl12xx_vif *wlvif;
 	u32 timeout;
 
+	/* We do not enter elp sleep in PLT mode */
+	if (wl->plt)
+		return;
+
 	if (wl->sleep_auth != WL1271_PSM_ELP)
 		return;
 
-- 
1.7.9.5

