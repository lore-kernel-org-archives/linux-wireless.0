Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873DDC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AECC218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbfAaMWB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:01 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53685 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732190AbfAaMWA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:00 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLjp7016731, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLjp7016731
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:45 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:45 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/24] rtw88: add get_c2h_from_skb for extracting c2h commands
Date:   Thu, 31 Jan 2019 20:21:15 +0800
Message-ID: <1548937297-14660-3-git-send-email-yhchuang@realtek.com>
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

pkt_offset is only used when getting the c2h from skb->data, use
get_c2h_from_skb to cleanup the code

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 4 +---
 drivers/net/wireless/realtek/rtw88/fw.h | 8 ++++++++
 drivers/net/wireless/realtek/rtw88/tx.c | 4 +---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 8ab1bbd..60330ba 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -11,11 +11,9 @@
 void rtw_fw_c2h_cmd_handle_ext(struct rtw_dev *rtwdev, struct sk_buff *skb)
 {
 	struct rtw_c2h_cmd *c2h;
-	u32 pkt_offset;
 	u8 sub_cmd_id;
 
-	pkt_offset = *((u32 *)skb->cb);
-	c2h = (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
+	c2h = get_c2h_from_skb(skb);
 	sub_cmd_id = c2h->payload[0];
 
 	switch (sub_cmd_id) {
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 6b03629..0b0e522 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -199,6 +199,14 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 #define SET_RA_INFO_RA_MASK3(h2c_pkt, value)                                   \
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(31, 24))
 
+static inline struct rtw_c2h_cmd *get_c2h_from_skb(struct sk_buff *skb)
+{
+	u32 pkt_offset;
+
+	pkt_offset = *((u32 *)skb->cb);
+	return (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
+}
+
 void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb);
 void rtw_fw_send_general_info(struct rtw_dev *rtwdev,
 			      struct rtw_general_info *info);
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 21516b7..e5267d5 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -199,12 +199,10 @@ void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	struct rtw_c2h_cmd *c2h;
 	struct sk_buff *cur, *tmp;
 	unsigned long flags;
-	u32 pkt_offset;
 	u8 sn, st;
 	u8 *n;
 
-	pkt_offset = *((u32 *)skb->cb);
-	c2h = (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
+	c2h = get_c2h_from_skb(skb);
 
 	sn = GET_CCX_REPORT_SEQNUM(c2h->payload);
 	st = GET_CCX_REPORT_STATUS(c2h->payload);
-- 
2.7.4

