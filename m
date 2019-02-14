Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9D7C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4DCB222B6
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbfBNI7c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:32 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39561 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbfBNI7c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xDfn005826, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xDfn005826
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:13 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:12 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 02/24] rtw88: add get_c2h_from_skb for extracting c2h commands
Date:   Thu, 14 Feb 2019 16:58:41 +0800
Message-ID: <1550134743-17443-3-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
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
index 68c422b..12c4de8 100644
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
index 89950c7..86d9c86 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -192,6 +192,14 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
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
 void rtw_fw_send_general_info(struct rtw_dev *rtwdev);
 void rtw_fw_send_phydm_info(struct rtw_dev *rtwdev);
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

