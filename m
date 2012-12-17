Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40231 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2LQJjx (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 17 Dec 2012 04:39:53 -0500
From: "Chen, Chien-Chia" <machen@suse.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Subject: [rt2x00-users] [PATCH] rt2800lib : Add a patch to disable/enable power save mode.
Date: Mon, 17 Dec 2012 17:43:13 +0800
Message-Id: <1355737393-8143-1-git-send-email-machen@suse.com> (sfid-20121217_103956_113780_487735A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to enable/disable power save mode. rt2800lib
disables PCI WLAN module power save mode default. It allows
to enable the power save mode.

Sign-off-by: Chen, Chien-Chia <matt680209@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 197b446..8ddbf83 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -44,6 +44,13 @@
 #include "rt2800.h"
 
 /*
+ * Allow power save mode to be disabled.
+ */
+static bool power_save_disabled = true;
+module_param(power_save_disabled, bool, 0444);
+MODULE_PARM_DESC(power_save_disabled, " Disable power save. (default: disable. 1=disable, 0=enable.)");
+
+/*
  * Register access.
  * All access to the CSR registers will go through the methods
  * rt2800_register_read and rt2800_register_write.
@@ -5079,7 +5086,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable powersaving as default on PCI devices.
 	 */
-	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
+	if ((rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) &&
+	    power_save_disabled)
 		rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	/*
-- 
1.6.0.2

