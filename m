Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:57080 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1EWAYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 20:24:08 -0400
Date: Sun, 22 May 2011 17:16:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH] wireless: fix cfg80211.h new kernel-doc warnings
Message-Id: <20110522171620.51458555.randy.dunlap@oracle.com> (sfid-20110523_022416_429934_78E3CABF)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc warnings in <net/cfg80211.h>:

Warning(linux-2.6.39-git5/include/net/cfg80211.h:560): No description found for parameter 'bss_param'
Warning(linux-2.6.39-git5/include/net/cfg80211.h:1555): Enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' not described in enum 'wiphy_flags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/cfg80211.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.39-git5.orig/include/net/cfg80211.h
+++ linux-2.6.39-git5/include/net/cfg80211.h
@@ -531,6 +531,7 @@ struct sta_bss_parameters {
  * @tx_retries: cumulative retry counts
  * @tx_failed: number of failed transmissions (retries exceeded, no ACK)
  * @rx_dropped_misc:  Dropped for un-specified reason.
+ * @bss_param: current BSS parameters
  * @generation: generation number for nl80211 dumps.
  *	This number should increase every time the list of stations
  *	changes, i.e. when a station is added or removed, so that
@@ -1537,7 +1538,7 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
- * @WIPHY_FLAG_SCHED_SCAN: The device supports scheduled scans.
+ * @WIPHY_FLAG_SUPPORTS_SCHED_SCAN: The device supports scheduled scans.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
