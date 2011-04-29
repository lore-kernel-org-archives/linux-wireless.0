Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:42975 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518Ab1D2RLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 13:11:52 -0400
Subject: [PATCH 1/2] staging: ath6kl: cfg80211_roam issue; driver wedge
To: gregkh@suse.de
From: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Fri, 29 Apr 2011 20:02:20 +0300
Message-ID: <20110429170220.26819.66972.stgit@x201> (sfid-20110429_191156_370927_B5707017)
In-Reply-To: <20110429165934.26819.76573.stgit@x201>
References: <20110429165934.26819.76573.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

If a heavy traffic is undergoing and a link is lost (bcn miss),
wlan driver does a reconnection on its own and after connection
is re-established, reports it as ROAM_EVENT to cfg. Now this event
is handled as work queue. It could very well happen that by the
time this event gets handled, cfg would have aged out the bss and
we get the following WARN_ON in __cfg80211_roamed function in file
net/wireless/sme.c.

        /* internal error -- how did we get to CONNECTED w/o BSS? */
        if (WARN_ON(!wdev->current_bss)) {
                return;
        }
To resolve the issue we report the BSS whenever we send a connect or
roam event to the cfg.

kvalo: fix style issues

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |   96 +++++++++++++++-------------
 1 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index e87d3aa..f6e3817 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -487,74 +487,82 @@ ar6k_cfg80211_connect_event(struct ar6_softc *ar, u16 channel,
                            ((ADHOC_NETWORK & networkType) ? WLAN_CAPABILITY_IBSS : WLAN_CAPABILITY_ESS),
                            ((ADHOC_NETWORK & networkType) ? WLAN_CAPABILITY_IBSS : WLAN_CAPABILITY_ESS));
 
-    if(!bss) {
-        if (ADHOC_NETWORK & networkType) {
+    /*
+     * Earlier we were updating the cfg about bss by making a beacon frame
+     * only if the entry for bss is not there. This can have some issue if
+     * ROAM event is generated and a heavy traffic is ongoing. The ROAM
+     * event is handled through a work queue and by the time it really gets
+     * handled, BSS would have been aged out. So it is better to update the
+     * cfg about BSS irrespective of its entry being present right now or
+     * not.
+     */
+
+    if (ADHOC_NETWORK & networkType) {
             /* construct 802.11 mgmt beacon */
             if(ptr_ie_buf) {
-                *ptr_ie_buf++ = WLAN_EID_SSID;
-                *ptr_ie_buf++ = ar->arSsidLen;
-                memcpy(ptr_ie_buf, ar->arSsid, ar->arSsidLen);
-                ptr_ie_buf +=ar->arSsidLen;
+		    *ptr_ie_buf++ = WLAN_EID_SSID;
+		    *ptr_ie_buf++ = ar->arSsidLen;
+		    memcpy(ptr_ie_buf, ar->arSsid, ar->arSsidLen);
+		    ptr_ie_buf +=ar->arSsidLen;
 
-                *ptr_ie_buf++ = WLAN_EID_IBSS_PARAMS;
-                *ptr_ie_buf++ = 2; /* length */
-                *ptr_ie_buf++ = 0; /* ATIM window */
-                *ptr_ie_buf++ = 0; /* ATIM window */
+		    *ptr_ie_buf++ = WLAN_EID_IBSS_PARAMS;
+		    *ptr_ie_buf++ = 2; /* length */
+		    *ptr_ie_buf++ = 0; /* ATIM window */
+		    *ptr_ie_buf++ = 0; /* ATIM window */
 
-                /* TODO: update ibss params and include supported rates,
-                 * DS param set, extened support rates, wmm. */
+		    /* TODO: update ibss params and include supported rates,
+		     * DS param set, extened support rates, wmm. */
 
-                ie_buf_len = ptr_ie_buf - ie_buf;
+		    ie_buf_len = ptr_ie_buf - ie_buf;
             }
 
             capability |= IEEE80211_CAPINFO_IBSS;
             if(WEP_CRYPT == ar->arPairwiseCrypto) {
-                capability |= IEEE80211_CAPINFO_PRIVACY;
+		    capability |= IEEE80211_CAPINFO_PRIVACY;
             }
             memcpy(source_mac, ar->arNetDev->dev_addr, ATH_MAC_LEN);
             ptr_ie_buf = ie_buf;
-        } else {
+    } else {
             capability = *(u16 *)(&assocInfo[beaconIeLen]);
             memcpy(source_mac, bssid, ATH_MAC_LEN);
             ptr_ie_buf = assocReqIe;
             ie_buf_len = assocReqLen;
-        }
+    }
 
-        size = offsetof(struct ieee80211_mgmt, u)
-             + sizeof(mgmt->u.beacon)
-             + ie_buf_len;
+    size = offsetof(struct ieee80211_mgmt, u)
+	    + sizeof(mgmt->u.beacon)
+	    + ie_buf_len;
 
-        ieeemgmtbuf = A_MALLOC_NOWAIT(size);
-        if(!ieeemgmtbuf) {
+    ieeemgmtbuf = A_MALLOC_NOWAIT(size);
+    if(!ieeemgmtbuf) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                             ("%s: ieeeMgmtbuf alloc error\n", __func__));
             return;
-        }
+    }
 
