Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3E041D4EA
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750660; cv=none; b=o02/4GKp8Nc/Y2vRhgMTswOcR5LQ+SM7PQz/5NptaQIY7aZJuFmgZByioRqwngIm9Nmo436yeVjhMLXfqRIJttPiW2pDkJJT9zsLnOrlCUMBh1GW2XtxFswAimwsMAK+/TAaeGjosGunmhoAf3/hUgzgBdtODiw/1QvpdmwMhRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750660; c=relaxed/simple;
	bh=puLx88GSh2ylBpOjXVmimrvGLSys6bm+2nAyJsXpIH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWePxWS0Zplpf8f/u9qkVnREiQh5l08pd5LlMiRWTyzw1E5FTdLR/2zLN0r3GvRW8gc1vadw8t2XVU0U4V/82BCCHj+YB2mWxUvio2RDxxxPB/Xqnv/tb/kyGuhqY7curifTzX6QVOZRy3km7pwEO7+jq26m0Qx0UmS2HJ1HrBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qWJ5IkDh; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qWJ5IkDh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784750651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/rUPGsrnk3b70cOt8o+Ksjyvg8Zw3XA46ou9iTDg9Y=;
	b=qWJ5IkDhLuz03AuU1IgZqzPOUw4i/zmA04UUkRJs+93nZGCBOAvJd0qAvbVfcgJBbtoAlB
	teJeOXW1GrPEL2p9O0/J7qkesC/Z6pigLm+fxfuvlbfsST31oDwg4MHvtQd1BGXJ8jG+71
	hV9rjqs8Zvla5epYf5pYfhd8poTNM2I=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 1/4] wifi: rtw88: 8723bs: add the core handling required by RTL8723BS
Date: Wed, 22 Jul 2026 22:03:28 +0200
Message-ID: <20260722200337.135150-2-luka.gejak@linux.dev>
In-Reply-To: <20260722200337.135150-1-luka.gejak@linux.dev>
References: <20260722200337.135150-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The RTL8723BS predates rtw88 and runs the Realtek vendor firmware
(version 41), whose H2C/C2H protocol and association behaviour differ
from the firmware used by the existing rtw88 8723-family devices. It
therefore needs a set of changes in the shared rtw88 code before the
chip driver itself can work.

Add the RTW_CHIP_TYPE_8723B chip type, the rtw_is_8723bs() helper, the
register and security-config definitions, and the per-vif and
per-station state the paths below use. Everything else is gated on
rtw_is_8723bs(), so the other chips are unaffected.

Covered here are the vendor H2C/C2H interface, including the
reserved-page BIT_BCN_VALID handshake for SDIO; WiFi/BT antenna
handling, because on these boards the scan and authentication windows
route through the PTA mux even when BT is disabled; scan, calibration
and rate adaptation; the vendor association sequence, which the firmware
expects the driver to drive the way vendor start_clnt_join() does; and
the RTL8723BS SDIO transfer contract.

Several of those need explaining, because the reason is not visible in
the code:

The chip does not append an RX FCS, so RX_INCLUDES_FCS must not be
advertised; otherwise mac80211 trims four bytes of real frame data and
corrupts the last beacon or probe-response IE. The firmware has no
hardware-feature report either, so the stream and antenna count are
derived from the RF-path count and the single-stream MCS 0-7 set is
advertised along with the 20/40 MHz capability. An empty MCS set makes
APs drop the station immediately after association.

Low-power-save entry is gated on sustained idle rather than on a single
quiet window, because the firmware's per-packet wake latency out of LPS
throttles bursty traffic hard.

Management completion is reported at SDIO DMA completion, as the vendor
dump_mgntframe_and_wait() path does, because the vendor SW_DEFINE value
cannot uniquely match asynchronous TX reports.

The per-AC software TX FIFO is bounded by stopping a mac80211 queue at a
high watermark and resuming it at a low one, which prevents unbounded
queueing latency and uplink congestion collapse. That in turn needs a
retry path: when the write path hits a temporary free-page shortage it
requeues the skb at the queue head, and rtw88 enables no free-page
(AVAL) interrupt on any SDIO chip, so a retry can only come from newly
enqueued traffic. RTL8723BS is the only SDIO chip that applies
backpressure, so once the queue is stopped nothing re-kicks the worker
and the requeued skb stays stuck even after the hardware frees pages.
The TX handler therefore uses delayed work, with a short retry when the
write path returns -EBUSY.

Finally, the TX report purge timeout is extended to cover this chip,
reusing the longer window already used for 8723D USB, because the
firmware delivers its CCX reports later than the 500 ms default on
slower SDIO hosts.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/coex.c     | 237 ++++++++
 drivers/net/wireless/realtek/rtw88/coex.h     |   4 +
 drivers/net/wireless/realtek/rtw88/fw.c       | 166 +++++-
 drivers/net/wireless/realtek/rtw88/fw.h       |  17 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 542 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/main.c     | 186 +++++-
 drivers/net/wireless/realtek/rtw88/main.h     |  35 ++
 drivers/net/wireless/realtek/rtw88/reg.h      |  31 +
 drivers/net/wireless/realtek/rtw88/rx.c       |   8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c     | 462 +++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h     |  20 +-
 drivers/net/wireless/realtek/rtw88/sec.h      |   1 +
 drivers/net/wireless/realtek/rtw88/tx.c       |   5 +-
 13 files changed, 1637 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 37c336def419..641cfa1181b2 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -1443,6 +1443,205 @@ static void rtw_coex_set_ant_path(struct rtw_dev *rtwdev, bool force, u8 phase)
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
+/* Write BB_SEL_BTG (0x948), retrying once with SYS_FUNC BB reset if the first
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
+	rtw_write32(rtwdev, 0x948, value);
+	readback = rtw_read32(rtwdev, 0x948);
+	if (readback == value)
+		return readback;
+
+	usleep_range(10, 11);
+	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
+	rtw_write32(rtwdev, 0x948, value);
+
+	return rtw_read32(rtwdev, 0x948);
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
+	if (rtw_read8(rtwdev, 0x765) == 0x00 &&
+	    rtw_read8(rtwdev, 0x76e) == 0x0c)
+		return;
+
+	rtw_fw_set_gnt_bt(rtwdev, 0);
+}
+
+static void rtw_coex_8723bs_force_assoc_pta_ant(struct rtw_dev *rtwdev)
+{
+	u32 ant_target;
+
+	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
+		return;
+
+	ant_target = rtw_coex_8723bs_pta_ant_path(rtwdev);
+
+	rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
+	rtw_coex_set_ant_switch(rtwdev, COEX_SWITCH_CTRL_BY_PTA,
+				COEX_SWITCH_TO_NOCARE);
+	rtw_coex_8723bs_set_cck_pri(rtwdev, true);
+	rtw_coex_8723bs_write_bb_sel_btg(rtwdev, ant_target);
+	rtw_coex_8723bs_restore_pad_ctrl(rtwdev, true);
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
+/* Replayed immediately before start_clnt_join()/auth: BT_INFO + PS-TDMA type 8
+ * then the forced WiFi PTA antenna path, so the auth window is clean.
+ */
+void rtw_coex_8723bs_pre_auth_h2c(struct rtw_dev *rtwdev)
+{
+	lockdep_assert_held(&rtwdev->mutex);
+
+	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
+		return;
+
+	rtw_fw_query_bt_info(rtwdev);
+	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+	rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
+	rtw_coex_8723bs_force_assoc_pta_ant(rtwdev);
+}
+
+/* Minimal PTA antenna path so RF register writes reach the chip after IPS
+ * leave / power-on (before rtw_set_channel()).
+ */
+void rtw_coex_8723bs_ensure_pta_path(struct rtw_dev *rtwdev)
+{
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	rtw_coex_8723bs_reassert_ant_buffer(rtwdev);
+	rtw_coex_8723bs_write_bb_sel_btg(rtwdev,
+					 rtw_coex_8723bs_pta_ant_path(rtwdev));
+	rtw_coex_8723bs_restore_pad_ctrl(rtwdev, false);
+}
+
 static const char *rtw_coex_get_algo_string(u8 algo)
 {
 	switch (algo) {
@@ -2877,6 +3076,33 @@ void rtw_coex_scan_notify(struct rtw_dev *rtwdev, u8 type)
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
@@ -2938,6 +3164,17 @@ void rtw_coex_connect_notify(struct rtw_dev *rtwdev, u8 type)
 	if (coex->manual_control || coex->stop_dm)
 		return;
 
+	/* 8723BS SDIO BT-disabled: the vendor ConnectNotify() early-returns
+	 * without sending H2Cs; scan_workaround already established the PTA
+	 * path / coex table / PS-TDMA. Keep only the register-level PTA
+	 * reassertion at associate-start.
+	 */
+	if (rtw_coex_8723bs_bt_disabled(rtwdev)) {
+		if (type == COEX_ASSOCIATE_START)
+			rtw_coex_8723bs_force_assoc_pta_ant(rtwdev);
+		return;
+	}
+
 	rtw_coex_write_scbd(rtwdev, COEX_SCBD_ACTIVE | COEX_SCBD_ONOFF, true);
 
 	if (type == COEX_ASSOCIATE_5G_START) {
diff --git a/drivers/net/wireless/realtek/rtw88/coex.h b/drivers/net/wireless/realtek/rtw88/coex.h
index c398be8391f7..1f0aa17d4050 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.h
+++ b/drivers/net/wireless/realtek/rtw88/coex.h
@@ -430,4 +430,8 @@ static inline void rtw_coex_active_query_bt_info(struct rtw_dev *rtwdev)
 		rtw_coex_query_bt_info(rtwdev);
 }
 
+void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev);
+void rtw_coex_8723bs_pre_auth_h2c(struct rtw_dev *rtwdev);
+void rtw_coex_8723bs_ensure_pta_path(struct rtw_dev *rtwdev);
+
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..20f196752381 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -317,6 +317,15 @@ void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	case C2H_CCX_TX_RPT:
 		rtw_tx_report_handle(rtwdev, skb, C2H_CCX_TX_RPT);
 		break;
+	case C2H_VENDOR_TX_RPT:
+	case C2H_WLAN_RFON:
+		/*
+		 * The RTL8723BS firmware reports management TX through these
+		 * two events instead, using the same payload layout.
+		 */
+		if (rtw_is_8723bs(rtwdev))
+			rtw_tx_report_handle(rtwdev, skb, C2H_CCX_TX_RPT);
+		break;
 	case C2H_BT_INFO:
 		rtw_coex_bt_info_notify(rtwdev, c2h->payload, len);
 		break;
@@ -365,6 +374,15 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
 		rtw_coex_info_response(rtwdev, skb);
 		break;
 	case C2H_WLAN_RFON:
+		/* On 8723BS SDIO with v41 firmware, C2H 0x32 carries a scan TX
+		 * report, not a WLAN_RFON event: defer it to rtw_fw_c2h_cmd_handle().
+		 */
+		if (rtw_is_8723bs(rtwdev)) {
+			*((u32 *)skb->cb) = pkt_offset;
+			skb_queue_tail(&rtwdev->c2h_queue, skb);
+			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
+			break;
+		}
 		complete(&rtwdev->lps_leave_check);
 		dev_kfree_skb_any(skb);
 		break;
@@ -726,9 +744,19 @@ void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 
 	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RSSI_MONITOR);
 
-	SET_RSSI_INFO_MACID(h2c_pkt, si->mac_id);
-	SET_RSSI_INFO_RSSI(h2c_pkt, rssi);
-	SET_RSSI_INFO_STBC(h2c_pkt, stbc_en);
+	if (rtw_is_8723bs(rtwdev)) {
+		/* Vendor v5.2.17 RA_INFO byte layout (H2C 0x42):
+		 * [1] mac_id, [2] 0x00, [3] rssi, [4] stbc?0x04:0x00.
+		 */
+		h2c_pkt[1] = si->mac_id & 0x7f;
+		h2c_pkt[2] = 0x00;
+		h2c_pkt[3] = rssi;
+		h2c_pkt[4] = stbc_en ? 0x04 : 0x00;
+	} else {
+		SET_RSSI_INFO_MACID(h2c_pkt, si->mac_id);
+		SET_RSSI_INFO_RSSI(h2c_pkt, rssi);
+		SET_RSSI_INFO_STBC(h2c_pkt, stbc_en);
+	}
 
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
@@ -742,6 +770,37 @@ void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 
 	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
 
