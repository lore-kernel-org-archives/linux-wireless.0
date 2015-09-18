Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43962 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbbIRNc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:32:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOviC030875
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:55 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7eq7-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:55 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 05/16] mwifiex: NULL check for cfg80211_inform_bss()
Date: Fri, 18 Sep 2015 06:32:07 -0700
Message-ID: <1442583138-2979-6-git-send-email-akarwar@marvell.com> (sfid-20150918_153259_212092_02E44387)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

cfg80211_inform_bss would return null in some cases, such as
memory allocation failure.

This patch adds sanity check for this case, to avoid possible
issues when above corner case is hit.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  6 ++++--
 drivers/net/wireless/mwifiex/scan.c     | 20 ++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4e06e98..262c4b9 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1994,8 +1994,10 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 				  CFG80211_BSS_FTYPE_UNKNOWN,
 				  bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
 				  0, ie_buf, ie_len, 0, GFP_KERNEL);
-	cfg80211_put_bss(priv->wdev.wiphy, bss);
-	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
+	if (bss) {
+		cfg80211_put_bss(priv->wdev.wiphy, bss);
+		ether_addr_copy(priv->cfg_bssid, bss_info.bssid);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 5847863..3675730 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1839,14 +1839,18 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 					    bssid, timestamp,
 					    cap_info_bitmap, beacon_period,
 					    ie_buf, ie_len, rssi, GFP_KERNEL);
-			bss_priv = (struct mwifiex_bss_priv *)bss->priv;
-			bss_priv->band = band;
-			bss_priv->fw_tsf = fw_tsf;
-			if (priv->media_connected &&
-			    !memcmp(bssid, priv->curr_bss_params.bss_descriptor
-				    .mac_address, ETH_ALEN))
-				mwifiex_update_curr_bss_params(priv, bss);
-			cfg80211_put_bss(priv->wdev.wiphy, bss);
+			if (bss) {
+				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
+				bss_priv->band = band;
+				bss_priv->fw_tsf = fw_tsf;
+				if (priv->media_connected &&
+				    !memcmp(bssid, priv->curr_bss_params.
+					    bss_descriptor.mac_address,
+					    ETH_ALEN))
+					mwifiex_update_curr_bss_params(priv,
+								       bss);
+				cfg80211_put_bss(priv->wdev.wiphy, bss);
+			}
 
 			if ((chan->flags & IEEE80211_CHAN_RADAR) ||
 			    (chan->flags & IEEE80211_CHAN_NO_IR)) {
-- 
1.8.1.4

