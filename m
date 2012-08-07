Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29656 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab2HGC05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 22:26:57 -0400
Date: Tue, 7 Aug 2012 10:26:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mwifiex: fix code mis-alignment after the if statement
Message-ID: <20120807022653.GA21014@localhost> (sfid-20120807_042714_050905_27286061)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/net/wireless/mwifiex/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/drivers/net/wireless/mwifiex/scan.c	2012-07-25 19:09:37.939358714 +0800
+++ linux/drivers/net/wireless/mwifiex/scan.c	2012-08-07 10:21:20.303090255 +0800
@@ -1433,9 +1433,9 @@ int mwifiex_check_network_compatibility(
 			if (ret)
 				dev_err(priv->adapter->dev, "cannot find ssid "
 					"%s\n", bss_desc->ssid.ssid);
-				break;
+			break;
 		default:
-				ret = 0;
+			ret = 0;
 		}
 	}
 