-        A_MEMZERO(ieeemgmtbuf, size);
-        mgmt = (struct ieee80211_mgmt *)ieeemgmtbuf;
-        mgmt->frame_control = (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
-        memcpy(mgmt->da, bcast_mac, ATH_MAC_LEN);
-        memcpy(mgmt->sa, source_mac, ATH_MAC_LEN);
-        memcpy(mgmt->bssid, bssid, ATH_MAC_LEN);
-        mgmt->u.beacon.beacon_int = beaconInterval;
-        mgmt->u.beacon.capab_info = capability;
-        memcpy(mgmt->u.beacon.variable, ptr_ie_buf, ie_buf_len);
+    A_MEMZERO(ieeemgmtbuf, size);
+    mgmt = (struct ieee80211_mgmt *)ieeemgmtbuf;
+    mgmt->frame_control = (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
+    memcpy(mgmt->da, bcast_mac, ATH_MAC_LEN);
+    memcpy(mgmt->sa, source_mac, ATH_MAC_LEN);
+    memcpy(mgmt->bssid, bssid, ATH_MAC_LEN);
+    mgmt->u.beacon.beacon_int = beaconInterval;
+    mgmt->u.beacon.capab_info = capability;
+    memcpy(mgmt->u.beacon.variable, ptr_ie_buf, ie_buf_len);
 
-        ibss_channel = ieee80211_get_channel(ar->wdev->wiphy, (int)channel);
+    ibss_channel = ieee80211_get_channel(ar->wdev->wiphy, (int)channel);
 
-	AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
-		("%s: inform bss with bssid %pM channel %d beaconInterval %d "
-			"capability 0x%x\n", __func__, mgmt->bssid,
-			ibss_channel->hw_value, beaconInterval, capability));
-
-        bss = cfg80211_inform_bss_frame(ar->wdev->wiphy,
-                                        ibss_channel, mgmt,
-                                        le16_to_cpu(size),
-                                        signal, GFP_KERNEL);
-        kfree(ieeemgmtbuf);
-        cfg80211_put_bss(bss);
-    }
+    AR_DEBUG_PRINTF(ATH_DEBUG_INFO,
+		    ("%s: inform bss with bssid %pM channel %d beaconInterval %d "
+		     "capability 0x%x\n", __func__, mgmt->bssid,
+		     ibss_channel->hw_value, beaconInterval, capability));
+
+    bss = cfg80211_inform_bss_frame(ar->wdev->wiphy,
+				    ibss_channel, mgmt,
+				    le16_to_cpu(size),
+				    signal, GFP_KERNEL);
+    kfree(ieeemgmtbuf);
+    cfg80211_put_bss(bss);
 
     if((ADHOC_NETWORK & networkType)) {
         cfg80211_ibss_joined(ar->arNetDev, bssid, GFP_KERNEL);

