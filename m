Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255B5C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 11:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E80D320841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 11:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E80D320841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbeJHSdk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 14:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbeJHSdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 14:33:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7BA4B30832EE;
        Mon,  8 Oct 2018 11:22:24 +0000 (UTC)
Received: from localhost (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72CA35DD6B;
        Mon,  8 Oct 2018 11:22:21 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: remove dma.h
Date:   Mon,  8 Oct 2018 13:22:20 +0200
Message-Id: <1538997740-14007-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 08 Oct 2018 11:22:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

dma.h is not used any longer.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h | 126 ------------------------
 1 file changed, 126 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.h b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
deleted file mode 100644
index 891ce1c3461f..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MT76X0U_DMA_H
-#define __MT76X0U_DMA_H
-
-#include <asm/unaligned.h>
-#include <linux/skbuff.h>
-
-#define MT_DMA_HDR_LEN			4
-#define MT_RX_INFO_LEN			4
-#define MT_FCE_INFO_LEN			4
-#define MT_DMA_HDRS			(MT_DMA_HDR_LEN + MT_RX_INFO_LEN)
-
-/* Common Tx DMA descriptor fields */
-#define MT_TXD_INFO_LEN		GENMASK(15, 0)
-#define MT_TXD_INFO_D_PORT	GENMASK(29, 27)
-#define MT_TXD_INFO_TYPE	GENMASK(31, 30)
-
-/* Tx DMA MCU command specific flags */
-#define MT_TXD_CMD_SEQ		GENMASK(19, 16)
-#define MT_TXD_CMD_TYPE		GENMASK(26, 20)
-
-enum mt76_msg_port {
-	WLAN_PORT,
-	CPU_RX_PORT,
-	CPU_TX_PORT,
-	HOST_PORT,
-	VIRTUAL_CPU_RX_PORT,
-	VIRTUAL_CPU_TX_PORT,
-	DISCARD,
-};
-
-enum mt76_info_type {
-	DMA_PACKET,
-	DMA_COMMAND,
-};
-
-/* Tx DMA packet specific flags */
-#define MT_TXD_PKT_INFO_NEXT_VLD	BIT(16)
-#define MT_TXD_PKT_INFO_TX_BURST	BIT(17)
-#define MT_TXD_PKT_INFO_80211		BIT(19)
-#define MT_TXD_PKT_INFO_TSO		BIT(20)
-#define MT_TXD_PKT_INFO_CSO		BIT(21)
-#define MT_TXD_PKT_INFO_WIV		BIT(24)
-#define MT_TXD_PKT_INFO_QSEL		GENMASK(26, 25)
-
-enum mt76_qsel {
-	MT_QSEL_MGMT,
-	MT_QSEL_HCCA,
-	MT_QSEL_EDCA,
-	MT_QSEL_EDCA_2,
-};
-
-
-static inline int mt76x0_dma_skb_wrap(struct sk_buff *skb,
-				       enum mt76_msg_port d_port,
-				       enum mt76_info_type type, u32 flags)
-{
-	u32 info;
-
-	/* Buffer layout:
-	 *	|   4B   | xfer len |      pad       |  4B  |
-	 *	| TXINFO | pkt/cmd  | zero pad to 4B | zero |
-	 *
-	 * length field of TXINFO should be set to 'xfer len'.
-	 */
-
-	info = flags |
-		FIELD_PREP(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
-		FIELD_PREP(MT_TXD_INFO_D_PORT, d_port) |
-		FIELD_PREP(MT_TXD_INFO_TYPE, type);
-
-	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
-	return skb_put_padto(skb, round_up(skb->len, 4) + 4);
-}
-
-static inline int
-mt76x0_dma_skb_wrap_pkt(struct sk_buff *skb, enum mt76_qsel qsel, u32 flags)
-{
-	flags |= FIELD_PREP(MT_TXD_PKT_INFO_QSEL, qsel);
-	return mt76x0_dma_skb_wrap(skb, WLAN_PORT, DMA_PACKET, flags);
-}
-
-/* Common Rx DMA descriptor fields */
-#define MT_RXD_INFO_LEN			GENMASK(13, 0)
-#define MT_RXD_INFO_PCIE_INTR		BIT(24)
-#define MT_RXD_INFO_QSEL		GENMASK(26, 25)
-#define MT_RXD_INFO_PORT		GENMASK(29, 27)
-#define MT_RXD_INFO_TYPE		GENMASK(31, 30)
-
-/* Rx DMA packet specific flags */
-#define MT_RXD_PKT_INFO_UDP_ERR		BIT(16)
-#define MT_RXD_PKT_INFO_TCP_ERR		BIT(17)
-#define MT_RXD_PKT_INFO_IP_ERR		BIT(18)
-#define MT_RXD_PKT_INFO_PKT_80211	BIT(19)
-#define MT_RXD_PKT_INFO_L3L4_DONE	BIT(20)
-#define MT_RXD_PKT_INFO_MAC_LEN		GENMASK(23, 21)
-
-/* Rx DMA MCU command specific flags */
-#define MT_RXD_CMD_INFO_SELF_GEN	BIT(15)
-#define MT_RXD_CMD_INFO_CMD_SEQ		GENMASK(19, 16)
-#define MT_RXD_CMD_INFO_EVT_TYPE	GENMASK(23, 20)
-
-enum mt76_evt_type {
-	CMD_DONE,
-	CMD_ERROR,
-	CMD_RETRY,
-	EVENT_PWR_RSP,
-	EVENT_WOW_RSP,
-	EVENT_CARRIER_DETECT_RSP,
-	EVENT_DFS_DETECT_RSP,
-};
-
-#endif
-- 
2.7.5

