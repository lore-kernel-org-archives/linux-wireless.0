Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47384C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 094FE214C5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 094FE214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbeIZQig (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:38:36 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39495 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbeIZQif (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:38:35 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="21366800"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 26 Sep 2018 03:26:18 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 CHN-SV-EXCH01.mchp-main.com (10.10.76.37) with Microsoft SMTP Server id
 14.3.352.0; Wed, 26 Sep 2018 03:26:18 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/19] wilc: add linux_mon.c
Date:   Wed, 26 Sep 2018 15:55:20 +0530
Message-ID: <1537957525-11467-15-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Moved '/driver/staging/wilc1000/linux_mon.c' to
'drivers/net/wireless/microchip/wilc/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/net/wireless/microchip/wilc/linux_mon.c | 273 ++++++++++++++++++++++++
 1 file changed, 273 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc/linux_mon.c

diff --git a/drivers/net/wireless/microchip/wilc/linux_mon.c b/drivers/net/wireless/microchip/wilc/linux_mon.c
new file mode 100644
index 0000000..a634468
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc/linux_mon.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
+#include "wilc_wfi_cfgoperations.h"
+
+struct wilc_wfi_radiotap_hdr {
+	struct ieee80211_radiotap_header hdr;
+	u8 rate;
+} __packed;
+
+struct wilc_wfi_radiotap_cb_hdr {
+	struct ieee80211_radiotap_header hdr;
+	u8 rate;
+	u8 dump;
+	u16 tx_flags;
+} __packed;
+
+static struct net_device *wilc_wfi_mon; /* global monitor netdev */
+
+static u8 srcadd[6];
+static u8 bssid[6];
+
+#define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
+#define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
+
+#define TX_RADIOTAP_PRESENT ((1 << IEEE80211_RADIOTAP_RATE) |	\
+			     (1 << IEEE80211_RADIOTAP_TX_FLAGS))
+
+void wilc_wfi_monitor_rx(u8 *buff, u32 size)
+{
+	u32 header, pkt_offset;
+	struct sk_buff *skb = NULL;
+	struct wilc_wfi_radiotap_hdr *hdr;
+	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
+
+	if (!wilc_wfi_mon)
+		return;
+
+	if (!netif_running(wilc_wfi_mon))
+		return;
+
+	/* Get WILC header */
+	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
+	le32_to_cpus(&header);
+	/*
+	 * The packet offset field contain info about what type of management
+	 * the frame we are dealing with and ack status
+	 */
+	pkt_offset = GET_PKT_OFFSET(header);
+
+	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
+		/* hostapd callback mgmt frame */
+
+		skb = dev_alloc_skb(size + sizeof(*cb_hdr));
+		if (!skb)
+			return;
+
+		skb_put_data(skb, buff, size);
+
+		cb_hdr = skb_push(skb, sizeof(*cb_hdr));
+		memset(cb_hdr, 0, sizeof(*cb_hdr));
+
+		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
+
+		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(*cb_hdr));
+
+		cb_hdr->hdr.it_present = cpu_to_le32(TX_RADIOTAP_PRESENT);
+
+		cb_hdr->rate = 5;
+
+		if (pkt_offset & IS_MGMT_STATUS_SUCCES)	{
+			/* success */
+			cb_hdr->tx_flags = IEEE80211_RADIOTAP_F_TX_RTS;
+		} else {
+			cb_hdr->tx_flags = IEEE80211_RADIOTAP_F_TX_FAIL;
+		}
+
+	} else {
+		skb = dev_alloc_skb(size + sizeof(*hdr));
+
+		if (!skb)
+			return;
+
+		skb_put_data(skb, buff, size);
+		hdr = skb_push(skb, sizeof(*hdr));
+		memset(hdr, 0, sizeof(struct wilc_wfi_radiotap_hdr));
+		hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
+		hdr->hdr.it_len = cpu_to_le16(sizeof(*hdr));
+		hdr->hdr.it_present = cpu_to_le32
+				(1 << IEEE80211_RADIOTAP_RATE);
+		hdr->rate = 5;
+	}
+
+	skb->dev = wilc_wfi_mon;
+	skb_reset_mac_header(skb);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+	memset(skb->cb, 0, sizeof(skb->cb));
+
+	netif_rx(skb);
+}
+
+struct tx_complete_mon_data {
+	int size;
+	void *buff;
+};
+
+static void mgmt_tx_complete(void *priv, int status)
+{
+	struct tx_complete_mon_data *pv_data = priv;
+	/*
+	 * in case of fully hosting mode, the freeing will be done
+	 * in response to the cfg packet
+	 */
+	kfree(pv_data->buff);
+
+	kfree(pv_data);
+}
+
+static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
+{
+	struct tx_complete_mon_data *mgmt_tx = NULL;
+
+	if (!dev)
+		return -EFAULT;
+
+	netif_stop_queue(dev);
+	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_ATOMIC);
+	if (!mgmt_tx)
+		return -ENOMEM;
+
+	mgmt_tx->buff = kmemdup(buf, len, GFP_ATOMIC);
+	if (!mgmt_tx->buff) {
+		kfree(mgmt_tx);
+		return -ENOMEM;
+	}
+
+	mgmt_tx->size = len;
+
+	wilc_wlan_txq_add_mgmt_pkt(dev, mgmt_tx, mgmt_tx->buff, mgmt_tx->size,
+				   mgmt_tx_complete);
+
+	netif_wake_queue(dev);
+	return 0;
+}
+
+static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
+				     struct net_device *dev)
+{
+	u32 rtap_len, ret = 0;
+	struct wilc_wfi_mon_priv  *mon_priv;
+	struct sk_buff *skb2;
+	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
+
+	if (!wilc_wfi_mon)
+		return -EFAULT;
+
+	mon_priv = netdev_priv(wilc_wfi_mon);
+	if (!mon_priv)
+		return -EFAULT;
+	rtap_len = ieee80211_get_radiotap_len(skb->data);
+	if (skb->len < rtap_len)
+		return -1;
+
+	skb_pull(skb, rtap_len);
+
+	if (skb->data[0] == 0xc0 && is_broadcast_ether_addr(&skb->data[4])) {
+		skb2 = dev_alloc_skb(skb->len + sizeof(*cb_hdr));
+		if (!skb2)
+			return -ENOMEM;
+
+		skb_put_data(skb2, skb->data, skb->len);
+
+		cb_hdr = skb_push(skb2, sizeof(*cb_hdr));
+		memset(cb_hdr, 0, sizeof(struct wilc_wfi_radiotap_cb_hdr));
+
+		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
+
+		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(*cb_hdr));
+
+		cb_hdr->hdr.it_present = cpu_to_le32(TX_RADIOTAP_PRESENT);
+
+		cb_hdr->rate = 5;
+		cb_hdr->tx_flags = 0x0004;
+
+		skb2->dev = wilc_wfi_mon;
+		skb_reset_mac_header(skb2);
+		skb2->ip_summed = CHECKSUM_UNNECESSARY;
+		skb2->pkt_type = PACKET_OTHERHOST;
+		skb2->protocol = htons(ETH_P_802_2);
+		memset(skb2->cb, 0, sizeof(skb2->cb));
+
+		netif_rx(skb2);
+
+		return 0;
+	}
+	skb->dev = mon_priv->real_ndev;
+
+	memcpy(srcadd, &skb->data[10], 6);
+	memcpy(bssid, &skb->data[16], 6);
+	/*
+	 * Identify if data or mgmt packet, if source address and bssid
+	 * fields are equal send it to mgmt frames handler
+	 */
+	if (!(memcmp(srcadd, bssid, 6))) {
+		ret = mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
+		if (ret)
+			netdev_err(dev, "fail to mgmt tx\n");
+		dev_kfree_skb(skb);
+	} else {
+		ret = wilc_mac_xmit(skb, mon_priv->real_ndev);
+	}
+
+	return ret;
+}
+
+static const struct net_device_ops wilc_wfi_netdev_ops = {
+	.ndo_start_xmit         = wilc_wfi_mon_xmit,
+
+};
+
+struct net_device *wilc_wfi_init_mon_interface(const char *name,
+					       struct net_device *real_dev)
+{
+	struct wilc_wfi_mon_priv *priv;
+
+	/*If monitor interface is already initialized, return it*/
+	if (wilc_wfi_mon)
+		return wilc_wfi_mon;
+
+	wilc_wfi_mon = alloc_etherdev(sizeof(struct wilc_wfi_mon_priv));
+	if (!wilc_wfi_mon)
+		return NULL;
+	wilc_wfi_mon->type = ARPHRD_IEEE80211_RADIOTAP;
+	strncpy(wilc_wfi_mon->name, name, IFNAMSIZ);
+	wilc_wfi_mon->name[IFNAMSIZ - 1] = 0;
+	wilc_wfi_mon->netdev_ops = &wilc_wfi_netdev_ops;
+
+	if (register_netdevice(wilc_wfi_mon)) {
+		netdev_err(real_dev, "register_netdevice failed\n");
+		return NULL;
+	}
+	priv = netdev_priv(wilc_wfi_mon);
+	if (!priv)
+		return NULL;
+
+	priv->real_ndev = real_dev;
+
+	return wilc_wfi_mon;
+}
+
+void wilc_wfi_deinit_mon_interface(void)
+{
+	bool rollback_lock = false;
+
+	if (wilc_wfi_mon) {
+		if (rtnl_is_locked()) {
+			rtnl_unlock();
+			rollback_lock = true;
+		}
+		unregister_netdev(wilc_wfi_mon);
+
+		if (rollback_lock) {
+			rtnl_lock();
+			rollback_lock = false;
+		}
+		wilc_wfi_mon = NULL;
+	}
+}
-- 
2.7.4

