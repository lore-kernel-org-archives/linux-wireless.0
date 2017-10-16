Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:24839 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdJPF6j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 01:58:39 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V6 2/5] ath10k: Enable TDLS peer buffer STA feature
Date: Mon, 16 Oct 2017 14:00:30 +0800
Message-ID: <1508133633-23214-3-git-send-email-yintang@qti.qualcomm.com> (sfid-20171016_075845_179229_ADD64F5D)
In-Reply-To: <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patches V6>
 <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com>
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
index 5683f1a..1672043 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8204,6 +8204,9 @@ int ath10k_mac_register(struct ath10k *ar)
 		ieee80211_hw_set(ar->hw, TDLS_WIDER_BW);
 	}
 
+	if (test_bit(WMI_SERVICE_TDLS_UAPSD_BUFFER_STA, ar->wmi.svc_map))
+		ieee80211_hw_set(ar->hw, SUPPORTS_TDLS_BUFFER_STA);
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