+	if (rtw_is_8723bs(rtwdev)) {
+		/* The v41 firmware parses the vendor v5.2.17 MACID_CFG (0x40)
+		 * byte layout, not the bit-packed rtw88 RA_INFO below:
+		 * [1] mac_id, [2] rate_id | sgi_en(bit7),
+		 * [3] bw(bits 1-0) | no_update(bit3), [4..7] 4-byte mask.
+		 *
+		 * no_update(bit3)=1 tells the firmware to keep its existing
+		 * rate mask, so a mask that changes under no_update is dropped.
+		 * Force no_update=0 whenever the mask actually changes so the
+		 * update is applied, and keep no_update=1 for identical
+		 * refreshes so the firmware retains the rate it has learned.
+		 */
+		bool apply = reset_ra_mask || si->ra_mask != si->ra_mask_last;
+
+		h2c_pkt[1] = si->mac_id & 0x7f;
+		h2c_pkt[2] = (si->rate_id & 0x1f) |
+			     (si->sgi_enable ? BIT(7) : 0);
+		h2c_pkt[3] = ((si->bw_mode ? 3 : 1) & 0x3) |
+			     (apply ? 0 : BIT(3));
+		h2c_pkt[4] = si->ra_mask & 0xff;
+		h2c_pkt[5] = (si->ra_mask >> 8) & 0xff;
+		h2c_pkt[6] = (si->ra_mask >> 16) & 0xff;
+		h2c_pkt[7] = (si->ra_mask >> 24) & 0xff;
+
+		si->ra_mask_last = si->ra_mask;
+		si->init_ra_lv = 0;
+
+		rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+		return;
+	}
+
 	SET_RA_INFO_MACID(h2c_pkt, si->mac_id);
 	SET_RA_INFO_RATE_ID(h2c_pkt, si->rate_id);
 	SET_RA_INFO_INIT_RA_LVL(h2c_pkt, si->init_ra_lv);
@@ -780,8 +839,78 @@ void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
 	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
 
 	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_MEDIA_STATUS_RPT);
-	MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, connect);
-	MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, mac_id);
+
+	if (rtw_is_8723bs(rtwdev)) {
+		/* Vendor v5.2.17 MEDIA_STATUS_RPT: connect = 21 00 00,
+		 * disconnect = 00 00 00. Byte1[0]=OPMODE, [5]=ROLE(STA=0),
+		 * [1]=MACID_IND; byte2=MACID; byte3=MACID_END.
+		 */
+		h2c_pkt[1] = connect ? 0x21 : 0x00;
+		h2c_pkt[2] = mac_id & 0x7f;
+		h2c_pkt[3] = 0x00;
+	} else {
+		MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, connect);
+		MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, mac_id);
+	}
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+/* 8723BS SDIO: post-assoc rate-adaptation config in the vendor v5.2.17
+ * MACID_CFG byte layout. disra (bit7 of [2]) must stay 0 so the firmware keeps
+ * running rate adaptation for this mac_id.
+ */
+void rtw_fw_macid_cfg(struct rtw_dev *rtwdev, u8 mac_id, u8 raid, u8 bw,
+		      u8 sgi, u32 rate_mask)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
+
+	h2c_pkt[1] = mac_id & 0x7f;
+	h2c_pkt[2] = (raid & 0x1f) | (sgi ? BIT(7) : 0) | 0x60;
+	h2c_pkt[3] = (bw ? 3 : 1) & 0x3;
+	h2c_pkt[4] = rate_mask & 0xff;
+	h2c_pkt[5] = (rate_mask >> 8) & 0xff;
+	h2c_pkt[6] = (rate_mask >> 16) & 0xff;
+	h2c_pkt[7] = (rate_mask >> 24) & 0xff;
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+/* 8723BS SDIO: report the connected channel/bandwidth to the vendor firmware. */
+void rtw_fw_send_wl_ch_info(struct rtw_dev *rtwdev, u8 ch, u8 bw)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	u8 bw_byte = bw == RTW_CHANNEL_WIDTH_40 ? 0x30 : 0x20;
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_WL_CH_INFO);
+	h2c_pkt[1] = 0x00;
+	h2c_pkt[2] = ch;
+	h2c_pkt[3] = bw_byte;
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+/* 8723BS SDIO: set the firmware GNT_BT state (0 = WiFi owns the antenna). */
+void rtw_fw_set_gnt_bt(struct rtw_dev *rtwdev, u8 state)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_GNT_BT);
+	SET_GNT_BT_STATE(h2c_pkt, state);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+/* 8723BS SDIO: vendor coex antenna-select reserve H2C (part of the init toggle). */
+void rtw_fw_coex_ant_sel_rsv(struct rtw_dev *rtwdev, u8 inverse, u8 type)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_COEX_ANT_SEL_RSV);
+	SET_COEX_ANT_SEL_RSV_INVERSE(h2c_pkt, inverse);
+	SET_COEX_ANT_SEL_RSV_TYPE(h2c_pkt, type);
 
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
@@ -1466,10 +1595,14 @@ void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev,
 	rtw_add_rsvd_page(rtwdev, rtwvif, RSVD_LPS_PG_INFO, true);
 }
 
+/* REG_DWBCN1_CTRL bit 20 (SW_BCN_SEL for port 0), relative to byte +2 */
+#define BIT_OFFSET_DWBCN1_SW_BCN_SEL_PORT0	(20 - 16)
+
 int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 				u8 *buf, u32 size)
 {
-	u8 bckp[3];
+	const bool is_8723bs_sdio = rtw_is_8723bs(rtwdev);
+	u8 bckp[4];
 	u8 val;
 	u16 rsvd_pg_head;
 	u32 bcn_valid_addr;
@@ -1499,13 +1632,28 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	rtw_write8(rtwdev, REG_BCN_CTRL,
 		   (bckp[2] & ~BIT_EN_BCN_FUNCTION) | BIT_DIS_TSF_UDT);
 
-	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE) {
+	/* Clear BIT_EN_BCNQ_DL so the chip does not treat the reserved-page
+	 * upload as a real beacon; otherwise BIT_BCN_VALID never asserts. The
+	 * vendor rtl8723bs driver does this unconditionally; rtw88 only did it
+	 * for PCIe, which left 8723BS SDIO's BCN_VALID handshake failing.
+	 */
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE || is_8723bs_sdio) {
 		val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
 		bckp[1] = val;
 		val &= ~(BIT_EN_BCNQ_DL >> 16);
 		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
 	}
 
+	/* 8723BS SDIO: point the SW beacon download path at port 0, else
+	 * BIT_BCN_VALID is never asserted after the SDIO upload completes.
+	 */
+	if (is_8723bs_sdio) {
+		val = rtw_read8(rtwdev, REG_DWBCN1_CTRL + 2);
+		bckp[3] = val;
+		val &= ~BIT(BIT_OFFSET_DWBCN1_SW_BCN_SEL_PORT0);
+		rtw_write8(rtwdev, REG_DWBCN1_CTRL + 2, val);
+	}
+
 	ret = rtw_hci_write_data_rsvd_page(rtwdev, buf, size);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write data to rsvd page\n");
@@ -1526,11 +1674,13 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
 	}
 
 restore:
+	if (is_8723bs_sdio)
+		rtw_write8(rtwdev, REG_DWBCN1_CTRL + 2, bckp[3]);
 	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
 	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
 		    rsvd_pg_head | BIT_BCN_VALID_V1);
 	rtw_write8(rtwdev, REG_BCN_CTRL, bckp[2]);
-	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE || is_8723bs_sdio)
 		rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
 	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
 
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 48ad9ceab6ea..8b238b41decf 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -54,6 +54,10 @@ enum rtw_c2h_cmd_id {
 	C2H_BT_MP_INFO = 0x0b,
 	C2H_BT_HID_INFO = 0x45,
 	C2H_RA_RPT = 0x0c,
+	/* 8723BS SDIO vendor v41 firmware management TX report (0x32 is
+	 * reported as C2H_WLAN_RFON, handled per-chip in the C2H dispatch).
+	 */
+	C2H_VENDOR_TX_RPT = 0x12,
 	C2H_HW_FEATURE_REPORT = 0x19,
 	C2H_WLAN_INFO = 0x27,
 	C2H_WLAN_RFON = 0x32,
@@ -568,10 +572,12 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 #define H2C_CMD_QUERY_BT_INFO		0x61
 #define H2C_CMD_FORCE_BT_TX_POWER	0x62
 #define H2C_CMD_IGNORE_WLAN_ACTION	0x63
+#define H2C_CMD_COEX_ANT_SEL_RSV	0x65
 #define H2C_CMD_WL_CH_INFO		0x66
 #define H2C_CMD_QUERY_BT_MP_INFO	0x67
 #define H2C_CMD_BT_WIFI_CONTROL		0x69
 #define H2C_CMD_WIFI_CALIBRATION	0x6d
+#define H2C_CMD_GNT_BT			0x6e
 #define H2C_CMD_QUERY_BT_HID_INFO	0x73
 
 #define H2C_CMD_KEEP_ALIVE		0x03
@@ -684,6 +690,12 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(31, 24))
 #define SET_QUERY_BT_INFO(h2c_pkt, value)                                      \
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
+#define SET_GNT_BT_STATE(h2c_pkt, value)                                       \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
+#define SET_COEX_ANT_SEL_RSV_INVERSE(h2c_pkt, value)                           \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
+#define SET_COEX_ANT_SEL_RSV_TYPE(h2c_pkt, value)                              \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(23, 16))
 #define SET_WL_CH_INFO_LINK(h2c_pkt, value)                                    \
 	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
 #define SET_WL_CH_INFO_CHNL(h2c_pkt, value)                                    \
@@ -849,6 +861,11 @@ void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
 void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 			 bool reset_ra_mask);
 void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool conn);
