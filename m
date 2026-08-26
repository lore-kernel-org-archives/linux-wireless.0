Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95141A6836
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726479; cv=none; b=EJLEhVB3Y6I+70DTMLyAFdCEyYcQce0/5TD3TSQFzHAXptgK3qZrB+cJorWG+Y9nwK7zHMMI174PXmKfdhFE2Q6zxil4Jj8Zw/rI7o0UePBLK8ywOiODWz3/pj+SkpgUmheuZBV4RJDbWdc6VE+Mu0Bdv89QgxWCs0EZbgfYlKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726479; c=relaxed/simple;
	bh=o2bAPXxC9daYvsUgKhEv3SPnbA561H/9bV30gnD3cfE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P9UbBQHYtA/w7llxtFw5kDSdw+T6KEiHi1+Tr8OCrR+xigszywypGuMDOrAN2SSbTPCXNmLxi/9aNx9007fWFcXcxEX8yrQLrfIT+NeSqPm4aiNm66sXLDSnRymfCUlkVzRbSLYnzrKEEfVT+5m1onKVNv8yOu7+JSiem9NWlUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CCHxNN8L; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CCHxNN8L"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fFEx9352984, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726475; bh=5VHYnEASX5tQrSRpCXqgo8GStI+2pTHs00GGfJrt1OQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=CCHxNN8LkRIxvMKcAQFATxCDcqrz/TaMxhZZq6RruEEGqUbtAzsvJqju6crpyIpOa
	 rTi6sMivx6W/GAfZCiP4r6Xyi68Ug8i6g/Z0w0FJ2HyMapHdRoupp/esTFOZgKoJVp
	 WW1baHIfVqoPJS8rDwQZp6Dc+U3tr+LMY2Eign8vWwKj8LMTDKl827XUBDbiVXNVdM
	 zQmsVERpONqdgB/Cmdkd5WdbnXUewXnzdgS1MU+SuA+VCEI9vn+rsWljHbYfUsIjMF
	 XrabAaYf8G4MyoE1QzbJp/shERmy4THlfcZH30qKy/tpmRviQfq9i+oqj28/2rpqn8
	 A+NhOrajCB6Gg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fFEx9352984
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:15 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:15 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 01/14] wifi: rtw89: 8922de: add low latency quirk for Valve device
Date: Wed, 26 Aug 2026 14:40:48 +0800
Message-ID: <20260826064101.58892-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Hsiao-Yung Chen <henchy.chen@realtek.com>

Add RTW89_QUIRK_LOW_LATENCY to the rtw89_quirks enum for
latency-sensitive platforms. When set, the RA report handler skips
computing max_agg_wait and leaves it at its default of zero, which
makes rtw89_core_txq_agg_wait() bail out early, so frames are
dispatched immediately instead of being held to build an aggregate,
trading throughput for lower latency.

Apply the quirk for the Valve device (SSID 0x1e44:0x1400) on the
8922DE, and add RTW89_CUSTID_VALVE for that customer ID.

Signed-off-by: Hsiao-Yung Chen <henchy.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h      | 2 ++
 drivers/net/wireless/realtek/rtw89/phy.c       | 3 ++-
 drivers/net/wireless/realtek/rtw89/rtw8922de.c | 8 +++++++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 2b21d969ece7..b1a0103aaf0c 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6465,6 +6465,7 @@ enum rtw89_quirks {
 	RTW89_QUIRK_THERMAL_PROT_110C,
 	RTW89_QUIRK_HW_INFO_SYSFS,
 	RTW89_QUIRK_DISABLE_2GHZ,
+	RTW89_QUIRK_LOW_LATENCY,
 
 	NUM_OF_RTW89_QUIRKS,
 };
@@ -6479,6 +6480,7 @@ enum rtw89_custid {
 	RTW89_CUSTID_AMD = 6,
 	RTW89_CUSTID_FUJITSU = 7,
 	RTW89_CUSTID_DELL = 8,
+	RTW89_CUSTID_VALVE, /* driver only */
 };
 
 enum rtw89_pkt_drop_sel {
diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index c78107e92206..ebf6ecf08c35 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3345,7 +3345,8 @@ static void __rtw89_phy_c2h_ra_rpt_iter(struct rtw89_sta_link *rtwsta_link,
 		*changed = true;
 	}
 
-	rtwsta_link->max_agg_wait = link_sta->agg.max_rc_amsdu_len / 1500 - 1;
+	if (!test_bit(RTW89_QUIRK_LOW_LATENCY, rtwdev->quirks))
+		rtwsta_link->max_agg_wait = link_sta->agg.max_rc_amsdu_len / 1500 - 1;
 }
 
 static void rtw89_phy_c2h_ra_rpt_iter(void *data, struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922de.c b/drivers/net/wireless/realtek/rtw89/rtw8922de.c
index a71e41f28544..d0dede477fb4 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922de.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922de.c
@@ -9,6 +9,12 @@
 #include "reg.h"
 #include "rtw8922d.h"
 
+static const struct rtw89_pci_ssid_quirk rtw8922de_pci_ssid_quirks[] = {
+	{RTW89_PCI_SSID(PCI_VENDOR_ID_REALTEK, 0x892D, 0x1E44, 0x1400, VALVE),
+		.bitmap = BIT(RTW89_QUIRK_LOW_LATENCY)},
+	{},
+};
+
 static const struct rtw89_pci_info rtw8922d_pci_info = {
 	.gen_def		= &rtw89_pci_gen_be,
 	.isr_def		= &rtw89_pci_isr_be_v1,
@@ -66,7 +72,7 @@ static const struct rtw89_pci_info rtw8922d_pci_info = {
 	.disable_intr		= rtw89_pci_disable_intr_v3,
 	.recognize_intrs	= rtw89_pci_recognize_intrs_v3,
 
-	.ssid_quirks		= NULL,
+	.ssid_quirks		= rtw8922de_pci_ssid_quirks,
 };
 
 static const struct rtw89_driver_info rtw89_8922de_vs_info = {
-- 
2.25.1

