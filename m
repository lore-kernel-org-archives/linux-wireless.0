Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1KCJk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:40:29 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Dai Shuibing <shuibing@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/3] ath6kl: Allow SMS4 to be configured in AP mode
Date: Thu, 3 Nov 2011 11:39:38 +0200
Message-ID: <1320313179-9259-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20111103_104032_332577_FB83CF7A)
In-Reply-To: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
References: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dai Shuibing <shuibing@qca.qualcomm.com>

Signed-off-by: Dai Shuibing <shuibing@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 42eeed1..095a378 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1923,6 +1923,9 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 		case WLAN_CIPHER_SUITE_CCMP:
 			p.prwise_crypto_type |= AES_CRYPT;
 			break;
+		case WLAN_CIPHER_SUITE_SMS4:
+			p.prwise_crypto_type |= WAPI_CRYPT;
+			break;
 		}
 	}
 	if (p.prwise_crypto_type == 0) {
@@ -1942,6 +1945,9 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_CCMP:
 		p.grp_crypto_type = AES_CRYPT;
 		break;
+	case WLAN_CIPHER_SUITE_SMS4:
+		p.grp_crypto_type = WAPI_CRYPT;
+		break;
 	default:
 		p.grp_crypto_type = NONE_CRYPT;
 		break;
-- 
1.7.4.1