+void rtw_fw_macid_cfg(struct rtw_dev *rtwdev, u8 mac_id, u8 raid, u8 bw,
+		      u8 sgi, u32 rate_mask);
+void rtw_fw_send_wl_ch_info(struct rtw_dev *rtwdev, u8 ch, u8 bw);
+void rtw_fw_set_gnt_bt(struct rtw_dev *rtwdev, u8 state);
+void rtw_fw_coex_ant_sel_rsv(struct rtw_dev *rtwdev, u8 inverse, u8 type);
 void rtw_fw_update_wl_phy_info(struct rtw_dev *rtwdev);
 void rtw_fw_beacon_filter_config(struct rtw_dev *rtwdev, bool connect,
 				 struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index b01b98d24b0a..2e25dd0409ca 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -15,6 +15,463 @@
 #include "wow.h"
 #include "sar.h"
 
+/* 8723BS SDIO: record a beacon/probe-resp seen from the target BSSID during
+ * the pre-auth window so the join sequence (mgd_prepare_tx) can wait for it,
+ * mirroring the vendor start_clnt_join(). Called from the SDIO RX path.
+ */
+void rtw8723bs_auth_sync_rx(struct rtw_dev *rtwdev,
+			    const struct ieee80211_hdr *hdr, u32 len,
+			    const struct rtw_rx_pkt_stat *pkt_stat,
+			    const struct ieee80211_rx_status *rx_status)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+	__le16 fc = hdr->frame_control;
+
+	if (!rtw_is_8723bs(rtwdev) ||
+	    test_bit(RTW_FLAG_SCANNING, rtwdev->flags) ||
+	    pkt_stat->crc_err || pkt_stat->icv_err)
+		return;
+
+	if (!ieee80211_is_beacon(fc) && !ieee80211_is_probe_resp(fc))
+		return;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	if (sync->active && ether_addr_equal(hdr->addr3, sync->bssid)) {
+		sync->seen = true;
+		sync->seen_count++;
+		wake_up(&sync->wait);
+	}
+	spin_unlock_irqrestore(&sync->lock, flags);
+}
+EXPORT_SYMBOL(rtw8723bs_auth_sync_rx);
+
+/* ---- 8723BS SDIO association sequence (vendor start_clnt_join) ---- */
+
+#define RTW8723BS_JOIN_RETRY_LIMIT		0x30
+#define RTW8723BS_AUTH_SYNC_WAIT_FALLBACK_MS	120
+#define RTW8723BS_AUTH_SYNC_WAIT_MIN_MS		80
+#define RTW8723BS_AUTH_SYNC_WAIT_MAX_MS		160
+#define RTW8723BS_ACK_PREAMBLE_SHORT		BIT(7)
+#define RTW8723BS_SHORT_SLOT_TIME		9
+#define RTW8723BS_LONG_SLOT_TIME		20
+#define RTW8723BS_RRSR_1M			BIT(0)
+#define RTW8723BS_RRSR_2M			BIT(1)
+#define RTW8723BS_RRSR_5_5M			BIT(2)
+#define RTW8723BS_RRSR_11M			BIT(3)
+#define RTW8723BS_RRSR_6M			BIT(4)
+#define RTW8723BS_RRSR_9M			BIT(5)
+#define RTW8723BS_RRSR_12M			BIT(6)
+#define RTW8723BS_RRSR_18M			BIT(7)
+#define RTW8723BS_RRSR_24M			BIT(8)
+#define RTW8723BS_RRSR_36M			BIT(9)
+#define RTW8723BS_RRSR_48M			BIT(10)
+#define RTW8723BS_RRSR_54M			BIT(11)
+#define RTW8723BS_RRSR_CCK_RATES \
+	(RTW8723BS_RRSR_1M | RTW8723BS_RRSR_2M | \
+	 RTW8723BS_RRSR_5_5M | RTW8723BS_RRSR_11M)
+#define RTW8723BS_RRSR_2G_FORCE			RTW8723BS_RRSR_CCK_RATES
+#define RTW8723BS_RRSR_2G_ALLOW \
+	(RTW8723BS_RRSR_CCK_RATES | RTW8723BS_RRSR_6M | \
+	 RTW8723BS_RRSR_12M | RTW8723BS_RRSR_24M)
+
+/* Keep the RCR at the vendor target-only state (AMF + CBSSID) across the whole
+ * connect window, matching the vendor STA path. accept_all is kept only for the
+ * caller's intent; both paths converge the filter to target-only.
+ */
+static void rtw8723bs_auth_rx_filter(struct rtw_dev *rtwdev, bool accept_all)
+{
+	rtwdev->hal.rcr |= BIT_AMF | BIT_CBSSID_DATA | BIT_CBSSID_BCN;
+	rtwdev->hal.rcr &= ~BIT_AAP;
+	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
+}
+
+static void rtw8723bs_config_sec_cfg(struct rtw_dev *rtwdev)
+{
+	u16 sec = rtw_read16(rtwdev, RTW_SEC_CONFIG);
+
+	sec |= RTW_SEC_CHK_KEYID | RTW_SEC_TX_DEC_EN | RTW_SEC_RX_DEC_EN;
+	rtw_write16(rtwdev, RTW_SEC_CONFIG, sec);
+}
+
+static void rtw8723bs_config_default_key_search(struct rtw_dev *rtwdev,
+						bool enable)
+{
+	u16 sec = rtw_read16(rtwdev, RTW_SEC_CONFIG);
+
+	if (enable)
+		sec |= RTW_SEC_TX_BC_USE_DK | RTW_SEC_TX_UNI_USE_DK |
+		       RTW_SEC_RX_UNI_USE_DK;
+	else
+		sec &= ~(RTW_SEC_TX_UNI_USE_DK | RTW_SEC_RX_UNI_USE_DK |
+			 RTW_SEC_TX_BC_USE_DK | RTW_SEC_RX_BC_USE_DK);
+	rtw_write16(rtwdev, RTW_SEC_CONFIG, sec);
+}
+
+static void rtw8723bs_enable_tsf_update(struct rtw_dev *rtwdev)
+{
+	rtw_write8_clr(rtwdev, REG_BCN_CTRL, BIT_DIS_TSF_UDT);
+}
+
+static void rtw8723bs_set_ack_preamble(struct rtw_dev *rtwdev,
+				       bool short_preamble)
+{
+	u8 val = rtw_read8(rtwdev, REG_RRSR + 2) & ~RTW8723BS_ACK_PREAMBLE_SHORT;
+
+	if (short_preamble)
+		val |= RTW8723BS_ACK_PREAMBLE_SHORT;
+	rtw_write8(rtwdev, REG_RRSR + 2, val);
+}
+
+static void rtw8723bs_set_slot_time(struct rtw_dev *rtwdev, bool short_slot)
+{
+	rtw_write8(rtwdev, REG_SLOT,
+		   short_slot ? RTW8723BS_SHORT_SLOT_TIME :
+				RTW8723BS_LONG_SLOT_TIME);
+}
+
+static u16 rtw8723bs_rrsr_from_ie_rate(u8 rate)
+{
+	switch (rate & 0x7f) {
+	case 2:   return RTW8723BS_RRSR_1M;
+	case 4:   return RTW8723BS_RRSR_2M;
+	case 11:  return RTW8723BS_RRSR_5_5M;
+	case 22:  return RTW8723BS_RRSR_11M;
+	case 12:  return RTW8723BS_RRSR_6M;
+	case 18:  return RTW8723BS_RRSR_9M;
+	case 24:  return RTW8723BS_RRSR_12M;
+	case 36:  return RTW8723BS_RRSR_18M;
+	case 48:  return RTW8723BS_RRSR_24M;
+	case 72:  return RTW8723BS_RRSR_36M;
+	case 96:  return RTW8723BS_RRSR_48M;
+	case 108: return RTW8723BS_RRSR_54M;
+	default:  return 0;
+	}
+}
+
+static void rtw8723bs_collect_basic_rates(const u8 *ie, u16 *basic_rates,
+					  bool *valid)
+{
+	int i;
+
+	if (!ie)
+		return;
+
+	for (i = 0; i < ie[1]; i++) {
+		u16 r;
+
+		if (!(ie[i + 2] & 0x80))
+			continue;
+		r = rtw8723bs_rrsr_from_ie_rate(ie[i + 2]);
+		if (!r)
+			continue;
+		*basic_rates |= r;
+		*valid = true;
+	}
+}
+
+static void rtw8723bs_reset_response_rates(struct rtw_dev *rtwdev)
+{
+	rtw_write32(rtwdev, REG_RRSR, 0xffff1);
+	rtwdev->dm_info.rrsr_val_init = 0xffff1;
+}
+
+static void rtw8723bs_apply_basic_rates(struct rtw_dev *rtwdev,
+					struct ieee80211_vif *vif,
+					const u8 *bssid)
+{
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
+	struct cfg80211_bss *lookup_bss = NULL;
+	struct cfg80211_bss *bss = NULL;
+	bool valid = false;
+	u16 basic_rates = 0;
+
+	if (!rtw_is_8723bs(rtwdev) || vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (conf->bss) {
+		bss = conf->bss;
+	} else if (bssid && is_valid_ether_addr(bssid)) {
+		lookup_bss = cfg80211_get_bss(rtwdev->hw->wiphy, NULL,
+					      bssid, NULL, 0,
+					      IEEE80211_BSS_TYPE_ESS,
+					      IEEE80211_PRIVACY_ANY);
+		bss = lookup_bss;
+	}
+
+	if (bss) {
+		const u8 *rates, *ext;
+
+		rcu_read_lock();
+		rates = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+		ext = ieee80211_bss_get_ie(bss, WLAN_EID_EXT_SUPP_RATES);
+		rtw8723bs_collect_basic_rates(rates, &basic_rates, &valid);
+		rtw8723bs_collect_basic_rates(ext, &basic_rates, &valid);
+		rcu_read_unlock();
+	}
+
+	if (valid) {
+		basic_rates |= RTW8723BS_RRSR_2G_FORCE;
+		basic_rates &= RTW8723BS_RRSR_2G_ALLOW;
+		rtw_write16(rtwdev, REG_RRSR, basic_rates);
+		rtw_write8(rtwdev, REG_RRSR + 2,
+			   rtw_read8(rtwdev, REG_RRSR + 2) & 0xf0);
+		rtwdev->dm_info.rrsr_val_init = basic_rates;
+	}
+
+	if (lookup_bss)
+		cfg80211_put_bss(rtwdev->hw->wiphy, lookup_bss);
+}
+
+/* Program response slot time (and, when set_preamble, the ACK preamble) from
+ * the selected scan BSS capabilities; the AP capabilities are not yet in
+ * bss_conf at mgd_prepare_tx() time.
+ */
+static void rtw8723bs_apply_bss_cap(struct rtw_dev *rtwdev,
+				    struct ieee80211_vif *vif,
+				    const u8 *bssid, bool set_preamble)
+{
+	struct ieee80211_bss_conf *conf = &vif->bss_conf;
+	struct cfg80211_bss *lookup_bss = NULL;
+	struct cfg80211_bss *bss = NULL;
+	bool short_preamble, short_slot;
+	u16 cap = 0;
+
+	if (!rtw_is_8723bs(rtwdev) || vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (conf->bss) {
+		bss = conf->bss;
+	} else if (bssid && is_valid_ether_addr(bssid)) {
+		lookup_bss = cfg80211_get_bss(rtwdev->hw->wiphy, NULL,
+					      bssid, NULL, 0,
+					      IEEE80211_BSS_TYPE_ESS,
+					      IEEE80211_PRIVACY_ANY);
+		bss = lookup_bss;
+	}
+
+	if (bss) {
+		cap = bss->capability;
+	} else if (conf->assoc_capability) {
+		cap = conf->assoc_capability;
+	} else {
+		short_preamble = conf->use_short_preamble;
+		short_slot = conf->use_short_slot;
+		goto program;
+	}
+	short_preamble = !!(cap & WLAN_CAPABILITY_SHORT_PREAMBLE);
+	short_slot = !!(cap & WLAN_CAPABILITY_SHORT_SLOT_TIME);
+
+program:
+	if (set_preamble)
+		rtw8723bs_set_ack_preamble(rtwdev, short_preamble);
+	rtw8723bs_set_slot_time(rtwdev, short_slot);
+
+	if (lookup_bss)
+		cfg80211_put_bss(rtwdev->hw->wiphy, lookup_bss);
+}
+
+static unsigned int rtw8723bs_auth_sync_wait_ms(struct ieee80211_vif *vif)
+{
+	u16 beacon_int = vif->bss_conf.beacon_int;
+	unsigned int wait_ms;
+
+	if (!beacon_int)
+		return RTW8723BS_AUTH_SYNC_WAIT_FALLBACK_MS;
+
+	wait_ms = DIV_ROUND_UP(beacon_int * 1024, 1000) + 20;
+	return clamp_t(unsigned int, wait_ms, RTW8723BS_AUTH_SYNC_WAIT_MIN_MS,
+		       RTW8723BS_AUTH_SYNC_WAIT_MAX_MS);
+}
+
+static void rtw8723bs_auth_sync_start(struct rtw_dev *rtwdev, const u8 *bssid)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	ether_addr_copy(sync->bssid, bssid);
+	sync->seen = false;
+	sync->seen_count = 0;
+	sync->active = true;
+	spin_unlock_irqrestore(&sync->lock, flags);
+}
+
+static void rtw8723bs_auth_sync_stop(struct rtw_dev *rtwdev)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	sync->active = false;
+	spin_unlock_irqrestore(&sync->lock, flags);
+}
+
+static bool rtw8723bs_auth_sync_seen(struct rtw_dev *rtwdev)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+	unsigned long flags;
+	bool seen;
+
+	spin_lock_irqsave(&sync->lock, flags);
+	seen = sync->seen;
+	spin_unlock_irqrestore(&sync->lock, flags);
+
+	return seen;
+}
+
+static bool rtw8723bs_auth_sync_wait(struct rtw_dev *rtwdev,
+				     unsigned int wait_ms)
+{
+	struct rtw_auth_sync *sync = &rtwdev->auth_sync;
+
+	return wait_event_timeout(sync->wait, rtw8723bs_auth_sync_seen(rtwdev),
+				  msecs_to_jiffies(wait_ms)) > 0;
+}
+
+static bool rtw8723bs_mgd_prepare_is_auth(struct rtw_dev *rtwdev,
+					  struct ieee80211_prep_tx_info *info)
+{
+	return rtw_is_8723bs(rtwdev) && info &&
+	       info->subtype == IEEE80211_STYPE_AUTH;
+}
+
+/* Replicate the vendor start_clnt_join() register programming right before
+ * auth. Returns true for a fresh join (BSSID changed).
+ */
+static bool rtw8723bs_mgd_prepare_join(struct rtw_dev *rtwdev,
+				       struct ieee80211_vif *vif,
+				       const u8 *bssid)
+{
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	bool fresh_join;
+	u16 retry_limit;
+
+	if (!is_valid_ether_addr(bssid))
+		return false;
+
+	fresh_join = !ether_addr_equal(rtwvif->bssid, bssid);
+
+	ether_addr_copy(rtwvif->bssid, bssid);
+	rtwvif->aid = 0;
+	rtwvif->net_type = RTW_NET_MGD_LINKED;
+	rtw_vif_port_config(rtwdev, rtwvif,
+			    PORT_SET_BSSID | PORT_SET_AID | PORT_SET_NET_TYPE);
+
+	/* Do not narrow RRSR or switch to short-preamble responses before the
+	 * exchange: the whole auth/assoc runs on the init response set
+	 * (0xffff1, long preamble). Only slot time is programmed early.
+	 */
+	rtw8723bs_apply_bss_cap(rtwdev, vif, bssid, false);
+
+	rtw_fw_beacon_filter_config(rtwdev, false, vif);
+
+	/* Match the vendor start_clnt_join() TX state (set_msr directly, keep
+	 * BCN_CTRL / BCNQ_DL set, reassert TBTT/RESP_SIFS every join).
+	 */
+	rtw_write8(rtwdev, REG_BCN_CTRL,
+		   BIT_DIS_TSF_UDT | BIT_EN_BCN_FUNCTION);
+	rtw_write32_set(rtwdev, REG_FWHW_TXQ_CTRL, BIT_EN_BCNQ_DL);
+	rtw_write8(rtwdev, REG_TBTT_PROHIBIT + 1, 0x64 & 0xff);
+	rtw_write8(rtwdev, REG_TBTT_PROHIBIT + 2,
+		   (rtw_read8(rtwdev, REG_TBTT_PROHIBIT + 2) & 0xf0) | (0x64 >> 8));
+	rtw_write16(rtwdev, REG_RESP_SIFS_CCK, 0x0808);
+	rtw_write16(rtwdev, REG_RESP_SIFS_OFDM, 0x0a0a);
+
+	rtw_write16(rtwdev, REG_RXFLTMAP0, 0xffff);
+	rtw_write16(rtwdev, REG_RXFLTMAP2, 0xffff);
+	rtw8723bs_auth_rx_filter(rtwdev, true);
+
+	retry_limit = (RTW8723BS_JOIN_RETRY_LIMIT << 8) |
+		      RTW8723BS_JOIN_RETRY_LIMIT;
+	rtw_write16(rtwdev, REG_RETRY_LIMIT, retry_limit);
+
+	rtw8723bs_config_sec_cfg(rtwdev);
+
+	return fresh_join;
+}
+
+/* The vendor sends a deauth to the target before auth to clear stale AP-side
+ * state; synthesize and TX one, then let the AP settle.
+ */
+static void rtw8723bs_tx_pre_auth_deauth(struct rtw_dev *rtwdev,
+					 struct ieee80211_vif *vif,
+					 const u8 *bssid)
+{
+	struct ieee80211_tx_control control = {};
+	struct ieee80211_tx_info *info;
+	struct ieee80211_mgmt *mgmt;
+	struct sk_buff *skb;
+	unsigned int frame_len, headroom;
+
+	frame_len = sizeof(struct ieee80211_hdr_3addr) + sizeof(mgmt->u.deauth);
+	headroom = rtwdev->chip->tx_pkt_desc_sz + 8;
+
+	skb = dev_alloc_skb(headroom + frame_len);
+	if (!skb)
+		return;
+
+	skb_reserve(skb, headroom);
+	mgmt = skb_put_zero(skb, frame_len);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_DEAUTH);
+	memcpy(mgmt->da, bssid, ETH_ALEN);
+	memcpy(mgmt->sa, vif->addr, ETH_ALEN);
+	memcpy(mgmt->bssid, bssid, ETH_ALEN);
+	mgmt->u.deauth.reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
+
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+	info->control.vif = vif;
+
+	rtw_tx(rtwdev, &control, skb);
+	msleep(100);
+}
+
+/* Orchestrate the pre-auth join: program the vendor join state, send the
+ * pre-auth deauth, wait for a beacon from the target, then replay the
+ * pre-auth coex H2Cs - once per fresh BSSID.
+ */
+static void rtw8723bs_mgd_prepare_auth_join(struct rtw_dev *rtwdev,
+					    struct ieee80211_vif *vif,
+					    struct ieee80211_prep_tx_info *info)
+{
+	struct rtw_vif *rtwvif;
+	const u8 *bssid = NULL;
+	bool fresh_join;
+
+	if (!rtw8723bs_mgd_prepare_is_auth(rtwdev, info) || !vif ||
+	    test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
+		return;
+
+	rtwvif = (struct rtw_vif *)vif->drv_priv;
+
+	if (!is_zero_ether_addr(vif->cfg.ap_addr))
+		bssid = vif->cfg.ap_addr;
+	else if (vif->bss_conf.bssid && !is_zero_ether_addr(vif->bss_conf.bssid))
+		bssid = vif->bss_conf.bssid;
+
+	if (!bssid)
+		return;
+
+	fresh_join = rtw8723bs_mgd_prepare_join(rtwdev, vif, bssid);
+
+	if (fresh_join || !rtwvif->pre_auth_join_done) {
+		unsigned int wait_ms = rtw8723bs_auth_sync_wait_ms(vif);
+
+		rtw8723bs_auth_sync_start(rtwdev, bssid);
+		rtw8723bs_tx_pre_auth_deauth(rtwdev, vif, bssid);
+		rtw8723bs_auth_sync_wait(rtwdev, wait_ms);
+		rtw8723bs_auth_sync_stop(rtwdev);
+		rtwvif->pre_auth_join_done = true;
+	}
+
+	if (!rtwvif->pre_auth_h2c_sent) {
+		rtw_coex_8723bs_pre_auth_h2c(rtwdev);
+		rtwvif->pre_auth_h2c_sent = true;
+	}
+}
+
 static void rtw_ops_tx(struct ieee80211_hw *hw,
 		       struct ieee80211_tx_control *control,
 		       struct sk_buff *skb)
@@ -393,6 +850,28 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC) {
 		rtw_vif_assoc_changed(rtwvif, conf);
 		if (vif->cfg.assoc) {
+			if (rtw_is_8723bs(rtwdev) &&
+			    vif->type == NL80211_IFTYPE_STATION) {
+				rtw8723bs_auth_rx_filter(rtwdev, false);
+				rtw8723bs_apply_bss_cap(rtwdev, vif, NULL, true);
+				rtw8723bs_apply_basic_rates(rtwdev, vif, NULL);
+				rtw8723bs_enable_tsf_update(rtwdev);
+				/* Vendor mlmeext_joinbss sends MACID_CFG before
+				 * MEDIA_STATUS_RPT, then WL_CH_INFO.
+				 */
+				rtw_fw_macid_cfg(rtwdev, rtwvif->mac_id,
+						 1, 0, 1, 0x0ff015);
+				if (!rtwvif->fw_media_connected) {
+					rtw_fw_media_status_report(rtwdev,
+								   rtwvif->mac_id,
+								   true);
+					rtwvif->fw_media_connected = true;
+				}
+				rtw_fw_send_wl_ch_info(rtwdev,
+						       rtwdev->hal.current_channel,
+						       rtwdev->hal.current_band_width);
+			}
+
 			rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_FINISH);
 
 			rtw_fw_download_rsvd_page(rtwdev);
@@ -414,6 +893,13 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 			if (test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 				rtw_hw_scan_abort(rtwdev);
 
+			if (rtw_is_8723bs(rtwdev) &&
+			    vif->type == NL80211_IFTYPE_STATION) {
+				rtw8723bs_auth_rx_filter(rtwdev, false);
+				rtw8723bs_reset_response_rates(rtwdev);
+				rtwvif->pre_auth_h2c_sent = false;
+				rtwvif->pre_auth_join_done = false;
+			}
 		}
 
 		config |= PORT_SET_NET_TYPE;
@@ -421,8 +907,26 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
+		bool bssid_cleared = is_zero_ether_addr(conf->bssid);
+		bool bssid_changed = !ether_addr_equal(rtwvif->bssid,
+						       conf->bssid);
+
+		if (rtw_is_8723bs(rtwdev) &&
+		    vif->type == NL80211_IFTYPE_STATION && bssid_changed) {
+			rtwvif->pre_auth_h2c_sent = false;
+			rtwvif->pre_auth_join_done = false;
+		}
 		ether_addr_copy(rtwvif->bssid, conf->bssid);
 		config |= PORT_SET_BSSID;
+		if (rtw_is_8723bs(rtwdev) &&
+		    vif->type == NL80211_IFTYPE_STATION && bssid_cleared) {
+			rtwvif->aid = 0;
+			rtwvif->net_type = RTW_NET_NO_LINK;
+			config |= PORT_SET_NET_TYPE | PORT_SET_AID;
+			rtw_write8(rtwdev, REG_BCN_CTRL,
+				   BIT_DIS_TSF_UDT | BIT_EN_BCN_FUNCTION |
+				   BIT_DIS_ATIM);
+		}
 		if (!rtw_core_check_sta_active(rtwdev))
 			rtw_clear_op_chan(rtwdev);
 		else
@@ -454,8 +958,17 @@ static void rtw_ops_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_MU_GROUPS)
 		rtw_chip_set_gid_table(rtwdev, vif, conf);
 
