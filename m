Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:65324 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYKYRLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 12:11:17 -0500
Received: by gxk4 with SMTP id 4so48631gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 09:10:44 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH] ipw2200: increase scan timeout
Date: Tue, 25 Nov 2008 18:09:54 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, ipw2100-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811251809.55461.helmut.schaa@gmail.com> (sfid-20081125_181123_584262_949E6EF9)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current scan timeout is set to 5 seconds. If the timeout is hit because
the firmware did not respond yet, the adapter gets restarted, which results
in a disassociation.

However, in an environment with lots of access points the scan sometimes takes
longer than 5 seconds. This patch simply increases the timeout to 10 seconds.

Signed-off-by: helmut.schaa@googlemail.com
---

I was able to reproduce the issue fairly reliable with a 2915 adapter by 
periodically triggering scans while associated.

I have no idea in which situations the scan takes longer than 5 seconds to
complete but maybe it might even take longer than 10 seconds. Has anybody from
Intel insight into the firmware scan code?

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index c73173a..a776da3 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2304,7 +2304,7 @@ static void ipw_bg_adapter_restart(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
-#define IPW_SCAN_CHECK_WATCHDOG (5 * HZ)
+#define IPW_SCAN_CHECK_WATCHDOG (10 * HZ)
 
 static void ipw_scan_check(void *data)
 {
