Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1575 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab3A1Qim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:42 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/14] wil6210: checkpatch warnings
Date: Mon, 28 Jan 2013 18:31:07 +0200
Message-ID: <1359390669-9310-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173849_211713_10D89740)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  |    1 -
 drivers/net/wireless/ath/wil6210/interrupt.c |    1 -
 drivers/net/wireless/ath/wil6210/main.c      |    4 ++--
 drivers/net/wireless/ath/wil6210/netdev.c    |    4 ++--
 drivers/net/wireless/ath/wil6210/txrx.c      |    3 +--
 drivers/net/wireless/ath/wil6210/wmi.c       |    1 -
 6 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4b48f2e..002851f 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -204,7 +204,6 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		break;
 	default:
 		return -EOPNOTSUPP;
-
 	}
 
 	/* FW don't support scan after connection attempt */
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 865c33f..dc97e7b 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -52,7 +52,6 @@
 
 static inline void wil_icr_clear(u32 x, void __iomem *addr)
 {
-
 }
 #else /* defined(CONFIG_WIL6210_ISR_COR) */
 /* configure to Write-1-to-Clear mode */
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d160ea8..761c389 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -80,7 +80,7 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 					GFP_KERNEL);
 		break;
 	default:
-		;
+		break;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++)
@@ -357,7 +357,7 @@ static int __wil_up(struct wil6210_priv *wil)
 			wmi_set_channel(wil, channel->hw_value);
 		break;
 	default:
-		;
+		break;
 	}
 
 	/* MAC address - pre-requisite for other commands */
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 073dc7d..8ce2e33 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -39,8 +39,8 @@ static const struct net_device_ops wil_netdev_ops = {
 	.ndo_open		= wil_open,
 	.ndo_stop		= wil_stop,
 	.ndo_start_xmit		= wil_start_xmit,
-	.ndo_set_mac_address    = eth_mac_addr,
-	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
 };
 
 void *wil_if_alloc(struct device *dev, void __iomem *csr)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index f0d0913..48cfa7e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -758,8 +758,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	case -ENOMEM:
 		return NETDEV_TX_BUSY;
 	default:
-		; /* goto drop; */
-		break;
+		break; /* goto drop; */
 	}
  drop:
 	netif_tx_stop_all_queues(ndev);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 91f41a7..8178cc0 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -188,7 +188,6 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
 			(int)(sizeof(cmd) + len), r->entry_size);
 		return -ERANGE;
-
 	}
 
 	might_sleep();
-- 
1.7.10.4