-	if (changed & BSS_CHANGED_ERP_SLOT)
+	if (changed & BSS_CHANGED_ERP_PREAMBLE &&
+	    rtw_is_8723bs(rtwdev) &&
+	    vif->type == NL80211_IFTYPE_STATION)
+		rtw8723bs_set_ack_preamble(rtwdev, conf->use_short_preamble);
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (rtw_is_8723bs(rtwdev) &&
+		    vif->type == NL80211_IFTYPE_STATION)
+			rtw8723bs_set_slot_time(rtwdev, conf->use_short_slot);
 		rtw_conf_tx(rtwdev, rtwvif);
+	}
 
 	if (changed & BSS_CHANGED_PS)
 		rtw_recalc_lps(rtwdev, NULL);
@@ -615,11 +1128,19 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key->hw_key_idx = hw_key_idx;
 		rtw_sec_write_cam(rtwdev, sec, sta, key,
 				  hw_key_type, hw_key_idx);
+		if (rtw_is_8723bs(rtwdev) && vif &&
+		    vif->type == NL80211_IFTYPE_STATION &&
+		    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+			rtw8723bs_config_default_key_search(rtwdev, true);
 		break;
 	case DISABLE_KEY:
 		rtw_hci_flush_all_queues(rtwdev, false);
 		rtw_mac_flush_all_queues(rtwdev, false);
 		rtw_sec_clear_cam(rtwdev, sec, key->hw_key_idx);
+		if (rtw_is_8723bs(rtwdev) && vif &&
+		    vif->type == NL80211_IFTYPE_STATION &&
+		    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+			rtw8723bs_config_default_key_search(rtwdev, false);
 		break;
 	}
 
@@ -709,8 +1230,23 @@ static void rtw_ops_mgd_prepare_tx(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_leave_lps_deep(rtwdev);
-	rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
-	rtw_chip_prepare_tx(rtwdev);
+
+	if (rtw_is_8723bs(rtwdev)) {
+		/* Wake from soft IPS and run the vendor join sequence. The RFK
+		 * is handled by the once-only power-on IQK plus the ps.c
+		 * post-IPS RF-bus recovery, not a fresh calibration here.
+		 */
+		if (rtw_leave_ips(rtwdev)) {
+			rtw_err(rtwdev, "failed to leave idle state for mgd tx\n");
+			goto out;
+		}
+		rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
+		rtw8723bs_mgd_prepare_auth_join(rtwdev, vif, info);
+	} else {
+		rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
+		rtw_chip_prepare_tx(rtwdev);
+	}
+out:
 	mutex_unlock(&rtwdev->mutex);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index cd9254370fcc..e2f0fd367beb 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -43,6 +43,108 @@ MODULE_PARM_DESC(disable_lps_deep, "Set Y to disable Deep PS");
 MODULE_PARM_DESC(support_bf, "Set Y to enable beamformee support");
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 
+#define RTW8723BS_REG_BB_SEL_BTG	0x0948
+#define RTW8723BS_SCAN_IGI		0x1e
+
+struct rtw8723bs_txagc_entry {
+	u8 rate;
+	u8 pwr_idx;
+};
+
+/* Vendor/staging per-rate TXAGC PG bytes for 8723BS 2.4 GHz. */
+static const struct rtw8723bs_txagc_entry rtw8723bs_pg_txagc[] = {
+	{ DESC_RATE1M, 0x38 }, { DESC_RATE2M, 0x36 },
+	{ DESC_RATE5_5M, 0x34 }, { DESC_RATE11M, 0x32 },
+	{ DESC_RATE6M, 0x44 }, { DESC_RATE9M, 0x44 },
+	{ DESC_RATE12M, 0x42 }, { DESC_RATE18M, 0x40 },
+	{ DESC_RATE24M, 0x38 }, { DESC_RATE36M, 0x36 },
+	{ DESC_RATE48M, 0x32 }, { DESC_RATE54M, 0x28 },
+	{ DESC_RATEMCS0, 0x44 }, { DESC_RATEMCS1, 0x42 },
+	{ DESC_RATEMCS2, 0x40 }, { DESC_RATEMCS3, 0x38 },
+	{ DESC_RATEMCS4, 0x36 }, { DESC_RATEMCS5, 0x34 },
+	{ DESC_RATEMCS6, 0x30 }, { DESC_RATEMCS7, 0x26 },
+};
+
+/* Lower the scan-time initial gain so the 8723BS SDIO site-survey hears the AP. */
+static void rtw_scan_set_8723bs_igi(struct rtw_dev *rtwdev)
+{
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	rtw_write32_mask(rtwdev, REG_RXIGI_A, MASKBYTE0, RTW8723BS_SCAN_IGI);
+}
+
+/* rtw_load_table() only populates the by-rate cache; restore the staging
+ * 8723BS PG bytes after the generic channel power update and push them to the
+ * chip TXAGC registers.
+ */
+static void rtw8723bs_reapply_pg_txagc(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 path;
+	int i;
+
+	if (!rtw_is_8723bs(rtwdev) || hal->current_band_type != RTW_BAND_2G)
+		return;
+
+	mutex_lock(&hal->tx_power_mutex);
+	for (path = 0; path < hal->rf_path_num && path < RTW_RF_PATH_MAX; path++)
+		for (i = 0; i < ARRAY_SIZE(rtw8723bs_pg_txagc); i++)
+			hal->tx_pwr_tbl[path][rtw8723bs_pg_txagc[i].rate] =
+				rtw8723bs_pg_txagc[i].pwr_idx;
+	rtwdev->chip->ops->set_tx_power_index(rtwdev);
+	mutex_unlock(&hal->tx_power_mutex);
+}
+
+/* Staging runs PHY_IQCalibrate_8723B() only during initial hal_init, never on
+ * IPS leave. Match that: run IQK once on the first power-on, then on later
+ * (IPS-leave) power-ons just restore the PTA antenna path and reset RF_WLINT.
+ */
+static void rtw_power_on_8723bs_sdio_rfk(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u32 pta_path;
+	u32 saved_path;
+
+	if (!rtw_is_8723bs(rtwdev) || !chip->ops->phy_calibration)
+		return;
+
+	pta_path = (efuse->bt_setting & BIT(6)) ? 0x80 : 0x200;
+
+	if (rtwdev->initial_rfk_done) {
+		rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, pta_path);
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK, 0x0780);
+		return;
+	}
+
+	saved_path = rtw_read32(rtwdev, RTW8723BS_REG_BB_SEL_BTG);
+	rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, pta_path);
+	chip->ops->phy_calibration(rtwdev);
+	rtwdev->need_rfk = false;
+	rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, saved_path);
+	rtwdev->initial_rfk_done = true;
+}
+
+static bool rtw8723bs_station_media_status(struct rtw_dev *rtwdev,
+					   struct ieee80211_sta *sta,
+					   struct ieee80211_vif *vif)
+{
+	return rtw_is_8723bs(rtwdev) &&
+	       vif->type == NL80211_IFTYPE_STATION && !sta->tdls;
+}
+
+/* 8723BS SDIO: defer the connect MEDIA_STATUS_RPT until the STA is actually
+ * associated (the vendor firmware sends it at assoc completion, not sta-add).
+ */
+static bool rtw8723bs_defer_sta_media_status(struct rtw_dev *rtwdev,
+					     struct ieee80211_sta *sta,
+					     struct ieee80211_vif *vif)
+{
+	return rtw8723bs_station_media_status(rtwdev, sta, vif) &&
+	       !vif->cfg.assoc;
+}
+
 static struct ieee80211_channel rtw_channeltable_2g[] = {
 	{.center_freq = 2412, .hw_value = 1,},
 	{.center_freq = 2417, .hw_value = 2,},
@@ -299,6 +401,18 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	 * get that vif and check if device is having traffic more than the
 	 * threshold.
 	 */
+
+	/* On 8723BS SDIO the firmware's per-packet wake latency out of LPS
+	 * throttles bursty traffic hard. The stock check enters LPS after a
+	 * single quiet 2s window, which a normal bursty session hits
+	 * constantly. Gate LPS on the smoothed throughput instead so the chip
+	 * only sleeps after sustained idle and stays awake through an active
+	 * session. Other chips keep the normal behaviour.
+	 */
+	if (rtw_is_8723bs(rtwdev) &&
+	    (stats->tx_throughput || stats->rx_throughput))
+		ps_active = true;
+
 	if (rtwdev->ps_enabled && data.rtwvif && !ps_active &&
 	    !rtwdev->beacon_loss && !rtwdev->ap_active)
 		rtw_enter_lps(rtwdev, data.rtwvif->port);
@@ -367,7 +481,13 @@ int rtw_sta_add(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 	INIT_WORK(&si->rc_work, rtw_sta_rc_work);
 
 	rtw_update_sta_info(rtwdev, si, true);
-	rtw_fw_media_status_report(rtwdev, si->mac_id, true);
+	if (rtw8723bs_defer_sta_media_status(rtwdev, sta, vif)) {
+		rtwvif->fw_media_connected = false;
+	} else {
+		rtw_fw_media_status_report(rtwdev, si->mac_id, true);
+		if (rtw8723bs_station_media_status(rtwdev, sta, vif))
+			rtwvif->fw_media_connected = true;
+	}
 
 	rtwdev->sta_cnt++;
 	rtwdev->beacon_loss = false;
@@ -382,14 +502,21 @@ void rtw_sta_remove(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 {
 	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
 	struct ieee80211_vif *vif = si->vif;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
 	int i;
 
 	cancel_work_sync(&si->rc_work);
 
 	if (vif->type != NL80211_IFTYPE_STATION || sta->tdls)
 		rtw_release_macid(rtwdev, si->mac_id);
-	if (fw_exist)
+	if (fw_exist && rtw8723bs_station_media_status(rtwdev, sta, vif) &&
+	    !rtwvif->fw_media_connected) {
+		/* connect status was deferred and never sent; nothing to undo */
+	} else if (fw_exist) {
 		rtw_fw_media_status_report(rtwdev, si->mac_id, false);
+		if (rtw8723bs_station_media_status(rtwdev, sta, vif))
+			rtwvif->fw_media_connected = false;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		rtw_txq_cleanup(rtwdev, sta->txq[i]);
@@ -904,6 +1031,8 @@ void rtw_set_channel(struct rtw_dev *rtwdev)
 
 	rtw_phy_set_tx_power_level(rtwdev, center_chan);
 
+	rtw8723bs_reapply_pg_txagc(rtwdev);
+
 	/* if the channel isn't set for scanning, we will do RF calibration
 	 * in ieee80211_ops::mgd_prepare_tx(). Performing the calibration
 	 * during scanning on each channel takes too long.
@@ -1429,6 +1558,34 @@ int rtw_power_on(struct rtw_dev *rtwdev)
 	rtw_fw_send_phydm_info(rtwdev);
 
 	wifi_only = !rtwdev->efuse.btcoex;
+
+	/* 8723BS SDIO: on an IPS-leave power-on (IQK already done once) skip the
+	 * BT-path coex init entirely - scan_workaround re-establishes the PTA /
+	 * coex state. Run the once-only IQK via the RFK helper; on the first
+	 * power-on, finalise coex with the vendor init H2C toggle that enables
+	 * the 8051 management TX scheduler.
+	 */
+	if (rtw_is_8723bs(rtwdev)) {
+		bool ips_wake = rtwdev->initial_rfk_done;
+
+		if (!ips_wake)
+			rtw_coex_power_on_setting(rtwdev);
+
+		rtw_power_on_8723bs_sdio_rfk(rtwdev);
+
+		if (!ips_wake) {
+			rtw_coex_init_hw_config(rtwdev, wifi_only);
+			rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+			rtw_fw_set_gnt_bt(rtwdev, 1);
+			rtw_fw_coex_ant_sel_rsv(rtwdev, 0, 0);
+			rtw_fw_query_bt_info(rtwdev);
+			rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+			rtw_fw_set_gnt_bt(rtwdev, 0);
+		}
+
+		return 0;
+	}
+
 	rtw_coex_power_on_setting(rtwdev);
 	rtw_coex_init_hw_config(rtwdev, wifi_only);
 
@@ -1485,6 +1642,7 @@ void rtw_core_scan_start(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
 	set_bit(RTW_FLAG_SCANNING, rtwdev->flags);
 
 	rtw_phy_dig_set_max_coverage(rtwdev);
+	rtw_scan_set_8723bs_igi(rtwdev);
 }
 
 void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
@@ -1965,8 +2123,21 @@ static int rtw_dump_hw_feature(struct rtw_dev *rtwdev)
 	u8 bw;
 	int i;
 
-	if (!rtwdev->chip->hw_feature_report)
+	if (!rtwdev->chip->hw_feature_report) {
+		/* 8723BS has neither a firmware feature report nor an efuse hw_cap
+		 * parser, so hw_cap is otherwise left at zero. A zero stream count
+		 * produces an HT capability with no usable RX MCS rates, which makes
+		 * APs drop the station immediately after a successful association.
+		 * Other report-less chips fill hw_cap in when parsing the efuse.
+		 */
+		if (rtw_is_8723bs(rtwdev)) {
+			efuse->hw_cap.nss = rtwdev->hal.rf_path_num ? : 1;
+			efuse->hw_cap.ant_num = rtwdev->hal.rf_path_num ? : 1;
+			efuse->hw_cap.bw = BIT(RTW_CHANNEL_WIDTH_20) |
+					   BIT(RTW_CHANNEL_WIDTH_40);
+		}
 		return 0;
+	}
 
 	id = rtw_read8(rtwdev, REG_C2HEVT);
 	if (id != C2H_HW_FEATURE_REPORT) {
@@ -2174,11 +2345,13 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
+	spin_lock_init(&rtwdev->auth_sync.lock);
 
 	mutex_init(&rtwdev->mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
 
 	init_waitqueue_head(&rtwdev->coex.wait);
+	init_waitqueue_head(&rtwdev->auth_sync.wait);
 	init_completion(&rtwdev->lps_leave_check);
 	init_completion(&rtwdev->fw_scan_density);
 
@@ -2270,7 +2443,12 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	hw->vif_data_size = sizeof(struct rtw_vif);
 
 	ieee80211_hw_set(hw, SIGNAL_DBM);
-	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	/* RTL8723BS keeps BIT_APP_FCS clear, so received frames do not contain
+	 * the FCS. Advertising RX_INCLUDES_FCS would make mac80211 trim four
+	 * bytes of frame data and corrupt the tail IE in beacons/probe responses.
+	 */
+	if (!rtw_is_8723bs(rtwdev))
+		ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index c6e981ba7986..c6d993e989dd 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -194,6 +194,7 @@ enum rtw_chip_type {
 	RTW_CHIP_TYPE_8723D,
 	RTW_CHIP_TYPE_8821C,
 	RTW_CHIP_TYPE_8703B,
+	RTW_CHIP_TYPE_8723B,
 	RTW_CHIP_TYPE_8821A,
 	RTW_CHIP_TYPE_8812A,
 	RTW_CHIP_TYPE_8814A,
@@ -781,6 +782,8 @@ struct rtw_sta_info {
 	bool vht_enable;
 	u8 init_ra_lv;
 	u64 ra_mask;
+	/* Last rate mask sent to the firmware, to gate no_update. */
+	u64 ra_mask_last;
 
 	DECLARE_BITMAP(tid_ba, IEEE80211_NUM_TIDS);
 
@@ -828,6 +831,10 @@ struct rtw_vif {
 	u8 bssid[ETH_ALEN];
 	u8 port;
 	u8 bcn_ctrl;
+	/* Set once the firmware has been told the STA is connected. */
+	bool fw_media_connected;
+	bool pre_auth_h2c_sent;
+	bool pre_auth_join_done;
 	struct list_head rsvd_page_list;
 	struct ieee80211_tx_queue_params tx_params[IEEE80211_NUM_ACS];
 	const struct rtw_vif_port *conf;
@@ -2057,6 +2064,20 @@ struct rtw_hw_scan_info {
 	u8 op_bw;
 };
 
+/*
+ * Synchronises the pre-auth wait on a beacon or probe response from the
+ * target BSSID before the join sequence continues.
+ */
+struct rtw_auth_sync {
+	wait_queue_head_t wait;
+	/* Protects the fields below. */
+	spinlock_t lock;
+	u8 bssid[ETH_ALEN];
+	bool active;
+	bool seen;
+	u32 seen_count;
+};
+
 struct rtw_dev {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -2130,9 +2151,13 @@ struct rtw_dev {
 	struct rtw_wow_param wow;
 
 	bool need_rfk;
+	/* Run the initial IQK once, not on every IPS leave. */
+	bool initial_rfk_done;
 	struct completion fw_scan_density;
 	bool ap_active;
 
+	struct rtw_auth_sync auth_sync;
+
 	bool led_registered;
 	char led_name[32];
 	struct led_classdev led_cdev;
@@ -2194,6 +2219,12 @@ static inline bool rtw_chip_has_tx_stbc(struct rtw_dev *rtwdev)
 	return rtwdev->chip->tx_stbc;
 }
 
+static inline bool rtw_is_8723bs(struct rtw_dev *rtwdev)
+{
+	return rtwdev->chip->id == RTW_CHIP_TYPE_8723B &&
+	       rtwdev->hci.type == RTW_HCI_TYPE_SDIO;
+}
+
 static inline u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
 {
 	unsigned long mac_id;
@@ -2284,4 +2315,8 @@ bool rtw_core_check_sta_active(struct rtw_dev *rtwdev);
 void rtw_core_enable_beacon(struct rtw_dev *rtwdev, bool enable);
 void rtw_set_ampdu_factor(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf);
+void rtw8723bs_auth_sync_rx(struct rtw_dev *rtwdev,
+			    const struct ieee80211_hdr *hdr, u32 len,
+			    const struct rtw_rx_pkt_stat *pkt_stat,
+			    const struct ieee80211_rx_status *rx_status);
 #endif
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 08e9494977e0..463058134534 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -8,7 +8,9 @@
 #define REG_SYS_FUNC_EN		0x0002
 #define BIT_FEN_EN_25_1		BIT(13)
 #define BIT_FEN_ELDR		BIT(12)
+#define BIT_FEN_PPLL		BIT(7)
 #define BIT_FEN_PCIEA		BIT(6)
+#define BIT_FEN_DIO_PCIE	BIT(5)
 #define BIT_FEN_CPUEN		BIT(2)
 #define BIT_FEN_USBA		BIT(2)
 #define BIT_FEN_BB_GLB_RST	BIT(1)
@@ -19,6 +21,7 @@
 #define BIT_PFM_WOWL		BIT(3)
 #define BIT_APFM_OFFMAC		BIT(9)
 #define REG_APS_FSMCO		0x0004
+#define BIT_EN_PDN		BIT(4)
 #define APS_FSMCO_MAC_ENABLE	BIT(8)
 #define APS_FSMCO_MAC_OFF	BIT(9)
 #define APS_FSMCO_HW_POWERDOWN	BIT(15)
@@ -61,6 +64,8 @@
 
 #define REG_LDO_EFUSE_CTRL	0x0034
 #define BIT_MASK_EFUSE_BANK_SEL	(BIT(8) | BIT(9))
+#define REG_PWR_DATA		0x0038
+#define REG_BT_COEX_CTRL_8723B	0x0039
 
 #define BIT_LDO25_VOLTAGE_V25	0x03
 #define BIT_MASK_LDO25_VOLTAGE	GENMASK(6, 4)
@@ -105,6 +110,7 @@
 #define BIT_BTGP_SPI_EN		BIT(20)
 #define BIT_LED1DIS		BIT(15)
 #define BIT_SW_DPDT_SEL_DATA	BIT(0)
+#define REG_BT_ANT_SEL_8723B	0x0067
 #define REG_WL_BT_PWR_CTRL	0x0068
 #define BIT_BT_FUNC_EN		BIT(18)
 #define BIT_BT_DIG_CLK_EN	BIT(8)
@@ -301,6 +307,8 @@
 #define REG_HMEBOX3		0x01DC
 #define REG_LLT_INIT		0x01E0
 #define BIT_LLT_WRITE_ACCESS	BIT(30)
+#define REG_RFK_FW_ACK_8723B	0x01e7
+#define BIT_RFK_FW_ACK_8723B	BIT(0)
 #define REG_HMEBOX0_EX		0x01F0
 #define REG_HMEBOX1_EX		0x01F4
 #define REG_HMEBOX2_EX		0x01F8
@@ -429,6 +437,8 @@
 #define REG_ARFRH5		0x04A8
 #define REG_SW_AMPDU_BURST_MODE_CTRL 0x04BC
 #define BIT_PRE_TX_CMD		BIT(6)
+#define REG_PKT_VO_VI_LIFE_TIME	0x04C0
+#define REG_PKT_BE_BK_LIFE_TIME	0x04C2
 #define REG_QUEUE_CTRL		0x04C6
 #define BIT_PTA_WL_TX_EN	BIT(4)
 #define BIT_PTA_EDCCA_EN	BIT(5)
@@ -437,6 +447,8 @@
 #define REG_PROT_MODE_CTRL	0x04C8
 #define REG_MAX_AGGR_NUM	0x04CA
 #define REG_BAR_MODE_CTRL	0x04CC
+#define REG_MACID_PKT_DROP0	0x04D0
+#define REG_MACID_PKT_SLEEP	0x04D4
 #define REG_PRECNT_CTRL		0x04E5
 #define BIT_BTCCA_CTRL		(BIT(0) | BIT(1))
 #define BIT_EN_PRECNT		BIT(11)
@@ -479,6 +491,7 @@
 #define BIT_DIS_TSF_UDT		BIT(4)
 #define BIT_EN_BCN_FUNCTION	BIT(3)
 #define BIT_EN_TXBCN_RPT	BIT(2)
+#define BIT_DIS_ATIM		BIT(0)
 #define REG_BCN_CTRL_CLINT0	0x0551
 #define REG_DRVERLYINT		0x0558
 #define REG_BCNDMATIM		0x0559
@@ -495,6 +508,8 @@
 #define REG_TIMER0_SRC_SEL	0x05B4
 #define BIT_TSFT_SEL_TIMER0	(BIT(4) | BIT(5) | BIT(6))
 
+#define REG_BWOPMODE		0x0603
+#define BIT_BWOPMODE_20MHZ	BIT(2)
 #define REG_TCR			0x0604
 #define BIT_PWRMGT_HWDATA_EN	BIT(7)
 #define BIT_TCR_UPDATE_TIMIE	BIT(5)
@@ -518,6 +533,7 @@
 #define BIT_UC_MD_EN		BIT(16)
 #define BIT_RXSK_PERPKT		BIT(15)
 #define BIT_HTC_LOC_CTRL	BIT(14)
+#define BIT_AMF			BIT(13)
 #define BIT_RPFM_CAM_ENABLE	BIT(12)
 #define BIT_TA_BCN		BIT(11)
 #define BIT_RCR_ADF		BIT(11)
@@ -544,6 +560,7 @@
 #define REG_ACKTO		0x0640
 #define REG_EIFS		0x0642
 #define REG_NAV_CTRL		0x0650
+#define REG_NAV_UPPER		0x0652
 #define REG_WMAC_TRXPTCL_CTL	0x0668
 #define BIT_RFMOD		(BIT(7) | BIT(8))
 #define BIT_RFMOD_80M		BIT(8)
@@ -579,6 +596,7 @@
 #define REG_BT_COEX_V2		0x0762
 #define BIT_GNT_BT_POLARITY	BIT(12)
 #define BIT_LTE_COEX_EN		BIT(7)
+#define REG_BT_CONTROL_8723B	0x0764
 #define REG_GNT_BT		0x0765
 #define BIT_PTA_SW_CTL		GENMASK(4, 3)
 #define REG_BT_COEX_ENH_INTR_CTRL	0x76E
@@ -604,12 +622,21 @@
 #define BIT_RX_PSEL_RST		(BIT(28) | BIT(29))
 #define REG_TXPSEL		0x080C
 #define REG_RX_GAIN_EN		0x081c
+#define REG_FPGA0_XA_HSSI_PARM2	0x0824
+#define HSSI_3WIRE_ADDR_LEN	0x400
+#define HSSI_3WIRE_DATA_LEN	0x800
 #define REG_CCASEL		0x082C
+#define REG_FPGA0_XB_HSSI_PARM2	0x082c
 #define REG_PDMFTH		0x0830
 #define REG_BWINDICATION	0x0834
 #define REG_CCA2ND		0x0838
 #define REG_L1PKTH		0x0848
 #define REG_CLKTRK		0x0860
+#define REG_FPGA0_XA_RF_INT_OE	0x0860
+#define REG_FPGA0_XB_RF_INT_OE	0x0864
+#define REG_FPGA0_XA_RF_SW_CTRL	0x0870
+#define RFSI_RFENV		0x10
+#define REG_FPGA0_XB_RF_SW_CTRL	0x0872
 #define REG_CSI_MASK_SETTING1	0x0874
 #define REG_NBI_SETTING		0x087c
 #define BIT_NBI_ENABLE		BIT(13)
@@ -628,6 +655,9 @@
 #define REG_PSD			0x0910
 #define BIT_PSD_INI		GENMASK(23, 22)
 #define REG_SINGLE_TONE_CONT_TX	0x0914
+#define REG_BB_ANT_CFG_8723B	0x0930
+#define REG_BB_ANT_CFG1_8723B	0x0944
+#define BIT_BT_SEL_BY_WIFI_8723B	BIT(5)
 #define REG_AGC_TABLE		0x0958
 #define REG_RFE_CTRL_E		0x0974
 #define REG_2ND_CCA_CTRL	0x0976
@@ -681,6 +711,7 @@
 #define REG_RX_IQC_AB_A		0x0c10
 #define REG_RX_IQC_CD_A		0x0c14
 #define REG_TXSCALE_A		0x0c1c
+#define REG_B_RXIQI		0x0c1c
 #define BB_SWING_MASK		GENMASK(31, 21)
 #define REG_TX_AGC_A_CCK_11_CCK_1		0xc20
 #define REG_TX_AGC_A_OFDM18_OFDM6		0xc24
diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index 01fd299abb7f..57facbc1b41f 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -253,10 +253,12 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 
 	rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
 
-	/* Rtl8723cs driver checks for size < 14 or size > 8192 and
-	 * simply drops the packet.
+	/* Rtl8723cs and rtl8723bs drivers check for size < 14 or size > 8192
+	 * and simply drop the packet.
 	 */
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8703B && pkt_stat->pkt_len == 0) {
+	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8703B ||
+	     rtwdev->chip->id == RTW_CHIP_TYPE_8723B) &&
+	    pkt_stat->pkt_len == 0) {
 		rx_status->flag |= RX_FLAG_NO_PSDU;
 		rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
 	}
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 5b40d74b16ee..dd059e562e14 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -20,6 +20,16 @@
 #include "tx.h"
 
 #define RTW_SDIO_INDIRECT_RW_RETRIES			50
+#define RTW_SDIO_OQT_TIMEOUT_MS				1000
+
+/* 8723BS SDIO TX FIFO back-pressure watermarks: stop the mac80211 queue once
+ * the per-AC software FIFO fills past the high watermark, and wake it from the
+ * TX drain path once it falls back to the low one. Bounds the queueing latency
+ * that otherwise causes uplink bufferbloat / congestion collapse.
+ */
+#define RTW_SDIO_TX_FIFO_HIWATER			16
+#define RTW_SDIO_TX_FIFO_LOWATER			8
+#define RTW_SDIO_TX_RETRY_DELAY			msecs_to_jiffies(1)
 
 static bool rtw_sdio_is_bus_addr(u32 addr)
 {
@@ -479,8 +489,14 @@ static u32 rtw_sdio_get_tx_addr(struct rtw_dev *rtwdev, size_t size,
 		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
 				    REG_SDIO_CMD_ADDR_TXFF_HIGH);
 		break;
-	case RTW_TX_QUEUE_VI:
 	case RTW_TX_QUEUE_VO:
+		if (rtw_is_8723bs(rtwdev)) {
+			txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+					    REG_SDIO_CMD_ADDR_TXFF_HIGH);
+			break;
+		}
+		fallthrough;
+	case RTW_TX_QUEUE_VI:
 		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
 				    REG_SDIO_CMD_ADDR_TXFF_NORMAL);
 		break;
@@ -491,6 +507,8 @@ static u32 rtw_sdio_get_tx_addr(struct rtw_dev *rtwdev, size_t size,
 		break;
 	case RTW_TX_QUEUE_MGMT:
 		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				    rtw_is_8723bs(rtwdev) ?
+				    REG_SDIO_CMD_ADDR_TXFF_HIGH :
 				    REG_SDIO_CMD_ADDR_TXFF_EXTRA);
 		break;
 	default:
@@ -548,40 +566,111 @@ static int rtw_sdio_read_port(struct rtw_dev *rtwdev, u8 *buf, size_t count)
 	return ret;
 }
 
+static void rtw_sdio_init_free_txpg(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	const struct rtw_page_table *pg_tbl;
+	u32 free_txpg;
+	u16 pubq_num;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	pg_tbl = &rtwdev->chip->page_table[0];
+	pubq_num = rtwdev->fifo.acq_pg_num - pg_tbl->hq_num - pg_tbl->lq_num -
+		   pg_tbl->nq_num - pg_tbl->exq_num - pg_tbl->gapq_num;
+	free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+	if (free_txpg) {
+		atomic_set(&rtwsdio->free_pg_high, free_txpg & 0xff);
+		atomic_set(&rtwsdio->free_pg_normal, (free_txpg >> 8) & 0xff);
+		atomic_set(&rtwsdio->free_pg_low, (free_txpg >> 16) & 0xff);
+		atomic_set(&rtwsdio->free_pg_pub, (free_txpg >> 24) & 0xff);
+	} else {
+		atomic_set(&rtwsdio->free_pg_high, pg_tbl->hq_num);
+		atomic_set(&rtwsdio->free_pg_normal, pg_tbl->nq_num);
+		atomic_set(&rtwsdio->free_pg_low, pg_tbl->lq_num);
+		atomic_set(&rtwsdio->free_pg_pub, pubq_num);
+	}
+
+	atomic_set(&rtwsdio->tx_oqt_free,
+		   rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG));
+}
+
+static void rtw_sdio_sync_free_txpg(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u32 free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
+	if (!free_txpg)
+		return;
+
+	atomic_set(&rtwsdio->free_pg_high, free_txpg & 0xff);
+	atomic_set(&rtwsdio->free_pg_normal, (free_txpg >> 8) & 0xff);
+	atomic_set(&rtwsdio->free_pg_low, (free_txpg >> 16) & 0xff);
+	atomic_set(&rtwsdio->free_pg_pub, (free_txpg >> 24) & 0xff);
+}
+
+static int rtw_sdio_8723bs_free_txpg(struct rtw_dev *rtwdev, u8 queue)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	switch (queue) {
+	case RTW_TX_QUEUE_BCN:
+	case RTW_TX_QUEUE_H2C:
+	case RTW_TX_QUEUE_HI0:
+	case RTW_TX_QUEUE_MGMT:
+	case RTW_TX_QUEUE_VO:
+		return atomic_read(&rtwsdio->free_pg_high);
+	case RTW_TX_QUEUE_VI:
+		return atomic_read(&rtwsdio->free_pg_normal);
+	case RTW_TX_QUEUE_BE:
+	case RTW_TX_QUEUE_BK:
+		return atomic_read(&rtwsdio->free_pg_low);
+	default:
+		return -EINVAL;
+	}
+}
+
 static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
 				    size_t count)
 {
 	unsigned int pages_free, pages_needed;
 
-	if (rtw_chip_wcpu_8051(rtwdev)) {
-		u32 free_txpg;
+	if (rtw_is_8723bs(rtwdev)) {
+		struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+		int dedicated = rtw_sdio_8723bs_free_txpg(rtwdev, queue);
 
-		free_txpg = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG);
+		if (dedicated < 0)
+			return dedicated;
+		pages_free = dedicated + atomic_read(&rtwsdio->free_pg_pub);
+		pages_needed = DIV_ROUND_UP(count, rtwdev->chip->page_size);
+		if (pages_needed <= pages_free)
+			return 0;
+
+		rtw_sdio_sync_free_txpg(rtwdev);
+		dedicated = rtw_sdio_8723bs_free_txpg(rtwdev, queue);
+		pages_free = dedicated + atomic_read(&rtwsdio->free_pg_pub);
+	} else if (rtw_chip_wcpu_8051(rtwdev)) {
+		u32 free_txpg = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG);
 
 		switch (queue) {
 		case RTW_TX_QUEUE_BCN:
 		case RTW_TX_QUEUE_H2C:
 		case RTW_TX_QUEUE_HI0:
 		case RTW_TX_QUEUE_MGMT:
-			/* high */
 			pages_free = free_txpg & 0xff;
 			break;
 		case RTW_TX_QUEUE_VI:
 		case RTW_TX_QUEUE_VO:
-			/* normal */
 			pages_free = (free_txpg >> 8) & 0xff;
 			break;
 		case RTW_TX_QUEUE_BE:
 		case RTW_TX_QUEUE_BK:
-			/* low */
 			pages_free = (free_txpg >> 16) & 0xff;
 			break;
 		default:
-			rtw_warn(rtwdev, "Unknown mapping for queue %u\n", queue);
 			return -EINVAL;
 		}
-
-		/* add the pages from the public queue */
 		pages_free += (free_txpg >> 24) & 0xff;
 	} else {
 		u32 free_txpg[3];
@@ -632,44 +721,137 @@ static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
 	return 0;
 }
 
+static int rtw_sdio_wait_tx_oqt(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	int i;
+	u8 free;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return 0;
+
+	if (atomic_add_unless(&rtwsdio->tx_oqt_free, -1, 0))
+		return 0;
+
+	for (i = 0; i < RTW_SDIO_OQT_TIMEOUT_MS; i++) {
+		free = rtw_read8(rtwdev, REG_SDIO_OQT_FREE_PG);
+		if (free) {
+			atomic_set(&rtwsdio->tx_oqt_free, free - 1);
+			return 0;
+		}
+		usleep_range(1000, 2000);
+	}
+
+	return -EBUSY;
+}
+
+static void rtw_sdio_8723bs_consume_txpg(struct rtw_dev *rtwdev, u8 queue,
+					 unsigned int pages)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	atomic_t *dedicated;
+	int free;
+
+	switch (queue) {
+	case RTW_TX_QUEUE_VI:
+		dedicated = &rtwsdio->free_pg_normal;
+		break;
+	case RTW_TX_QUEUE_BE:
+	case RTW_TX_QUEUE_BK:
+		dedicated = &rtwsdio->free_pg_low;
+		break;
+	default:
+		dedicated = &rtwsdio->free_pg_high;
+		break;
+	}
+
+	free = atomic_read(dedicated);
+	if (pages <= free) {
+		atomic_sub(pages, dedicated);
+	} else {
+		atomic_set(dedicated, 0);
+		atomic_sub(pages - free, &rtwsdio->free_pg_pub);
+	}
+}
+
+static struct rtw_sdio_tx_data *rtw_sdio_get_tx_data(struct sk_buff *skb);
+
 static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			       enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	struct rtw_sdio_tx_data *tx_data = rtw_sdio_get_tx_data(skb);
+	unsigned int orig_len = skb->len;
+	bool rtl8723bs = rtw_is_8723bs(rtwdev);
+	bool quiet = rtl8723bs && tx_data->is_mgmt;
+	unsigned int pages;
 	bool bus_claim;
 	size_t txsize;
+	size_t write_size;
 	u32 txaddr;
 	int ret;
 
-	txaddr = rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
-	if (!txaddr)
-		return -EINVAL;
+	if (rtl8723bs) {
+		txsize = round_up(orig_len, 4);
+		write_size = txsize > RTW_SDIO_BLOCK_SIZE ?
+			     round_up(txsize, RTW_SDIO_BLOCK_SIZE) : txsize;
+	} else {
+		txsize = sdio_align_size(rtwsdio->sdio_func, orig_len);
+		write_size = txsize;
+	}
+
+	if (write_size > orig_len) {
+		unsigned int padding = write_size - orig_len;
 
-	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+		if (skb_tailroom(skb) < padding) {
+			ret = pskb_expand_head(skb, 0,
+					       padding - skb_tailroom(skb),
+					       GFP_KERNEL);
+			if (ret)
+				return ret;
+		}
+		skb_put_zero(skb, padding);
+	}
+
+	txaddr = rtw_sdio_get_tx_addr(rtwdev, txsize, queue);
+	if (!txaddr) {
+		ret = -EINVAL;
+		goto out_trim;
+	}
 
 	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
 	if (ret)
-		return ret;
+		goto out_trim;
+	ret = rtw_sdio_wait_tx_oqt(rtwdev);
+	if (ret)
+		goto out_trim;
 
 	if (!IS_ALIGNED((unsigned long)skb->data, RTW_SDIO_DATA_PTR_ALIGN))
 		rtw_warn(rtwdev, "Got unaligned SKB in %s() for queue %u\n",
 			 __func__, queue);
 
 	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
-
 	if (bus_claim)
 		sdio_claim_host(rtwsdio->sdio_func);
-
-	ret = sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data, txsize);
-
+	ret = sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data,
+			       write_size);
 	if (bus_claim)
 		sdio_release_host(rtwsdio->sdio_func);
 
+	if (!ret && quiet)
+		usleep_range(1000, 2000);
+	if (!ret && rtl8723bs) {
+		pages = DIV_ROUND_UP(txsize, rtwdev->chip->page_size);
+		rtw_sdio_8723bs_consume_txpg(rtwdev, queue, pages);
+	}
 	if (ret)
 		rtw_warn(rtwdev,
 			 "Failed to write %zu byte(s) to SDIO port 0x%08x",
-			 txsize, txaddr);
+			 write_size, txaddr);
 
+out_trim:
+	if (write_size > orig_len)
+		skb_trim(skb, orig_len);
 	return ret;
 }
 
