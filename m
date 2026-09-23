Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39061408017
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142360; cv=none; b=N/pLPk8Rd0ooAKZUE4qNCmRNDAM8TgiDKxpXOYuPq0bPTChYkEECyJ+gBM0HdVx61F7YSI/8VNikwWUERDz32RCRyyJikoBRIzbXtP6vnSRFnVTSuiPxDSJw3TDAo1BQr+Td4WJ1eCBvBBOL3sA2BSDDJG5ESNLkwgs3VLnNR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142360; c=relaxed/simple;
	bh=DerqlxMzUBHsaq6uqPvtFHvS2ZQg96ifsAjLblkEYKg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XKTYJYzuoa++1rWp1ZvDoiQ5ENRDkMJSFeX3qo1YRVEbcDQKrOifLzUXsfzvhbn80memRbJGPgw/JPpTi+1LS+4GmnyWBkMvp6wesBcpwsdFBfInO+xnChi520KKfDkClubgqJwUqN8kiHuvt6iCaxVFrjB5F/FAF9du3h+tpd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HtLrVVG+; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HtLrVVG+"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N5jtWuB097445, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790142356; bh=M9I4NU4n7ZogZL4qic7kM6IthOpRNbHuQCKKBZt0L6Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=HtLrVVG+zJsOWBDxuIVA3oohhfpcM10AjGzyDBbDNb8BWLMoq3mUwv+C+R7/jbkVG
	 wkoYi7L1nBlgE0/wKxWk+j6qamCVL3jbfCv0Yk/8RR/eTMKDQ/0jtN7Ifw+T5fK9jx
	 UXGycJdolG3zcC77F9Uh5Ts776QbNnVY3vCxj+4P3kKvWnes5jvo17R4L4MbMTBXzy
	 19nXHqA8f+sgC0v88OfqKcVhfx38FryOzxaOgJGYuPVPX9dio/ktO/VyLOB1Gdt7Iy
	 oJQ70M1XZJgI1xFhzI5XcOajRGlrUVXxW6Q8a8e/bt02APIciTxcFKk7+dysWHK/G4
	 z3NQKbItFAj9Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N5jtWuB097445
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:45:55 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:45:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:45:53 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 13:45:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 2/6] wifi: rtw89: fw: release firmware after recognizing firmware elements
Date: Wed, 23 Sep 2026 13:45:01 +0800
Message-ID: <20260923054505.43329-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923054505.43329-1-pkshih@realtek.com>
References: <20260923054505.43329-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The firmware elements are recognized according to hardware variants in
rtw89_chip_info_setup(), and the last function uses firmware content is
rtw89_core_setup_rfe_parms(). Release firmware at the end of the function
if we have duplicated the elements.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c |  4 ++++
 drivers/net/wireless/realtek/rtw89/fw.c   | 24 ++++++++++++++---------
 drivers/net/wireless/realtek/rtw89/fw.h   |  1 +
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 0c1c5c8ae8ce..5ca0c401c43a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -7388,6 +7388,7 @@ void rtw89_core_rfkill_poll(struct rtw89_dev *rtwdev, bool force)
 
 int rtw89_chip_info_setup(struct rtw89_dev *rtwdev)
 {
+	struct rtw89_fw_req_info *fw_req = &rtwdev->fw.req;
 	struct rtw89_efuse *efuse = &rtwdev->efuse;
 	struct rtw89_hal *hal = &rtwdev->hal;
 	int ret;
@@ -7437,6 +7438,9 @@ int rtw89_chip_info_setup(struct rtw89_dev *rtwdev)
 		   hal->cid, hal->cv, hal->aid, hal->acv, efuse->rfe_type);
 
 out:
+	if (fw_req->free_after_probe)
+		__rtw89_unload_firmware(rtwdev);
+
 	rtw89_mac_pwr_off(rtwdev);
 
 	return ret;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 3cdfb141f075..e4b59690622d 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2206,20 +2206,26 @@ static void rtw89_unload_firmware_elements(struct rtw89_dev *rtwdev)
 	kfree(elm_info->rfk_log_fmt);
 }
 
-void rtw89_unload_firmware(struct rtw89_dev *rtwdev)
+void __rtw89_unload_firmware(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_fw_info *fw = &rtwdev->fw;
 
-	cancel_work_sync(&rtwdev->load_firmware_work);
+	release_firmware(fw->req.firmware);
 
-	if (fw->req.firmware) {
-		release_firmware(fw->req.firmware);
+	/*
+	 * Directly call this to free firmware early in normal flow. Assign
+	 * NULL back in case rtw89_free_ieee80211_hw() or tw89_core_deinit()
+	 * try to release the same one again in error handling paths.
+	 */
+	fw->req.firmware = NULL;
+}
 
-		/* assign NULL back in case rtw89_free_ieee80211_hw()
-		 * try to release the same one again.
-		 */
-		fw->req.firmware = NULL;
-	}
+void rtw89_unload_firmware(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_fw_info *fw = &rtwdev->fw;
+
+	cancel_work_sync(&rtwdev->load_firmware_work);
+	__rtw89_unload_firmware(rtwdev);
 
 	kfree(fw->log.fmts);
 	rtw89_unload_firmware_elements(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 473278f6bbea..cb4209df5843 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -5419,6 +5419,7 @@ rtw89_early_fw_feature_recognize(struct device *device,
 int rtw89_fw_download(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 		      bool include_bb);
 void rtw89_load_firmware_work(struct work_struct *work);
+void __rtw89_unload_firmware(struct rtw89_dev *rtwdev);
 void rtw89_unload_firmware(struct rtw89_dev *rtwdev);
 int rtw89_wait_firmware_completion(struct rtw89_dev *rtwdev);
 int rtw89_fw_log_prepare(struct rtw89_dev *rtwdev);
-- 
2.25.1

