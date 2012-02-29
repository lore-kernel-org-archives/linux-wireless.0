Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50008 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2B2Gil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 01:38:41 -0500
Date: Wed, 29 Feb 2012 09:36:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 3/4] rndis_wlan: make some variables unsigned
Message-ID: <20120229063657.GE18031@elgon.mountain> (sfid-20120229_073847_161188_EEFB9655)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These variables can never be less than zero because we cap them in
get_device_pmkids().  Let's make them unsigned here because it's simpler
to not have to worry about negative numbers when we read the code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index a93cfe2..74e2d1b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1790,7 +1790,8 @@ static struct ndis_80211_pmkid *remove_pmkid(struct usbnet *usbdev,
 						struct cfg80211_pmksa *pmksa,
 						int max_pmkids)
 {
-	int i, count, newlen, err;
+	int i, newlen, err;
+	unsigned int count;
 
 	count = le32_to_cpu(pmkids->bssid_info_count);
 
@@ -1830,7 +1831,8 @@ static struct ndis_80211_pmkid *update_pmkid(struct usbnet *usbdev,
 						struct cfg80211_pmksa *pmksa,
 						int max_pmkids)
 {
-	int i, err, count, newlen;
+	int i, err, newlen;
+	unsigned int count;
 
 	count = le32_to_cpu(pmkids->bssid_info_count);
 
