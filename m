Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61073 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbaBHAVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:21:20 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 01/30] mwifiex: make use of IEEE80211_VHT_MCS_NOT_SUPPORTED
Date: Fri, 7 Feb 2014 16:20:58 -0800
Message-ID: <1391818861-20926-1-git-send-email-bzhao@marvell.com> (sfid-20140208_012122_943828_A6EED066)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove driver's macro and use ieee80211's definition instead

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c | 14 ++++++++------
 drivers/net/wireless/mwifiex/fw.h   |  2 --
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index 5e0eec4..cc0458c 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -126,9 +126,10 @@ mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
 		mcs_user = GET_VHTNSSMCS(mcs_map_user, nss);
 		mcs_resp = GET_VHTNSSMCS(mcs_map_resp, nss);
 
-		if ((mcs_user == NO_NSS_SUPPORT) ||
-		    (mcs_resp == NO_NSS_SUPPORT))
-			SET_VHTNSSMCS(mcs_map_result, nss, NO_NSS_SUPPORT);
+		if ((mcs_user == IEEE80211_VHT_MCS_NOT_SUPPORTED) ||
+		    (mcs_resp == IEEE80211_VHT_MCS_NOT_SUPPORTED))
+			SET_VHTNSSMCS(mcs_map_result, nss,
+				      IEEE80211_VHT_MCS_NOT_SUPPORTED);
 		else
 			SET_VHTNSSMCS(mcs_map_result, nss,
 				      min(mcs_user, mcs_resp));
@@ -147,9 +148,10 @@ mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
 	for (nss = 1; nss <= 8; nss++) {
 		mcs_user = GET_VHTNSSMCS(mcs_map_user, nss);
 		mcs_resp = GET_VHTNSSMCS(mcs_map_resp, nss);
-		if ((mcs_user == NO_NSS_SUPPORT) ||
-		    (mcs_resp == NO_NSS_SUPPORT))
-			SET_VHTNSSMCS(mcs_map_result, nss, NO_NSS_SUPPORT);
+		if ((mcs_user == IEEE80211_VHT_MCS_NOT_SUPPORTED) ||
+		    (mcs_resp == IEEE80211_VHT_MCS_NOT_SUPPORTED))
+			SET_VHTNSSMCS(mcs_map_result, nss,
+				      IEEE80211_VHT_MCS_NOT_SUPPORTED);
 		else
 			SET_VHTNSSMCS(mcs_map_result, nss,
 				      min(mcs_user, mcs_resp));
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 5fa932d..059bc16 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -232,8 +232,6 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define GET_VHTNSSMCS(mcs_mapset, nss) ((mcs_mapset >> (2 * (nss - 1))) & 0x3)
 #define SET_VHTNSSMCS(mcs_mapset, nss, value) (mcs_mapset |= (value & 0x3) << \
 					      (2 * (nss - 1)))
-#define NO_NSS_SUPPORT		0x3
-
 #define GET_DEVTXMCSMAP(dev_mcs_map)      (dev_mcs_map >> 16)
 #define GET_DEVRXMCSMAP(dev_mcs_map)      (dev_mcs_map & 0xFFFF)
 
-- 
1.8.2.3

