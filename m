Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58054C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 21:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1650A206DD
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 21:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hS7tSX0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbfCDV7u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 16:59:50 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36269 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDV7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 16:59:49 -0500
Received: by mail-ot1-f68.google.com with SMTP id v62so5623806otb.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2019 13:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mjmA6sZgyo6rTWkTe2w0LDRQ8dD8aOc+nSmJuVhtbc4=;
        b=hS7tSX0Ah9I9Hn4FV/8QH/D/JJhGZBpIFI65YkSX3CHlp19w7g6NQc21ikYXz1UaSp
         YhOeL+dtf9uU3EdnUAKssZbZCKK9XykzRr/2poZHSl76ljpXKS+FVKeJnKtdLCOwrPNn
         ky/i5298OQLXI5jj/cV47tphfvIrBJaEweMRVKe28tsJRP8c2oHoEImbtnXIHwu0LG3p
         0Lwm+7uc8KU2TuegT/eUktDJqwVw4tdtmUXJKis9K5ErMnIxs8jx1TtTC27mdZxPCKYZ
         VD6Xvv1mePsuwxZjjlBQUjPWgiFkWEZZpB5dn+nC7X66nMNjmhrc6NjOwH1CjzccS/Fc
         +yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=mjmA6sZgyo6rTWkTe2w0LDRQ8dD8aOc+nSmJuVhtbc4=;
        b=NnILdDPAy58RahArzdPBOcd9ArlP+ZDm35T8Rpog9+Eruc3dAsXA6HDe/Xee4eHVZy
         22q2QpOPYmtsARaCwudjWwimkUxVOgsqs1TTFLAI0YDqN7DSZfeleKDSLaEUiJ1j0ogH
         4B0MP7CaGhg68esArKrV7EJxJf9te+DdHm5dYseRcpF5m0/L9FlxIrxOwalrzb24f/Ri
         jIfwOXifEWSu4sotUea9JvWM/CDy35bMvzY1w+MPT3kU824nvk0Ib1pxdA7lW5l1XapA
         6YXE7bwzaSyLnXqO+qKLHY843QZKcOLJzC3xUEE3SHpZesRZYLQknfSORG5rJ4eqXGga
         HPXQ==
X-Gm-Message-State: APjAAAW0f3u8Myh0Zw7skJk9ANFwHlTwPGO8WgKNbFTw4dIhn80ioUpA
        G+aSiNsQK6rsyCgyKY1jlZk=
X-Google-Smtp-Source: APXvYqwaB+ijQ43XtDHHFpy4qtJG1gytdhsoDDZtVm4L7QbLV/NgfF0ygs0UKKvAdE/wwUMYxIoUXQ==
X-Received: by 2002:a9d:630b:: with SMTP id q11mr14050154otk.14.1551736788610;
        Mon, 04 Mar 2019 13:59:48 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e125sm2923744oia.18.2019.03.04.13.59.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 13:59:48 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/2] rtlwifi: Convert the wake_match variable to local
Date:   Mon,  4 Mar 2019 15:59:40 -0600
Message-Id: <20190304215940.2608-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190304215940.2608-1-Larry.Finger@lwfinger.net>
References: <20190304215940.2608-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In five of the drivers, the contents of bits 29-31 of one of the RX
descriptors is used to set bits in a variable that is used to save the
wakeup condition for output in a debugging statement. The resulting
variable is not used anywhere else even though it is stored in a struct
and could be available in other routines. This variable is changed to be
local.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   | 13 +++++++------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   | 13 +++++++------
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   | 14 +++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   | 14 +++++++-------
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  1 -
 5 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 3a70be92a77c..e5729dc5c832 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -373,6 +373,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 	struct rx_fwinfo_88e *p_drvinfo;
 	struct ieee80211_hdr *hdr;
 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
+	u8 wake_match;
 
 	status->packet_report_type = (u8)GET_RX_STATUS_DESC_RPT_SEL(pdesc);
 	if (status->packet_report_type == TX_REPORT2)
@@ -400,17 +401,17 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 
 	status->macid = GET_RX_DESC_MACID(pdesc);
 	if (GET_RX_STATUS_DESC_PATTERN_MATCH(pdesc))
-		status->wake_match = BIT(2);
+		wake_match = BIT(2);
 	else if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
-		status->wake_match = BIT(1);
+		wake_match = BIT(1);
 	else if (GET_RX_STATUS_DESC_UNICAST_MATCH(pdesc))
