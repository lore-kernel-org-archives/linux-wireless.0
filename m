Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E69285C8B
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2026 06:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063583; cv=none; b=KAh6DPq6pyzb8Zfe60gRYrs2YL4ZVWzXcPqN+SpzcGc5bdix/E5yJuFMxfQ6EQSyOTAZbdB9TlA0kAR+UroYSn4GuCibEOB8RyaSFVONhOtjCTRT41mPu7GBw15Vhy/rGSx0+PKSN2CXxfSmDERCEKTN/nZ8marqDwGGRd12+4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063583; c=relaxed/simple;
	bh=KCKF5J6bN2QKrs5eozOwta3xBfIq/ygyCjZeraamVQ4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qBKhw1I1nUd8+H2PZg14/aHYEFMI9ZpdWKvql/qFj7eRbHaIlhKN8Z8dnHFsfrZp3TSQJcbsNt4d/G4IISdrop4H8IFI/XHpviLXNAkT3DUmnNjHSSgyM+i3RKxdsRXXt4xAX/iyWu4Dzp+sMTflp/+YZQe//Dur9W7N/n7q4pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rpKtpZZ5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rpKtpZZ5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63D6xcpK73794751, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776063578; bh=2UPMzgKRTDXAALbczLQ1ETRKFJ3ZQcFB/XSw15eM7Fw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=rpKtpZZ5ZhsHv3LyMRIVL5x5yhzkAPiMsDpB2xfAzXbM4zqImcOcY/XqPmQmesIzR
	 83AqWr5pJ1aCgsOQD7LygcfN8zNcOMDtrSEBIDk9h0NeZOnfsxisFtolQnTc04ZP7K
	 CFqVDLuJk/lPyHCEWbeJlZlZuDjnhIxVtVvwUntbaNVulJamdvYBYPIEY81Sbmso5A
	 yYeIEv0HLIw0as+fp85zCXeveVVxqbmrtHLC7mtE9EE0BCNAmtwF+NyQddu0OLzKy5
	 fGZmWsmGxif21Oif4f4UgCi3VY92hQFLsXUrHn81/atVbH0BXMWYl6L1r+kUQwk5yP
	 m5T3J/jTH+aPQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63D6xcpK73794751
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2026 14:59:38 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 13 Apr 2026 14:59:38 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 13 Apr 2026 14:59:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>
Subject: [PATCH rtw-next] wifi: rtw88: fix wrong pci_get_drvdata type in AER handlers
Date: Mon, 13 Apr 2026 14:59:26 +0800
Message-ID: <20260413065926.17027-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chin-Yen Lee <timlee@realtek.com>

rtw88 stores an ieee80211_hw pointer via pci_set_drvdata() at probe
time, but io_error_detected() and io_resume() retrieve it as a
net_device pointer.  This causes netif_device_detach/attach to
operate on an ieee80211_hw struct, reading and writing at wrong
offsets.

Use ieee80211_stop_queues/wake_queues instead, consistent with
every other queue stop/start path in the driver.

Fixes: cdb82c80b934 ("wifi: rtw88: pci: add PCI Express error handling")
Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index bba370ad510c..c56beacbb1b0 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1711,9 +1711,9 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 static pci_ers_result_t rtw_pci_io_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
-	netif_device_detach(netdev);
+	ieee80211_stop_queues(hw);
 
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -1730,12 +1730,12 @@ static pci_ers_result_t rtw_pci_io_slot_reset(struct pci_dev *pdev)
 
 static void rtw_pci_io_resume(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
 	/* ack any pending wake events, disable PME */
 	pci_enable_wake(pdev, PCI_D0, 0);
 
-	netif_device_attach(netdev);
+	ieee80211_wake_queues(hw);
 }
 
 const struct pci_error_handlers rtw_pci_err_handler = {

base-commit: fa489a77e3267e05df95db96ba98e141ec07cbd9
-- 
2.25.1

