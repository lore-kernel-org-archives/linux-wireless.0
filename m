Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:48958 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZBNAjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 19:39:22 -0500
Date: Fri, 13 Feb 2009 16:39:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org, akpm <akpm@linux-foundation.org>,
	linville@tuxdriver.com
Subject: [PATCH -next/mmotm/resend/lost] wireless: fix for CONFIG_NL80211=n
Message-Id: <20090213163935.ea924a9a.randy.dunlap@oracle.com> (sfid-20090214_013927_260784_1DD3BDE7)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Add empty function for case of CONFIG_NL80211=n:

net/wireless/scan.c:35: error: implicit declaration of function 'nl80211_send_scan_aborted'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/wireless/nl80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20090212.orig/net/wireless/nl80211.h
+++ linux-next-20090212/net/wireless/nl80211.h
@@ -27,6 +27,10 @@ static inline void
 nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 		       struct net_device *netdev)
 {}
+static inline void nl80211_send_scan_aborted(
+					struct cfg80211_registered_device *rdev,
+					struct net_device *netdev)
+{}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
