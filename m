Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:60285 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779Ab2IZD3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:29:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 05/15] mwifiex: report received management frames to cfg80211
Date: Tue, 25 Sep 2012 20:23:35 -0700
Message-Id: <1348629825-12001-6-git-send-email-bzhao@marvell.com> (sfid-20120926_052908_737225_1E0B69BE)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Process the management frames received from firmware and report
them to cfg80211.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Kevin Gan <ganhy@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h       |    1 +
 drivers/net/wireless/mwifiex/init.c     |    1 +
 drivers/net/wireless/mwifiex/main.h     |    4 +++
 drivers/net/wireless/mwifiex/sta_rx.c   |    6 ++++
 drivers/net/wireless/mwifiex/uap_txrx.c |    6 ++++
 drivers/net/wireless/mwifiex/util.c     |   40 +++++++++++++++++++++++++++++++
 6 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 41b304a..b587ea3 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -94,6 +94,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 };
 
 #define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
+#define CAL_RSSI(SNR, NF)		((s16)((s16)(SNR)+(s16)(NF)))
 
 #define UAP_BSS_PARAMS_I			0
 #define UAP_CUSTOM_IE_I				1
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index b2ba262..105a5c5 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -214,6 +214,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->wps_ie = NULL;
 	priv->wps_ie_len = 0;
 	priv->ap_11n_enabled = 0;
+	priv->mgmt_rx_freq = 2437;
 
 	priv->scan_block = false;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6e08062..ec5794e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -497,6 +497,7 @@ struct mwifiex_private {
 	struct timer_list scan_delay_timer;
 	u8 ap_11n_enabled;
 	u32 mgmt_frame_mask;
+	u32 mgmt_rx_freq;
 };
 
 enum mwifiex_ba_status {
@@ -741,6 +742,9 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *, struct mwifiex_fw_image *);
 
 int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
 
+int mwifiex_process_mgmt_packet(struct mwifiex_adapter *adapter,
+				struct sk_buff *skb);
+
 int mwifiex_process_event(struct mwifiex_adapter *adapter);
 
 int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index d91d5c0..07d32b7 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -174,6 +174,12 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 				dev_err(adapter->dev, "Rx of A-MSDU failed");
 		}
 		return 0;
+	} else if (rx_pkt_type == PKT_TYPE_MGMT) {
+		ret = mwifiex_process_mgmt_packet(adapter, skb);
+		if (ret)
+			dev_err(adapter->dev, "Rx of mgmt packet failed");
+		dev_kfree_skb_any(skb);
+		return ret;
 	}
 
 	/*
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index df17d08..012c143 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -217,6 +217,12 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_adapter *adapter,
 		}
 
 		return 0;
+	} else if (rx_pkt_type == PKT_TYPE_MGMT) {
+		ret = mwifiex_process_mgmt_packet(adapter, skb);
+		if (ret)
+			dev_err(adapter->dev, "Rx of mgmt packet failed");
+		dev_kfree_skb_any(skb);
+		return ret;
 	}
 
 	memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 2864c74..e1dc3e4 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -142,6 +142,46 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 }
 
 /*
+ * This function processes the received management packet and send it
+ * to the kernel.
+ */
+int
+mwifiex_process_mgmt_packet(struct mwifiex_adapter *adapter,
+			    struct sk_buff *skb)
+{
+	struct rxpd *rx_pd;
+	struct mwifiex_private *priv;
+	u16 pkt_len;
+
+	if (!skb)
+		return -1;
+
+	rx_pd = (struct rxpd *)skb->data;
+	priv = mwifiex_get_priv_by_id(adapter, rx_pd->bss_num, rx_pd->bss_type);
+	if (!priv)
+		return -1;
+
+	skb_pull(skb, le16_to_cpu(rx_pd->rx_pkt_offset));
+	skb_pull(skb, sizeof(pkt_len));
+
+	pkt_len = le16_to_cpu(rx_pd->rx_pkt_length);
+
+	/* Remove address4 */
+	memmove(skb->data + sizeof(struct ieee80211_hdr_3addr),
+		skb->data + sizeof(struct ieee80211_hdr),
+		pkt_len - sizeof(struct ieee80211_hdr));
+
+	pkt_len -= ETH_ALEN + sizeof(pkt_len);
+	rx_pd->rx_pkt_length = cpu_to_le16(pkt_len);
+
+	cfg80211_rx_mgmt(priv->wdev, priv->mgmt_rx_freq,
+			 CAL_RSSI(rx_pd->snr, rx_pd->nf),
+			 skb->data, pkt_len, GFP_ATOMIC);
+
+	return 0;
+}
+
+/*
  * This function processes the received packet before sending it to the
  * kernel.
  *
-- 
1.7.0.2

