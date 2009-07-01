Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZGAM6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 08:58:17 -0400
Subject: [PATCH] iwlwifi: fix aggregation limit
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 14:57:59 +0200
Message-Id: <1246453079.4131.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the documentation, the limit is 0x3f == 63, not 64.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
It seems bug 2018 is related to the link quality command, because it
seems I can trivially trigger it or similar bugs that way, but this
doesn't fix it.

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-commands.h	2009-07-01 14:53:33.804427206 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-commands.h	2009-07-01 14:53:38.924427592 +0200
@@ -1922,7 +1922,7 @@ struct iwl_link_qual_general_params {
 #define LINK_QUAL_AGG_DISABLE_START_MIN	(0)
 
 #define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(31)
-#define LINK_QUAL_AGG_FRAME_LIMIT_MAX	(64)
+#define LINK_QUAL_AGG_FRAME_LIMIT_MAX	0x3f
 #define LINK_QUAL_AGG_FRAME_LIMIT_MIN	(0)
 
 /**


