Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44709 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab0AESRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:17:00 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 3603AEF55C
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:59 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 0B6951C6391
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:58 +0200 (EET)
Subject: [PATCH v2 7/9] wl1251: get probe request template from mac80211
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 20:16:57 +0200
Message-ID: <20100105181657.27418.46559.stgit@tikku>
In-Reply-To: <20100105181522.27418.97100.stgit@tikku>
References: <20100105181522.27418.97100.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Instead of creating the template in driver, get it from mac80211 instead.
Thanks to this, three functions can be now removed.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   86 ++++-------------------------
 1 files changed, 12 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index e038707..1db9722 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -831,82 +831,11 @@ out:
 	return ret;
 }
 
-static int wl1251_build_basic_rates(char *rates)
-{
-	u8 index = 0;
-
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_5MB;
-	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_11MB;
-
-	return index;
-}
-
-static int wl1251_build_extended_rates(char *rates)
-{
-	u8 index = 0;
-
-	rates[index++] = IEEE80211_OFDM_RATE_6MB;
-	rates[index++] = IEEE80211_OFDM_RATE_9MB;
-	rates[index++] = IEEE80211_OFDM_RATE_12MB;
-	rates[index++] = IEEE80211_OFDM_RATE_18MB;
-	rates[index++] = IEEE80211_OFDM_RATE_24MB;
-	rates[index++] = IEEE80211_OFDM_RATE_36MB;
-	rates[index++] = IEEE80211_OFDM_RATE_48MB;
-	rates[index++] = IEEE80211_OFDM_RATE_54MB;
-
-	return index;
-}
-
-
-static int wl1251_build_probe_req(struct wl1251 *wl, u8 *ssid, size_t ssid_len)
-{
-	struct wl12xx_probe_req_template template;
-	struct wl12xx_ie_rates *rates;
-	char *ptr;
-	u16 size;
-
-	ptr = (char *)&template;
-	size = sizeof(struct ieee80211_header);
-
-	memset(template.header.da, 0xff, ETH_ALEN);
-	memset(template.header.bssid, 0xff, ETH_ALEN);
-	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
-	template.header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-
-	/* IEs */
-	/* SSID */
-	template.ssid.header.id = WLAN_EID_SSID;
-	template.ssid.header.len = ssid_len;
-	if (ssid_len && ssid)
-		memcpy(template.ssid.ssid, ssid, ssid_len);
-	size += sizeof(struct wl12xx_ie_header) + ssid_len;
-	ptr += size;
-
-	/* Basic Rates */
-	rates = (struct wl12xx_ie_rates *)ptr;
-	rates->header.id = WLAN_EID_SUPP_RATES;
-	rates->header.len = wl1251_build_basic_rates(rates->rates);
-	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
-	ptr += sizeof(struct wl12xx_ie_header) + rates->header.len;
-
-	/* Extended rates */
-	rates = (struct wl12xx_ie_rates *)ptr;
-	rates->header.id = WLAN_EID_EXT_SUPP_RATES;
-	rates->header.len = wl1251_build_extended_rates(rates->rates);
-	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
-
-	wl1251_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
-
-	return wl1251_cmd_template_set(wl, CMD_PROBE_REQ, &template,
-				      size);
-}
-
 static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 			     struct cfg80211_scan_request *req)
 {
 	struct wl1251 *wl = hw->priv;
+	struct sk_buff *skb;
 	size_t ssid_len = 0;
 	u8 *ssid = NULL;
 	int ret;
@@ -930,9 +859,18 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1251_build_probe_req(wl, ssid, ssid_len);
+	skb = ieee80211_probereq_get(wl->hw, wl->vif, ssid, ssid_len,
+				     req->ie, req->ie_len);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1251_cmd_template_set(wl, CMD_PROBE_REQ, skb->data,
+				      skb->len);
+	dev_kfree_skb(skb);
 	if (ret < 0)
-		wl1251_error("probe request template build failed");
+		goto out_sleep;
 
 	ret = wl1251_cmd_trigger_scan_to(wl, 0);
 	if (ret < 0)

