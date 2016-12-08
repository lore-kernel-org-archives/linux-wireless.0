Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:60175 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932441AbcLHAkc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 19:40:32 -0500
From: Pan Bian <bianpan2016@163.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] orinoco: fix improper return value
Date: Thu,  8 Dec 2016 08:40:02 +0800
Message-Id: <1481157602-4011-1-git-send-email-bianpan2016@163.com> (sfid-20161208_014052_692890_947577B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function orinoco_ioctl_commit() returns 0 (indicates success) when the
call to orinoco_lock() fails. Thus, the return value is inconsistent with
the execution status. It may be better to return "-EBUSY" when the call 
to orinoco_lock() fails.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188671

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/wireless/intersil/orinoco/wext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/wext.c b/drivers/net/wireless/intersil/orinoco/wext.c
index 1d4dae4..fee57ea 100644
--- a/drivers/net/wireless/intersil/orinoco/wext.c
+++ b/drivers/net/wireless/intersil/orinoco/wext.c
@@ -1314,7 +1314,7 @@ static int orinoco_ioctl_commit(struct net_device *dev,
 		return 0;
 
 	if (orinoco_lock(priv, &flags) != 0)
-		return err;
+		return -EBUSY;
 
 	err = orinoco_commit(priv);
 
-- 
1.9.1
