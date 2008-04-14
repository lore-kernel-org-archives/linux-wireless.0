Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms4.Sony.CO.JP ([211.125.136.198]:44062 "EHLO ms4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYDNJH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 05:07:26 -0400
Received: from mta8.sony.co.jp (mta8.Sony.CO.JP [137.153.71.15])
 by ms4.sony.co.jp (R8/Sony) with ESMTP id m3E97L5f004513
 for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 18:07:21 +0900 (JST)
Received: from mta8.sony.co.jp (localhost [127.0.0.1])
 by mta8.sony.co.jp (R8/Sony) with ESMTP id m3E97No7011097
 for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 18:07:23 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta8.sony.co.jp (R8/Sony) with ESMTP id m3E97MOu011092
 for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 18:07:22 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id m3E97LP20630 for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 18:07:21 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id m3E97Lp8007613
	for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 18:07:21 +0900 (JST)
Date: Mon, 14 Apr 2008 18:07:21 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] PS3: gelic: fix the oops on the broken IE returned from the hypervisor
Message-Id: <20080414174950.035A.40F06B3A@sm.sony.co.jp> (sfid-20080414_100738_770329_9F924CAC)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the bug that the driver would try to over-scan the memory
if the sum of the length field of every IEs does not match the length
returned from the hypervisor.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -512,13 +512,18 @@ static void gelic_wl_parse_ie(u8 *data, 
 		 data, len);
 	memset(ie_info, 0, sizeof(struct ie_info));
 
-	while (0 < data_left) {
+	while (2 <= data_left) {
 		item_id = *pos++;
 		item_len = *pos++;
+		data_left -= 2;
+
+		if (data_left < item_len)
+			break;
 
 		switch (item_id) {
 		case MFIE_TYPE_GENERIC:
-			if (!memcmp(pos, wpa_oui, OUI_LEN) &&
+			if ((OUI_LEN + 1 <= item_len) &&
+			    !memcmp(pos, wpa_oui, OUI_LEN) &&
 			    pos[OUI_LEN] == 0x01) {
 				ie_info->wpa.data = pos - 2;
 				ie_info->wpa.len = item_len + 2;
@@ -535,7 +540,7 @@ static void gelic_wl_parse_ie(u8 *data, 
 			break;
 		}
 		pos += item_len;
-		data_left -= item_len + 2;
+		data_left -= item_len;
 	}
 	pr_debug("%s: wpa=%p,%d wpa2=%p,%d\n", __func__,
 		 ie_info->wpa.data, ie_info->wpa.len,

-- 
Masakazu Mokuno

