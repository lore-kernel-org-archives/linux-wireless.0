Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35026 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483AbZCTNxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 09:53:30 -0400
Date: Fri, 20 Mar 2009 15:53:16 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix memleak in nl80211 authentication on deinit
Message-ID: <20090320135316.GA10874@jm.kir.nu> (sfid-20090320_145344_419288_347749CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file was forgotten from the quilt patch that added MLME
primitives, so the kfree on interface removal is missing. Fix this
potential memleak by freeing the temporary Authentication frame IEs
from SME when the interface is being removed.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/iface.c |    1 +
 1 file changed, 1 insertion(+)

--- uml.orig/net/mac80211/iface.c	2009-03-20 15:30:26.000000000 +0200
+++ uml/net/mac80211/iface.c	2009-03-20 15:31:46.000000000 +0200
@@ -660,6 +660,7 @@ static void ieee80211_teardown_sdata(str
 		kfree(sdata->u.mgd.ie_reassocreq);
 		kfree(sdata->u.mgd.ie_deauth);
 		kfree(sdata->u.mgd.ie_disassoc);
+		kfree(sdata->u.mgd.sme_auth_ie);
 		break;
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:

-- 
Jouni Malinen                                            PGP id EFC895FA
