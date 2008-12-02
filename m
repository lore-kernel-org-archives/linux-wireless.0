Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:42047 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbYLBXGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 18:06:35 -0500
Received: by ug-out-1314.google.com with SMTP id 39so3222254ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 15:06:33 -0800 (PST)
Message-ID: <4935BF7F.4080109@gmail.com> (sfid-20081203_000643_014098_DE023235)
Date: Wed, 03 Dec 2008 00:06:39 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, linux-wireless@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] wlan: skb_p80211_to_ether() - payload_length is unsigned,
 check before subtraction
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

payload_length is unsigned, check before subtraction

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 68121b9..9dd8b77 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -333,11 +333,11 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		memcpy(saddr, w_hdr->a3.a2, WLAN_ETHADDR_LEN);
 	} else {
 		payload_offset = WLAN_HDR_A4_LEN;
-		payload_length -= ( WLAN_HDR_A4_LEN - WLAN_HDR_A3_LEN );
-		if (payload_length < 0 ) {
+		if (payload_length < WLAN_HDR_A4_LEN - WLAN_HDR_A3_LEN) {
 			WLAN_LOG_ERROR("A4 frame too short!\n");
 			return 1;
 		}
+		payload_length -= (WLAN_HDR_A4_LEN - WLAN_HDR_A3_LEN);
 		memcpy(daddr, w_hdr->a4.a3, WLAN_ETHADDR_LEN);
 		memcpy(saddr, w_hdr->a4.a4, WLAN_ETHADDR_LEN);
 	}

