Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673E2435AB2
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902977; cv=none; b=OFW4BXBOw6UTcDFtmGiVoY03q0MpvpARRWkltrr2ZjHYplBTGD2cVJFlMKRMvrcHGLIEQQ2tc6zjnkskzjE6tDdbnM10UryyuHiVqBYUgQ1Zk5pxuDQyhzKJNphe5SF0hCXkl9iEkruzOtm8KpWH0CArE1/q4KumY/33Qkz5WCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902977; c=relaxed/simple;
	bh=/SCUOWAbSXOok7MQGQFX9TeSR43FjS2q1gyyIkLWeAk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vyzx/+U4/7akD4IUBCXwMJ71umG0+dXRxVR126owefGvIBdc3Q8JMgRxccuCS/JfxFnMVla2IM+QUHafk4Osois6JRqwX9MEH/OxvxRxt6N5IF6uN0QBtbgoYhB9fsYjoe9wB+p3C2/OjlDHBjHIyU6NgM8ZnqtVXWBq5aCvEIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=U4RZk3gb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="U4RZk3gb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66OEMp0O21234238, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784902972; bh=t6+jYpLcu5BqzgmXOXowCJla1Uk7wYX/bNaFNBExh8o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=U4RZk3gb3pTr9MA0NPNKjrYT4jOjSNmjkr3ik2m9n8H2YPnjQrzO6KF58zvMOSbGM
	 pLD21JGbiGt2NQjZTcffM9JekupY5GDUs2jX22EROZLO+Z1bxg5o+pqwutm0su+39R
	 yRgR3CG1x+NuSaezuNCCtZ2JVxGY8Iq2Nv+la8NASAArGdDgS1RX7YZTTBwcmLbAZ/
	 txttSon19OtSQLHdZgeT6/mxphB3hREW8vLZVuzAqhcwY46JRRgTJnBwD5B39CsK2+
	 DSCg8HyQMSWS+hLc1gbUR/0GKIldugz/BY8W4mdNryjHU9oCaM2qCblAj3lumzkcBH
	 CDayvbV6XaDHQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66OEMp0O21234238
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:22:51 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 22:22:52 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 22:22:51 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 22:22:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <phhuang@realtek.com>
Subject: [PATCH rtw-next 1/3] wifi: rtw89: refine RX filter configuration for WiFi 7 generation
Date: Fri, 24 Jul 2026 22:22:44 +0800
Message-ID: <20260724142246.3195274-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724142246.3195274-1-pkshih@realtek.com>
References: <20260724142246.3195274-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

When an AP interface is registered and starts AP, mac80211 calls the
configure_filter() to clear B_AX_A_UC_CAM_MATCH and B_AX_A_BC_CAM_MATCH
so that frames from un-associated stations can be received. However, for
a dedicated AP interface created via iw command, configure_filter() is
only triggered on the initial AP startup. Since the interface remains up
even after hostapd stops, and it isn't triggered again on later restarts.
Additionally, each AP start causes IPS leave, reverting the RX filter to
its default value.

