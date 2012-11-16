Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57791 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2KPG5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:44 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1734366pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2012 22:57:44 -0800 (PST)
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Luciano Coelho <coelho@ti.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 14/14] wlcore: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:46 +0530
Message-Id: <1353048646-10935-15-git-send-email-tushar.behera@linaro.org> (sfid-20121116_075818_360204_8349EE55)
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to check whether unsigned variable is less than 0.

CC: Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index c86bb00..93f801d 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -993,7 +993,7 @@ static ssize_t sleep_auth_write(struct file *file,
 		return -EINVAL;
 	}
 
-	if (value < 0 || value > WL1271_PSM_MAX) {
+	if (value > WL1271_PSM_MAX) {
 		wl1271_warning("sleep_auth must be between 0 and %d",
 			       WL1271_PSM_MAX);
 		return -ERANGE;
-- 
1.7.4.1

