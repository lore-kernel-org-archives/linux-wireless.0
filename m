Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:59984 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIJNfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:41 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Dedy Lansky <qca_dlansky@qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/22] wil6210: enlarge TX/RX buffer length
Date: Wed, 10 Sep 2014 16:34:45 +0300
Message-ID: <1410356091-19219-17-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153545_673532_790DCD4A)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW supports upto 2304 packet size on the air.
HW is responsible for adding (Tx) or removing (Rx) the following headers:
802.11 hdr: 26B
SNAP: 8B
CRC: 4B
Security (optional): 24B
HW adds max 62B to the payload passed from driver. It means driver can use
max packet size of 2304-62 = 2242B

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 5 ++++-
 drivers/net/wireless/ath/wil6210/txrx.c   | 3 ++-
 drivers/net/wireless/ath/wil6210/txrx.h   | 6 +++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index a995d9d..1c0c77d 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 
 #include "wil6210.h"
+#include "txrx.h"
 
 static int wil_open(struct net_device *ndev)
 {
@@ -40,8 +41,10 @@ static int wil_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 
-	if (new_mtu < 68 || new_mtu > IEEE80211_MAX_DATA_LEN_DMG)
+	if (new_mtu < 68 || new_mtu > (TX_BUF_LEN - ETH_HLEN)) {
+		wil_err(wil, "invalid MTU %d\n", new_mtu);
 		return -EINVAL;
+	}
 
 	wil_dbg_misc(wil, "change MTU %d -> %d\n", ndev->mtu, new_mtu);
 	ndev->mtu = new_mtu;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 02fd43d..2936ef0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -668,7 +668,8 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	struct vring *vring = &wil->vring_tx[id];
 	struct vring_tx_data *txdata = &wil->vring_tx_data[id];
 
-	wil_dbg_misc(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "%s() max_mpdu_size %d\n", __func__,
+		     cmd.vring_cfg.tx_sw_ring.max_mpdu_size);
 
 	if (vring->va) {
 		wil_err(wil, "Tx ring [%d] already allocated\n", id);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 979edf2..de04671 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -20,9 +20,9 @@
 #define BUF_SW_OWNED    (1)
 #define BUF_HW_OWNED    (0)
 
-/* size of max. Rx packet */
-#define RX_BUF_LEN      (2048)
-#define TX_BUF_LEN      (2048)
+/* size of max. Tx/Rx buffers, as supported by FW */
+#define RX_BUF_LEN      (2242)
+#define TX_BUF_LEN      (2242)
 /* how many bytes to reserve for rtap header? */
 #define WIL6210_RTAP_SIZE (128)
 
-- 
1.9.1