@@ -677,7 +859,11 @@ static void rtw_sdio_init(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 
-	rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST | REG_SDIO_HIMR_CPWM1;
+	if (rtw_is_8723bs(rtwdev))
+		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST;
+	else
+		rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST |
+				       REG_SDIO_HIMR_CPWM1;
 }
 
 static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
@@ -685,6 +871,7 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 	u8 size, timeout;
 
 	switch (rtwdev->chip->id) {
+	case RTW_CHIP_TYPE_8723B:
 	case RTW_CHIP_TYPE_8703B:
 	case RTW_CHIP_TYPE_8821A:
 	case RTW_CHIP_TYPE_8812A:
@@ -712,6 +899,8 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
 		    FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
 
 	rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
+	if (rtw_is_8723bs(rtwdev))
+		rtw_write8_set(rtwdev, REG_RXDMA_MODE, 3 << 2);
 }
 
 static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
@@ -749,9 +938,50 @@ static int rtw_sdio_setup(struct rtw_dev *rtwdev)
 	return 0;
 }
 
+static void rtw_sdio_8723bs_check_rqpn(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_fifo_conf *fifo = &rtwdev->fifo;
+	const struct rtw_page_table *pg_tbl;
+	u32 free_txpg;
+	u16 pubq_num;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	free_txpg = rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+	if (free_txpg || !fifo->acq_pg_num)
+		return;
+
+	pg_tbl = &chip->page_table[0];
+	if (fifo->acq_pg_num <= pg_tbl->hq_num + pg_tbl->lq_num +
+				    pg_tbl->nq_num + pg_tbl->exq_num +
+				    pg_tbl->gapq_num)
+		return;
+
+	pubq_num = fifo->acq_pg_num - pg_tbl->hq_num - pg_tbl->lq_num -
+		   pg_tbl->nq_num - pg_tbl->exq_num - pg_tbl->gapq_num;
+	rtw_write32(rtwdev, REG_RQPN_NPQ,
+		    BIT_RQPN_NE(pg_tbl->nq_num, pg_tbl->exq_num));
+	rtw_write32(rtwdev, REG_RQPN,
+		    BIT_RQPN_HLP(pg_tbl->hq_num, pg_tbl->lq_num, pubq_num));
+}
+
 static int rtw_sdio_start(struct rtw_dev *rtwdev)
 {
+	u32 clear;
+
+	rtw_sdio_8723bs_check_rqpn(rtwdev);
+	rtw_sdio_init_free_txpg(rtwdev);
 	rtw_sdio_enable_rx_aggregation(rtwdev);
+
+	if (rtw_is_8723bs(rtwdev)) {
+		clear = rtw_read32(rtwdev, REG_SDIO_HISR) &
+			RTW_SDIO_HISR_CLEAR_MASK;
+		if (clear)
+			rtw_write32(rtwdev, REG_SDIO_HISR, clear);
+	}
+
 	rtw_sdio_enable_interrupt(rtwdev);
 
 	return 0;
@@ -815,7 +1045,7 @@ static void rtw_sdio_tx_kick_off(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 
-	queue_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work);
+	mod_delayed_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work, 0);
 }
 
 static void rtw_sdio_link_ps(struct rtw_dev *rtwdev, bool enter)
