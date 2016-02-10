Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35602 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbcBJOEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 09:04:09 -0500
Received: by mail-pf0-f193.google.com with SMTP id w128so451014pfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 06:04:09 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH] mwifiex: Fixed coding style issues
Date: Wed, 10 Feb 2016 19:34:01 +0530
Message-Id: <1455113041-28226-1-git-send-email-royujjal@gmail.com> (sfid-20160210_150426_199571_FE763CAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some indentation and basic style violations are fixed in this patch.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c     | 2 +-
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c  | 2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c      | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index e7adef7..cb0cf03 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -676,7 +676,7 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		}
 		break;

-		case MWIFIEX_BSS_ROLE_STA:
+	case MWIFIEX_BSS_ROLE_STA:
 		if (priv->media_connected) {
 			mwifiex_dbg(adapter, ERROR,
 				    "cannot change wiphy params when connected");
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6d0dc40..4d29cce 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1408,7 +1408,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		return -1;
 	}

-	if (mwifiex_map_pci_memory(adapter, skb, skb->len , PCI_DMA_TODEVICE))
+	if (mwifiex_map_pci_memory(adapter, skb, skb->len, PCI_DMA_TODEVICE))
 		return -1;

 	buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index e791166..16d95b2 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -192,7 +192,7 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 		}
 		priv->ap_11n_enabled = 1;
 	} else {
-		memset(&bss_cfg->ht_cap , 0, sizeof(struct ieee80211_ht_cap));
+		memset(&bss_cfg->ht_cap, 0, sizeof(struct ieee80211_ht_cap));
 		bss_cfg->ht_cap.cap_info = cpu_to_le16(MWIFIEX_DEF_HT_CAP);
 		bss_cfg->ht_cap.ampdu_params_info = MWIFIEX_DEF_AMPDU;
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index e43aff9..0510861 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -244,9 +244,9 @@ setup_for_next:
 	if (card->rx_cmd_ep == context->ep) {
 		mwifiex_usb_submit_rx_urb(context, size);
 	} else {
-		if (atomic_read(&adapter->rx_pending) <= HIGH_RX_PENDING){
+		if (atomic_read(&adapter->rx_pending) <= HIGH_RX_PENDING) {
 			mwifiex_usb_submit_rx_urb(context, size);
-		}else{
+		} else {
 			context->skb = NULL;
 		}
 	}
--
1.9.1

