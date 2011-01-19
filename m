Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1ASWe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:34:56 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:34:55 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 6/8] staging: brcm80211: Remove static ether_bcast.
Date: Wed, 19 Jan 2011 23:35:30 +0100
Message-Id: <1295476532-21130-7-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-6-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-4-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-5-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-6-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the static struct ether_bcast and use memset for setting the broadcast
address instead of copying the struct.
_

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    4 ++--
 drivers/staging/brcm80211/include/proto/ethernet.h |    2 --
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |    3 +--
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 991463f..c7e3837 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -648,7 +648,7 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 
 static void wl_iscan_prep(struct wl_scan_params *params, struct wlc_ssid *ssid)
 {
-	memcpy(&params->bssid, &ether_bcast, ETH_ALEN);
+	memset(&params->bssid, 0xff, ETH_ALEN);
 	params->bss_type = DOT11_BSSTYPE_ANY;
 	params->scan_type = 0;
 	params->nprobes = -1;
@@ -1373,7 +1373,7 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(join_params.ssid.SSID_len);
 	wl_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
-	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
+	memset(&join_params.params.bssid, 0xff, ETH_ALEN);
 
 	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
 	WL_DBG("join_param_size %d\n", join_params_size);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index db6e68e..346b190 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -1015,7 +1015,7 @@ static int wl_iw_iscan_prep(wl_scan_params_t *params, wlc_ssid_t *ssid)
 {
 	int err = 0;
 
-	memcpy(&params->bssid, &ether_bcast, ETH_ALEN);
+	memset(&params->bssid, 0xff, ETH_ALEN);
 	params->bss_type = DOT11_BSSTYPE_ANY;
 	params->scan_type = 0;
 	params->nprobes = -1;
@@ -1919,7 +1919,7 @@ wl_iw_set_essid(struct net_device *dev,
 
 	memcpy(&join_params.ssid.SSID, g_ssid.SSID, g_ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(g_ssid.SSID_len);
-	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
+	memset(&join_params.params.bssid, 0xff, ETH_ALEN);
 
 	wl_iw_ch_to_chanspec(g_wl_iw_params.target_channel, &join_params,
 			     &join_params_size);
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index 77deb94..b401fda 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -25,8 +25,6 @@ BWL_PRE_PACKED_STRUCT struct ether_addr {
 	u8 octet[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
 
-static const struct ether_addr ether_bcast = { {255, 255, 255, 255, 255, 255} };
-
 #include <packed_section_end.h>
 
 #endif				/* _NET_ETHERNET_H_ */
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 9c57573..0bf70fc 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -7658,8 +7658,7 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
 	/* A1 filled in by MAC for prb resp, broadcast for bcn */
 	if (type == FC_BEACON)
-		bcopy((const char *)&ether_bcast, (char *)&h->da,
-		      ETH_ALEN);
+		memset(&h->da, 0xff, ETH_ALEN);
 	bcopy((char *)&cfg->cur_etheraddr, (char *)&h->sa, ETH_ALEN);
 	bcopy((char *)&cfg->BSSID, (char *)&h->bssid, ETH_ALEN);
 
-- 
1.5.6.5