@@ -831,6 +1061,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
 
 	val = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
 	val &= 0xfff8;
+	if (rtw_is_8723bs(rtwdev))
+		val |= BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
 	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
 }
 
@@ -844,42 +1076,82 @@ static struct rtw_sdio_tx_data *rtw_sdio_get_tx_data(struct sk_buff *skb)
 	return (struct rtw_sdio_tx_data *)info->status.status_driver_data;
 }
 
-static void rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
-				    struct rtw_tx_pkt_info *pkt_info,
-				    struct sk_buff *skb,
-				    enum rtw_tx_queue_type queue)
+static int rtw_sdio_align_tx_skb(struct sk_buff *skb, unsigned int headroom)
+{
+	unsigned int misalign, needed;
+	int ret;
+
+	misalign = (unsigned long)skb->data & (RTW_SDIO_DATA_PTR_ALIGN - 1);
+	if (!misalign)
+		return 0;
+
+	needed = headroom + RTW_SDIO_DATA_PTR_ALIGN - 1;
+	if (skb_headroom(skb) < needed) {
+		ret = pskb_expand_head(skb, needed - skb_headroom(skb), 0,
+				       GFP_KERNEL);
+		if (ret)
+			return ret;
+
+		misalign = (unsigned long)skb->data &
+			   (RTW_SDIO_DATA_PTR_ALIGN - 1);
+		if (!misalign)
+			return 0;
+	}
+
+	needed = headroom + misalign;
+	if (skb_headroom(skb) < needed)
+		return -ENOSPC;
+
+	skb_push(skb, misalign);
+	memmove(skb->data, skb->data + misalign, skb->len - misalign);
+	skb_trim(skb, skb->len - misalign);
+
+	return 0;
+}
+
+static int rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
+				   struct rtw_tx_pkt_info *pkt_info,
+				   struct sk_buff *skb,
+				   enum rtw_tx_queue_type queue)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	unsigned long data_addr, aligned_addr;
+	bool fixed_8723bs_offset;
 	size_t offset;
 	u8 *pkt_desc;
