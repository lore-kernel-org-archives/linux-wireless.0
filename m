Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server514f.exghost.com ([72.32.253.73]:4315 "EHLO
	server514.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754193Ab2BHVF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 16:05:26 -0500
Date: Wed, 8 Feb 2012 16:05:09 -0500
From: Simon Graham <simon.graham@virtualcomputer.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn
Subject: [PATCH] iwlwifi: Return correct failure code on error
Message-ID: <20120208210509.GA1250@simgr-precise.oldroadcomputing.net> (sfid-20120208_220530_543342_8BF9818B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Callers of rtl_pci_init expect zero to be returned on error. Returning
the error code leads to, amongst other things, divide by zero panics
attempting to use the ring size that was never set.

---
 drivers/net/wireless/rtlwifi/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index fb84707..f0ce366 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1492,7 +1492,7 @@ static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "tx ring initialization failed\n");
-		return err;
+		return 0;
 	}
 
 	return 1;
-- 
1.7.8.3

