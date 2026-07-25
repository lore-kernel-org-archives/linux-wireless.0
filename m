Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1CB33F5AC
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991905; cv=none; b=NOGGZKeV7Ik/e8Se2H3FmwI6N5Zl+Knu+nyyGZBYLsNcosFiuh1+urqF6dOOSUoW56Uhkf3ccIZW0rz8CmwNNvqtI8uxGaSxrExQdr7UgjJUZ1lzeA/vQjvZXRrozOAi/BMuaNWqqVTEHwGHX0429Eneav4NhzfBbucPCBbn1Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991905; c=relaxed/simple;
	bh=vi+wue3k5f6vqulJnzsLE+DAcZ0V70WCiveszk0u/kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD8q7Zvap5Boqiu0o57VvZZ8TCMiKsmqhlMCE9shmFiaHiYnFRo4XB+AlpNDwHCzrsopXnlpF3PUHQlvJ+IkhSmiG/ipN8pitWZZRafopsDL/n40Vg5jWS8FlKPHOQAN9jYbh+qAsmXY8Vo35MWdakqROtiysxVPWEVZCB6iQ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ljRL4SOh; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ljRL4SOh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbkYZPR3jdcSBQHPQ9eKhRXwpGbCUPO+MpqFn3rwH2U=;
	b=ljRL4SOhFuiAbWp1rjPuAD/yfu8bk592XkxRMg9G7hdVPzE2MJI53ywsfXRxMK/kKPp9Tw
	1xJGM5/UDXcu8dj5zDLhFMFNzxLAIAMUpu1p0137RsxWcx15Pm6yZDTMNI3RZI4I5BB8NK
	abUPKDgL8NOt2MiWqYldHhGabda3pZg=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 05/11] wifi: rtw88: coex: add the RTL8723BS scan antenna workaround
Date: Sat, 25 Jul 2026 17:04:21 +0200
Message-ID: <20260725150427.93887-6-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-1-luka.gejak@linux.dev>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On the RTL8723BS the PTA antenna path has to be programmed directly
during scan. The vendor driver keeps its own scan-time antenna state and
does not run the generic coexistence algorithm on boards where BT is
disabled, and following it is necessary here: without the antenna and
CCK priority setup applied at scan start, the site survey does not hear
the AP reliably.

Detect the BT-disabled case, replay the vendor BT_MP and BT_INFO queries
once the firmware has been up long enough for RX DMA to be stable, then
establish the scan path antenna configuration and skip the generic run.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 179 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/coex.h |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h  |   1 +
 3 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 37c336def419..daba6082f850 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -1443,6 +1443,156 @@ static void rtw_coex_set_ant_path(struct rtw_dev *rtwdev, bool force, u8 phase)
 #define case_ALGO(src) \
 	case COEX_ALGO_##src: return #src
 