+	int ret;
+
+	fixed_8723bs_offset = rtw_is_8723bs(rtwdev) &&
+			      (queue == RTW_TX_QUEUE_MGMT ||
+			       queue == RTW_TX_QUEUE_BCN);
+
+	if (fixed_8723bs_offset) {
+		ret = rtw_sdio_align_tx_skb(skb, chip->tx_pkt_desc_sz);
+		if (ret)
+			return ret;
+	}
 
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 
 	data_addr = (unsigned long)pkt_desc;
 	aligned_addr = ALIGN(data_addr, RTW_SDIO_DATA_PTR_ALIGN);
 
-	if (data_addr != aligned_addr) {
+	if (!fixed_8723bs_offset && data_addr != aligned_addr) {
 		/* Ensure that the start of the pkt_desc is always aligned at
 		 * RTW_SDIO_DATA_PTR_ALIGN.
 		 */
 		offset = RTW_SDIO_DATA_PTR_ALIGN - (aligned_addr - data_addr);
-
 		pkt_desc = skb_push(skb, offset);
-
-		/* By inserting padding to align the start of the pkt_desc we
-		 * need to inform the firmware that the actual data starts at
-		 * a different offset than normal.
-		 */
 		pkt_info->offset += offset;
+		memset(pkt_desc + chip->tx_pkt_desc_sz, 0, offset);
 	}
 
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
-
 	pkt_info->qsel = rtw_sdio_get_tx_qsel(rtwdev, skb, queue);
-
 	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, pkt_desc);
