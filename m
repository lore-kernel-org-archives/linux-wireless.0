Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbXLJRPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:15:01 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 22/48] libertas: Don't set IW_ENCODE_NOKEY when returning WEP keys.
Message-Id: <E1J1kpR-0006lt-6f@shinybook.infradead.org> (sfid-20071210_171507_469285_BCED61FE)
Date: Mon, 10 Dec 2007 10:45:57 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Fri, 7 Dec 2007 19:32:12 +0000

Also clean up the double setting/clearing of IW_ENCODE_DISABLED.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/wext.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index b8c93c0..1af140b 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1122,14 +1122,6 @@ static int lbs_get_encode(struct net_device *dev,
 		break;
 	}
 
-	if (   adapter->secinfo.wep_enabled
-	    || adapter->secinfo.WPAenabled
-	    || adapter->secinfo.WPA2enabled) {
-		dwrq->flags &= ~IW_ENCODE_DISABLED;
-	} else {
-		dwrq->flags |= IW_ENCODE_DISABLED;
-	}
-
 	memset(extra, 0, 16);
 
 	mutex_lock(&adapter->lock);
@@ -1150,14 +1142,13 @@ static int lbs_get_encode(struct net_device *dev,
 		   || (adapter->secinfo.WPA2enabled)) {
 		/* return WPA enabled */
 		dwrq->flags &= ~IW_ENCODE_DISABLED;
+		dwrq->flags |= IW_ENCODE_NOKEY;
 	} else {
 		dwrq->flags |= IW_ENCODE_DISABLED;
 	}
 
 	mutex_unlock(&adapter->lock);
 
-	dwrq->flags |= IW_ENCODE_NOKEY;
-
 	lbs_deb_wext("key: %02x:%02x:%02x:%02x:%02x:%02x, keylen %d\n",
 	       extra[0], extra[1], extra[2],
 	       extra[3], extra[4], extra[5], dwrq->length);
-- 
1.5.3.4