+/* 8723BS SDIO WiFi/BT coexistence antenna handling. On BT-disabled boards the
+ * scan/auth window still routes through the PTA mux; these helpers force the
+ * vendor-shaped WiFi-owned antenna path so directed management TX reaches air.
+ */
+#define REG_8723BS_BT_COEX_CTRL		0x0039
+#define REG_8723BS_BB_ANT_CFG		0x0930
+#define REG_8723BS_BB_ANT_CFG1		0x0944
+#define REG_8723BS_BB_ANT_BUF		0x0974
+#define RTW8723BS_COEX_H_WLAN_ACTIVE	0x1800101b
+
+static bool rtw_coex_8723bs_ant_is_aux(struct rtw_dev *rtwdev)
+{
+	return !!(rtwdev->efuse.bt_setting & BIT(6));
+}
+
+static bool rtw_coex_8723bs_bt_disabled(struct rtw_dev *rtwdev)
+{
+	return rtw_is_8723bs(rtwdev) && rtwdev->coex.stat.bt_disabled;
+}
+
+static u32 rtw_coex_8723bs_pta_ant_path(struct rtw_dev *rtwdev)
+{
+	return rtw_coex_8723bs_ant_is_aux(rtwdev) ? 0x80 : 0x200;
+}
+
+/* Write BB_SEL_BTG, retrying once with SYS_FUNC BB reset if the first
+ * write does not stick (RF/BB clock may have been gated).
+ */
+static u32 rtw_coex_8723bs_write_bb_sel_btg(struct rtw_dev *rtwdev, u32 value)
+{
+	u8 sys_func_before;
+	u32 readback;
+
+	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
+	if ((sys_func_before & (BIT(0) | BIT(1))) != (BIT(0) | BIT(1))) {
+		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
+		usleep_range(10, 11);
+	}
+
+	rtw_write32(rtwdev, REG_BB_SEL_BTG_8723B, value);
+	readback = rtw_read32(rtwdev, REG_BB_SEL_BTG_8723B);
+	if (readback == value)
+		return readback;
+
+	usleep_range(10, 11);
+	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
+	rtw_write32(rtwdev, REG_BB_SEL_BTG_8723B, value);
+
+	return rtw_read32(rtwdev, REG_BB_SEL_BTG_8723B);
+}
+
+static u32 rtw_coex_8723bs_reassert_pta_ant(struct rtw_dev *rtwdev)
+{
+	return rtw_coex_8723bs_write_bb_sel_btg(rtwdev,
+						rtw_coex_8723bs_pta_ant_path(rtwdev));
+}
+
+static void rtw_coex_8723bs_set_cck_pri(struct rtw_dev *rtwdev, bool high)
+{
+	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
+		return;
+
+	if (high) {
+		rtw_write32(rtwdev, REG_BT_COEX_TABLE_H,
+			    RTW8723BS_COEX_H_WLAN_ACTIVE);
+	} else {
+		rtw_coex_set_wl_pri_mask(rtwdev, COEX_WLPRI_TX_CCK, false);
+		rtw_coex_set_wl_pri_mask(rtwdev, COEX_WLPRI_RX_CCK, false);
+	}
+}
+
+static void rtw_coex_8723bs_restore_pad_ctrl(struct rtw_dev *rtwdev,
+					     bool keep_pta_owner)
+{
+	u32 before, after;
+
+	before = rtw_read32(rtwdev, REG_PAD_CTRL1);
+	after = before & ~(BIT_LNAON_WLBT_SEL | BIT_SW_DPDT_SEL_DATA);
+	if (keep_pta_owner)
+		after |= BIT_PAPE_WLBT_SEL;
+	else
+		after &= ~BIT_PAPE_WLBT_SEL;
+	if (after != before)
+		rtw_write32(rtwdev, REG_PAD_CTRL1, after);
+}
+
+static void rtw_coex_8723bs_fw_gnt_bt_low(struct rtw_dev *rtwdev)
+{
+	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
+		return;
+
+	if (rtw_read8(rtwdev, REG_GNT_BT) == 0x00 &&
+	    rtw_read8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL) == 0x0c)
+		return;
+
+	rtw_fw_set_gnt_bt(rtwdev, 0);
+}
+
+static void rtw_coex_8723bs_reassert_ant_buffer(struct rtw_dev *rtwdev)
+{
+	u8 sys_func_before;
+
+	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
+	if ((sys_func_before & (BIT(0) | BIT(1))) != (BIT(0) | BIT(1))) {
+		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
+		usleep_range(10, 11);
+	}
+
+	rtw_write8_mask(rtwdev, REG_8723BS_BT_COEX_CTRL, BIT(3), 0x1);
+	rtw_write8(rtwdev, REG_8723BS_BB_ANT_BUF, 0xff);
+	rtw_write8_mask(rtwdev, REG_8723BS_BB_ANT_CFG1, 0x3, 0x3);
+	rtw_write8(rtwdev, REG_8723BS_BB_ANT_CFG, 0x77);
+}
+
+static void rtw_coex_8723bs_apply_scan_table(struct rtw_dev *rtwdev)
+{
+	rtwdev->coex.dm.cur_table = 2;
+	rtw_coex_set_table(rtwdev, true, 0x5a5a5a5a, 0x5a5a5a5a);
+}
+
+/* Non-connected scan/auth workaround: PS-TDMA type 8 off, PTA antenna path,
+ * coex table type 2 (matches the vendor non-connected arbitration).
+ */
+void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev)
+{
+	struct rtw_coex_dm *coex_dm = &rtwdev->coex.dm;
+	struct rtw_coex_stat *coex_stat = &rtwdev->coex.stat;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	coex_dm->cur_ps_tdma_on = false;
+	coex_dm->cur_ps_tdma = 8;
+	coex_dm->ps_tdma_para[0] = 0x08;
+	coex_dm->ps_tdma_para[1] = 0x00;
+	coex_dm->ps_tdma_para[2] = 0x00;
+	coex_dm->ps_tdma_para[3] = 0x00;
+	coex_dm->ps_tdma_para[4] = 0x00;
+
+	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+	rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
+	rtw_coex_set_ant_path(rtwdev, true, COEX_SET_ANT_2G);
+	rtw_coex_8723bs_reassert_ant_buffer(rtwdev);
+	rtw_coex_8723bs_apply_scan_table(rtwdev);
+	if (coex_stat->bt_disabled)
+		rtw_coex_8723bs_set_cck_pri(rtwdev, true);
+	rtw_coex_8723bs_reassert_pta_ant(rtwdev);
+	rtw_coex_8723bs_restore_pad_ctrl(rtwdev, true);
+}
+
 static const char *rtw_coex_get_algo_string(u8 algo)
 {
 	switch (algo) {
@@ -2770,7 +2920,7 @@ void rtw_coex_power_on_setting(struct rtw_dev *rtwdev)
 	coex->stop_dm = true;
 	coex->wl_rf_off = false;
 
-	/* enable BB, we can write 0x948 */
+	/* enable BB, so BB_SEL_BTG is writable */
 	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
 		       BIT_FEN_BB_GLB_RST | BIT_FEN_BB_RSTB);
 
@@ -2877,6 +3027,33 @@ void rtw_coex_scan_notify(struct rtw_dev *rtwdev, u8 type)
 	coex->freeze = false;
 	rtw_coex_write_scbd(rtwdev, COEX_SCBD_ACTIVE | COEX_SCBD_ONOFF, true);
 
+	/* 8723BS SDIO BT-disabled: keep the scan/auth PTA antenna state the
+	 * vendor uses and skip the generic coex run. At scan start (firmware
+	 * has been up long enough for stable RX DMA) replay the vendor BT_MP /
+	 * BT_INFO queries, then re-establish the scan-path PTA setup.
+	 */
+	if (rtw_coex_8723bs_bt_disabled(rtwdev)) {
+		if (type == COEX_SCAN_START_2G || type == COEX_SCAN_START) {
+			struct rtw_coex_info_req req = {};
+
+			coex_stat->cnt_wl[COEX_CNT_WL_SCANAP] = 0;
+			coex_stat->wl_hi_pri_task2 = true;
+
+			req.seq = 0x0e;
+			req.op_code = BT_MP_INFO_OP_SUPP_VER;
+			rtw_fw_query_bt_mp_info(rtwdev, &req);
+			req.seq = 0x0f;
+			req.op_code = BT_MP_INFO_OP_PATCH_VER;
+			rtw_fw_query_bt_mp_info(rtwdev, &req);
+			rtw_fw_query_bt_info(rtwdev);
+
+			rtw_coex_8723bs_scan_workaround(rtwdev);
+		} else {
+			coex_stat->wl_hi_pri_task2 = false;
+		}
+		return;
+	}
+
 	if (type == COEX_SCAN_START_5G) {
 		rtw_dbg(rtwdev, RTW_DBG_COEX,
 			"[BTCoex], SCAN START notify (5G)\n");
diff --git a/drivers/net/wireless/realtek/rtw88/coex.h b/drivers/net/wireless/realtek/rtw88/coex.h
index c398be8391f7..72b1353c9313 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.h
+++ b/drivers/net/wireless/realtek/rtw88/coex.h
@@ -430,4 +430,6 @@ static inline void rtw_coex_active_query_bt_info(struct rtw_dev *rtwdev)
 		rtw_coex_query_bt_info(rtwdev);
 }
 
+void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev);
+
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 08e9494977e0..b82a8de66e84 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -628,6 +628,7 @@
 #define REG_PSD			0x0910
 #define BIT_PSD_INI		GENMASK(23, 22)
 #define REG_SINGLE_TONE_CONT_TX	0x0914
+#define REG_BB_SEL_BTG_8723B	0x0948
 #define REG_AGC_TABLE		0x0958
 #define REG_RFE_CTRL_E		0x0974
 #define REG_2ND_CCA_CTRL	0x0976
-- 
2.55.0