+
+	return 0;
 }
 
 static int rtw_sdio_write_data(struct rtw_dev *rtwdev,
@@ -889,9 +1161,10 @@ static int rtw_sdio_write_data(struct rtw_dev *rtwdev,
 {
 	int ret;
 
-	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
-
-	ret = rtw_sdio_write_port(rtwdev, skb, queue);
+	memset(rtw_sdio_get_tx_data(skb), 0, sizeof(struct rtw_sdio_tx_data));
+	ret = rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+	if (!ret)
+		ret = rtw_sdio_write_port(rtwdev, skb, queue);
 	dev_kfree_skb_any(skb);
 
 	return ret;
@@ -929,14 +1202,37 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
 	struct rtw_sdio_tx_data *tx_data;
-
-	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+	int ret;
 
 	tx_data = rtw_sdio_get_tx_data(skb);
+	memset(tx_data, 0, sizeof(*tx_data));
+	if (skb->len >= sizeof(struct ieee80211_hdr_3addr)) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+		tx_data->is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
+	}
+
+	ret = rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+	if (ret)
+		return ret;
+
 	tx_data->sn = pkt_info->sn;
+	tx_data->tx_pkt_offset = pkt_info->offset;
 
 	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
 
+	/* Back-pressure on the data ACs (BK/BE/VI/VO): once the FIFO fills past
+	 * the high watermark, stop the corresponding mac80211 queue so it stops
+	 * handing us frames, bounding the queueing latency. Resumed from the TX
+	 * drain path once the FIFO drains below the low watermark.
+	 */
+	if (rtw_is_8723bs(rtwdev) && queue < RTW_TX_QUEUE_BCN &&
+	    !rtwsdio->queue_stopped[queue] &&
+	    skb_queue_len(&rtwsdio->tx_queue[queue]) >= RTW_SDIO_TX_FIFO_HIWATER) {
+		rtwsdio->queue_stopped[queue] = true;
+		ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(skb));
+	}
+
 	return 0;
 }
 
@@ -965,6 +1261,11 @@ static void rtw_sdio_rx_skb(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	rtw_update_rx_freq_for_invalid(rtwdev, skb, rx_status, pkt_stat);
 	rtw_rx_stats(rtwdev, pkt_stat->vif, skb);
 
+	if (skb->len >= sizeof(struct ieee80211_hdr_3addr))
+		rtw8723bs_auth_sync_rx(rtwdev,
+				       (struct ieee80211_hdr *)skb->data,
+				       skb->len, pkt_stat, rx_status);
+
 	ieee80211_rx_irqsafe(rtwdev->hw, skb);
 }
 
@@ -1079,15 +1380,14 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
 	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
 	struct rtw_sdio *rtwsdio;
 	struct rtw_dev *rtwdev;
+	u32 clear;
 	u32 hisr;
 
 	rtwdev = hw->priv;
 	rtwsdio = (struct rtw_sdio *)rtwdev->priv;
-
 	rtwsdio->irq_thread = current;
 
 	hisr = rtw_read32(rtwdev, REG_SDIO_HISR);
-
 	if (hisr & REG_SDIO_HISR_TXERR)
 		rtw_sdio_tx_err_isr(rtwdev);
 	if (hisr & REG_SDIO_HISR_RX_REQUEST) {
@@ -1095,7 +1395,12 @@ static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
 		rtw_sdio_rx_isr(rtwdev);
 	}
 
-	rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
+	if (rtw_is_8723bs(rtwdev))
+		clear = hisr & rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK;
+	else
+		clear = hisr & RTW_SDIO_HISR_CLEAR_MASK;
+	if (clear)
+		rtw_write32(rtwdev, REG_SDIO_HISR, clear);
 
 	rtwsdio->irq_thread = NULL;
 }
@@ -1212,11 +1517,20 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
 	struct rtw_sdio_tx_data *tx_data = rtw_sdio_get_tx_data(skb);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = rtwdev->hw;
-
-	skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
-
-	/* enqueue to wait for tx report */
-	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+	u8 tx_pkt_offset = tx_data->tx_pkt_offset;
+
+	if (!tx_pkt_offset)
+		tx_pkt_offset = rtwdev->chip->tx_pkt_desc_sz;
+	skb_pull(skb, tx_pkt_offset);
+
+	/* The RTL8723BS vendor descriptor uses SW_DEFINE/sn=0 for management
+	 * frames, so there is no unique key for matching asynchronous C2H TX
+	 * reports. Report completion at SDIO DMA completion, as the vendor
+	 * dump_mgntframe_and_wait() path does; data frames keep the normal C2H
+	 * report queue.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS &&
+	    !(rtw_is_8723bs(rtwdev) && tx_data->is_mgmt)) {
 		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
 		return;
 	}
@@ -1231,32 +1545,48 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
-				      enum rtw_tx_queue_type queue)
+static int rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
+				     enum rtw_tx_queue_type queue,
+				     bool *processed)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	struct sk_buff *skb;
+	u16 q_map;
 	int ret;
 
+	*processed = false;
 	skb = skb_dequeue(&rtwsdio->tx_queue[queue]);
 	if (!skb)
-		return;
+		return 0;
 
+	*processed = true;
+	q_map = skb_get_queue_mapping(skb);
 	ret = rtw_sdio_write_port(rtwdev, skb, queue);
 	if (ret) {
 		skb_queue_head(&rtwsdio->tx_queue[queue], skb);
-		return;
+		return ret;
 	}
 
 	rtw_sdio_indicate_tx_status(rtwdev, skb);
+
+	if (rtw_is_8723bs(rtwdev) && queue < RTW_TX_QUEUE_BCN &&
+	    rtwsdio->queue_stopped[queue] &&
+	    skb_queue_len(&rtwsdio->tx_queue[queue]) <= RTW_SDIO_TX_FIFO_LOWATER) {
+		rtwsdio->queue_stopped[queue] = false;
+		ieee80211_wake_queue(rtwdev->hw, q_map);
+	}
+
+	return 0;
 }
 
 static void rtw_sdio_tx_handler(struct work_struct *work)
 {
 	struct rtw_sdio_work_data *work_data =
-		container_of(work, struct rtw_sdio_work_data, work);
+		container_of(to_delayed_work(work), struct rtw_sdio_work_data,
+			     work);
 	struct rtw_sdio *rtwsdio;
 	struct rtw_dev *rtwdev;
+	bool processed;
 	int limit, queue;
 
 	rtwdev = work_data->rtwdev;
@@ -1267,7 +1597,24 @@ static void rtw_sdio_tx_handler(struct work_struct *work)
 
 	for (queue = RTK_MAX_TX_QUEUE_NUM - 1; queue >= 0; queue--) {
 		for (limit = 0; limit < 1000; limit++) {
-			rtw_sdio_process_tx_queue(rtwdev, queue);
+			int ret;
+
+			ret = rtw_sdio_process_tx_queue(rtwdev, queue, &processed);
+			if (ret) {
+				if (rtw_is_8723bs(rtwdev) && ret == -EBUSY) {
+					mod_delayed_work(rtwsdio->txwq,
+							 &work_data->work,
+							 RTW_SDIO_TX_RETRY_DELAY);
+					return;
+				}
+				break;
+			}
+
+			if (rtw_is_8723bs(rtwdev) &&
+			    queue == RTW_TX_QUEUE_MGMT && processed) {
+				mod_delayed_work(rtwsdio->txwq, &work_data->work, 0);
+				return;
+			}
 
 			if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
 				break;
@@ -1294,14 +1641,16 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
+	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
 		skb_queue_head_init(&rtwsdio->tx_queue[i]);
+		rtwsdio->queue_stopped[i] = false;
+	}
 	rtwsdio->tx_handler_data = kmalloc_obj(*rtwsdio->tx_handler_data);
 	if (!rtwsdio->tx_handler_data)
 		goto err_destroy_wq;
 
 	rtwsdio->tx_handler_data->rtwdev = rtwdev;
-	INIT_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
+	INIT_DELAYED_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
 
 	return 0;
 
@@ -1315,6 +1664,7 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	int i;
 
+	cancel_delayed_work_sync(&rtwsdio->tx_handler_data->work);
 	destroy_workqueue(rtwsdio->txwq);
 	kfree(rtwsdio->tx_handler_data);
 
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 457e8b02380e..3dd0f44676bf 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -22,6 +22,7 @@
 
 /* SDIO Tx Control */
 #define REG_SDIO_TX_CTRL			(SDIO_LOCAL_OFFSET + 0x0000)
+#define BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE	BIT(4)
 
 /*SDIO status timeout*/
 #define REG_SDIO_TIMEOUT			(SDIO_LOCAL_OFFSET + 0x0002)
@@ -77,6 +78,14 @@
 /* the following two are RTL8188 SDIO Specific */
 #define REG_SDIO_HISR_MCU_ERR			BIT(28)
 #define REG_SDIO_HISR_TSF_BIT32_TOGGLE		BIT(29)
+#define RTW_SDIO_HISR_CLEAR_MASK		\
+	(REG_SDIO_HISR_TXERR | REG_SDIO_HISR_RXERR | \
+	 REG_SDIO_HISR_TXFOVW | REG_SDIO_HISR_RXFOVW | \
+	 REG_SDIO_HISR_TXBCNOK | REG_SDIO_HISR_TXBCNERR | \
+	 REG_SDIO_HISR_C2HCMD | REG_SDIO_HISR_CPWM1 | \
+	 REG_SDIO_HISR_CPWM2 | REG_SDIO_HISR_HSISR_IND | \
+	 REG_SDIO_HISR_GTINT3_IND | REG_SDIO_HISR_GTINT4_IND | \
+	 REG_SDIO_HISR_PSTIMEOUT | REG_SDIO_HISR_OCPINT)
 
 /* HCI Current Power Mode */
 #define REG_SDIO_HCPWM				(SDIO_LOCAL_OFFSET + 0x0019)
@@ -140,10 +149,12 @@ struct sdio_device_id;
 
 struct rtw_sdio_tx_data {
 	u8 sn;
+	u8 tx_pkt_offset;
+	bool is_mgmt;
 };
 
 struct rtw_sdio_work_data {
-	struct work_struct work;
+	struct delayed_work work;
 	struct rtw_dev *rtwdev;
 };
 
@@ -159,6 +170,13 @@ struct rtw_sdio {
 	struct workqueue_struct *txwq;
 	struct rtw_sdio_work_data *tx_handler_data;
 	struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
+	bool queue_stopped[RTK_MAX_TX_QUEUE_NUM];
+
+	atomic_t free_pg_high;
+	atomic_t free_pg_normal;
+	atomic_t free_pg_low;
+	atomic_t free_pg_pub;
+	atomic_t tx_oqt_free;
 };
 
 extern const struct dev_pm_ops rtw_sdio_pm_ops;
diff --git a/drivers/net/wireless/realtek/rtw88/sec.h b/drivers/net/wireless/realtek/rtw88/sec.h
index efcf45433999..73f2af66effe 100644
--- a/drivers/net/wireless/realtek/rtw88/sec.h
+++ b/drivers/net/wireless/realtek/rtw88/sec.h
@@ -22,6 +22,7 @@
 #define RTW_SEC_RX_DEC_EN		BIT(3)
 #define RTW_SEC_TX_BC_USE_DK		BIT(6)
 #define RTW_SEC_RX_BC_USE_DK		BIT(7)
+#define RTW_SEC_CHK_KEYID		BIT(8)
 
 #define RTW_SEC_ENGINE_EN		BIT(9)
 
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 9d747a060b98..797c1e0402f2 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -208,8 +208,9 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 	__skb_queue_tail(&tx_report->queue, skb);
 	spin_unlock_irqrestore(&tx_report->q_lock, flags);
 
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
-	    rtwdev->hci.type == RTW_HCI_TYPE_USB)
+	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
+	     rtwdev->hci.type == RTW_HCI_TYPE_USB) ||
+	    rtw_is_8723bs(rtwdev))
 		timeout = msecs_to_jiffies(2500);
 
 	mod_timer(&tx_report->purge_timer, jiffies + timeout);
-- 
2.55.0

