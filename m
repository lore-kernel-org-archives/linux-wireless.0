Return-Path: <SRS0=JKVC=45=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB65C4CECE
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Mar 2020 16:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30C020716
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Mar 2020 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584028977;
	bh=0sP3xQJnSSPWdJPq59NoY8TpyORlbZzrCx0XGTjsAaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VB/ufCJLzUnMT+r1bw1IB/CuoUGwx3c00Ttdj55RpXvKBmXyZgC2rBtSDlVAHjNq4
	 NZaUbltjKHh8hhRVggNf/RdufSBvkXSqisOGA+xJSoMI9HYTjjXK6vDZa59DWcHqW5
	 Xdtm5xGi6H3tWLGpLAOKHJRyOfeUbE3HMiy56/ok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgCLQC4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Mar 2020 12:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbgCLQCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Mar 2020 12:02:55 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 446E0206FA;
        Thu, 12 Mar 2020 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584028975;
        bh=0sP3xQJnSSPWdJPq59NoY8TpyORlbZzrCx0XGTjsAaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f71ErHxn1na6V2ik3w9ifJKKQLQ72fzvf3xKavAlKVOBQmTDz/yE72aQ/FA4bY3gc
         0IQBh1VIP01nic5zmBLsP9dvc/A4jwOIi9jirN0rUEROqp9s6x3ZUVcc+D7Bemjk0s
         V8N41IVOjNmhH/McU2XSsShdRpSXGW+EVDc+peUI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        ryder.lee@mediatek.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 05/25] mt76: always init to 0 mcu messages
Date:   Thu, 12 Mar 2020 17:02:15 +0100
Message-Id: <491494d2a8a084ee3e418d7d9a8d3e610cfcb1fd.1584028319.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1584028319.git.lorenzo@kernel.org>
References: <cover.1584028319.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Always initialize to 0 mcu messages since if they are not propely
configured they could hang the firmware.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mcu.c        | 6 ++++--
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 1 -
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mcu.c b/drivers/net/wireless/mediatek/mt76/mcu.c
index 633ad948c21d..4048f446e3ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mcu.c
@@ -9,14 +9,16 @@ struct sk_buff *
 mt76_mcu_msg_alloc(const void *data, int head_len,
 		   int data_len, int tail_len)
 {
+	int length = head_len + data_len + tail_len;
 	struct sk_buff *skb;
 
-	skb = alloc_skb(head_len + data_len + tail_len,
-			GFP_KERNEL);
+	skb = alloc_skb(length, GFP_KERNEL);
 	if (!skb)
 		return NULL;
 
+	memset(skb->head, 0, length);
 	skb_reserve(skb, head_len);
+
 	if (data && data_len)
 		skb_put_data(skb, data, data_len);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index b466b3ab8a2c..77985d81c447 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -27,7 +27,6 @@ __mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb,
 		seq = ++mdev->mcu.msg_seq & 0xf;
 
 	txd = (struct mt7603_mcu_txd *)skb_push(skb, hdrlen);
-	memset(txd, 0, hdrlen);
 
 	txd->len = cpu_to_le16(skb->len);
 	if (cmd == -MCU_CMD_FW_SCATTER)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index b24240f90a7d..b94b1b73fd1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -62,7 +62,6 @@ void mt7615_mcu_fill_msg(struct mt7615_dev *dev, struct sk_buff *skb,
 		seq = ++dev->mt76.mcu.msg_seq & 0xf;
 
 	mcu_txd = (struct mt7615_mcu_txd *)skb_push(skb, sizeof(*mcu_txd));
-	memset(mcu_txd, 0, sizeof(*mcu_txd));
 
 	if (cmd != -MCU_CMD_FW_SCATTER) {
 		q_idx = MT_TX_MCU_PORT_RX_Q0;
-- 
2.24.1

