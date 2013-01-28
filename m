Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1586 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3A1Qix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:53 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/14] wil6210: Never delete Rx chain with firmware
Date: Mon, 28 Jan 2013 18:31:08 +0200
Message-ID: <1359390669-9310-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173902_196352_D9A2A614)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware crash on attempt to delete Rx chain.
Driver part of Rx chain removed only in preparation for the target reset;
as reset is the only flow that removes Rx chain in the firmware.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c    |    4 +---
 drivers/net/wireless/ath/wil6210/wil6210.h |    1 -
 drivers/net/wireless/ath/wil6210/wmi.c     |   22 ----------------------
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 48cfa7e..1985951 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -511,10 +511,8 @@ void wil_rx_fini(struct wil6210_priv *wil)
 {
 	struct vring *vring = &wil->vring_rx;
 
-	if (vring->va) {
-		wmi_rx_chain_del(wil);
+	if (vring->va)
 		wil_vring_free(wil, vring, 0);
-	}
 }
 
 int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 69e5162..aea961f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -327,7 +327,6 @@ int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
 		       const void *mac_addr, int key_len, const void *key);
 int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
-int wmi_rx_chain_del(struct wil6210_priv *wil);
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8178cc0..0b70e17 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -902,28 +902,6 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 	return rc;
 }
 
-int wmi_rx_chain_del(struct wil6210_priv *wil)
-{
-	int rc;
-	struct wmi_cfg_rx_chain_cmd cmd = {
-		.action = cpu_to_le32(WMI_RX_CHAIN_DEL),
-		.rx_sw_ring = {
-			.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
-		},
-	};
-	struct {
-		struct wil6210_mbox_hdr_wmi wmi;
-		struct wmi_cfg_rx_chain_done_event cfg;
-	} __packed wmi_rx_cfg_reply;
-
-	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
-		      WMI_CFG_RX_CHAIN_DONE_EVENTID,
-		      &wmi_rx_cfg_reply, sizeof(wmi_rx_cfg_reply),
-		      100);
-
-	return rc;
-}
-
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
-- 
1.7.10.4

