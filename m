Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41326 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1ISQPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:15:32 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 1/9] ath6kl: Fix BSS update on roaming
Date: Mon, 19 Sep 2011 19:14:59 +0300
Message-ID: <1316448907-10166-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181537_186422_EC9E278A)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the BSS "update" just before the connected or roamed event.
The previous implementation was completely broken: it forced a hardcoded
signal strength and IEs from Association _Request_ frame instead of any
Beacon information. This broke various things, including PMKSA caching.

The current workaround for creating a dummy BSS entry before the roamed
event is not exactly ideal, but that is quite a bit better than the
previous state. As a future improvement, cfg80211 could potentially be
extended to allow this type of use or ath6kl could delay sending the
roamed event before receiving a BSS info event.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  141 +++++++++++-----------------
 1 files changed, 56 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e196097e..5ede3d2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -413,6 +413,53 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ath6kl_add_bss_if_needed(struct ath6kl *ar, const u8 *bssid,
+				    struct ieee80211_channel *chan,
+				    const u8 *beacon_ie, size_t beacon_ie_len)
+{
+	struct cfg80211_bss *bss;
+	u8 *ie;
+
+	bss = cfg80211_get_bss(ar->wdev->wiphy, chan, bssid,
+			       ar->ssid, ar->ssid_len, WLAN_CAPABILITY_ESS,
+			       WLAN_CAPABILITY_ESS);
+	if (bss == NULL) {
+		/*
+		 * Since cfg80211 may not yet know about the BSS,
+		 * generate a partial entry until the first BSS info
+		 * event becomes available.
+		 *
+		 * Prepend SSID element since it is not included in the Beacon
+		 * IEs from the target.
+		 */
+		ie = kmalloc(2 + ar->ssid_len + beacon_ie_len, GFP_KERNEL);
+		if (ie == NULL)
+			return -ENOMEM;
+		ie[0] = WLAN_EID_SSID;
+		ie[1] = ar->ssid_len;
+		memcpy(ie + 2, ar->ssid, ar->ssid_len);
+		memcpy(ie + 2 + ar->ssid_len, beacon_ie, beacon_ie_len);
+		bss = cfg80211_inform_bss(ar->wdev->wiphy, chan,
+					  bssid, 0, WLAN_CAPABILITY_ESS, 100,
+					  ie, 2 + ar->ssid_len + beacon_ie_len,
+					  0, GFP_KERNEL);
+		if (bss)
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "added dummy bss for "
+				   "%pM prior to indicating connect/roamed "
+				   "event\n", bssid);
+		kfree(ie);
+	} else
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss "
+			   "entry\n");
+
+	if (bss == NULL)
+		return -ENOMEM;
+
+	cfg80211_put_bss(bss);
+
+	return 0;
+}
+
 void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 				   u8 *bssid, u16 listen_intvl,
 				   u16 beacon_intvl,
@@ -420,17 +467,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 				   u8 beacon_ie_len, u8 assoc_req_len,
 				   u8 assoc_resp_len, u8 *assoc_info)
 {
-	u16 size = 0;
-	u16 capability = 0;
-	struct cfg80211_bss *bss = NULL;
-	struct ieee80211_mgmt *mgmt = NULL;
-	struct ieee80211_channel *ibss_ch = NULL;
-	s32 signal = 50 * 100;
-	u8 ie_buf_len = 0;
-	unsigned char ie_buf[256];
-	unsigned char *ptr_ie_buf = ie_buf;
-	unsigned char *ieeemgmtbuf = NULL;
-	u8 source_mac[ETH_ALEN];
+	struct ieee80211_channel *chan;
 
 	/* capinfo + listen interval */
 	u8 assoc_req_ie_offset = sizeof(u16) + sizeof(u16);
@@ -462,84 +499,18 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 		}
 	}
 
