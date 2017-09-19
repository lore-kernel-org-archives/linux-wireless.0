Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:63064 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751009AbdISCuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 22:50:14 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [TDLS PATCH V2 2/5] ath10k: Enable TDLS peer buffer STA feature
Date: Tue, 19 Sep 2017 10:51:05 +0800
Message-ID: <1505789468-25330-3-git-send-email-yintang@qti.qualcomm.com> (sfid-20170919_045018_420715_65A25EB2)
In-Reply-To: <1505789468-25330-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patchset v2>
 <1505789468-25330-1-git-send-email-yintang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yingying Tang <yintang@qti.qualcomm.com>

Enable TDLS peer buffer STA feature.
QCA6174 firmware(version: WLAN.RM.4.4) support TDLS peer buffer STA,
it reports this capability through wmi service map in wmi service ready
event. Set related parameter in TDLS WMI command to enable this feature.

Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     |    3 +++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5683f1a..399f9ba 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8204,6 +8204,9 @@ int ath10k_mac_register(struct ath10k *ar)
 		ieee80211_hw_set(ar->hw, TDLS_WIDER_BW);
 	}
 
+	if (test_bit(WMI_SERVICE_TDLS_UAPSD_BUFFER_STA, ar->wmi.svc_map))
+		ar->hw->wiphy->flags |= WIPHY_FLAG_SUPPORT_TDLS_BUFFER_STA;
+
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7616c1c..f60b46e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2747,6 +2747,9 @@ static void *ath10k_wmi_tlv_put_wmm(void *ptr,
 	 */
 	u32 options = 0;
 
+	if (test_bit(WMI_SERVICE_TDLS_UAPSD_BUFFER_STA, ar->wmi.svc_map))
+		options |=  WMI_TLV_TDLS_BUFFER_STA_EN;
+
 	len = sizeof(*tlv) + sizeof(*cmd);
 	skb = ath10k_wmi_alloc_skb(ar, len);
 	if (!skb)
-- 
1.7.9.5