-		status->wake_match = BIT(0);
+		wake_match = BIT(0);
 	else
-		status->wake_match = 0;
-	if (status->wake_match)
+		wake_match = 0;
+	if (wake_match)
 		RT_TRACE(rtlpriv, COMP_RXDESC, DBG_LOUD,
 		"GGGGGGGGGGGGGet Wakeup Packet!! WakeMatch=%d\n",
-		status->wake_match);
+		wake_match);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 49a4c84d193a..d297cfc0fd2b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -331,6 +331,7 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 	struct rx_fwinfo *p_drvinfo;
 	struct ieee80211_hdr *hdr;
 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
+	u8 wake_match;
 
 	if (GET_RX_STATUS_DESC_RPT_SEL(pdesc) == 0)
 		status->packet_report_type = NORMAL_RX;
@@ -351,17 +352,17 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 
 	status->macid = GET_RX_DESC_MACID(pdesc);
 	if (GET_RX_STATUS_DESC_PATTERN_MATCH(pdesc))
-		status->wake_match = BIT(2);
+		wake_match = BIT(2);
 	else if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
-		status->wake_match = BIT(1);
+		wake_match = BIT(1);
 	else if (GET_RX_STATUS_DESC_UNICAST_MATCH(pdesc))
-		status->wake_match = BIT(0);
+		wake_match = BIT(0);
 	else
-		status->wake_match = 0;
-	if (status->wake_match)
+		wake_match = 0;
+	if (wake_match)
 		RT_TRACE(rtlpriv, COMP_RXDESC, DBG_LOUD,
 			 "GGGGGGGGGGGGGet Wakeup Packet!! WakeMatch=%d\n",
-			 status->wake_match);
+			 wake_match);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index a382cdc668ed..d87ba03fe78f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -300,7 +300,7 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rx_fwinfo_8723be *p_drvinfo;
 	struct ieee80211_hdr *hdr;
-
+	u8 wake_match;
 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
 
 	status->length = (u16)GET_RX_DESC_PKT_LEN(pdesc);
@@ -330,17 +330,17 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 
 
 	if (GET_RX_STATUS_DESC_PATTERN_MATCH(pdesc))
-		status->wake_match = BIT(2);
+		wake_match = BIT(2);
 	else if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
-		status->wake_match = BIT(1);
+		wake_match = BIT(1);
 	else if (GET_RX_STATUS_DESC_UNICAST_MATCH(pdesc))
-		status->wake_match = BIT(0);
+		wake_match = BIT(0);
 	else
-		status->wake_match = 0;
-	if (status->wake_match)
+		wake_match = 0;
+	if (wake_match)
 		RT_TRACE(rtlpriv, COMP_RXDESC, DBG_LOUD,
 		"GGGGGGGGGGGGGet Wakeup Packet!! WakeMatch=%d\n",
-		status->wake_match);
+		wake_match);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index db5e628b17ed..7b6faf38e09c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -436,7 +436,7 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rx_fwinfo_8821ae *p_drvinfo;
 	struct ieee80211_hdr *hdr;
-
+	u8 wake_match;
 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
 
 	status->length = (u16)GET_RX_DESC_PKT_LEN(pdesc);
@@ -473,18 +473,18 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 		status->packet_report_type = NORMAL_RX;
 
 	if (GET_RX_STATUS_DESC_PATTERN_MATCH(pdesc))
-		status->wake_match = BIT(2);
+		wake_match = BIT(2);
 	else if (GET_RX_STATUS_DESC_MAGIC_MATCH(pdesc))
-		status->wake_match = BIT(1);
+		wake_match = BIT(1);
 	else if (GET_RX_STATUS_DESC_UNICAST_MATCH(pdesc))
-		status->wake_match = BIT(0);
+		wake_match = BIT(0);
 	else
-		status->wake_match = 0;
+		wake_match = 0;
 
-	if (status->wake_match)
+	if (wake_match)
 		RT_TRACE(rtlpriv, COMP_RXDESC, DBG_LOUD,
 			 "GGGGGGGGGGGGGet Wakeup Packet!! WakeMatch=%d\n",
-			 status->wake_match);
+			 wake_match);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index e32e9ffa3192..518aaa875361 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2138,7 +2138,6 @@ struct rtl_stats {
 	u8 packet_report_type;
 
 	u32 macid;
-	u8 wake_match;
 	u32 bt_rx_rssi_percentage;
 	u32 macid_valid_entry[2];
 };
-- 
2.21.0

