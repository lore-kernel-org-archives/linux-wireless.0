Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40896 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaEBGs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 02:48:26 -0400
Received: by mail-pd0-f182.google.com with SMTP id v10so4213717pde.41
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 23:48:26 -0700 (PDT)
Received: from mail.pileus.org (76-219-180-192.lightspeed.irvnca.sbcglobal.net. [76.219.180.192])
        by mx.google.com with ESMTPSA id xg8sm175477322pac.26.2014.05.01.23.48.21
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 May 2014 23:48:22 -0700 (PDT)
Received: from andy by mail.pileus.org with local (Exim 4.80.1)
	(envelope-from <andy@pileus.org>)
	id 1Wg7GX-00084N-VB
	for linux-wireless@vger.kernel.org; Fri, 02 May 2014 06:48:13 +0000
Date: Fri, 2 May 2014 06:48:13 +0000
From: Andy Spencer <andy753421@ucla.edu>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] RTL8192CU: Increase max APFM_ONMAC polling count
Message-ID: <20140502064813.GA30179@pileus.org> (sfid-20140502_084834_917808_3CDB1FAA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With certain hardware combinations the poll interval is exceeded before
initialization completes.

Tested on a MacBookPro10,1 using a Sabrent USB-A11N USB adapter.

Signed-off-by: Andy Spencer <andy753421@ucla.edu>
---
I was unable to reproduce this issue using other hardware combinations.
I thought it might be a USB3 issue but another laptop with USB3 worked
without the patch.

With my hardware the polling count reaches around 230 before
initialization completes.

 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -511,7 +511,7 @@ static int _rtl92cu_init_power_on(struct ieee80211_hw *hw)
 			pr_info("MAC auto ON okay!\n");
 			break;
 		}
-		if (pollingCount++ > 100) {
+		if (pollingCount++ > 1000) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
 				 "Failed to polling REG_APS_FSMCO[APFM_ONMAC] done!\n");
 			return -ENODEV;