For WiFi 7 chips, the default value is hardcoded in rx_fltr_init_be(),
so the reverted value does not match hal.rx_fltr. Therefore, refine
the behavior of WiFi 7 chips to align with the WiFi 6 implementation.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c   | 3 ++-
 drivers/net/wireless/realtek/rtw89/mac.c    | 1 +
 drivers/net/wireless/realtek/rtw89/mac.h    | 1 +
 drivers/net/wireless/realtek/rtw89/mac_be.c | 7 ++-----
 drivers/net/wireless/realtek/rtw89/reg.h    | 6 +++++-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 77a0e2582dbe..097e9b0312a1 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -6960,6 +6960,7 @@ void rtw89_sta_unset_link(struct rtw89_sta *rtwsta, unsigned int link_id)
 
 int rtw89_core_init(struct rtw89_dev *rtwdev)
 {
+	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
 	struct rtw89_btc *btc = &rtwdev->btc;
 	u8 band;
 
@@ -7016,7 +7017,7 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
 	rtw89_core_ppdu_sts_init(rtwdev);
 	rtw89_traffic_stats_init(rtwdev, &rtwdev->stats);
 
-	rtwdev->hal.rx_fltr = DEFAULT_AX_RX_FLTR;
+	rtwdev->hal.rx_fltr = mac->default_rx_fltr;
 	rtwdev->dbcc_en = false;
 	rtwdev->mlo_dbcc_mode = MLO_DBCC_NOT_SUPPORT;
 	rtwdev->mac.qta_mode = RTW89_QTA_SCC;
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index db9fca828829..ca08fe520eaa 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -7458,6 +7458,7 @@ const struct rtw89_mac_gen_def rtw89_mac_gen_ax = {
 	.mem_base_addrs = rtw89_mac_mem_base_addrs_ax,
 	.mem_page_size = MAC_MEM_DUMP_PAGE_SIZE_AX,
 	.rx_fltr = R_AX_RX_FLTR_OPT,
+	.default_rx_fltr = DEFAULT_AX_RX_FLTR,
 	.port_base = &rtw89_port_base_ax,
 	.agg_len_ht = R_AX_AGG_LEN_HT_0,
 	.ps_status = R_AX_PPWRBIT_SETTING,
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 493d2b9626a6..8419bcd3956a 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1063,6 +1063,7 @@ struct rtw89_mac_gen_def {
 	const u32 *mem_base_addrs;
 	u32 mem_page_size;
 	u32 rx_fltr;
+	u32 default_rx_fltr;
 	const struct rtw89_port_reg *port_base;
 	u32 agg_len_ht;
 	u32 ps_status;
diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index 8de0fe5a3b1d..413c214d968a 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -1332,11 +1332,7 @@ static int rx_fltr_init_be(struct rtw89_dev *rtwdev, u8 mac_idx)
 	rtw89_mac_typ_fltr_opt_be(rtwdev, RTW89_DATA, RTW89_FWD_TO_HOST, mac_idx);
 
 	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_RX_FLTR_OPT, mac_idx);
-	val = B_BE_A_BC_CAM_MATCH | B_BE_A_UC_CAM_MATCH | B_BE_A_MC |
-	      B_BE_A_BC | B_BE_A_A1_MATCH |
-	      u32_encode_bits(15, B_BE_UID_FILTER_MASK);
-	rtw89_write32(rtwdev, reg, val);
-	u32p_replace_bits(&rtwdev->hal.rx_fltr, 15, B_BE_UID_FILTER_MASK);
+	rtw89_write32(rtwdev, reg, rtwdev->hal.rx_fltr);
 
 	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_PLCP_HDR_FLTR, mac_idx);
 	val = B_BE_HE_SIGB_CRC_CHK | B_BE_VHT_MU_SIGB_CRC_CHK |
@@ -3280,6 +3276,7 @@ const struct rtw89_mac_gen_def rtw89_mac_gen_be = {
 	.mem_base_addrs = rtw89_mac_mem_base_addrs_be,
 	.mem_page_size = MAC_MEM_DUMP_PAGE_SIZE_BE,
 	.rx_fltr = R_BE_RX_FLTR_OPT,
+	.default_rx_fltr = DEFAULT_BE_RX_FLTR,
 	.port_base = &rtw89_port_base_be,
 	.agg_len_ht = R_BE_AGG_LEN_HT_0,
 	.ps_status = R_BE_WMTX_POWER_BE_BIT_CTL,
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 756b94dcd475..abeeb61007dc 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -3348,7 +3348,7 @@
 #define DEFAULT_AX_RX_FLTR (B_AX_A_A1_MATCH | B_AX_A_BC | B_AX_A_MC |	       \
 			    B_AX_A_UC_CAM_MATCH | B_AX_A_BC_CAM_MATCH |	       \
 			    B_AX_A_PWR_MGNT | B_AX_A_FTM_REQ |		       \
-			    u32_encode_bits(3, B_AX_UID_FILTER_MASK) |	       \
+			    FIELD_PREP_CONST(B_AX_UID_FILTER_MASK, 3) |       \
 			    B_AX_A_BCN_CHK_EN)
 #define B_AX_RX_FLTR_CFG_MASK ((u32)~B_AX_RX_MPDU_MAX_LEN_MASK)
 
@@ -8209,6 +8209,10 @@
 #define B_BE_A_BC BIT(2)
 #define B_BE_A_A1_MATCH BIT(1)
 #define B_BE_SNIFFER_MODE BIT(0)
+#define DEFAULT_BE_RX_FLTR (B_BE_A_BC_CAM_MATCH | B_BE_A_UC_CAM_MATCH |        \
+			    B_BE_A_MC | B_BE_A_BC | B_BE_A_A1_MATCH |          \
+			    FIELD_PREP_CONST(B_BE_UID_FILTER_MASK, 15) |       \
+			    B_BE_A_FTM_REQ | B_BE_A_BCN_CHK_EN)
 
 #define R_BE_CTRL_FLTR 0x11424
 #define R_BE_CTRL_FLTR_C1 0x15424
-- 
2.25.1

