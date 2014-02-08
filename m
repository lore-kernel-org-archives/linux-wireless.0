Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59633 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbaBHAVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:21:11 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 03/30] mwifiex: improve readability in 11ac mcsmap to maxrate conversion
Date: Fri, 7 Feb 2014 16:21:00 -0800
Message-ID: <1391818861-20926-3-git-send-email-bzhao@marvell.com> (sfid-20140208_012114_110103_2CD80A96)
In-Reply-To: <1391818861-20926-1-git-send-email-bzhao@marvell.com>
References: <1391818861-20926-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) rename max_mcs to mcs;
2) initialize 'i' and 'nss' as 1 instead of 0 in nss lookup;
3) use GET_VHTNSSMCS(mcs_map, nss) macro;
4) use IEEE80211_VHT_MCS_* definitions instead of hard coding

Reported-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index f07a500..4738392 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -55,7 +55,7 @@ static u16
 mwifiex_convert_mcsmap_to_maxrate(struct mwifiex_private *priv,
 				  u8 bands, u16 mcs_map)
 {
-	u8 i, nss, max_mcs;
+	u8 i, nss, mcs;
 	u16 max_rate = 0;
 	u32 usr_vht_cap_info = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -66,29 +66,29 @@ mwifiex_convert_mcsmap_to_maxrate(struct mwifiex_private *priv,
 		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_bg;
 
 	/* find the max NSS supported */
-	nss = 0;
-	for (i = 0; i < 8; i++) {
-		max_mcs = (mcs_map >> (2 * i)) & 0x3;
-		if (max_mcs < 3)
+	nss = 1;
+	for (i = 1; i <= 8; i++) {
+		mcs = GET_VHTNSSMCS(mcs_map, i);
+		if (mcs < IEEE80211_VHT_MCS_NOT_SUPPORTED)
 			nss = i;
 	}
-	max_mcs = (mcs_map >> (2 * nss)) & 0x3;
+	mcs = GET_VHTNSSMCS(mcs_map, nss);
 
-	/* if max_mcs is 3, nss must be 0 (SS = 1). Thus, max mcs is MCS 9 */
-	if (max_mcs >= 3)
-		max_mcs = 2;
+	/* if mcs is 3, nss must be 1 (NSS = 1). Default mcs to MCS 0~9 */
+	if (mcs == IEEE80211_VHT_MCS_NOT_SUPPORTED)
+		mcs = IEEE80211_VHT_MCS_SUPPORT_0_9;
 
 	if (GET_VHTCAP_CHWDSET(usr_vht_cap_info)) {
 		/* support 160 MHz */
-		max_rate = max_rate_lgi_160MHZ[nss][max_mcs];
+		max_rate = max_rate_lgi_160MHZ[nss - 1][mcs];
 		if (!max_rate)
 			/* MCS9 is not supported in NSS6 */
-			max_rate = max_rate_lgi_160MHZ[nss][max_mcs - 1];
+			max_rate = max_rate_lgi_160MHZ[nss - 1][mcs - 1];
 	} else {
-		max_rate = max_rate_lgi_80MHZ[nss][max_mcs];
+		max_rate = max_rate_lgi_80MHZ[nss - 1][mcs];
 		if (!max_rate)
 			/* MCS9 is not supported in NSS3 */
-			max_rate = max_rate_lgi_80MHZ[nss][max_mcs - 1];
+			max_rate = max_rate_lgi_80MHZ[nss - 1][mcs - 1];
 	}
 
 	return max_rate;
-- 
1.8.2.3

