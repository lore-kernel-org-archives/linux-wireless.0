Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42817 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2IBNMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 09:12:33 -0400
Received: by wibhq12 with SMTP id hq12so2619716wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 06:12:32 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 2 Sep 2012 14:25:50 +0200
Subject: [PATCH] carl9170: connect to 11w protected networks
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1T89yV-0007Cn-JT@debian64.localnet> (sfid-20120902_151319_118701_3604D3F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, it was not possible to connect to
networks which requires 11w to be supported by
the stations.

While the documentation hints that there's some
hardware support for offloading MFP "decryption",
this simple implementation relies on the mac80211
stack to do the actual crypto operations.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/mac.c  |    3 ++-
 drivers/net/wireless/ath/carl9170/main.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index f867628..e3b1b6e 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -304,7 +304,8 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
 	struct ath_common *common = &ar->common;
 	u8 *mac_addr, *bssid;
 	u32 cam_mode = AR9170_MAC_CAM_DEFAULTS;
-	u32 enc_mode = AR9170_MAC_ENCRYPTION_DEFAULTS;
+	u32 enc_mode = AR9170_MAC_ENCRYPTION_DEFAULTS |
+		AR9170_MAC_ENCRYPTION_MGMT_RX_SOFTWARE;
 	u32 rx_ctrl = AR9170_MAC_RX_CTRL_DEAGG |
 		      AR9170_MAC_RX_CTRL_SHORT_FILTER;
 	u32 sniffer = AR9170_MAC_SNIFFER_DEFAULTS;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 18554ab..50c2949 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1149,6 +1149,7 @@ static int carl9170_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		ktype = AR9170_ENC_ALG_AESCCMP;
+		key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1780,6 +1781,7 @@ void *carl9170_alloc(size_t priv_size)
 	hw->wiphy->interface_modes = 0;
 
 	hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_MFP_CAPABLE |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
-- 
1.7.10.4

