Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZGBX6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 19:58:48 -0400
Date: Fri, 3 Jul 2009 02:00:48 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: check for current_bss from giwrate
Message-ID: <20090703000044.GB4143@sortiz.org>
References: <20090701192641.072258140@sipsolutions.net> <20090701193421.155074452@sipsolutions.net>
MIME-Version: 1.0
In-Reply-To: <20090701193421.155074452@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


When connecting to an ESSID manually, we may not set the BSSID, and thus
wdev->wext.connect.bssid will be NULL.
wdev->current_bss is always updated when a connection is established so we
should check it first.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 net/wireless/wext-compat.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: iwm-2.6/net/wireless/wext-compat.c
===================================================================
--- iwm-2.6.orig/net/wireless/wext-compat.c	2009-07-03 01:40:09.000000000 +0200
+++ iwm-2.6/net/wireless/wext-compat.c	2009-07-03 01:40:18.000000000 +0200
@@ -1137,8 +1137,11 @@ int cfg80211_wext_giwrate(struct net_dev
 	if (!rdev->ops->get_station)
 		return -EOPNOTSUPP;
 
-	addr = wdev->wext.connect.bssid;
-	if (!addr)
+	if (wdev->current_bss)
+		addr = wdev->current_bss->bssid;
+	else if (wdev->wext.connect.bssid)
+		addr = wdev->wext.connect.bssid;
+	else
 		return -ENOTSUPP;
 
 	err = rdev->ops->get_station(&rdev->wiphy, dev, addr, &sinfo);
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

