Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0548C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46E79206DD
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMjfUNSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfDDS3o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 14:29:44 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36928 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfDDS3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 14:29:44 -0400
Received: by mail-oi1-f196.google.com with SMTP id v84so2747715oif.4
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 11:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HFXFw1kVL/FgCKVvF5OHLLt6V2ZCPqN2wyj6Xqdrn/g=;
        b=eMjfUNSzzIfJPQWCPKNrmLkD66uDN0ZeVfeBfBj5h2LsOP9hlMUNOYnbfvrHuM9o6a
         FtDSoFaATSYOSuK7nlEg2nltZF6/ohrsHhrV+gdo4Co9xBCyTQ0+xvWK6qjqJMcAJyW1
         D0ngXnjKWrU7P3ORTtiwcAex4Jmua1JYHc8ODHXveTB6bR8gIUNVq/K0tVVGv5e1bZRt
         rqmeCcVyc46wJsE/xjwLbPOBM6B6tGSlMK5Hl5ZDrMK3E1RItbVsD+MNYHhznmRJKGeZ
         QXmM+1bnu+gsxRfE/J7ulFEoCSLxABA3k0HZB8GnobQpSHdoCOzwwCqYjqoGKU67mi5k
         w16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=HFXFw1kVL/FgCKVvF5OHLLt6V2ZCPqN2wyj6Xqdrn/g=;
        b=HInV1/zi0Ar5U2fEhoF0Zt6zTEGcKG2VjixKt/Ze8ghVPzujUkbKrgI8h8o2RtNx2o
         2OLugIa8p9HlQnJQfkG6oIjm6S6cg/dsbjQlyfXogX58uKvu2cAln5H2lV64OgkIIWmB
         FOqDJfmyidzcx2J2LSWqgRNv1HuWjrQM/fD5+7UWxqLJBJ+EPoXW9A0OHBdWs6dC/qvb
         X3biKDcVRtgD6GBmKyd8TjsQKmdTebyZc8nsWF3SZvozRqkGH5EcCY9fgPvjSMnquJfE
         ri4ffOSYtQBzhnOiy6sefnjb2bDLz5E/lZVw4NIqx5DgKTjq1iVq4PRf3n2kT9HXlHdn
         XgzQ==
X-Gm-Message-State: APjAAAWo6zrKh9/f6QRCgNGxWQo9h8qqeXBplzyu96DB9MlPGUunyVBR
        7Qpa2RmpXa/EspadbWTm5k8x8O5G
X-Google-Smtp-Source: APXvYqwDPxht7FHYaNnhVZ+VwwH3F+XTRTHLYF17LkxgUEyxp+oXFziQHB6SZJpc2r4gf6/0pMAn6w==
X-Received: by 2002:aca:5010:: with SMTP id e16mr4468067oib.27.1554402583471;
        Thu, 04 Apr 2019 11:29:43 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a16sm7787996otl.4.2019.04.04.11.29.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 11:29:42 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 2/2] rtlwifi: Convert the wake_match variable to local
Date:   Thu,  4 Apr 2019 13:29:31 -0500
Message-Id: <20190404182931.9477-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404182931.9477-1-Larry.Finger@lwfinger.net>
References: <20190404182931.9477-1-Larry.Finger@lwfinger.net>
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
V2 - Fixed Merge problem
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c  | 15 ++++++++-------
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej  | 10 ++++++++++
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c  | 13 +++++++------
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c  | 14 +++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c  | 14 +++++++-------
 drivers/net/wireless/realtek/rtlwifi/wifi.h       |  1 -
 6 files changed, 39 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 2dd01696c014..483dc8bdc555 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -372,8 +372,9 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rx_fwinfo_88e *p_drvinfo;
 	struct ieee80211_hdr *hdr;
-
+	u8 wake_match;
 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
+
 	status->packet_report_type = (u8)GET_RX_STATUS_DESC_RPT_SEL(pdesc);
 	if (status->packet_report_type == TX_REPORT2)
 		status->length = (u16)GET_RX_RPT2_DESC_PKT_LEN(pdesc);
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
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
new file mode 100644
index 000000000000..aa03d4605d8c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
@@ -0,0 +1,10 @@
+--- drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
++++ drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+@@ -373,6 +373,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
+ 	struct rx_fwinfo_88e *p_drvinfo;
+ 	struct ieee80211_hdr *hdr;
+ 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
++	u8 wake_match;
+ 
+ 	status->packet_report_type = (u8)GET_RX_STATUS_DESC_RPT_SEL(pdesc);
+ 	if (status->packet_report_type == TX_REPORT2)
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

