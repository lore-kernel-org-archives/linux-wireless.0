Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13245 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZJQT0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 15:26:50 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org
Cc: yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH net-next V2 3/3] i2400m-sdio: select IWMC3200TOP in Kconfig
Date: Sat, 17 Oct 2009 21:09:36 +0200
Message-Id: <1255806576-26869-3-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1255806576-26869-2-git-send-email-tomas.winkler@intel.com>
References: <1255806576-26869-1-git-send-email-tomas.winkler@intel.com>
 <1255806576-26869-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2400m-sdio requires iwmc3200top for its operation

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
---
 drivers/net/wimax/i2400m/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wimax/i2400m/Kconfig b/drivers/net/wimax/i2400m/Kconfig
index d623b3d..32cb214 100644
--- a/drivers/net/wimax/i2400m/Kconfig
+++ b/drivers/net/wimax/i2400m/Kconfig
@@ -31,6 +31,14 @@ config WIMAX_I2400M_SDIO
 
 	  If unsure, it is safe to select M (module).
 
+config WIMAX_IWMC3200_SDIO
+	bool "Intel Wireless Multicom WiMAX Connection 3200 over SDIO"
+	depends on WIMAX_I2400M_SDIO
+	select IWMC3200TOP
+	help
+	  Select if you have a device based on the Intel Multicom WiMAX
+          Connection 3200 over SDIO.
+ 
 config WIMAX_I2400M_DEBUG_LEVEL
 	int "WiMAX i2400m debug level"
 	depends on WIMAX_I2400M
-- 
1.6.0.6

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

