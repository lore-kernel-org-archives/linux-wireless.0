Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43724 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1HNLik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 07:38:40 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath6kl: Cleanup ath6kl_wmi_data_hdr_remove()
Date: Sun, 14 Aug 2011 17:08:35 +0530
Message-ID: <1313321916-29685-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110814_133845_158297_FA468645)
In-Reply-To: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    3 +--
 drivers/net/wireless/ath/ath6kl/wmi.c  |   10 ----------
 drivers/net/wireless/ath/ath6kl/wmi.h  |    1 -
 3 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index fb67c24..5d3d4b6 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1162,8 +1162,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	seq_no = wmi_data_hdr_get_seqno(dhdr);
 	meta_type = wmi_data_hdr_get_meta(dhdr);
 	dot11_hdr = wmi_data_hdr_get_dot11(dhdr);
-
-	ath6kl_wmi_data_hdr_remove(ar->wmi, skb);
+	skb_pull(skb, sizeof(struct wmi_data_hdr));
 
 	switch (meta_type) {
 	case WMI_META_VERSION_1:
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f5aa33d..13b1a20 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -376,16 +376,6 @@ int ath6kl_wmi_dot3_2_dix(struct sk_buff *skb)
 	return 0;
 }
 
-int ath6kl_wmi_data_hdr_remove(struct wmi *wmi, struct sk_buff *skb)
-{
-	if (WARN_ON(skb == NULL))
-		return -EINVAL;
-
-	skb_pull(skb, sizeof(struct wmi_data_hdr));
-
-	return 0;
-}
-
 static void ath6kl_wmi_convert_bssinfo_hdr2_to_hdr(struct sk_buff *skb,
 						   u8 *datap)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index fe3ddce..8fa5d6e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1925,7 +1925,6 @@ int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 
 int ath6kl_wmi_dot11_hdr_remove(struct wmi *wmi, struct sk_buff *skb);
 int ath6kl_wmi_dot3_2_dix(struct sk_buff *skb);
-int ath6kl_wmi_data_hdr_remove(struct wmi *wmi, struct sk_buff *skb);
 int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
 				       u32 layer2_priority, bool wmm_enabled,
 				       u8 *ac);
-- 
1.7.0.4

