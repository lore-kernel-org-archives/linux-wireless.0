Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46203 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3IIJZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:25:11 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so990540wid.14
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:25:10 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/13] wlcore: save last regdom configuration on stop
Date: Mon,  9 Sep 2013 12:24:44 +0300
Message-Id: <1378718684-14430-13-git-send-email-eliad@wizery.com> (sfid-20130909_114831_214280_B3FE9EA2)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to reconfigure the correct reg domain on
recovery, we have to save the current configuration
before clearing it (wl->reg_ch_conf_pending is
considered before configuring a new regdomain).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index acb3502..657b9eb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1950,8 +1950,10 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 
 	/*
 	 * FW channels must be re-calibrated after recovery,
-	 * clear the last Reg-Domain channel configuration.
+	 * save current Reg-Domain channel configuration and clear it.
 	 */
+	memcpy(wl->reg_ch_conf_pending, wl->reg_ch_conf_last,
+	       sizeof(wl->reg_ch_conf_pending));
 	memset(wl->reg_ch_conf_last, 0, sizeof(wl->reg_ch_conf_last));
 }
 
-- 
1.8.3.rc1.35.g9b79519

