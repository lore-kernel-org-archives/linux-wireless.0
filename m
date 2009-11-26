Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27839 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760656AbZKZPJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:50 -0500
Subject: [PATCH 09/12] wl1251: implement wl1251_acx_tid_cfg()
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:09:24 +0200
Message-ID: <20091126150924.917.98093.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Needed for WMM.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_acx.c  |   36 +++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h  |   55 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_main.c |   11 ++++++
 3 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index b409c75..beff084 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -1009,3 +1009,39 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1251_acx_tid_cfg(struct wl1251 *wl, u8 queue,
+		       enum wl1251_acx_channel_type type,
+		       u8 tsid, enum wl1251_acx_ps_scheme ps_scheme,
+		       enum wl1251_acx_ack_policy ack_policy)
+{
+	struct wl1251_acx_tid_cfg *acx;
+	int ret = 0;
+
+	wl1251_debug(DEBUG_ACX, "acx tid cfg %d type %d tsid %d "
+		     "ps_scheme %d ack_policy %d", queue, type, tsid,
+		     ps_scheme, ack_policy);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->queue = queue;
+	acx->type = type;
+	acx->tsid = tsid;
+	acx->ps_scheme = ps_scheme;
+	acx->ack_policy = ack_policy;
+
+	ret = wl1251_cmd_configure(wl, ACX_TID_CFG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1251_warning("acx tid cfg failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 5679324..26160c4 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -1196,6 +1196,57 @@ struct wl1251_acx_ac_cfg {
 	u16 txop_limit;
 } __attribute__ ((packed));
 
+
+enum wl1251_acx_channel_type {
+	CHANNEL_TYPE_DCF	= 0,
+	CHANNEL_TYPE_EDCF	= 1,
+	CHANNEL_TYPE_HCCA	= 2,
+};
+
+enum wl1251_acx_ps_scheme {
+	/* regular ps: simple sending of packets */
+	WL1251_ACX_PS_SCHEME_LEGACY	= 0,
+
+	/* sending a packet triggers a unscheduled apsd downstream */
+	WL1251_ACX_PS_SCHEME_UPSD_TRIGGER	= 1,
+
+	/* a pspoll packet will be sent before every data packet */
+	WL1251_ACX_PS_SCHEME_LEGACY_PSPOLL	= 2,
+
+	/* scheduled apsd mode */
+	WL1251_ACX_PS_SCHEME_SAPSD		= 3,
+};
+
+enum wl1251_acx_ack_policy {
+	WL1251_ACX_ACK_POLICY_LEGACY	= 0,
+	WL1251_ACX_ACK_POLICY_NO_ACK	= 1,
+	WL1251_ACX_ACK_POLICY_BLOCK	= 2,
+};
+
+struct wl1251_acx_tid_cfg {
+	struct acx_header header;
+
+	/* tx queue id number (0-7) */
+	u8 queue;
+
+	/* channel access type for the queue, enum wl1251_acx_channel_type */
+	u8 type;
+
+	/* EDCA: ac index (0-3), HCCA: traffic stream id (8-15) */
+	u8 tsid;
+
+	/* ps scheme of the specified queue, enum wl1251_acx_ps_scheme */
+	u8 ps_scheme;
+
+	/* the tx queue ack policy, enum wl1251_acx_ack_policy */
+	u8 ack_policy;
+
+	u8 padding[3];
+
+	/* not supported */
+	u32 apsdconf[2];
+} __attribute__ ((packed));
+
 /*************************************************************************
 
     Host Interrupt Register (WiLink -> Host)
@@ -1354,5 +1405,9 @@ int wl1251_acx_mem_cfg(struct wl1251 *wl);
 int wl1251_acx_wr_tbtt_and_dtim(struct wl1251 *wl, u16 tbtt, u8 dtim);
 int wl1251_acx_ac_cfg(struct wl1251 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifs, u16 txop);
+int wl1251_acx_tid_cfg(struct wl1251 *wl, u8 queue,
+		       enum wl1251_acx_channel_type type,
+		       u8 tsid, enum wl1251_acx_ps_scheme ps_scheme,
+		       enum wl1251_acx_ack_policy ack_policy);
 
 #endif /* __WL1251_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 4d335d6..253706c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1296,7 +1296,18 @@ static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	ret = wl1251_acx_ac_cfg(wl, wl1251_tx_get_queue(queue),
 				params->cw_min, params->cw_max,
 				params->aifs, params->txop);
+	if (ret < 0)
+		goto out_sleep;
+
+	ret = wl1251_acx_tid_cfg(wl, wl1251_tx_get_queue(queue),
+				 CHANNEL_TYPE_DCF,
+				 wl1251_tx_get_queue(queue),
+				 WL1251_ACX_PS_SCHEME_LEGACY,
+				 WL1251_ACX_ACK_POLICY_LEGACY);
+	if (ret < 0)
+		goto out_sleep;
 
+out_sleep:
 	wl1251_ps_elp_sleep(wl);
 
 out:

