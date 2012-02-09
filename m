Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server514c.exghost.com ([72.32.253.76]:3715 "EHLO
	server514.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752265Ab2BIO4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 09:56:55 -0500
From: Simon Graham <simon.graham@virtualcomputer.com>
To: linux-wireless@vger.kernel.org
Cc: Simon Graham <simon.graham@virtualcomputer.com>,
	linville@tuxdriver.com, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn
Subject: [PATCH v3] rtlwifi: Modify rtl_pci_init to return 0 on success
Date: Thu,  9 Feb 2012 09:55:13 -0500
Message-Id: <1328799314-28867-1-git-send-email-simon.graham@virtualcomputer.com> (sfid-20120209_155658_870108_8712132F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes problem where caller would think routine succeeded when it failed
leading to divide by zero panic.

Signed-off-by: Simon Graham <simon.graham@virtualcomputer.com>
---
 drivers/net/wireless/rtlwifi/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index fb84707..16ec0c1 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1495,7 +1495,7 @@ static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 		return err;
 	}
 
-	return 1;
+	return 0;
 }
 
 static int rtl_pci_start(struct ieee80211_hw *hw)
@@ -1866,7 +1866,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Init PCI sw */
-	err = !rtl_pci_init(hw, pdev);
+	err = rtl_pci_init(hw, pdev);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Failed to init PCI\n");
 		goto fail3;
-- 
1.7.9

