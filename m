Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D9CC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DB42147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfCLJHQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:07:16 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49920 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfCLJHQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 05:07:16 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x2C96x5M022165, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x2C96x5M022165
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Tue, 12 Mar 2019 17:07:00 +0800
Received: from localhost.localdomain (172.21.69.114) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Tue, 12 Mar 2019 17:06:59 +0800
From:   <pkshih@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <kjlu@umn.edu>
Subject: [PATCH] rtlwifi: fix potential NULL pointer dereference
Date:   Tue, 12 Mar 2019 17:06:48 +0800
Message-ID: <20190312090648.30750-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.69.114]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

In case dev_alloc_skb fails, the fix safely returns to avoid
potential NULL pointer dereference.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c       | 4 ++++
 6 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
index 203e7b574e84..e2e0bfbc24fe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -600,6 +600,8 @@ void rtl88e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 18c76990a089..86b1b88cc4ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -623,6 +623,8 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	if (cmd_send_packet)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 7c5b54b71a92..67305ce915ec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -744,6 +744,8 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
index be451a6f7dbe..33481232fad0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
@@ -448,6 +448,8 @@ void rtl8723e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index 4d7fa27f55ca..aa56058af56e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -562,6 +562,8 @@ void rtl8723be_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      u1rsvdpageloc, sizeof(u1rsvdpageloc));
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index dc0eb692088f..fe32d397d287 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -1623,6 +1623,8 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      &reserved_page_packet_8812[0], totalpacketlen);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet_8812, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
@@ -1759,6 +1761,8 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      &reserved_page_packet_8821[0], totalpacketlen);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet_8821, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
-- 
2.19.1

