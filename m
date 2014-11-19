Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18478 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbaKSN3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 08:29:09 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: [PATCH] device coredump: fix minor issue in Kconfig file
Date: Wed, 19 Nov 2014 05:28:02 -0800
Message-ID: <1416403682-9203-1-git-send-email-akarwar@marvell.com> (sfid-20141119_142927_722539_72E3339B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if "CONFIG_DEV_COREDUMP=y" is added to configuration file, it
gets removed when final configuration file is generated. The
reason is it requires CONFIG_WANT_DEV_COREDUMP to be enabled.

Currently "make menuconfig" doesn't display an option to enable
WANT_DEV_COREDUMP. This patch updates Kconfig so that user can
enable WANT_DEV_COREDUMP.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Tested-by: Xinming Hu <huxm@marvell.com>
---
 drivers/base/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 61a33f4..e491b07 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -166,7 +166,7 @@ config FW_LOADER_USER_HELPER_FALLBACK
 	  If you are unsure about this, say N here.
 
 config WANT_DEV_COREDUMP
-	bool
+	bool "Want device coredump"
 	help
 	  Drivers should "select" this option if they desire to use the
 	  device coredump mechanism.
-- 
1.8.1.4

