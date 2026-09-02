Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8247A361DD0
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327026; cv=none; b=e3QHZMKZhSlbNPqa4F6LW4jE/eJFneejviaI7/xgKPnEG1ZUVZ6zdIPV1YI/cmXwu3hBkohmslnGKyJOmA4VPYMc5chaiJDuxtM3zQ3v0cHdx4307noCqRLCrDL8L5+Gzv3BS+A0DnrAWzgOwcWBuMFpoVseQBZzMisdzmDYJLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327026; c=relaxed/simple;
	bh=nJgpgqHJfaIEzM1UKAgjevx3CqveYhRV6CxRfpSV8C0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKfUjMoPIQQoZrg/EvxT1SHADFHqgSQQGHmYHICSC71R3ATmzJqunG6j6yFEl1LrOIqFxukw4WZVincYatQmO+BNwLVghHKNoKyaol9CtyYDH76gd8yX05fPcydiY9CjXf2X2/776V1wPvENXKgzBZtAKlv6QeEwP/j5EwBcCCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=aYuTLxxc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="aYuTLxxc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825ULzV42368327, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327022; bh=MZNHyJljxVh9N0f4RtT8OcYdbpvEPMubkCSPfKKBLQQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=aYuTLxxc1GrneauY6l+c6cbDmoFGaZMk9t/72xufSP4RKYqk7vDBzw88g2MjCKSdk
	 AqkwRjAYOG3keKTyzQszmURPJnM4va30xcCrnY4LcD4Wzq8jjF0ShIl4eHekONEqmf
	 BwdYTKYo/9OXzHYNk/GhGhr/VWLecCTokWPJcWvm2gzRZEbacTZ9ymQ7c0smz+sWw2
	 m6aVjRiEGTUCLMLWwYfNbzI5hZRGrfrSELqkgy4xqvfzz3Dno64QvZHaTCu6iDXs/U
	 zBHGNMpfdWh1pkFJtqrzHqogDWS5QzAKi4T5cuBArxEyd1S9l4fDziWW+0tPbsLUYa
	 J3jyWUcP3jrKQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825ULzV42368327
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:30:22 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:21 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:30:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 01/14] wifi: rtw89: 8922de: add low latency quirk for Valve device
Date: Wed, 2 Sep 2026 13:29:45 +0800
Message-ID: <20260902052958.50371-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
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
index a71e41f28544..b8dbb680c3bd 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922de.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922de.c
@@ -9,6 +9,12 @@
 #include "reg.h"
 #include "rtw8922d.h"
 
+static const struct rtw89_pci_ssid_quirk rtw8922de_pci_ssid_quirks[] = {
+	{RTW89_PCI_SSID(PCI_VENDOR_ID_REALTEK, 0x895D, 0x1E44, 0x1400, VALVE),
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

