Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5548AC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8DA218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbfAaMWE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:04 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53693 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732190AbfAaMWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:02 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLiYd016727, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLiYd016727
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:45 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:44 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/24] rtw88: report correct tx status if mac80211 requested one
Date:   Thu, 31 Jan 2019 20:21:14 +0800
Message-ID: <1548937297-14660-2-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Before this commit, driver always reports IEEE80211_TX_STAT_ACK for
every tx packet, but it will confuse the mac80211 stack for connection
monitor system. mac80211 stack needs correct ack information about some
specific packets such as prop_req, null, auth, assoc, in order to know
if AP is alive. And for such packets, mac80211 will pass a tx flag
IEEE80211_TX_CTL_REQ_TX_STATUS to driver. Driver then need to request a
tx report from hardware.

The tx report is not passed by hardware with the tx'ed packet, it is
passed through C2H. So driver need to queue the packets that require
correct tx report and upon the tx report is received, report to mac80211
stack, with the frame is acked or not.

In case of driver missed the C2H report, setup a 500ms timer to purge
the tx report skb queue (500ms is time mac80211 used as probe_time).

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c   | 21 ++++++-
 drivers/net/wireless/realtek/rtw88/fw.h   |  8 +++
 drivers/net/wireless/realtek/rtw88/main.c | 10 ++++
 drivers/net/wireless/realtek/rtw88/main.h | 13 +++++
 drivers/net/wireless/realtek/rtw88/pci.c  |  8 ++-
 drivers/net/wireless/realtek/rtw88/pci.h  |  1 +
 drivers/net/wireless/realtek/rtw88/tx.c   | 96 +++++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h   |  8 +++
 8 files changed, 163 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 194bb87..8ab1bbd 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -8,6 +8,25 @@
 #include "reg.h"
 #include "debug.h"
 
