Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suteba.org.ar ([200.16.134.105]:50186 "EHLO
        mail.suteba.org.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933889AbcIZPWH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 11:22:07 -0400
From: Matias Mucciolo <mmucciolo@suteba.org.ar>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix symbol 'WILC_DEBUG_LEVEL' was not declared.
Date: Mon, 26 Sep 2016 12:15:18 -0300
Message-ID: <34310025.aMSyYASYEz@varitech> (sfid-20160926_172210_637536_7323E821)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


- Fixed a sparse warning: symbol 'WILC_DEBUG_LEVEL' was not declared.

Signed-off-by: Matias Mucciolo <mmucciolo@suteba.org.ar>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index b052628..802bb1d 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -29,7 +29,7 @@ static struct dentry *wilc_dir;
 #define ERR             BIT(3)
 
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
+static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
 
 /*
-- 
2.1.4
