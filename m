Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZF3Pd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 11:33:26 -0400
Date: Tue, 30 Jun 2009 17:35:26 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: set conn.state properly in the connect() case
Message-ID: <20090630153522.GA28206@sortiz.org>
References: <20090630115245.675553951@sipsolutions.net> <20090630115301.625487032@sipsolutions.net>
MIME-Version: 1.0
In-Reply-To: <20090630115301.625487032@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We need to set the conn.state to ASSOCIATING for the ->connect() path. By
default, it is set to 0, i.e. SCANNING, which causes sme_scan_done() to
eventually call conn_do_work(), which then would call assoc() and auth()
blindly. That's why we also bug on those hooks not being defined there.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 net/wireless/sme.c |    3 +++
 1 file changed, 3 insertions(+)

Index: iwm-2.6/net/wireless/sme.c
===================================================================
--- iwm-2.6.orig/net/wireless/sme.c	2009-06-30 16:39:58.000000000 +0200
+++ iwm-2.6/net/wireless/sme.c	2009-06-30 17:17:14.000000000 +0200
@@ -103,6 +103,7 @@ static int cfg80211_conn_do_work(struct 
 		u.auth_req.ie = NULL;
 		u.auth_req.ie_len = 0;
 		wdev->conn.state = CFG80211_CONN_AUTHENTICATING;
+		BUG_ON(!drv->ops->auth);
 		return drv->ops->auth(wdev->wiphy, wdev->netdev, &u.auth_req);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		u.assoc_req.chan = wdev->conn.params.channel;
@@ -115,6 +116,7 @@ static int cfg80211_conn_do_work(struct 
 		memcpy(&u.assoc_req.crypto, &wdev->conn.params.crypto,
 			sizeof(u.assoc_req.crypto));
 		wdev->conn.state = CFG80211_CONN_ASSOCIATING;
+		BUG_ON(!drv->ops->assoc);
 		return drv->ops->assoc(wdev->wiphy, wdev->netdev,
 					&u.assoc_req);
 	default:
@@ -455,6 +457,7 @@ int cfg80211_connect(struct cfg80211_reg
 		return err;
 	} else {
 		wdev->sme_state = CFG80211_SME_CONNECTING;
+		wdev->conn.state = CFG80211_CONN_ASSOCIATING;
 		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
 		if (err) {
 			wdev->sme_state = CFG80211_SME_IDLE;
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

