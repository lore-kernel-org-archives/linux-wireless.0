Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19750 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954Ab2B2GuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 01:50:00 -0500
Date: Wed, 29 Feb 2012 09:36:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/4] rndis_wlan: remove unneeded variables
Message-ID: <20120229063628.GD18031@elgon.mountain> (sfid-20120229_075008_892506_92A37071)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We never use the "len" variable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 6d8a986..99fab7d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1790,9 +1790,8 @@ static struct ndis_80211_pmkid *remove_pmkid(struct usbnet *usbdev,
 						struct cfg80211_pmksa *pmksa,
 						int max_pmkids)
 {
-	int i, len, count, newlen, err;
+	int i, count, newlen, err;
 
-	len = le32_to_cpu(pmkids->length);
 	count = le32_to_cpu(pmkids->bssid_info_count);
 
 	if (count > max_pmkids)
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 99fab7d..a93cfe2 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1830,9 +1830,8 @@ static struct ndis_80211_pmkid *update_pmkid(struct usbnet *usbdev,
 						struct cfg80211_pmksa *pmksa,
 						int max_pmkids)
 {
-	int i, err, len, count, newlen;
+	int i, err, count, newlen;
 
-	len = le32_to_cpu(pmkids->length);
 	count = le32_to_cpu(pmkids->bssid_info_count);
 
 	if (count > max_pmkids)