-	/*
-	 * Earlier we were updating the cfg about bss by making a beacon frame
-	 * only if the entry for bss is not there. This can have some issue if
-	 * ROAM event is generated and a heavy traffic is ongoing. The ROAM
-	 * event is handled through a work queue and by the time it really gets
-	 * handled, BSS would have been aged out. So it is better to update the
-	 * cfg about BSS irrespective of its entry being present right now or
-	 * not.
-	 */
-
-	if (nw_type & ADHOC_NETWORK) {
-		/* construct 802.11 mgmt beacon */
-		if (ptr_ie_buf) {
-			*ptr_ie_buf++ = WLAN_EID_SSID;
-			*ptr_ie_buf++ = ar->ssid_len;
-			memcpy(ptr_ie_buf, ar->ssid, ar->ssid_len);
-			ptr_ie_buf += ar->ssid_len;
-
-			*ptr_ie_buf++ = WLAN_EID_IBSS_PARAMS;
-			*ptr_ie_buf++ = 2;	/* length */
-			*ptr_ie_buf++ = 0;	/* ATIM window */
-			*ptr_ie_buf++ = 0;	/* ATIM window */
-
-			/* TODO: update ibss params and include supported rates,
-			 * DS param set, extened support rates, wmm. */
-
-			ie_buf_len = ptr_ie_buf - ie_buf;
-		}
-
-		capability |= WLAN_CAPABILITY_IBSS;
-
-		if (ar->prwise_crypto == WEP_CRYPT)
-			capability |= WLAN_CAPABILITY_PRIVACY;
+	chan = ieee80211_get_channel(ar->wdev->wiphy, (int) channel);
 
-		memcpy(source_mac, ar->net_dev->dev_addr, ETH_ALEN);
-		ptr_ie_buf = ie_buf;
-	} else {
-		capability = *(u16 *) (&assoc_info[beacon_ie_len]);
-		memcpy(source_mac, bssid, ETH_ALEN);
-		ptr_ie_buf = assoc_req_ie;
-		ie_buf_len = assoc_req_len;
-	}
 
-	size = offsetof(struct ieee80211_mgmt, u)
-	+ sizeof(mgmt->u.beacon)
-	+ ie_buf_len;
-
-	ieeemgmtbuf = kzalloc(size, GFP_ATOMIC);
-	if (!ieeemgmtbuf) {
-		ath6kl_err("ieee mgmt buf alloc error\n");
+	if (nw_type & ADHOC_NETWORK) {
+		cfg80211_ibss_joined(ar->net_dev, bssid, GFP_KERNEL);
 		return;
 	}
 
-	mgmt = (struct ieee80211_mgmt *)ieeemgmtbuf;
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_BEACON);
-	memset(mgmt->da, 0xff, ETH_ALEN);	/* broadcast addr */
-	memcpy(mgmt->sa, source_mac, ETH_ALEN);
-	memcpy(mgmt->bssid, bssid, ETH_ALEN);
-	mgmt->u.beacon.beacon_int = cpu_to_le16(beacon_intvl);
-	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
-	memcpy(mgmt->u.beacon.variable, ptr_ie_buf, ie_buf_len);
-
-	ibss_ch = ieee80211_get_channel(ar->wdev->wiphy, (int)channel);
-
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
-		   "%s: inform bss with bssid %pM channel %d beacon_intvl %d capability 0x%x\n",
-		   __func__, mgmt->bssid, ibss_ch->hw_value,
-		   beacon_intvl, capability);
-
-	bss = cfg80211_inform_bss_frame(ar->wdev->wiphy,
-					ibss_ch, mgmt,
-					size, signal, GFP_KERNEL);
-	kfree(ieeemgmtbuf);
-	cfg80211_put_bss(bss);
-
-	if (nw_type & ADHOC_NETWORK) {
-		cfg80211_ibss_joined(ar->net_dev, bssid, GFP_KERNEL);
+	if (ath6kl_add_bss_if_needed(ar, bssid, chan, assoc_info,
+				     beacon_ie_len) < 0) {
+		ath6kl_err("could not add cfg80211 bss entry for "
+			   "connect/roamed notification\n");
 		return;
 	}
 
@@ -552,7 +523,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 					WLAN_STATUS_SUCCESS, GFP_KERNEL);
 	} else if (ar->sme_state == SME_CONNECTED) {
 		/* inform roam event to cfg80211 */
-		cfg80211_roamed(ar->net_dev, ibss_ch, bssid,
+		cfg80211_roamed(ar->net_dev, chan, bssid,
 				assoc_req_ie, assoc_req_len,
 				assoc_resp_ie, assoc_resp_len, GFP_KERNEL);
 	}
-- 
1.7.4.1

