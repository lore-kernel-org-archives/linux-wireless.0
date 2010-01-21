Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:23554 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752103Ab0AURYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 12:24:49 -0500
Date: Thu, 21 Jan 2010 18:26:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH v2] libertas: Set/clear WPA keys before the WEP ones
Message-ID: <20100121172618.GA17610@sortiz.org>
References: <20100118231920.GH5176@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100118231920.GH5176@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


With the v10 firmware running on 8688 HW, clearing WPA keys after setting the
WEP key prevents us from being able to associate with WEP APs.
Swapping the calling order for assoc_helper_wpa_keys() and
assoc_helper_wep_keys() fixes that issue.

Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/libertas/assoc.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 5e650f3..e15a83a 100644
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
@@ -2071,6 +2064,10 @@ void lbs_association_worker(struct work_struct *work)
 			goto out;
 	}
 
+	/* v10 FW wants WPA keys to be set/cleared before WEP key operations,
+	 * otherwise it will fail to correctly associate to WEP networks.
+	 * Other firmware versions don't appear to care.
+	 */
 	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)
 	    || test_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags)) {
 		ret = assoc_helper_wpa_keys(priv, assoc_req);
@@ -2078,6 +2075,14 @@ void lbs_association_worker(struct work_struct *work)
 			goto out;
 	}
 
+	if (test_bit(ASSOC_FLAG_WEP_KEYS, &assoc_req->flags)
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
