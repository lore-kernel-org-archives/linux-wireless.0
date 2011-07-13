Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965089Ab1GMIli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:38 -0400
Message-Id: <20110713084035.355518062@sipsolutions.net> (sfid-20110713_104143_035717_4B243190)
Date: Wed, 13 Jul 2011 10:39:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/11] mwifiex: add wext include
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In trying to remove the wext includes from mac80211
and cfg80211 I found that mwifiex currently uses
them. This is wrong, it shouldn't, but to not break
it completely include wext there.

Please remove this and fix all the resulting bugs.

Cc: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/ioctl.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mwifiex/ioctl.h	2011-07-13 10:29:57.000000000 +0200
+++ b/drivers/net/wireless/mwifiex/ioctl.h	2011-07-13 10:32:42.000000000 +0200
@@ -20,6 +20,7 @@
 #ifndef _MWIFIEX_IOCTL_H_
 #define _MWIFIEX_IOCTL_H_
 
+#include <linux/wireless.h>
 #include <net/mac80211.h>
 
 enum {


