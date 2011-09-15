Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38838 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab1IOJHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:07:10 -0400
Received: by wyh22 with SMTP id 22so2483131wyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 02:07:09 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: remove TIM ie from probe response
Date: Thu, 15 Sep 2011 12:07:04 +0300
Message-Id: <1316077625-20014-1-git-send-email-eliad@wizery.com> (sfid-20110915_110715_278978_BBE025D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx uses the beacon as the probe response template.
However, the beacon includes a TIM ie, which shouldn't
exist in the probe response.

Delete it from the skb before configuring the probe
response template.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 680f558..a1d9639 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3069,6 +3069,20 @@ static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 	return 0;
 }
 
+static void wl12xx_remove_ie(struct sk_buff *skb, u8 eid, int ieoffset)
+{
+	int len;
+	const u8 *next, *end = skb->data + skb->len;
+	u8 *ie = (u8 *)cfg80211_find_ie(eid, skb->data + ieoffset,
+					skb->len - ieoffset);
+	if (!ie)
+		return;
+	len = ie[1] + 2;
+	next = ie + len;
+	memmove(ie, next, end - next);
+	skb_trim(skb, skb->len - len);
+}
+
 static int wl1271_bss_erp_info_changed(struct wl1271 *wl,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
@@ -3151,6 +3165,9 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 			goto out;
 		}
 
+		/* remove TIM ie from probe response */
+		wl12xx_remove_ie(beacon, WLAN_EID_TIM, ieoffset);
+
 		hdr = (struct ieee80211_hdr *) beacon->data;
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_PROBE_RESP);
-- 
1.7.6.401.g6a319

