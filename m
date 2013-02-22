Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2443 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab3BVJH4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 04:07:56 -0500
From: "Piotr Haber" <phaber@broadcom.com>
To: linux-wireless@vger.kernel.org
cc: "Piotr Haber" <phaber@broadcom.com>
Subject: [PATCH 2/2] brcmfmac: control BT coexistence parameters
Date: Fri, 22 Feb 2013 10:08:12 +0100
Message-ID: <1361524092-4814-3-git-send-email-phaber@broadcom.com> (sfid-20130222_100813_632422_33F124F9)
In-Reply-To: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
References: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce feature to give Wifi traffic priority over Bluetooth.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c   |  472 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.h   |   24 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   11 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    3 +
 5 files changed, 512 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/btcoex.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 4d58aee..6421926 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -30,7 +30,8 @@ brcmfmac-objs += \
 		p2p.o \
 		dhd_cdc.o \
 		dhd_common.o \
-		dhd_linux.o
+		dhd_linux.o \
+		btcoex.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 		dhd_sdio.o \
 		bcmsdh.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
new file mode 100644
index 0000000..09f5721
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
@@ -0,0 +1,472 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include <net/cfg80211.h>
+
+#include <brcmu_wifi.h>
+#include <brcmu_utils.h>
+#include <defs.h>
+#include <dhd.h>
+#include <dhd_dbg.h>
+#include "fwil.h"
+#include "fwil_types.h"
+#include "btcoex.h"
+#include "p2p.h"
+#include "wl_cfg80211.h"
+
+/* T1 start SCO/eSCO priority suppression */
+#define BRCMF_BT_DHCP_OPPR_WIN_TIME   2500
+/* T2 turn off SCO/eSCO suppresion */
+#define BRCMF_BT_DHCP_FLAG_FORCE_TIME 5500
+
+/* BT registers values during DHCP */
+#define BRCMF_BT_DHCP_REG50 0x8022
+#define BRCMF_BT_DHCP_REG51 0
+#define BRCMF_BT_DHCP_REG64 0
+#define BRCMF_BT_DHCP_REG65 0
+#define BRCMF_BT_DHCP_REG71 0
+#define BRCMF_BT_DHCP_REG66 0x2710
+#define BRCMF_BT_DHCP_REG41 0x33
+#define BRCMF_BT_DHCP_REG68 0x190
+
+/* number of samples for SCO detection */
+#define BRCMF_BT_SCO_SAMPLES 12
+
+/**
+* enum brcmf_btcoex_state - BT coex DHCP state machine states
+* @BRCMF_BT_DHCP_IDLE: DCHP is idle
+* @BRCMF_BT_DHCP_START: DHCP started, wait before
+*			boosting wifi priority
+* @BRCMF_BT_DHCP_OPPR_WIN: graceful DHCP opportunity ended,
+*			boost wifi priority
+* @BRCMF_BT_DHCP_FLAG_FORCE_TIMEOUT: wifi priority boost end,
+*			restore defaults
+*/
+enum brcmf_btcoex_state {
+	BRCMF_BT_DHCP_IDLE,
+	BRCMF_BT_DHCP_START,
+	BRCMF_BT_DHCP_OPPR_WIN,
+	BRCMF_BT_DHCP_FLAG_FORCE_TIMEOUT
+};
+
+/**
+* struct brcmf_btcoex_info - BT coex related information
+* @timer: timer for DHCP state machine
+* @timer_on:  DHCP timer active
+* @dhcp_done: DHCP finished before T1/T2 timer expiration
+* @bt_state: DHCP state machine state
+* @work: DHCP state machine work
+* @cfg: driver private data for cfg80211 interface
+* @saved_reg66: saved value of btc_params 66
+* @saved_reg41: saved value of btc_params 41
+* @saved_reg68: saved value of btc_params 68
+* @saved_regs_part1: flag indicating regs 66,41,68
+*			have been saved
+* @saved_reg51: saved value of btc_params 51
+* @saved_reg64: saved value of btc_params 64
+* @saved_reg65: saved value of btc_params 65
+* @saved_reg71: saved value of btc_params 71
+* @saved_regs_part1: flag indicating regs 50,51,64,65,71
+*			have been saved
+*/
+struct brcmf_btcoex_info {
+	struct timer_list timer;
+	bool timer_on;
+	bool dhcp_done;
+	enum brcmf_btcoex_state bt_state;
+	struct work_struct work;
+	struct brcmf_cfg80211_info *cfg;
+	u32 saved_reg66;
+	u32 saved_reg41;
+	u32 saved_reg68;
+	bool saved_regs_part1;
+	u32 saved_reg50;
+	u32 saved_reg51;
+	u32 saved_reg64;
+	u32 saved_reg65;
+	u32 saved_reg71;
+	bool saved_regs_part2;
+};
+
+/**
+ * brcmf_btcoex_btcparams_write() - write bts_params firmware variable
+ * @ifp: interface
+ * @addr: btc_params register number
+ * @data: data to write
+ */
+static s32 brcmf_btcoex_btcparams_write(struct brcmf_if *ifp,
+				  u32 addr, u32 data)
+{
+	struct {
+		__le32 addr;
+		__le32 data;
+	} reg_write;
+
+	reg_write.addr = cpu_to_le32(addr);
+	reg_write.data = cpu_to_le32(data);
+	return brcmf_fil_iovar_data_set(ifp, "btc_params",
+					&reg_write, sizeof(reg_write));
+}
+
+/**
+ * brcmf_btcoex_btcparams_read() - read bts_params firmware variable
+ * @ifp: interface
+ * @addr: btc_params register number
+ * @data: read data
+ */
+static s32 brcmf_btcoex_btcparams_read(struct brcmf_if *ifp,
+				 u32 addr, u32 *data)
+{
+	*data = addr;
+
+	return brcmf_fil_iovar_int_get(ifp, "btc_params", data);
+}
+
+/**
+ * brcmf_btcoex_boost_wifi() - control BT SCO/eSCO parameters
+ * @btcx_inf: BT coex info
+ * @trump_sco:
+ *	true - set SCO/eSCO parameters for compatibility
+ *		during DHCP window
+ *	false - restore saved parameter values
+ *
+ * Enhanced BT COEX settings for eSCO compatibility during DHCP window
+ */
+static void brcmf_btcoex_boost_wifi(struct brcmf_btcoex_info *btcx_inf,
+				    bool trump_sco)
+{
+	struct brcmf_if *ifp = btcx_inf->cfg->pub->iflist[0];
+
+	if (trump_sco && !btcx_inf->saved_regs_part2) {
+		/* this should reduce eSCO agressive
+		 * retransmit w/o breaking it
+		 */
+
+		/* save current */
+		brcmf_dbg(TRACE, "new SCO/eSCO coex algo {save & override}\n");
+		brcmf_btcoex_btcparams_read(ifp, 50,
+					    &btcx_inf->saved_reg50);
+		brcmf_btcoex_btcparams_read(ifp, 51,
+					    &btcx_inf->saved_reg51);
+		brcmf_btcoex_btcparams_read(ifp, 64,
+					    &btcx_inf->saved_reg64);
+		brcmf_btcoex_btcparams_read(ifp, 65,
+					    &btcx_inf->saved_reg65);
+		brcmf_btcoex_btcparams_read(ifp, 71,
+					    &btcx_inf->saved_reg71);
+
+		btcx_inf->saved_regs_part2 = true;
+		brcmf_dbg(TRACE,
+			  "saved bt_params[50,51,64,65,71]: 0x%x 0x%x 0x%x 0x%x 0x%x\n",
+			  btcx_inf->saved_reg50, btcx_inf->saved_reg51,
+			  btcx_inf->saved_reg64, btcx_inf->saved_reg65,
+			  btcx_inf->saved_reg71);
+
+		/* pacify the eSco   */
+		brcmf_btcoex_btcparams_write(ifp, 50,
+					     BRCMF_BT_DHCP_REG50);
+		brcmf_btcoex_btcparams_write(ifp, 51,
+					     BRCMF_BT_DHCP_REG51);
+		brcmf_btcoex_btcparams_write(ifp, 64,
+					     BRCMF_BT_DHCP_REG64);
+		brcmf_btcoex_btcparams_write(ifp, 65,
+					     BRCMF_BT_DHCP_REG65);
+		brcmf_btcoex_btcparams_write(ifp, 71,
+					     BRCMF_BT_DHCP_REG71);
+
+	} else if (btcx_inf->saved_regs_part2) {
+		/* restore previously saved bt params */
+		brcmf_dbg(TRACE, "Do new SCO/eSCO coex algo {restore}\n");
+		brcmf_btcoex_btcparams_write(ifp, 50,
+					     btcx_inf->saved_reg50);
+		brcmf_btcoex_btcparams_write(ifp, 51,
+					     btcx_inf->saved_reg51);
+		brcmf_btcoex_btcparams_write(ifp, 64,
+					     btcx_inf->saved_reg64);
+		brcmf_btcoex_btcparams_write(ifp, 65,
+					     btcx_inf->saved_reg65);
+		brcmf_btcoex_btcparams_write(ifp, 71,
+					     btcx_inf->saved_reg71);
+
+		brcmf_dbg(TRACE,
+			  "restored bt_params[50,51,64,65,71]: 0x%x 0x%x 0x%x 0x%x 0x%x\n",
+			  btcx_inf->saved_reg50, btcx_inf->saved_reg51,
+			  btcx_inf->saved_reg64, btcx_inf->saved_reg65,
+			  btcx_inf->saved_reg71);
+
+		btcx_inf->saved_regs_part2 = false;
+	} else {
+		brcmf_err("attempted to restore not saved BTCOEX params\n");
+	}
+}
+
+/**
+ * brcmf_btcoex_is_sco_active() - check if SCO/eSCO is active
+ * @ifp: interface
+ *
+ * return: true if SCO/eSCO session is active
+ */
+static bool brcmf_btcoex_is_sco_active(struct brcmf_if *ifp)
+{
+	int ioc_res = 0;
+	bool res = false;
+	int sco_id_cnt = 0;
+	u32 param27;
+	int i;
+
+	for (i = 0; i < BRCMF_BT_SCO_SAMPLES; i++) {
+		ioc_res = brcmf_btcoex_btcparams_read(ifp, 27,
+						      &param27);
+
+		if (ioc_res < 0) {
+			brcmf_err("ioc read btc params error\n");
+			break;
+		}
+
+		brcmf_dbg(TRACE, "sample[%d], btc_params 27:%x\n", i, param27);
+
+		if ((param27 & 0x6) == 2) { /* count both sco & esco  */
+			sco_id_cnt++;
+		}
+
+		if (sco_id_cnt > 2) {
+			brcmf_dbg(TRACE,
+				  "sco/esco detected, pkt id_cnt:%d samples:%d\n",
+				  sco_id_cnt, i);
+			res = true;
+			break;
+		}
+	}
+	return res;
+}
+
+/**
+ * brcmf_btcoex_timerfunc() - BT coex timer callback
+ */
+static void brcmf_btcoex_timerfunc(ulong data)
+{
+	struct brcmf_btcoex_info *bt_local = (struct brcmf_btcoex_info *)data;
+	brcmf_dbg(TRACE, "enter\n");
+
+	bt_local->timer_on = false;
+	schedule_work(&bt_local->work);
+}
+
+/**
+ * brcmf_btcoex_handler() - BT coex state machine work handler
+ * @work: work
+ */
+static void brcmf_btcoex_handler(struct work_struct *work)
+{
+	struct brcmf_btcoex_info *btcx_inf;
+	btcx_inf = container_of(work, struct brcmf_btcoex_info, work);
+	if (btcx_inf->timer_on) {
+		btcx_inf->timer_on = false;
+		del_timer_sync(&btcx_inf->timer);
+	}
+
+	switch (btcx_inf->bt_state) {
+	case BRCMF_BT_DHCP_START:
+		/* DHCP started provide OPPORTUNITY window
+		   to get DHCP address
+		*/
+		brcmf_dbg(TRACE, "DHCP started\n");
+		btcx_inf->bt_state = BRCMF_BT_DHCP_OPPR_WIN;
+		mod_timer(&btcx_inf->timer, jiffies +
+			  msecs_to_jiffies(BRCMF_BT_DHCP_OPPR_WIN_TIME));
+		btcx_inf->timer_on = true;
+		break;
+
+	case BRCMF_BT_DHCP_OPPR_WIN:
+		if (btcx_inf->dhcp_done) {
+			brcmf_dbg(TRACE, "DHCP done before T1 expiration\n");
+			goto btc_coex_idle;
+		}
+
+		/* DHCP is not over yet, start lowering BT priority */
+		brcmf_dbg(TRACE, "DHCP T1:%d expired\n",
+			  BRCMF_BT_DHCP_OPPR_WIN_TIME);
+		brcmf_btcoex_boost_wifi(btcx_inf, true);
+
+		btcx_inf->bt_state = BRCMF_BT_DHCP_FLAG_FORCE_TIMEOUT;
+		mod_timer(&btcx_inf->timer, jiffies +
+			  msecs_to_jiffies(BRCMF_BT_DHCP_FLAG_FORCE_TIME));
+		btcx_inf->timer_on = true;
+		break;
+
+	case BRCMF_BT_DHCP_FLAG_FORCE_TIMEOUT:
+		if (btcx_inf->dhcp_done)
+			brcmf_dbg(TRACE, "DHCP done before T2 expiration\n");
+		else
+			brcmf_dbg(TRACE, "DHCP T2:%d expired\n",
+				  BRCMF_BT_DHCP_FLAG_FORCE_TIME);
+
+		/* Restoring default bt priority */
+		brcmf_btcoex_boost_wifi(btcx_inf, false);
+btc_coex_idle:
+		btcx_inf->bt_state = BRCMF_BT_DHCP_IDLE;
+		btcx_inf->timer_on = false;
+		break;
+
+	default:
+		brcmf_dbg(TRACE, "error state=%d !!!\n", btcx_inf->bt_state);
+		brcmf_btcoex_boost_wifi(btcx_inf, false);
+		btcx_inf->bt_state = BRCMF_BT_DHCP_IDLE;
+		btcx_inf->timer_on = false;
+		break;
+	}
+}
+
+/**
+ * brcmf_btcoex_init() - initialize BT coex data
+ * @cfg: driver private cfg80211 data
+ *
+ * return: 0 on success
+ */
+int brcmf_btcoex_init(struct brcmf_cfg80211_info *cfg)
+{
+	struct brcmf_btcoex_info *btco_inf = NULL;
+	brcmf_dbg(TRACE, "enter\n");
+
+	btco_inf = kmalloc(sizeof(struct brcmf_btcoex_info), GFP_KERNEL);
+	if (!btco_inf)
+		return -ENOMEM;
+
+	btco_inf->bt_state = BRCMF_BT_DHCP_IDLE;
+
+	/* Set up timer for BT  */
+	btco_inf->timer_on = false;
+	init_timer(&btco_inf->timer);
+	btco_inf->timer.data = (ulong)btco_inf;
+	btco_inf->timer.function = brcmf_btcoex_timerfunc;
+	btco_inf->cfg = cfg;
+	btco_inf->saved_regs_part1 = false;
+	btco_inf->saved_regs_part2 = false;
+
+	INIT_WORK(&btco_inf->work, brcmf_btcoex_handler);
+
+	cfg->btcoex = btco_inf;
+	return 0;
+}
+
+/**
+ * brcmf_btcoex_deinit - clean BT coex data
+ * @cfg: driver private cfg80211 data
+ */
+void brcmf_btcoex_deinit(struct brcmf_cfg80211_info *cfg)
+{
+	brcmf_dbg(TRACE, "enter\n");
+
+	if (!cfg->btcoex)
+		return;
+
+	if (cfg->btcoex->timer_on) {
+		cfg->btcoex->timer_on = false;
+		del_timer_sync(&cfg->btcoex->timer);
+	}
+
+	cancel_work_sync(&cfg->btcoex->work);
+
+	kfree(cfg->btcoex);
+	cfg->btcoex = NULL;
+}
+
+/**
+ * brcmf_btcoex_set_mode - set BT coex mode
+ * @cfg: driver private cfg80211 data
+ * @mode: Wifi-Bluetooth coexistence mode
+ *
+ * return: 0 on success
+ */
+int brcmf_btcoex_set_mode(struct brcmf_cfg80211_info *cfg,
+			enum nl80211_btcoex_mode mode)
+{
+	struct brcmf_btcoex_info *btco_inf = cfg->btcoex;
+	struct brcmf_if *ifp = cfg->pub->iflist[0];
+
+	switch (mode) {
+	case NL80211_BTCOEX_DISABLED:
+		brcmf_dbg(TRACE, "DHCP session starts\n");
+
+		if (!btco_inf->saved_regs_part1) {
+			/* Retrieve and save original reg value */
+			brcmf_btcoex_btcparams_read(ifp, 66,
+						    &btco_inf->saved_reg66);
+			brcmf_btcoex_btcparams_read(ifp, 41,
+						    &btco_inf->saved_reg41);
+			brcmf_btcoex_btcparams_read(ifp, 68,
+						    &btco_inf->saved_reg68);
+
+			btco_inf->saved_regs_part1 = true;
+			brcmf_dbg(TRACE,
+				  "saved btc_params regs (66,41,68) 0x%x 0x%x 0x%x\n",
+				  btco_inf->saved_reg66, btco_inf->saved_reg41,
+				  btco_inf->saved_reg68);
+		}
+		/* Start BT timer only for SCO connection */
+		if (brcmf_btcoex_is_sco_active(ifp)) {
+			/* set new regs values */
+			brcmf_btcoex_btcparams_write(ifp, 66,
+						     BRCMF_BT_DHCP_REG66);
+			brcmf_btcoex_btcparams_write(ifp, 41,
+						     BRCMF_BT_DHCP_REG41);
+			brcmf_btcoex_btcparams_write(ifp, 68,
+						     BRCMF_BT_DHCP_REG68);
+			btco_inf->dhcp_done = false;
+			btco_inf->bt_state = BRCMF_BT_DHCP_START;
+			btco_inf->timer_on = true;
+			mod_timer(&btco_inf->timer, btco_inf->timer.expires);
+			brcmf_dbg(TRACE, "enable BT DHCP Timer\n");
+		}
+		break;
+
+	case NL80211_BTCOEX_ENABLED:
+		brcmf_dbg(TRACE, "DHCP session ends\n");
+		/* Stop any bt timer because DHCP session is done */
+		btco_inf->dhcp_done = true;
+		if (btco_inf->timer_on) {
+			brcmf_dbg(TRACE, "disable BT DHCP Timer\n");
+			btco_inf->timer_on = false;
+			del_timer_sync(&btco_inf->timer);
+			if (btco_inf->bt_state != BRCMF_BT_DHCP_IDLE) {
+				brcmf_dbg(TRACE, "bt_state:%d\n",
+					  btco_inf->bt_state);
+				/* wake up btcoex thread */
+				schedule_work(&btco_inf->work);
+			}
+		}
+		/* Restore original values */
+		if (btco_inf->saved_regs_part1) {
+			/* btc_params */
+			brcmf_btcoex_btcparams_write(ifp, 66,
+						     btco_inf->saved_reg66);
+			brcmf_btcoex_btcparams_write(ifp, 41,
+						     btco_inf->saved_reg41);
+			brcmf_btcoex_btcparams_write(ifp, 68,
+						     btco_inf->saved_reg68);
+			brcmf_dbg(TRACE,
+				  "restored btc_params regs {66,41,68} 0x%x 0x%x 0x%x\n",
+				  btco_inf->saved_reg66, btco_inf->saved_reg41,
+				  btco_inf->saved_reg68);
+		}
+		btco_inf->saved_regs_part1 = false;
+		break;
+	default:
+		brcmf_dbg(TRACE, "Unknown mode, ignored\n");
+	}
+	return 0;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.h b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.h
new file mode 100644
index 0000000..5867123
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef WL_BTCOEX_H_
+#define WL_BTCOEX_H_
+
+int brcmf_btcoex_init(struct brcmf_cfg80211_info *cfg);
+void brcmf_btcoex_deinit(struct brcmf_cfg80211_info *cfg);
+int brcmf_btcoex_set_mode(struct brcmf_cfg80211_info *cfg,
+			  enum nl80211_btcoex_mode mode);
+
+#endif /* WL_BTCOEX_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index a4f27f6..188d142 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -28,6 +28,7 @@
 #include "dhd_dbg.h"
 #include "fwil_types.h"
 #include "p2p.h"
+#include "btcoex.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
 
@@ -1084,6 +1085,13 @@ static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		if (!err)
 			goto done;
 	}
