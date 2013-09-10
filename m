Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:16243 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IJLSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:18:39 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW0053YQ32TG50@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:18:38 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Larry Finger' <Larry.Finger@lwfinger.net>,
	'Chaoming Li' <chaoming_li@realsil.com.cn>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 02/12] wireless: rtlwifi: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:18:38 +0900
Message-id: <00b301ceae17$7f417480$7dc45d80$%han@samsung.com> (sfid-20130910_131842_867059_C83BF04A)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/rtlwifi/pci.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 703f839..2b6d3e0 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -2009,7 +2009,6 @@ fail2:
 fail1:
 	if (hw)
 		ieee80211_free_hw(hw);
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 
 	return err;
@@ -2064,8 +2063,6 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 
 	rtl_pci_disable_aspm(hw);
 
-	pci_set_drvdata(pdev, NULL);
-
 	ieee80211_free_hw(hw);
 }
 EXPORT_SYMBOL(rtl_pci_disconnect);
-- 
1.7.10.4


