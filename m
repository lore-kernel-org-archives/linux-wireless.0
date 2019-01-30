Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D766CC282D1
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 04:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98FB321848
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 04:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbfA3EDA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 23:03:00 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:46818 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729993AbfA3EC5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 23:02:57 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0U42RWK015701, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0U42RWK015701
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Wed, 30 Jan 2019 12:02:27 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Wed, 30 Jan 2019 12:02:26 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <pkshih@realtek.com>,
        <tehuang@realtek.com>, <briannorris@chromium.org>,
        <sgruszka@redhat.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 02/13] rtw88: core files
Date:   Wed, 30 Jan 2019 12:02:09 +0800
Message-ID: <1548820940-15237-3-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

core files for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/ps.c   | 166 +++++++++++++
 drivers/net/wireless/realtek/rtw88/ps.h   |  20 ++
 drivers/net/wireless/realtek/rtw88/regd.c | 391 ++++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/regd.h |  67 +++++
 drivers/net/wireless/realtek/rtw88/sec.c  | 120 +++++++++
 drivers/net/wireless/realtek/rtw88/sec.h  |  39 +++
 6 files changed, 803 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/regd.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sec.h

diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
new file mode 100644
index 0000000..c0dcc07
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "fw.h"
+#include "ps.h"
+#include "mac.h"
+#include "debug.h"
+
+static int rtw_ips_pwr_up(struct rtw_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw_core_start(rtwdev);
+	if (ret)
+		rtw_err(rtwdev, "leave idle state failed\n");
+
+	rtw_set_channel(rtwdev);
+	rtw_flag_clear(rtwdev, RTW_FLAG_INACTIVE_PS);
+
+	return ret;
+}
+
+int rtw_enter_ips(struct rtw_dev *rtwdev)
+{
+	rtw_flag_set(rtwdev, RTW_FLAG_INACTIVE_PS);
+
+	rtw_core_stop(rtwdev);
+
+	return 0;
+}
+
+static void rtw_restore_port_cfg_iter(void *data, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	struct rtw_dev *rtwdev = data;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	u32 config = ~0;
+
+	rtw_vif_port_config(rtwdev, rtwvif, config);
+}
+
+int rtw_leave_ips(struct rtw_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw_ips_pwr_up(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to leave ips state\n");
+		return ret;
+	}
+
+	rtw_iterate_vifs_atomic(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
+
+	return 0;
+}
+
+static void rtw_leave_lps_core(struct rtw_dev *rtwdev)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	conf->state = RTW_ALL_ON;
+	conf->awake_interval = 1;
+	conf->rlbm = 0;
+	conf->smart_ps = 0;
+
+	rtw_fw_set_pwr_mode(rtwdev);
+	rtw_flag_clear(rtwdev, RTW_FLAG_LEISURE_PS);
+}
+
+static void rtw_enter_lps_core(struct rtw_dev *rtwdev)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	conf->state = RTW_RF_OFF;
+	conf->awake_interval = 1;
+	conf->rlbm = 1;
+	conf->smart_ps = 2;
+
+	rtw_fw_set_pwr_mode(rtwdev);
+	rtw_flag_set(rtwdev, RTW_FLAG_LEISURE_PS);
+}
+
+void rtw_lps_work(struct work_struct *work)
+{
+	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
+					      lps_work.work);
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+	struct rtw_vif *rtwvif = conf->rtwvif;
+
+	if (WARN_ON(!rtwvif))
+		return;
+
+	if (conf->mode == RTW_MODE_LPS)
+		rtw_enter_lps_core(rtwdev);
+	else
+		rtw_leave_lps_core(rtwdev);
+}
+
+void rtw_enter_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_LPS;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = true;
+
+	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->lps_work, 0);
+}
+
+void rtw_leave_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (!rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_ACTIVE;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = false;
+
+	ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->lps_work, 0);
+}
+
+bool rtw_in_lps(struct rtw_dev *rtwdev)
+{
+	return rtw_flag_check(rtwdev, RTW_FLAG_LEISURE_PS);
+}
+
+void rtw_enter_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (WARN_ON(!rtwvif))
+		return;
+
+	if (rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_LPS;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = true;
+
+	rtw_enter_lps_core(rtwdev);
+}
+
+void rtw_leave_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+
+	if (WARN_ON(!rtwvif))
+		return;
+
+	if (!rtwvif->in_lps)
+		return;
+
+	conf->mode = RTW_MODE_ACTIVE;
+	conf->rtwvif = rtwvif;
+	rtwvif->in_lps = false;
+
+	rtw_leave_lps_core(rtwdev);
+}
diff --git a/drivers/net/wireless/realtek/rtw88/ps.h b/drivers/net/wireless/realtek/rtw88/ps.h
new file mode 100644
index 0000000..4006c6c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/ps.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_PS_H_
+#define __RTW_PS_H_
+
+#define RTW_LPS_THRESHOLD	2
+
+int rtw_enter_ips(struct rtw_dev *rtwdev);
+int rtw_leave_ips(struct rtw_dev *rtwdev);
+
+void rtw_lps_work(struct work_struct *work);
+void rtw_enter_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_leave_lps_irqsafe(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_enter_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+void rtw_leave_lps(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif);
+bool rtw_in_lps(struct rtw_dev *rtwdev);
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/regd.c b/drivers/net/wireless/realtek/rtw88/regd.c
new file mode 100644
index 0000000..2e8abc7
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/regd.c
@@ -0,0 +1,391 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "regd.h"
+#include "debug.h"
+#include "phy.h"
+
+#define COUNTRY_CHPLAN_ENT(_alpha2, _chplan, _txpwr_regd) \
+	{.alpha2 = (_alpha2), \
+	 .chplan = (_chplan), \
+	 .txpwr_regd = (_txpwr_regd) \
+	}
+
+/* If country code is not correctly defined in efuse,
+ * use worldwide country code and txpwr regd.
+ */
+static const struct rtw_regulatory rtw_defined_chplan =
+	COUNTRY_CHPLAN_ENT("00", RTW_CHPLAN_REALTEK_DEFINE, RTW_REGD_WW);
+
+static const struct rtw_regulatory all_chplan_map[] = {
+	COUNTRY_CHPLAN_ENT("AD", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AF", RTW_CHPLAN_ETSI1_ETSI4, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AL", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AN", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AO", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AQ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AR", RTW_CHPLAN_FCC2_FCC7, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("AS", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("AT", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AU", RTW_CHPLAN_WORLD_ACMA1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("AW", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("AZ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BA", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BB", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("BD", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BF", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BH", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BJ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BN", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BO", RTW_CHPLAN_WORLD_FCC7, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("BR", RTW_CHPLAN_FCC2_FCC1, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("BS", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("BW", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BY", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("BZ", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("CA", RTW_CHPLAN_IC1_IC2, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("CC", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CD", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CF", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CH", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CK", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CL", RTW_CHPLAN_WORLD_CHILE1, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("CM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CN", RTW_CHPLAN_WORLD_ETSI7, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CO", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("CR", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("CV", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CX", RTW_CHPLAN_WORLD_ACMA1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CY", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("CZ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("DE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("DJ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("DK", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("DM", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("DO", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("DZ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("EC", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("EE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("EG", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("EH", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ER", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ES", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ET", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("FI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("FJ", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("FK", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("FM", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("FO", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("FR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GA", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GB", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GD", RTW_CHPLAN_FCC1_FCC7, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("GE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GF", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GH", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GL", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GN", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GP", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GQ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GS", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GT", RTW_CHPLAN_FCC2_FCC7, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("GU", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("GW", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("GY", RTW_CHPLAN_FCC1_NCC3, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("HK", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("HM", RTW_CHPLAN_WORLD_ACMA1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("HN", RTW_CHPLAN_WORLD_FCC5, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("HR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("HT", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("HU", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ID", RTW_CHPLAN_ETSI1_ETSI12, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IL", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IN", RTW_CHPLAN_WORLD_ETSI7, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IQ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IS", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("IT", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("JE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("JM", RTW_CHPLAN_WORLD_ETSI10, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("JO", RTW_CHPLAN_WORLD_ETSI8, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("JP", RTW_CHPLAN_MKK1_MKK1, RTW_REGD_MKK),
+	COUNTRY_CHPLAN_ENT("KE", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("KG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("KH", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("KI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("KN", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("KR", RTW_CHPLAN_KCC1_KCC2, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("KW", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("KY", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("KZ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LA", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LB", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LC", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("LI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LK", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LS", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LT", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LU", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LV", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("LY", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MA", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MC", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MD", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ME", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MF", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("MG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MH", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("MK", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ML", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MN", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MO", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MP", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("MQ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MS", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MT", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MU", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MV", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MW", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MX", RTW_CHPLAN_FCC2_FCC7, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("MY", RTW_CHPLAN_WORLD_ETSI20, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("MZ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NA", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NC", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NF", RTW_CHPLAN_WORLD_ACMA1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NG", RTW_CHPLAN_WORLD_ETSI20, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NI", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("NL", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NO", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NP", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NU", RTW_CHPLAN_WORLD_ACMA1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("NZ", RTW_CHPLAN_WORLD_ACMA1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("OM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PA", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("PE", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("PF", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PH", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PK", RTW_CHPLAN_WORLD_ETSI10, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PL", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PR", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("PT", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("PW", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("PY", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("QA", RTW_CHPLAN_WORLD_ETSI10, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("RE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("RO", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("RS", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("RU", RTW_CHPLAN_WORLD_ETSI14, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("RW", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SA", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SB", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SC", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("SE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SH", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SI", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SJ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SK", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SL", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SN", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SO", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("SR", RTW_CHPLAN_FCC2_FCC17, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("ST", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("SV", RTW_CHPLAN_WORLD_FCC3, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("SX", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("SZ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TC", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TD", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TF", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TH", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TJ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TK", RTW_CHPLAN_WORLD_ACMA1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TN", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TO", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TR", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TT", RTW_CHPLAN_ETSI1_ETSI4, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("TW", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("TZ", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("UA", RTW_CHPLAN_WORLD_ETSI3, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("UG", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("US", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("UY", RTW_CHPLAN_WORLD_FCC3, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("UZ", RTW_CHPLAN_WORLD_ETSI6, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("VA", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("VC", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("VE", RTW_CHPLAN_WORLD_FCC3, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("VI", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("VN", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("VU", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("WF", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("WS", RTW_CHPLAN_FCC2_FCC11, RTW_REGD_FCC),
+	COUNTRY_CHPLAN_ENT("YE", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("YT", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ZA", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ZM", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+	COUNTRY_CHPLAN_ENT("ZW", RTW_CHPLAN_WORLD_ETSI1, RTW_REGD_ETSI),
+};
+
+static void rtw_regd_apply_beaconing_flags(struct wiphy *wiphy,
+					   enum nl80211_reg_initiator initiator)
+{
+	enum nl80211_band band;
+	struct ieee80211_supported_band *sband;
+	const struct ieee80211_reg_rule *reg_rule;
+	struct ieee80211_channel *ch;
+	unsigned int i;
+
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		if (!wiphy->bands[band])
+			continue;
+
+		sband = wiphy->bands[band];
+		for (i = 0; i < sband->n_channels; i++) {
+			ch = &sband->channels[i];
+
+			reg_rule = freq_reg_info(wiphy,
+						 MHZ_TO_KHZ(ch->center_freq));
+			if (IS_ERR(reg_rule))
+				continue;
+
+			ch->flags &= ~IEEE80211_CHAN_DISABLED;
+
+			if (!(reg_rule->flags & NL80211_RRF_NO_IR))
+				ch->flags &= ~IEEE80211_CHAN_NO_IR;
+		}
+	}
+}
+
+static void rtw_regd_apply_hw_cap_flags(struct wiphy *wiphy)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	int i;
+
+	if (efuse->hw_cap.bw & BIT(RTW_CHANNEL_WIDTH_80))
+		return;
+
+	sband = wiphy->bands[NL80211_BAND_2GHZ];
+	if (!sband)
+		goto out_5g;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		ch->flags |= IEEE80211_CHAN_NO_80MHZ;
+	}
+
+out_5g:
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
+	if (!sband)
+		return;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		ch->flags |= IEEE80211_CHAN_NO_80MHZ;
+	}
+}
+
+static void rtw_regd_apply_world_flags(struct wiphy *wiphy,
+				       enum nl80211_reg_initiator initiator)
+{
+	rtw_regd_apply_beaconing_flags(wiphy, initiator);
+}
+
+static struct rtw_regulatory rtw_regd_find_reg_by_name(char *alpha2)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(all_chplan_map); i++) {
+		if (!memcmp(all_chplan_map[i].alpha2, alpha2, 2))
+			return all_chplan_map[i];
+	}
+
+	return rtw_defined_chplan;
+}
+
+static int rtw_regd_notifier_apply(struct rtw_dev *rtwdev,
+				   struct wiphy *wiphy,
+				   struct regulatory_request *request)
+{
+	if (request->initiator == NL80211_REGDOM_SET_BY_USER)
+		return 0;
+	rtwdev->regd = rtw_regd_find_reg_by_name(request->alpha2);
+	rtw_regd_apply_world_flags(wiphy, request->initiator);
+
+	return 0;
+}
+
+static int
+rtw_regd_init_wiphy(struct rtw_regulatory *reg, struct wiphy *wiphy,
+		    void (*reg_notifier)(struct wiphy *wiphy,
+					 struct regulatory_request *request))
+{
+	wiphy->reg_notifier = reg_notifier;
+
+	wiphy->regulatory_flags &= ~REGULATORY_CUSTOM_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_STRICT_REG;
+	wiphy->regulatory_flags &= ~REGULATORY_DISABLE_BEACON_HINTS;
+
+	rtw_regd_apply_hw_cap_flags(wiphy);
+
+	return 0;
+}
+
+int rtw_regd_init(struct rtw_dev *rtwdev,
+		  void (*reg_notifier)(struct wiphy *wiphy,
+				       struct regulatory_request *request))
+{
+	struct wiphy *wiphy = rtwdev->hw->wiphy;
+
+	if (!wiphy)
+		return -EINVAL;
+
+	rtwdev->regd = rtw_regd_find_reg_by_name(rtwdev->efuse.country_code);
+	rtw_regd_init_wiphy(&rtwdev->regd, wiphy, reg_notifier);
+
+	return 0;
+}
+
+void rtw_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_hal *hal = &rtwdev->hal;
+
+	rtw_regd_notifier_apply(rtwdev, wiphy, request);
+	rtw_dbg(rtwdev,
+		"get alpha2 %c%c from initiator %d, mapping to chplan 0x%x, txregd %d\n",
+		request->alpha2[0], request->alpha2[1], request->initiator,
+		rtwdev->regd.chplan, rtwdev->regd.txpwr_regd);
+
+	rtw_phy_set_tx_power_level(rtwdev, hal->current_channel);
+}
diff --git a/drivers/net/wireless/realtek/rtw88/regd.h b/drivers/net/wireless/realtek/rtw88/regd.h
new file mode 100644
index 0000000..8316e8b
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/regd.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_REGD_H_
+#define __RTW_REGD_H_
+
+#define IEEE80211_CHAN_NO_IBSS IEEE80211_CHAN_NO_IR
+#define IEEE80211_CHAN_PASSIVE_SCAN IEEE80211_CHAN_NO_IR
+enum rtw_chplan_id {
+	RTW_CHPLAN_WORLD_ETSI1 = 0x26,
+	RTW_CHPLAN_MKK1_MKK1 = 0x27,
+	RTW_CHPLAN_IC1_IC2 = 0x2B,
+	RTW_CHPLAN_WORLD_CHILE1 = 0x2D,
+	RTW_CHPLAN_WORLD_FCC3 = 0x30,
+	RTW_CHPLAN_WORLD_FCC5 = 0x32,
+	RTW_CHPLAN_FCC1_FCC7 = 0x34,
+	RTW_CHPLAN_WORLD_ETSI3 = 0x36,
+	RTW_CHPLAN_ETSI1_ETSI12 = 0x3D,
+	RTW_CHPLAN_KCC1_KCC2 = 0x3E,
+	RTW_CHPLAN_ETSI1_ETSI4 = 0x42,
+	RTW_CHPLAN_FCC1_NCC3 = 0x44,
+	RTW_CHPLAN_WORLD_ACMA1 = 0x45,
+	RTW_CHPLAN_WORLD_ETSI6 = 0x47,
+	RTW_CHPLAN_WORLD_ETSI7 = 0x48,
+	RTW_CHPLAN_WORLD_ETSI8 = 0x49,
+	RTW_CHPLAN_WORLD_ETSI10 = 0x51,
+	RTW_CHPLAN_WORLD_ETSI14 = 0x59,
+	RTW_CHPLAN_FCC2_FCC7 = 0x61,
+	RTW_CHPLAN_FCC2_FCC1 = 0x62,
+	RTW_CHPLAN_WORLD_FCC7 = 0x73,
+	RTW_CHPLAN_FCC2_FCC17 = 0x74,
+	RTW_CHPLAN_WORLD_ETSI20 = 0x75,
+	RTW_CHPLAN_FCC2_FCC11 = 0x76,
+	RTW_CHPLAN_REALTEK_DEFINE = 0x7f,
+};
+
+struct country_code_to_enum_rd {
+	u16 countrycode;
+	const char *iso_name;
+};
+
+enum country_code_type {
+	COUNTRY_CODE_FCC = 0,
+	COUNTRY_CODE_IC = 1,
+	COUNTRY_CODE_ETSI = 2,
+	COUNTRY_CODE_SPAIN = 3,
+	COUNTRY_CODE_FRANCE = 4,
+	COUNTRY_CODE_MKK = 5,
+	COUNTRY_CODE_MKK1 = 6,
+	COUNTRY_CODE_ISRAEL = 7,
+	COUNTRY_CODE_TELEC = 8,
+	COUNTRY_CODE_MIC = 9,
+	COUNTRY_CODE_GLOBAL_DOMAIN = 10,
+	COUNTRY_CODE_WORLD_WIDE_13 = 11,
+	COUNTRY_CODE_TELEC_NETGEAR = 12,
+	COUNTRY_CODE_WORLD_WIDE_13_5G_ALL = 13,
+
+	/* new channel plan above this */
+	COUNTRY_CODE_MAX
+};
+
+int rtw_regd_init(struct rtw_dev *rtwdev,
+		  void (*reg_notifier)(struct wiphy *wiphy,
+				       struct regulatory_request *request));
+void rtw_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request);
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/sec.c b/drivers/net/wireless/realtek/rtw88/sec.c
new file mode 100644
index 0000000..59b6fce
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/sec.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "sec.h"
+#include "reg.h"
+
+int rtw_sec_get_free_cam(struct rtw_sec_desc *sec)
+{
+	/* if default key search is enabled, the first 4 cam entries
+	 * are used to direct map to group key with its key->key_idx, so
+	 * driver should use cam entries after 4 to install pairwise key
+	 */
+	if (sec->default_key_search)
+		return find_next_zero_bit(sec->cam_map, RTW_MAX_SEC_CAM_NUM,
+					  RTW_SEC_DEFAULT_KEY_NUM);
+
+	return find_first_zero_bit(sec->cam_map, RTW_MAX_SEC_CAM_NUM);
+}
+
+void rtw_sec_write_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key,
+		       u8 hw_key_type, u8 hw_key_idx)
+{
+	struct rtw_cam_entry *cam = &sec->cam_table[hw_key_idx];
+	u32 write_cmd;
+	u32 command;
+	u32 content;
+	u32 addr;
+	int i, j;
+
+	set_bit(hw_key_idx, sec->cam_map);
+	cam->valid = true;
+	cam->group = !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE);
+	cam->hw_key_type = hw_key_type;
+	cam->key = key;
+	if (sta)
+		ether_addr_copy(cam->addr, sta->addr);
+	else
+		eth_broadcast_addr(cam->addr);
+
+	write_cmd = RTW_SEC_CMD_WRITE_ENABLE | RTW_SEC_CMD_POLLING;
+	addr = hw_key_idx << RTW_SEC_CAM_ENTRY_SHIFT;
+	for (i = 5; i >= 0; i--) {
+		switch (i) {
+		case 0:
+			content = ((key->keyidx & 0x3))		|
+				  ((hw_key_type & 0x7)	<< 2)	|
+				  (cam->group		<< 6)	|
+				  (cam->valid		<< 15)	|
+				  (cam->addr[0]		<< 16)	|
+				  (cam->addr[1]		<< 24);
+			break;
+		case 1:
+			content = (cam->addr[2])		|
+				  (cam->addr[3]		<< 8)	|
+				  (cam->addr[4]		<< 16)	|
+				  (cam->addr[5]		<< 24);
+			break;
+		default:
+			j = (i - 2) << 2;
+			content = (key->key[j])			|
+				  (key->key[j + 1]	<< 8)	|
+				  (key->key[j + 2]	<< 16)	|
+				  (key->key[j + 3]	<< 24);
+			break;
+		}
+
+		command = write_cmd | (addr + i);
+		rtw_write32(rtwdev, RTW_SEC_WRITE_REG, content);
+		rtw_write32(rtwdev, RTW_SEC_CMD_REG, command);
+	}
+}
+
+void rtw_sec_clear_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       u8 hw_key_idx)
+{
+	struct rtw_cam_entry *cam = &sec->cam_table[hw_key_idx];
+	u32 write_cmd;
+	u32 command;
+	u32 addr;
+
+	clear_bit(hw_key_idx, sec->cam_map);
+	cam->valid = false;
+	cam->key = NULL;
+	eth_zero_addr(cam->addr);
+
+	write_cmd = RTW_SEC_CMD_WRITE_ENABLE | RTW_SEC_CMD_POLLING;
+	addr = hw_key_idx << RTW_SEC_CAM_ENTRY_SHIFT;
+	command = write_cmd | addr;
+	rtw_write32(rtwdev, RTW_SEC_WRITE_REG, 0);
+	rtw_write32(rtwdev, RTW_SEC_CMD_REG, command);
+}
+
+void rtw_sec_enable_sec_engine(struct rtw_dev *rtwdev)
+{
+	struct rtw_sec_desc *sec = &rtwdev->sec;
+	u16 ctrl_reg;
+	u16 sec_config;
+
+	/* default use default key search for now */
+	sec->default_key_search = true;
+
+	ctrl_reg = rtw_read16(rtwdev, REG_CR);
+	ctrl_reg |= RTW_SEC_ENGINE_EN;
+	rtw_write16(rtwdev, REG_CR, ctrl_reg);
+
+	sec_config = rtw_read16(rtwdev, RTW_SEC_CONFIG);
+
+	sec_config |= RTW_SEC_TX_DEC_EN | RTW_SEC_RX_DEC_EN;
+	if (sec->default_key_search)
+		sec_config |= RTW_SEC_TX_UNI_USE_DK | RTW_SEC_RX_UNI_USE_DK |
+			      RTW_SEC_TX_BC_USE_DK | RTW_SEC_RX_BC_USE_DK;
+
+	rtw_write16(rtwdev, RTW_SEC_CONFIG, sec_config);
+}
diff --git a/drivers/net/wireless/realtek/rtw88/sec.h b/drivers/net/wireless/realtek/rtw88/sec.h
new file mode 100644
index 0000000..f13b36a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/sec.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_SEC_H_
+#define __RTW_SEC_H_
+
+#define RTW_SEC_CMD_REG			0x670
+#define RTW_SEC_WRITE_REG		0x674
+#define RTW_SEC_READ_REG		0x678
+#define RTW_SEC_CONFIG			0x680
+
+#define RTW_SEC_CAM_ENTRY_SHIFT		3
+#define RTW_SEC_DEFAULT_KEY_NUM		4
+#define RTW_SEC_CMD_WRITE_ENABLE	BIT(16)
+#define RTW_SEC_CMD_CLEAR		BIT(30)
+#define RTW_SEC_CMD_POLLING		BIT(31)
+
+#define RTW_SEC_TX_UNI_USE_DK		BIT(0)
+#define RTW_SEC_RX_UNI_USE_DK		BIT(1)
+#define RTW_SEC_TX_DEC_EN		BIT(2)
+#define RTW_SEC_RX_DEC_EN		BIT(3)
+#define RTW_SEC_TX_BC_USE_DK		BIT(6)
+#define RTW_SEC_RX_BC_USE_DK		BIT(7)
+
+#define RTW_SEC_ENGINE_EN		BIT(9)
+
+int rtw_sec_get_free_cam(struct rtw_sec_desc *sec);
+void rtw_sec_write_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key,
+		       u8 hw_key_type, u8 hw_key_idx);
+void rtw_sec_clear_cam(struct rtw_dev *rtwdev,
+		       struct rtw_sec_desc *sec,
+		       u8 hw_key_idx);
+void rtw_sec_enable_sec_engine(struct rtw_dev *rtwdev);
+
+#endif
-- 
2.7.4