+void rtw_fw_c2h_cmd_handle_ext(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct rtw_c2h_cmd *c2h;
+	u32 pkt_offset;
+	u8 sub_cmd_id;
+
+	pkt_offset = *((u32 *)skb->cb);
+	c2h = (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
+	sub_cmd_id = c2h->payload[0];
+
+	switch (sub_cmd_id) {
+	case C2H_CCX_RPT:
+		rtw_tx_report_handle(rtwdev, skb);
+		break;
+	default:
+		break;
+	}
+}
+
 void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
 {
 	struct rtw_c2h_cmd *c2h;
@@ -23,7 +42,7 @@ void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
 
 	switch (c2h->id) {
 	case C2H_HALMAC:
-		/* halmac needs rx_desc + c2h payload */
+		rtw_fw_c2h_cmd_handle_ext(rtwdev, skb);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 6b56020..6b03629 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -40,6 +40,10 @@ enum rtw_c2h_cmd_id {
 	C2H_HALMAC = 0xff,
 };
 
+enum rtw_c2h_cmd_id_ext {
+	C2H_CCX_RPT = 0x0f,
+};
+
 struct rtw_c2h_cmd {
 	u8 id;
 	u8 seq;
@@ -87,6 +91,10 @@ struct rtw_rsvd_page {
 	bool add_txdesc;
 };
 
+/* C2H */
+#define GET_CCX_REPORT_SEQNUM(c2h_payload)	(c2h_payload[8] & 0xfc)
+#define GET_CCX_REPORT_STATUS(c2h_payload)	(c2h_payload[9] & 0xc0)
+
 /* PKT H2C */
 #define H2C_PKT_CMD_ID 0xFF
 #define H2C_PKT_CATEGORY 0x01
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 5225dff..ef010dc 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1081,14 +1081,19 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	INIT_LIST_HEAD(&rtwdev->rsvd_page_list);
 
+	timer_setup(&rtwdev->tx_report.purge_timer,
+		    rtw_tx_report_purge_timer, 0);
+
 	INIT_DELAYED_WORK(&rtwdev->watch_dog_work, rtw_watch_dog_work);
 	INIT_DELAYED_WORK(&rtwdev->lps_work, rtw_lps_work);
 	INIT_WORK(&rtwdev->c2h_work, rtw_c2h_work);
 	skb_queue_head_init(&rtwdev->c2h_queue);
+	skb_queue_head_init(&rtwdev->tx_report.queue);
 
 	spin_lock_init(&rtwdev->dm_lock);
 	spin_lock_init(&rtwdev->rf_lock);
 	spin_lock_init(&rtwdev->h2c.lock);
+	spin_lock_init(&rtwdev->tx_report.q_lock);
 
 	mutex_init(&rtwdev->mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
@@ -1120,10 +1125,15 @@ void rtw_core_deinit(struct rtw_dev *rtwdev)
 {
 	struct rtw_fw_state *fw = &rtwdev->fw;
 	struct rtw_rsvd_page *rsvd_pkt, *tmp;
+	unsigned long flags;
 
 	if (fw->firmware)
 		release_firmware(fw->firmware);
 
+	spin_lock_irqsave(&rtwdev->tx_report.q_lock, flags);
+	skb_queue_purge(&rtwdev->tx_report.queue);
+	spin_unlock_irqrestore(&rtwdev->tx_report.q_lock, flags);
+
 	list_for_each_entry_safe(rsvd_pkt, tmp, &rtwdev->rsvd_page_list, list) {
 		list_del(&rsvd_pkt->list);
 		kfree(rsvd_pkt);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index b345fe0..6574811 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -447,6 +447,7 @@ struct rtw_tx_pkt_info {
 	u8 qsel;
 	u8 bw;
 	u8 sec_type;
+	u8 sn;
 	bool ampdu_en;
 	u8 ampdu_factor;
 	u8 ampdu_density;
@@ -459,6 +460,7 @@ struct rtw_tx_pkt_info {
 	bool ls;
 	bool fs;
 	bool short_gi;
+	bool report;
 };
 
 struct rtw_rx_pkt_stat {
@@ -547,6 +549,14 @@ struct rtw_sec_desc {
 	DECLARE_BITMAP(cam_map, RTW_MAX_SEC_CAM_NUM);
 };
 
+struct rtw_tx_report {
+	/* protect the tx report queue */
+	spinlock_t q_lock;
+	struct sk_buff_head queue;
+	atomic_t sn;
+	struct timer_list purge_timer;
+};
+
 #define RTW_BC_MC_MACID 1
 DECLARE_EWMA(rssi, 10, 16);
 
@@ -1021,6 +1031,8 @@ struct rtw_dev {
 	struct sk_buff_head c2h_queue;
 	struct work_struct c2h_work;
 
+	struct rtw_tx_report tx_report;
+
 	struct {
 		/* incicate the mail box to use with fw */
 		u8 last_box_num;
@@ -1107,6 +1119,7 @@ void rtw_get_channel_params(struct cfg80211_chan_def *chandef,
 void rtw_set_channel(struct rtw_dev *rtwdev);
 void rtw_vif_port_config(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
 			 u32 config);
+void rtw_tx_report_purge_timer(struct timer_list *t);
 void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
 int rtw_core_start(struct rtw_dev *rtwdev);
 void rtw_core_stop(struct rtw_dev *rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index ef3c9bb..7de4638 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -585,6 +585,7 @@ static int rtw_pci_xmit(struct rtw_dev *rtwdev,
 
 	tx_data = rtw_pci_get_tx_data(skb);
 	tx_data->dma = dma;
+	tx_data->sn = pkt_info->sn;
 	skb_queue_tail(&ring->queue, skb);
 
 	/* kick off tx queue */
@@ -716,8 +717,13 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
 
 		info = IEEE80211_SKB_CB(skb);
+
+		/* enqueue to wait for tx report */
+		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
+			continue;
+		}
 		ieee80211_tx_info_clear_status(info);
-		info->flags |= IEEE80211_TX_STAT_ACK;
 		ieee80211_tx_status_irqsafe(hw, skb);
 	}
 
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 0b672f0..1658647 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -140,6 +140,7 @@ struct rtw_pci_tx_buffer_desc {
 
 struct rtw_pci_tx_data {
 	dma_addr_t dma;
+	u8 sn;
 };
 
 struct rtw_pci_ring {
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 49feb02..21516b7 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -4,6 +4,7 @@
 
 #include "main.h"
 #include "tx.h"
+#include "fw.h"
 #include "ps.h"
 
 static
@@ -55,6 +56,8 @@ void rtw_tx_fill_tx_desc(struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb)
 	SET_TX_DESC_AGG_EN(txdesc, pkt_info->ampdu_en);
 	SET_TX_DESC_LS(txdesc, pkt_info->ls);
 	SET_TX_DESC_DATA_SHORT(txdesc, pkt_info->short_gi);
+	SET_TX_DESC_SPE_RPT(txdesc, pkt_info->report);
+	SET_TX_DESC_SW_DEFINE(txdesc, pkt_info->sn);
 }
 EXPORT_SYMBOL(rtw_tx_fill_tx_desc);
 
@@ -128,6 +131,96 @@ static u8 get_highest_vht_tx_rate(struct rtw_dev *rtwdev,
 	return rate;
 }
 
+static void rtw_tx_report_enable(struct rtw_dev *rtwdev,
+				 struct rtw_tx_pkt_info *pkt_info)
+{
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+
+	/* [11:8], reserved, fills with zero
+	 * [7:2],  tx report sequence number
+	 * [1:0],  firmware use, fills with zero
+	 */
+	pkt_info->sn = (atomic_inc_return(&tx_report->sn) << 2) & 0xfc;
+	pkt_info->report = true;
+}
+
+void rtw_tx_report_purge_timer(struct timer_list *t)
+{
+	struct rtw_dev *rtwdev = from_timer(rtwdev, t, tx_report.purge_timer);
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+	unsigned long flags;
+
+	if (skb_queue_len(&tx_report->queue) == 0)
+		return;
+
+	WARN(1, "purge skb(s) not reported by firmware\n");
+
+	spin_lock_irqsave(&tx_report->q_lock, flags);
+	skb_queue_purge(&tx_report->queue);
+	spin_unlock_irqrestore(&tx_report->q_lock, flags);
+}
+
+void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
+{
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+	unsigned long flags;
+	u8 *drv_data;
+
+	/* pass sn to tx report handler through driver data */
+	drv_data = (u8 *)IEEE80211_SKB_CB(skb)->status.status_driver_data;
+	*drv_data = sn;
+
+	spin_lock_irqsave(&tx_report->q_lock, flags);
+	__skb_queue_tail(&tx_report->queue, skb);
+	spin_unlock_irqrestore(&tx_report->q_lock, flags);
+
+	mod_timer(&tx_report->purge_timer, jiffies + RTW_TX_PROBE_TIMEOUT);
+}
+EXPORT_SYMBOL(rtw_tx_report_enqueue);
+
+static void rtw_tx_report_tx_status(struct rtw_dev *rtwdev,
+				    struct sk_buff *skb, bool acked)
+{
+	struct ieee80211_tx_info *info;
+
+	info = IEEE80211_SKB_CB(skb);
+	ieee80211_tx_info_clear_status(info);
+	if (acked)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	else
+		info->flags &= ~IEEE80211_TX_STAT_ACK;
+
+	ieee80211_tx_status_irqsafe(rtwdev->hw, skb);
+}
+
+void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
+	struct rtw_c2h_cmd *c2h;
+	struct sk_buff *cur, *tmp;
+	unsigned long flags;
+	u32 pkt_offset;
+	u8 sn, st;
+	u8 *n;
+
+	pkt_offset = *((u32 *)skb->cb);
+	c2h = (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
+
+	sn = GET_CCX_REPORT_SEQNUM(c2h->payload);
+	st = GET_CCX_REPORT_STATUS(c2h->payload);
+
+	spin_lock_irqsave(&tx_report->q_lock, flags);
+	skb_queue_walk_safe(&tx_report->queue, cur, tmp) {
+		n = (u8 *)IEEE80211_SKB_CB(cur)->status.status_driver_data;
+		if (*n == sn) {
+			__skb_unlink(cur, &tx_report->queue);
+			rtw_tx_report_tx_status(rtwdev, cur, st == 0);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&tx_report->q_lock, flags);
+}
+
 static void rtw_tx_mgmt_pkt_info_update(struct rtw_dev *rtwdev,
 					struct rtw_tx_pkt_info *pkt_info,
 					struct ieee80211_tx_control *control,
@@ -241,6 +334,9 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
 	bmc = is_broadcast_ether_addr(hdr->addr1) ||
 	      is_multicast_ether_addr(hdr->addr1);
 
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+		rtw_tx_report_enable(rtwdev, pkt_info);
+
 	pkt_info->bmc = bmc;
 	pkt_info->sec_type = sec_type;
 	pkt_info->tx_pkt_size = skb->len;
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index 010a055..6782632 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -7,6 +7,8 @@
 
 #define RTK_TX_MAX_AGG_NUM_MASK		0x1f
 
+#define RTW_TX_PROBE_TIMEOUT		msecs_to_jiffies(500)
+
 #define SET_TX_DESC_TXPKTSIZE(txdesc, value)                                   \
 	le32p_replace_bits((__le32 *)(txdesc) + 0x00, value, GENMASK(15, 0))
 #define SET_TX_DESC_OFFSET(txdesc, value)                                      \
@@ -45,6 +47,10 @@
 	le32p_replace_bits((__le32 *)(txdesc) + 0x00, value, BIT(26))
 #define SET_TX_DESC_DATA_SHORT(txdesc, value)				       \
 	le32p_replace_bits((__le32 *)(txdesc) + 0x05, value, BIT(4))
+#define SET_TX_DESC_SPE_RPT(tx_desc, value)                                    \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x02, value, BIT(19))
+#define SET_TX_DESC_SW_DEFINE(tx_desc, value)                                  \
+	le32p_replace_bits((__le32 *)(txdesc) + 0x06, value, GENMASK(11, 0))
 
 enum rtw_tx_desc_queue_select {
 	TX_DESC_QSEL_TID0	= 0,
@@ -74,6 +80,8 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
 			    struct ieee80211_tx_control *control,
 			    struct sk_buff *skb);
 void rtw_tx_fill_tx_desc(struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb);
+void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn);
+void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb);
 void rtw_rsvd_page_pkt_info_update(struct rtw_dev *rtwdev,
 				   struct rtw_tx_pkt_info *pkt_info,
 				   struct sk_buff *skb);
-- 
2.7.4

