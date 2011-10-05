Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:47606 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:23:13 -0400
Subject: [PATCH 1/6] ath6kl: remove unused parameters from struct wmi
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Oct 2011 12:23:05 +0300
Message-ID: <20111005092305.1095.713.stgit@localhost6.localdomain6> (sfid-20111005_112317_270744_DD844A0F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no use for these, at least right now, so better to remove them.
If some of them are ever needed, we can always add them back.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   27 +++++++--------------------
 drivers/net/wireless/ath/ath6kl/wmi.h |   12 ------------
 2 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a7de23c..ab782d7 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -262,7 +262,12 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
 			usr_pri = layer2_priority & 0x7;
 	}
 
-	/* workaround for WMM S5 */
+	/*
+	 * workaround for WMM S5
+	 *
+	 * FIXME: wmi->traffic_class is always 100 so this test doesn't
+	 * make sense
+	 */
 	if ((wmi->traffic_class == WMM_AC_VI) &&
 	    ((usr_pri == 5) || (usr_pri == 4)))
 		usr_pri = 1;
@@ -641,7 +646,6 @@ static int ath6kl_wmi_ready_event_rx(struct wmi *wmi, u8 *datap, int len)
 	if (len < sizeof(struct wmi_ready_event_2))
 		return -EINVAL;
 
-	wmi->ready = true;
 	ath6kl_ready_event(wmi->parent_dev, ev->mac_addr,
 			   le32_to_cpu(ev->sw_version),
 			   le32_to_cpu(ev->abi_version));
@@ -857,8 +861,6 @@ static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len)
 		   ev->disconn_reason, ev->assoc_resp_len);
 
 	wmi->is_wmm_enabled = false;
-	wmi->pair_crypto_type = NONE_CRYPT;
-	wmi->grp_crypto_type = NONE_CRYPT;
 
 	ath6kl_disconnect_event(wmi->parent_dev, ev->disconn_reason,
 				ev->bssid, ev->assoc_resp_len, ev->assoc_info,
@@ -1639,9 +1641,6 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, enum network_type nw_type,
 	if (bssid != NULL)
 		memcpy(cc->bssid, bssid, ETH_ALEN);
 
-	wmi->pair_crypto_type = pairwise_crypto;
-	wmi->grp_crypto_type = group_crypto;
-
 	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_CONNECT_CMDID, NO_SYNC_WMIFLAG);
 
 	return ret;
@@ -2477,7 +2476,6 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl)
 
 	cmd = (struct wmi_set_keepalive_cmd *) skb->data;
 	cmd->keep_alive_intvl = keep_alive_intvl;
-	wmi->keep_alive_intvl = keep_alive_intvl;
 
 	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_KEEPALIVE_CMDID,
 				  NO_SYNC_WMIFLAG);
@@ -2818,7 +2816,6 @@ static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 
 	if (skb->len < sizeof(struct wmix_cmd_hdr)) {
 		ath6kl_err("bad packet 1\n");
-		wmi->stat.cmd_len_err++;
 		return -EINVAL;
 	}
 
@@ -2840,7 +2837,6 @@ static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	default:
 		ath6kl_warn("unknown cmd id 0x%x\n", id);
-		wmi->stat.cmd_id_err++;
 		ret = -EINVAL;
 		break;
 	}
@@ -2863,7 +2859,6 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 	if (skb->len < sizeof(struct wmi_cmd_hdr)) {
 		ath6kl_err("bad packet 1\n");
 		dev_kfree_skb(skb);
-		wmi->stat.cmd_len_err++;
 		return -EINVAL;
 	}
 
@@ -3068,7 +3063,6 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	default:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "unknown cmd id 0x%x\n", id);
-		wmi->stat.cmd_id_err++;
 		ret = -EINVAL;
 		break;
 	}
@@ -3103,16 +3097,9 @@ void *ath6kl_wmi_init(struct ath6kl *dev)
 
 	wmi->parent_dev = dev;
 
-	ath6kl_wmi_qos_state_init(wmi);
-
 	wmi->pwr_mode = REC_POWER;
-	wmi->phy_mode = WMI_11G_MODE;
 
-	wmi->pair_crypto_type = NONE_CRYPT;
-	wmi->grp_crypto_type = NONE_CRYPT;
-
-	wmi->ht_allowed[A_BAND_24GHZ] = 1;
-	wmi->ht_allowed[A_BAND_5GHZ] = 1;
+	ath6kl_wmi_qos_state_init(wmi);
 
 	return wmi;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 1600e7c..5166f05 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -93,11 +93,6 @@ struct sq_threshold_params {
 	u8 last_rssi_poll_event;
 };
 
-struct wmi_stats {
-	u32 cmd_len_err;
-	u32 cmd_id_err;
-};
-
 struct wmi_data_sync_bufs {
 	u8 traffic_class;
 	struct sk_buff *skb;
@@ -111,22 +106,15 @@ struct wmi_data_sync_bufs {
 #define WMM_AC_VO   3		/* voice */
 
 struct wmi {
-	bool ready;
 	u16 stream_exist_for_ac[WMM_NUM_AC];
 	u8 fat_pipe_exist;
 	struct ath6kl *parent_dev;
-	struct wmi_stats stat;
 	u8 pwr_mode;
-	u8 phy_mode;
-	u8 keep_alive_intvl;
 	spinlock_t lock;
 	enum htc_endpoint_id ep_id;
 	struct sq_threshold_params
 	    sq_threshld[SIGNAL_QUALITY_METRICS_NUM_MAX];
-	enum crypto_type pair_crypto_type;
-	enum crypto_type grp_crypto_type;
 	bool is_wmm_enabled;
-	u8 ht_allowed[A_NUM_BANDS];
 	u8 traffic_class;
 	bool is_probe_ssid;
 

