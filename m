Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:56039 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZBLRi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 12:38:26 -0500
Message-ID: <49945E98.70002@oracle.com> (sfid-20090212_183830_146685_748C36EF)
Date: Thu, 12 Feb 2009 09:38:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] wireless: fix for CONFIG_NL80211=n
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
In-Reply-To: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
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
