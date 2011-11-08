Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:54265 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751466Ab1KHFom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:44:42 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/7] mwifiex: fix 'Smatch' warnings
Date: Mon,  7 Nov 2011 21:41:10 -0800
Message-Id: <1320730872-25619-6-git-send-email-bzhao@marvell.com> (sfid-20111108_064446_024459_1A3CE1C5)
In-Reply-To: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
References: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Following three warnings are fixed:

>init.c +256 mwifiex_init_adapter(71)
>warn: variable dereferenced before check 'adapter->sleep_cfm'
>(see line 191)

>sta_rx.c +193 mwifiex_process_sta_rx_packet(75)
>warn: variable dereferenced before check 'priv' (see line 182)

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c   |    4 ++--
 drivers/net/wireless/mwifiex/sta_rx.c |   12 +++++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index d792b3f..2694045 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -187,8 +187,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	struct mwifiex_opt_sleep_confirm *sleep_cfm_buf = NULL;
 
 	skb_put(adapter->sleep_cfm, sizeof(struct mwifiex_opt_sleep_confirm));
-	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm *)
-						(adapter->sleep_cfm->data);
 
 	adapter->cmd_sent = false;
 
@@ -254,6 +252,8 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	mwifiex_wmm_init(adapter);
 
 	if (adapter->sleep_cfm) {
+		sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm *)
+						adapter->sleep_cfm->data;
 		memset(sleep_cfm_buf, 0, adapter->sleep_cfm->len);
 		sleep_cfm_buf->command =
 				cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 2743051..5e1ef7e 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -126,6 +126,9 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	u16 rx_pkt_type;
 	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 
+	if (!priv)
+		return -1;
+
 	local_rx_pd = (struct rxpd *) (skb->data);
 	rx_pkt_type = local_rx_pd->rx_pkt_type;
 
@@ -189,12 +192,11 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 					     (u8) local_rx_pd->rx_pkt_type,
 					     skb);
 
-	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
-		if (priv && (ret == -1))
-			priv->stats.rx_dropped++;
-
+	if (ret || (rx_pkt_type == PKT_TYPE_BAR))
 		dev_kfree_skb_any(skb);
-	}
+
+	if (ret)
+		priv->stats.rx_dropped++;
 
 	return ret;
 }
-- 
1.7.0.2

