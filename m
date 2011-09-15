Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55485 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab1IOJHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:07:12 -0400
Received: by wwf22 with SMTP id 22so3405096wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 02:07:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx: remove P2P ie from probe response
Date: Thu, 15 Sep 2011 12:07:05 +0300
Message-Id: <1316077625-20014-2-git-send-email-eliad@wizery.com> (sfid-20110915_110717_619353_387DF546)
In-Reply-To: <1316077625-20014-1-git-send-email-eliad@wizery.com>
References: <1316077625-20014-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx uses a single probe response template, regardless of
the probe request.
However, the P2P spec forbids including the p2p ie in some
cases (e.g. the probe request didn't include the p2p ie).

The fw responds only to probe requests that don't
include the p2p ie, and passes up probe requests that
include them (the supplicant will answer them).

Thus, strip the p2p ie from the probe response template.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on "cfg80211: add cfg80211_find_vendor_ie() function"

 drivers/net/wireless/wl12xx/main.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a1d9639..168ca4e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3083,6 +3083,23 @@ static void wl12xx_remove_ie(struct sk_buff *skb, u8 eid, int ieoffset)
 	skb_trim(skb, skb->len - len);
 }
 
+static void wl12xx_remove_vendor_ie(struct sk_buff *skb,
+					    unsigned int oui, u8 oui_type,
+					    int ieoffset)
+{
+	int len;
+	const u8 *next, *end = skb->data + skb->len;
+	u8 *ie = (u8 *)cfg80211_find_vendor_ie(oui, oui_type,
+					       skb->data + ieoffset,
+					       skb->len - ieoffset);
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
@@ -3168,6 +3185,17 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		/* remove TIM ie from probe response */
 		wl12xx_remove_ie(beacon, WLAN_EID_TIM, ieoffset);
 
+		/*
+		 * remove p2p ie from probe response.
+		 * the fw reponds to probe requests that don't include
+		 * the p2p ie. probe requests with p2p ie will be passed,
+		 * and will be responded by the supplicant (the spec
+		 * forbids including the p2p ie when responding to probe
+		 * requests that didn't include it).
+		 */
+		wl12xx_remove_vendor_ie(beacon, WLAN_OUI_WFA,
+					WLAN_OUI_TYPE_WFA_P2P, ieoffset);
+
 		hdr = (struct ieee80211_hdr *) beacon->data;
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_PROBE_RESP);
-- 
1.7.6.401.g6a319

