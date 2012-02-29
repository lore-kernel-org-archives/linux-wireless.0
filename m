Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26882 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2B2GgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 01:36:19 -0500
Date: Wed, 29 Feb 2012 09:35:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/4] rndis_wlan: integer overflows in
 rndis_wlan_do_link_up_work()
Message-ID: <20120229063555.GC18031@elgon.mountain> (sfid-20120229_073624_219412_643C1DE0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If "offset" is negative then we can get past this check:
	if (offset > CONTROL_BUFFER_SIZE)
Or if we pick a very high "req_ie_len" then we can get around the check:
	if (offset + req_ie_len > CONTROL_BUFFER_SIZE)

I made "resp_ie_len" and "req_ie_len" unsigned.  I don't know if it was
intentional that they were signed in the original.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index a330c69..6d8a986 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2755,9 +2755,10 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_assoc_info *info = NULL;
 	u8 bssid[ETH_ALEN];
-	int resp_ie_len, req_ie_len;
+	unsigned int resp_ie_len, req_ie_len;
+	unsigned int offset;
 	u8 *req_ie, *resp_ie;
-	int ret, offset;
+	int ret;
 	bool roamed = false;
 	bool match_bss;
 
@@ -2785,6 +2786,8 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 		ret = get_association_info(usbdev, info, CONTROL_BUFFER_SIZE);
 		if (!ret) {
 			req_ie_len = le32_to_cpu(info->req_ie_length);
+			if (req_ie_len > CONTROL_BUFFER_SIZE)
+				req_ie_len = CONTROL_BUFFER_SIZE;
 			if (req_ie_len > 0) {
 				offset = le32_to_cpu(info->offset_req_ies);
 
@@ -2799,6 +2802,8 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 			}
 
 			resp_ie_len = le32_to_cpu(info->resp_ie_length);
+			if (resp_ie_len > CONTROL_BUFFER_SIZE)
+				resp_ie_len = CONTROL_BUFFER_SIZE;
 			if (resp_ie_len > 0) {
 				offset = le32_to_cpu(info->offset_resp_ies);
 
