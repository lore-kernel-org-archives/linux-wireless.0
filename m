Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48758 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab2FGUkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:40:07 -0400
Received: by lbbgk8 with SMTP id gk8so950568lbb.26
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:47 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 6/9] wlcore: use u8 instead of enum for bcn_filt_mode
Date: Thu,  7 Jun 2012 23:39:25 +0300
Message-Id: <1339101568-25346-7-git-send-email-coelho@ti.com> (sfid-20120607_224014_106137_D83B48E6)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we will export the conf structure as a file, we need to use well
defined types.  Instead of using enum, whose size may vary, use u8 for
bcn_filt_mode instead.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/conf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 2e84ae1..0950bd2 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -824,7 +824,7 @@ struct conf_conn_settings {
 	 *
 	 * Range: CONF_BCN_FILT_MODE_*
 	 */
-	enum conf_bcn_filt_mode bcn_filt_mode;
+	u8 bcn_filt_mode;
 
 	/*
 	 * Configure Beacon filter pass-thru rules.
-- 
1.7.10