+	if (changed & WIPHY_PARAM_BTCOEX_MODE &&
+	    (cfg->conf->btcoex_mode != wiphy->btcoex_mode)) {
+		cfg->conf->btcoex_mode = wiphy->btcoex_mode;
+		err = brcmf_btcoex_set_mode(cfg, cfg->conf->btcoex_mode);
+		if (!err)
+			goto done;
+	}
 
 done:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -4657,6 +4665,7 @@ static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 	conf->retry_short = (u32)-1;
 	conf->retry_long = (u32)-1;
 	conf->tx_power = -1;
+	conf->btcoex_mode = NL80211_BTCOEX_ENABLED;
 }
 
 static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
@@ -4814,6 +4823,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		brcmf_err("P2P initilisation failed (%d)\n", err);
 		goto cfg80211_p2p_attach_out;
 	}
+	brcmf_btcoex_init(cfg);
 
 	return cfg;
 
@@ -4832,6 +4842,7 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	struct brcmf_cfg80211_vif *tmp;
 
 	wl_deinit_priv(cfg);
+	brcmf_btcoex_deinit(cfg);
 	list_for_each_entry_safe(vif, tmp, &cfg->vif_list, list) {
 		brcmf_free_vif(vif);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 8b5d498..f764925 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -107,6 +107,7 @@ struct brcmf_cfg80211_conf {
 	u32 retry_long;
 	s32 tx_power;
 	struct ieee80211_channel channel;
+	enum nl80211_btcoex_mode btcoex_mode;
 };
 
 /* basic structure of scan request */
@@ -347,6 +348,7 @@ struct brcmf_cfg80211_vif_event {
  * @wiphy: wiphy object for cfg80211 interface.
  * @conf: dongle configuration.
  * @p2p: peer-to-peer specific information.
+ * @btcoex: Bluetooth coexistence information.
  * @scan_request: cfg80211 scan request object.
  * @usr_sync: mainly for dongle up/down synchronization.
  * @bss_list: bss_list holding scanned ap information.
@@ -380,6 +382,7 @@ struct brcmf_cfg80211_info {
 	struct wiphy *wiphy;
 	struct brcmf_cfg80211_conf *conf;
 	struct brcmf_p2p_info p2p;
+	struct brcmf_btcoex_info *btcoex;
 	struct cfg80211_scan_request *scan_request;
 	struct mutex usr_sync;
 	struct brcmf_scan_results *bss_list;
-- 
1.7.9.5


