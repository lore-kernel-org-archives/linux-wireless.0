Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47120 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750934AbdF1G7x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 02:59:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v5S6ntXs002888
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 23:59:52 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2b9negs0ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 23:59:52 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: don not update MCS set from hostapd
Date: Wed, 28 Jun 2017 12:26:58 +0530
Message-ID: <1498633018-9059-1-git-send-email-gbhat@marvell.com> (sfid-20170628_085956_802146_2FF0A9BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not copy the MCS set from hostapd RX-STBC. We
have to just use the MCS set supported by the hardware.
This fixes an issue, where mwifiex is advertising wrong
MCS sets in beacons.

Fixes: 474a41e94 ("mwifiex: update MCS set as per RX-STBC bit from hostapd")
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      |  5 -----
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 22 ----------------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 4a848e8..07d3a0a 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -247,11 +247,6 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define MWIFIEX_DEF_AMPDU	IEEE80211_HT_AMPDU_PARM_FACTOR
 
-#define GET_RXSTBC(x) (x & IEEE80211_HT_CAP_RX_STBC)
-#define MWIFIEX_RX_STBC1	0x0100
-#define MWIFIEX_RX_STBC12	0x0200
-#define MWIFIEX_RX_STBC123	0x0300
-
 /* dev_cap bitmap
  * BIT
  * 0-16		reserved
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index 35d8636..477c29c 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -160,7 +160,6 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 		      struct cfg80211_ap_settings *params)
 {
 	const u8 *ht_ie;
-	u16 cap_info;
 
 	if (!ISSUPP_11NENABLED(priv->adapter->fw_cap_info))
 		return;
@@ -170,27 +169,6 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 	if (ht_ie) {
 		memcpy(&bss_cfg->ht_cap, ht_ie + 2,
 		       sizeof(struct ieee80211_ht_cap));
-		cap_info = le16_to_cpu(bss_cfg->ht_cap.cap_info);
-		memset(&bss_cfg->ht_cap.mcs, 0,
-		       priv->adapter->number_of_antenna);
-		switch (GET_RXSTBC(cap_info)) {
-		case MWIFIEX_RX_STBC1:
-			/* HT_CAP 1X1 mode */
-			bss_cfg->ht_cap.mcs.rx_mask[0] = 0xff;
-			break;
-		case MWIFIEX_RX_STBC12:	/* fall through */
-		case MWIFIEX_RX_STBC123:
-			/* HT_CAP 2X2 mode */
-			bss_cfg->ht_cap.mcs.rx_mask[0] = 0xff;
-			bss_cfg->ht_cap.mcs.rx_mask[1] = 0xff;
-			break;
-		default:
-			mwifiex_dbg(priv->adapter, WARN,
-				    "Unsupported RX-STBC, default to 2x2\n");
-			bss_cfg->ht_cap.mcs.rx_mask[0] = 0xff;
-			bss_cfg->ht_cap.mcs.rx_mask[1] = 0xff;
-			break;
-		}
 		priv->ap_11n_enabled = 1;
 	} else {
 		memset(&bss_cfg->ht_cap, 0, sizeof(struct ieee80211_ht_cap));
-- 
1.9.1
