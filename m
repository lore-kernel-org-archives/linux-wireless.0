Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4690 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaIJNfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:11 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 03/22] wil6210: print more information when connecting
Date: Wed, 10 Sep 2014 16:34:32 +0300
Message-ID: <1410356091-19219-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153517_228459_1DCE7D65)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when connecting, print some info about BSS

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index a00f318..df77711 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -319,6 +319,22 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	return rc;
 }
 
+static void wil_print_connect_params(struct wil6210_priv *wil,
+				     struct cfg80211_connect_params *sme)
+{
+	wil_info(wil, "Connecting to:\n");
+	if (sme->channel) {
+		wil_info(wil, "  Channel: %d freq %d\n",
+			 sme->channel->hw_value, sme->channel->center_freq);
+	}
+	if (sme->bssid)
+		wil_info(wil, "  BSSID: %pM\n", sme->bssid);
+	if (sme->ssid)
+		print_hex_dump(KERN_INFO, "  SSID: ", DUMP_PREFIX_OFFSET,
+			       16, 1, sme->ssid, sme->ssid_len, true);
+	wil_info(wil, "  Privacy: %s\n", sme->privacy ? "secure" : "open");
+}
+
 static int wil_cfg80211_connect(struct wiphy *wiphy,
 				struct net_device *ndev,
 				struct cfg80211_connect_params *sme)
@@ -335,6 +351,8 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	    test_bit(wil_status_fwconnected, &wil->status))
 		return -EALREADY;
 
+	wil_print_connect_params(wil, sme);
+
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
 			       sme->ssid, sme->ssid_len,
 			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
-- 
1.9.1

