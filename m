Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59016 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab0ARXRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 18:17:48 -0500
Date: Tue, 19 Jan 2010 00:19:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: Set/clear WPA keys before the WEP ones
Message-ID: <20100118231920.GH5176@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


With the v10 firmware running on 8688 HW, clearing WPA keys after setting the
WEP key prevents us from being able to associate with WEP APs.
Swapping the calling order for assoc_helper_wpa_keys() and
assoc_helper_wep_keys fixes that issue.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/libertas/assoc.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 5e650f3..fb3dff0 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -2052,13 +2052,6 @@ void lbs_association_worker(struct work_struct *work)
 			goto out;
 	}
 
-	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
-	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
-		ret = assoc_helper_wep_keys(priv, assoc_req);
-		if (ret)
-			goto out;
-	}
-
 	if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
 		ret = assoc_helper_secinfo(priv, assoc_req);
 		if (ret)
@@ -2078,6 +2071,14 @@ void lbs_association_worker(struct work_struct *work)
 			goto out;
 	}
 
+	if (   test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
+	    || test_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags)) {
+		ret = assoc_helper_wep_keys(priv, assoc_req);
+		if (ret)
+			goto out;
+	}
+
+
 	/* SSID/BSSID should be the _last_ config option set, because they
 	 * trigger the association attempt.
 	 */
-- 
1.6.3.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
