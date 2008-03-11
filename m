Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [211.125.136.229] ([211.125.136.229]:44378 "EHLO
	ms13.sony.co.jp" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750859AbYCKFRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 01:17:07 -0400
Received: from ms6.sony.co.jp (ms6.Sony.CO.JP [211.125.136.204])
 by ms13.sony.co.jp (R8/Sony) with ESMTP id m2B4KsxP008256
 for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 13:20:54 +0900 (JST)
Date: Tue, 11 Mar 2008 13:15:44 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
Cc: linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
Message-Id: <20080311130630.0AF0.40F06B3A@sm.sony.co.jp> (sfid-20080311_051712_368863_0E0A4ECC)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some implementations of the hidden SSID APs emit beacons which have the zero
length SSID information element instead of SSID padded by null (\0) characters.
If the firmware of the PS3 wireless hardware meets these beacons, it abandons parsing
IEs. Thus guest OSes get the invalid scan information for the AP.

To work around this, ignore these scan informations from the list.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---

This patch was submitted for 2.6.24.3 by Geert on Mar 10.  But I have not
submitted for 2.6.25 yet.  Please apply for 2.6.25.


 drivers/net/ps3_gelic_wireless.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1644,13 +1644,24 @@ static void gelic_wl_scan_complete_event
 	}
 
 	/* put them in the newtork_list */
-	scan_info = wl->buf;
-	scan_info_size = 0;
-	i = 0;
-	while (scan_info_size < data_len) {
+	for (i = 0, scan_info_size = 0, scan_info = wl->buf;
+	     scan_info_size < data_len;
+	     i++, scan_info_size += be16_to_cpu(scan_info->size),
+	     scan_info = (void *)scan_info + be16_to_cpu(scan_info->size)) {
 		pr_debug("%s:size=%d bssid=%s scan_info=%p\n", __func__,
 			 be16_to_cpu(scan_info->size),
 			 print_mac(mac, &scan_info->bssid[2]), scan_info);
+
+		/*
+		 * The wireless firmware may return invalid channel 0 and/or
+		 * invalid rate if the AP emits zero length SSID ie. As this
+		 * scan information is useless, ignore it
+		 */
+		if (!be16_to_cpu(scan_info->channel) || !scan_info->rate[0]) {
+			pr_debug("%s: invalid scan info\n", __func__);
+			continue;
+		}
+
 		found = 0;
 		oldest = NULL;
 		list_for_each_entry(target, &wl->network_list, list) {
@@ -1687,10 +1698,6 @@ static void gelic_wl_scan_complete_event
 					 GFP_KERNEL);
 		if (!target->hwinfo) {
 			pr_info("%s: kzalloc failed\n", __func__);
-			i++;
-			scan_info_size += be16_to_cpu(scan_info->size);
-			scan_info = (void *)scan_info +
-				be16_to_cpu(scan_info->size);
 			continue;
 		}
 		/* copy hw scan info */
@@ -1709,10 +1716,6 @@ static void gelic_wl_scan_complete_event
 			if (scan_info->ext_rate[r])
 				target->rate_ext_len++;
 		list_move_tail(&target->list, &wl->network_list);
-		/* bump pointer */
-		i++;
-		scan_info_size += be16_to_cpu(scan_info->size);
-		scan_info = (void *)scan_info + be16_to_cpu(scan_info->size);
 	}
 	memset(&data, 0, sizeof(data));
 	wireless_send_event(port_to_netdev(wl_port(wl)), SIOCGIWSCAN, &data,

-- 
Masakazu MOKUNO

