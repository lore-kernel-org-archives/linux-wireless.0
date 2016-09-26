Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suteba.org.ar ([200.16.134.105]:50982 "EHLO
        mail.suteba.org.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbcIZQNO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 12:13:14 -0400
From: Matias Mucciolo <mmucciolo@suteba.org.ar>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix sparse warning: symbol was not declared. Should it be static?
Date: Mon, 26 Sep 2016 13:13:03 -0300
Message-ID: <6507342.BIUiKHv64l@varitech> (sfid-20160926_181402_940456_EE73358D)
In-Reply-To: <20160926155220.GA3319@kroah.com>
References: <34310025.aMSyYASYEz@varitech> <4399555.QWNJt8EtNN@varitech> <20160926155220.GA3319@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Fixed a sparse warning:
  wilc_debugfs.c:32:10: warning: symbol 'WILC_DEBUG_LEVEL' was not declared. Should it be static?

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
