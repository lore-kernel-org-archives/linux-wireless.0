Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34203 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422727AbbFEOBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 10:01:55 -0400
Received: by pdbki1 with SMTP id ki1so54128782pdb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 07:01:54 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] rtlwifi: rtl8192cu: Fix variable isfirst_ampdu
Date: Fri,  5 Jun 2015 23:01:38 +0900
Message-Id: <1433512898-30137-3-git-send-email-ap420073@gmail.com> (sfid-20150605_160201_080796_EF915D9D)
In-Reply-To: <1433512898-30137-1-git-send-email-ap420073@gmail.com>
References: <1433512898-30137-1-git-send-email-ap420073@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl92cu_rx_query_desc set a isampdu twice.
but second code is related to isfirst_ampdu.
so i change it.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index cbead00..95880fe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -321,7 +321,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	stats->rate = (u8) GET_RX_DESC_RX_MCS(pdesc);
 	stats->shortpreamble = (u16) GET_RX_DESC_SPLCP(pdesc);
 	stats->isampdu = (bool) (GET_RX_DESC_PAGGR(pdesc) == 1);
-	stats->isampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
+	stats->isfirst_ampdu = (bool)((GET_RX_DESC_PAGGR(pdesc) == 1)
 				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
-- 
2.1.4

