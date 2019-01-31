Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3B4C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84B56218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbfAaMWO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:14 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53739 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbfAaMWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:12 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLudn016797, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLudn016797
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:56 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:55 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 16/24] rtw88: 8822c: add support for DACK
Date:   Thu, 31 Jan 2019 20:21:29 +0800
Message-ID: <1548937297-14660-17-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

8822c needs to calibrate dac to have a stable RF characteristics.
This calibration routine is static, means it only needs to be done once
after the hardware is powered on.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 600 ++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   5 +
 2 files changed, 605 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 9c3f0f1..975afc7 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -66,6 +66,605 @@ static void rtw8822c_header_file_init(struct rtw_dev *rtwdev, bool pre)
 		rtw_write32_set(rtwdev, REG_ENCCK, BIT_CCK_OFDM_BLK_EN);
 }
 
+static void rtw8822c_dac_backup_reg(struct rtw_dev *rtwdev,
+				    struct rtw_backup_info *backup,
+				    struct rtw_backup_info *backup_rf)
+{
+	u32 path, i;
+	u32 val;
+	u32 reg;
+	u32 rf_addr[DACK_RF_8822C] = {0x8f};
+	u32 addrs[DACK_REG_8822C] = {0x180c, 0x1810, 0x410c, 0x4110,
+				     0x1c3c, 0x1c24, 0x1d70, 0x9b4,
+				     0x1a00, 0x1a14, 0x1d58, 0x1c38,
+				     0x1e24, 0x1e28, 0x1860, 0x4160};
+
+	for (i = 0; i < DACK_REG_8822C; i++) {
+		backup[i].len = 4;
+		backup[i].reg = addrs[i];
+		backup[i].val = rtw_read32(rtwdev, addrs[i]);
+	}
+
+	for (path = 0; path < DACK_PATH_8822C; path++) {
+		for (i = 0; i < DACK_RF_8822C; i++) {
+			reg = rf_addr[i];
+			val = rtw_read_rf(rtwdev, path, reg, RFREG_MASK);
+			backup_rf[path * i + i].reg = reg;
+			backup_rf[path * i + i].val = val;
+		}
+	}
+}
+
+static void rtw8822c_dac_restore_reg(struct rtw_dev *rtwdev,
+				     struct rtw_backup_info *backup,
+				     struct rtw_backup_info *backup_rf)
+{
+	u32 path, i;
+	u32 val;
+	u32 reg;
+
+	rtw_restore_reg(rtwdev, backup, DACK_REG_8822C);
+
+	for (path = 0; path < DACK_PATH_8822C; path++) {
+		for (i = 0; i < DACK_RF_8822C; i++) {
+			val = backup_rf[path * i + i].val;
+			reg = backup_rf[path * i + i].reg;
+			rtw_write_rf(rtwdev, path, reg, RFREG_MASK, val);
+		}
+	}
+}
+
+static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, u32 value,
+				   u32 *min, u32 *max)
+{
+	if (value >= 0x200) {
+		if (*min >= 0x200) {
+			if (*min > value)
+				*min = value;
+		} else {
+			*min = value;
+		}
+		if (*max >= 0x200) {
+			if (*max < value)
+				*max = value;
+		}
+	} else {
+		if (*min < 0x200) {
+			if (*min > value)
+				*min = value;
+		}
+
+		if (*max  >= 0x200) {
+			*max = value;
+		} else {
+			if (*max < value)
+				*max = value;
+		}
+	}
+}
+
+static void swap_u32(u32 *v1, u32 *v2)
+{
+	u32 tmp;
+
+	tmp = *v1;
+	*v1 = *v2;
+	*v2 = tmp;
+}
+
+static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *v1, u32 *v2)
+{
+	if (*v1 >= 0x200 && *v2 >= 0x200) {
+		if (*v1 > *v2)
+			swap_u32(v1, v2);
+	} else if (*v1 < 0x200 && *v2 < 0x200) {
+		if (*v1 > *v2)
+			swap_u32(v1, v2);
+	} else if (*v1 < 0x200 && *v2 >= 0x200) {
+		swap_u32(v1, v2);
+	}
+}
+
+static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+{
+	u32 i, j;
+
+	for (i = 0; i < DACK_SN_8822C - 1; i++) {
+		for (j = 0; j < (DACK_SN_8822C - 1 - i) ; j++) {
+			__rtw8822c_dac_iq_sort(rtwdev, &iv[j], &iv[j + 1]);
+			__rtw8822c_dac_iq_sort(rtwdev, &qv[j], &qv[j + 1]);
+		}
+	}
+}
+
+static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, u32 *vec, u32 *val)
+{
+	u32 p, m, t, i;
+
+	m = 0;
+	p = 0;
+	for (i = 10; i < DACK_SN_8822C - 10; i++) {
+		if (vec[i] > 0x200)
+			m = (0x400 - vec[i]) + m;
+		else
+			p = vec[i] + p;
+	}
+
+	if (p > m) {
+		t = p - m;
+		t = t / (DACK_SN_8822C - 20);
+	} else {
+		t = m - p;
+		t = t / (DACK_SN_8822C - 20);
+		if (t != 0x0)
+			t = 0x400 - t;
+	}
+
+	*val = t;
+}
+
+static u32 rtw8822c_get_path_base_addr(u8 path)
+{
+	u32 base_addr;
+
+	switch (path) {
+	case RF_PATH_A:
+		base_addr = 0x1800;
+		break;
+	case RF_PATH_B:
+		base_addr = 0x4100;
+		break;
+	default:
+		WARN_ON(1);
+		return -1;
+	}
+
+	return base_addr;
+}
+
+static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, u32 value)
+{
+	bool ret = true;
+
+	if ((value >= 0x200 && (0x400 - value) > 0x64) ||
+	    (value < 0x200 && value > 0x64)) {
+		ret = false;
+		rtw_dbg(rtwdev, "[DACK] Error overflow\n");
+	}
+
+	return ret;
+}
+
+static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+{
+	u32 temp;
+	int i = 0, cnt = 0;
+
+	while (i < DACK_SN_8822C && cnt < 10000) {
+		cnt++;
+		temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
+		iv[i] = (temp & 0x3ff000) >> 12;
+		qv[i] = temp & 0x3ff;
+
+		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
+		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
+			i++;
+	}
+}
+
+static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
+				       u32 *iv, u32 *qv,
+				       u32 *i_value, u32 *q_value)
+{
+	u32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
+	u32 i_delta, q_delta;
+	u32 temp;
+	int i, cnt = 0;
+
+	do {
+		i_min = iv[0];
+		i_max = iv[0];
+		q_min = qv[0];
+		q_max = qv[0];
+		for (i = 0; i < DACK_SN_8822C; i++) {
+			rtw8822c_rf_minmax_cmp(rtwdev, iv[i], &i_min, &i_max);
+			rtw8822c_rf_minmax_cmp(rtwdev, qv[i], &q_min, &q_max);
+		}
+
+		if (i_max < 0x200 && i_min < 0x200)
+			i_delta = i_max - i_min;
+		else if (i_max >= 0x200 && i_min >= 0x200)
+			i_delta = i_max - i_min;
+		else
+			i_delta = i_max + (0x400 - i_min);
+
+		if (q_max < 0x200 && q_min < 0x200)
+			q_delta = q_max - q_min;
+		else if (q_max >= 0x200 && q_min >= 0x200)
+			q_delta = q_max - q_min;
+		else
+			q_delta = q_max + (0x400 - q_min);
+
+		rtw_dbg(rtwdev, "[DACK] i: min=0x%08x, max=0x%08x, delta=0x%08x\n",
+			i_min, i_max, i_delta);
+		rtw_dbg(rtwdev, "[DACK] q: min=0x%08x, max=0x%08x, delta=0x%08x\n",
+			q_min, q_max, q_delta);
+
+		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
+
+		if (i_delta > 5 || q_delta > 5) {
+			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
+			iv[0] = (temp & 0x3ff000) >> 12;
+			qv[0] = temp & 0x3ff;
+			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
+			iv[DACK_SN_8822C - 1] = (temp & 0x3ff000) >> 12;
+			qv[DACK_SN_8822C - 1] = temp & 0x3ff;
+		} else {
+			break;
+		}
+	} while (cnt++ < 100);
+
+	rtw8822c_dac_iq_offset(rtwdev, iv, i_value);
+	rtw8822c_dac_iq_offset(rtwdev, qv, q_value);
+}
+
+static void rtw8822c_dac_cal_rf_mode(struct rtw_dev *rtwdev,
+				     u32 *i_value, u32 *q_value)
+{
+	u32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
+	u32 rf_a, rf_b;
+
+	mdelay(10);
+
+	rf_a = rtw_read_rf(rtwdev, RF_PATH_A, 0x0, RFREG_MASK);
+	rf_b = rtw_read_rf(rtwdev, RF_PATH_B, 0x0, RFREG_MASK);
+
+	rtw_dbg(rtwdev, "[DACK] RF path-A=0x%05x\n", rf_a);
+	rtw_dbg(rtwdev, "[DACK] RF path-B=0x%05x\n", rf_b);
+
+	rtw8822c_dac_cal_iq_sample(rtwdev, iv, qv);
+	rtw8822c_dac_cal_iq_search(rtwdev, iv, qv, i_value, q_value);
+}
+
+static void rtw8822c_dac_bb_setting(struct rtw_dev *rtwdev)
+{
+	rtw_write32_mask(rtwdev, 0x1d58, 0xff8, 0x1ff);
+	rtw_write32_mask(rtwdev, 0x1a00, 0x3, 0x2);
+	rtw_write32_mask(rtwdev, 0x1a14, 0x300, 0x3);
+	rtw_write32(rtwdev, 0x1d70, 0x7e7e7e7e);
+	rtw_write32_mask(rtwdev, 0x180c, 0x3, 0x0);
+	rtw_write32_mask(rtwdev, 0x410c, 0x3, 0x0);
+	rtw_write32(rtwdev, 0x1b00, 0x00000008);
+	rtw_write8(rtwdev, 0x1bcc, 0x3f);
+	rtw_write32(rtwdev, 0x1b00, 0x0000000a);
+	rtw_write8(rtwdev, 0x1bcc, 0x3f);
+	rtw_write32_mask(rtwdev, 0x1e24, BIT(31), 0x0);
+	rtw_write32_mask(rtwdev, 0x1e28, 0xf, 0x3);
+}
+
+static void rtw8822c_dac_cal_adc(struct rtw_dev *rtwdev,
+				 u8 path, u32 *adc_ic, u32 *adc_qc)
+{
+	u32 ic = 0, qc = 0, temp = 0;
+	u32 base_addr;
+	u32 path_sel;
+	int i;
+
+	rtw_dbg(rtwdev, "[DACK] ADCK path(%d)\n", path);
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+	switch (path) {
+	case RF_PATH_A:
+		path_sel = 0xa0000;
+		break;
+	case RF_PATH_B:
+		path_sel = 0x80000;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	/* ADCK step1 */
+	rtw_write32_mask(rtwdev, base_addr + 0x30, BIT(30), 0x0);
+	if (path == RF_PATH_B)
+		rtw_write32(rtwdev, base_addr + 0x30, 0x30db8041);
+	rtw_write32(rtwdev, base_addr + 0x60, 0xf0040ff0);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02dd08c4);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0x10000260);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0x0, RFREG_MASK, 0x10000);
+	rtw_write_rf(rtwdev, RF_PATH_B, 0x0, RFREG_MASK, 0x10000);
+	for (i = 0; i < 10; i++) {
+		rtw_dbg(rtwdev, "[DACK] ADCK count=%d\n", i);
+		rtw_write32(rtwdev, 0x1c3c, path_sel + 0x8003);
+		rtw_write32(rtwdev, 0x1c24, 0x00010002);
+		rtw8822c_dac_cal_rf_mode(rtwdev, &ic, &qc);
+		rtw_dbg(rtwdev, "[DACK] before: i=0x%x, q=0x%x\n", ic, qc);
+
+		/* compensation value */
+		if (ic != 0x0) {
+			ic = 0x400 - ic;
+			*adc_ic = ic;
+		}
+		if (qc != 0x0) {
+			qc = 0x400 - qc;
+			*adc_qc = qc;
+		}
+		temp = (ic & 0x3ff) | ((qc & 0x3ff) << 10);
+		rtw_write32(rtwdev, base_addr + 0x68, temp);
+		rtw_dbg(rtwdev, "[DACK] ADCK 0x%08x=0x08%x\n",
+			base_addr + 0x68, temp);
+		/* check ADC DC offset */
+		rtw_write32(rtwdev, 0x1c3c, path_sel + 0x8103);
+		rtw8822c_dac_cal_rf_mode(rtwdev, &ic, &qc);
+		rtw_dbg(rtwdev, "[DACK] after:  i=0x%08x, q=0x%08x\n", ic, qc);
+		if (ic >= 0x200)
+			ic = 0x400 - ic;
+		if (qc >= 0x200)
+			qc = 0x400 - qc;
+		if (ic < 5 && qc < 5)
+			break;
+	}
+
+	/* ADCK step2 */
+	rtw_write32(rtwdev, 0x1c3c, 0x00000003);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0x10000260);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c4);
+
+	/* release pull low switch on IQ path */
+	rtw_write_rf(rtwdev, path, 0x8f, BIT(13), 0x1);
+}
+
+static void rtw8822c_dac_cal_step1(struct rtw_dev *rtwdev, u8 path)
+{
+	u32 base_addr;
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	if (path == RF_PATH_A) {
+		rtw_write32(rtwdev, base_addr + 0x60, 0xf0040ff0);
+		rtw_write32(rtwdev, 0x1c38, 0xffffffff);
+	}
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, 0x9b4, 0xdb66db00);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x0008ff81);
+	rtw_write32(rtwdev, base_addr + 0xc0, 0x0003d208);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xd8, 0x0008ff81);
+	rtw_write32(rtwdev, base_addr + 0xdc, 0x0003d208);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x60000000);
+	mdelay(2);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x000aff8d);
+	mdelay(2);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb89);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb89);
+	mdelay(1);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xd4, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x02000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x0008ff87);
+	rtw_write32(rtwdev, 0x9b4, 0xdb6db600);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x0008ff87);
+	rtw_write32(rtwdev, base_addr + 0x60, 0xf0000000);
+}
+
+static void rtw8822c_dac_cal_step2(struct rtw_dev *rtwdev,
+				   u8 path, u32 *ic_out, u32 *qc_out)
+{
+	u32 base_addr;
+	u32 ic, qc, ic_in, qc_in;
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xf0000000, 0x0);
+	rtw_write32_mask(rtwdev, base_addr + 0xc0, 0xf, 0x8);
+	rtw_write32_mask(rtwdev, base_addr + 0xd8, 0xf0000000, 0x0);
+	rtw_write32_mask(rtwdev, base_addr + 0xdc, 0xf, 0x8);
+
+	rtw_write32(rtwdev, 0x1b00, 0x00000008);
+	rtw_write8(rtwdev, 0x1bcc, 0x03f);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, 0x1c3c, 0x00088103);
+
+	rtw8822c_dac_cal_rf_mode(rtwdev, &ic_in, &qc_in);
+	ic = ic_in;
+	qc = qc_in;
+
+	/* compensation value */
+	if (ic != 0x0)
+		ic = 0x400 - ic;
+	if (qc != 0x0)
+		qc = 0x400 - qc;
+	if (ic < 0x300) {
+		ic = ic * 2 * 6 / 5;
+		ic = ic + 0x80;
+	} else {
+		ic = (0x400 - ic) * 2 * 6 / 5;
+		ic = 0x7f - ic;
+	}
+	if (qc < 0x300) {
+		qc = qc * 2 * 6 / 5;
+		qc = qc + 0x80;
+	} else {
+		qc = (0x400 - qc) * 2 * 6 / 5;
+		qc = 0x7f - qc;
+	}
+
+	*ic_out = ic;
+	*qc_out = qc;
+
+	rtw_dbg(rtwdev, "[DACK] before i=0x%x, q=0x%x\n", ic_in, qc_in);
+	rtw_dbg(rtwdev, "[DACK] after  i=0x%x, q=0x%x\n", ic, qc);
+}
+
+static void rtw8822c_dac_cal_step3(struct rtw_dev *rtwdev, u8 path,
+				   u32 adc_ic, u32 adc_qc,
+				   u32 *ic_in, u32 *qc_in,
+				   u32 *i_out, u32 *q_out)
+{
+	u32 base_addr;
+	u32 ic, qc;
+	u32 temp;
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+	ic = *ic_in;
+	qc = *qc_in;
+
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, 0x9b4, 0xdb66db00);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0xc008ff81);
+	rtw_write32(rtwdev, base_addr + 0xc0, 0x0003d208);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xf0000000, ic & 0xf);
+	rtw_write32_mask(rtwdev, base_addr + 0xc0, 0xf, (ic & 0xf0) >> 4);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xd8, 0xe008ff81);
+	rtw_write32(rtwdev, base_addr + 0xdc, 0x0003d208);
+	rtw_write32_mask(rtwdev, base_addr + 0xd8, 0xf0000000, qc & 0xf);
+	rtw_write32_mask(rtwdev, base_addr + 0xdc, 0xf, (qc & 0xf0) >> 4);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x60000000);
+	mdelay(2);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xe, 0x6);
+	mdelay(2);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb89);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb89);
+	mdelay(1);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xd4, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x02000000);
+	mdelay(20);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xe, 0x3);
+	rtw_write32(rtwdev, 0x9b4, 0xdb6db600);
+
+	/* check DAC DC offset */
+	temp = ((adc_ic + 0x10) & 0x3ff) | (((adc_qc + 0x10) & 0x3ff) << 10);
+	rtw_write32(rtwdev, base_addr + 0x68, temp);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, base_addr + 0x60, 0xf0000000);
+	rtw8822c_dac_cal_rf_mode(rtwdev, &ic, &qc);
+	if (ic >= 0x10)
+		ic = ic - 0x10;
+	else
+		ic = 0x400 - (0x10 - ic);
+
+	if (qc >= 0x10)
+		qc = qc - 0x10;
+	else
+		qc = 0x400 - (0x10 - qc);
+
+	*i_out = ic;
+	*q_out = qc;
+
+	if (ic >= 0x200)
+		ic = 0x400 - ic;
+	if (qc >= 0x200)
+		qc = 0x400 - qc;
+
+	*ic_in = ic;
+	*qc_in = qc;
+
+	rtw_dbg(rtwdev, "[DACK] after  DACK i=0x%x, q=0x%x\n", *i_out, *q_out);
+}
+
+static void rtw8822c_dac_cal_step4(struct rtw_dev *rtwdev, u8 path)
+{
+	u32 base_addr = rtw8822c_get_path_base_addr(path);
+
+	rtw_write32(rtwdev, base_addr + 0x68, 0x0);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c4);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0x1, 0x0);
+	rtw_write32_mask(rtwdev, base_addr + 0x30, BIT(30), 0x1);
+}
+
+static void rtw8822c_rf_dac_cal(struct rtw_dev *rtwdev)
+{
+	struct rtw_backup_info backup_rf[DACK_RF_8822C * DACK_PATH_8822C];
+	struct rtw_backup_info backup[DACK_REG_8822C];
+	u32 ic = 0, qc = 0, i;
+	u32 i_a = 0x0, q_a = 0x0, i_b = 0x0, q_b = 0x0;
+	u32 ic_a = 0x0, qc_a = 0x0, ic_b = 0x0, qc_b = 0x0;
+	u32 adc_ic_a = 0x0, adc_qc_a = 0x0, adc_ic_b = 0x0, adc_qc_b = 0x0;
+
+	rtw8822c_dac_backup_reg(rtwdev, backup, backup_rf);
+
+	rtw8822c_dac_bb_setting(rtwdev);
+
+	/* path-A */
+	rtw8822c_dac_cal_adc(rtwdev, RF_PATH_A, &adc_ic_a, &adc_qc_a);
+	for (i = 0; i < 10; i++) {
+		rtw8822c_dac_cal_step1(rtwdev, RF_PATH_A);
+		rtw8822c_dac_cal_step2(rtwdev, RF_PATH_A, &ic, &qc);
+		ic_a = ic;
+		qc_a = qc;
+
+		rtw8822c_dac_cal_step3(rtwdev, RF_PATH_A, adc_ic_a, adc_qc_a,
+				       &ic, &qc, &i_a, &q_a);
+
+		if (ic < 5 && qc < 5)
+			break;
+	}
+	rtw8822c_dac_cal_step4(rtwdev, RF_PATH_A);
+
+	/* path-B */
+	rtw8822c_dac_cal_adc(rtwdev, RF_PATH_B, &adc_ic_b, &adc_qc_b);
+	for (i = 0; i < 10; i++) {
+		rtw8822c_dac_cal_step1(rtwdev, RF_PATH_B);
+		rtw8822c_dac_cal_step2(rtwdev, RF_PATH_B, &ic, &qc);
+		ic_b = ic;
+		qc_b = qc;
+
+		rtw8822c_dac_cal_step3(rtwdev, RF_PATH_B, adc_ic_b, adc_qc_b,
+				       &ic, &qc, &i_b, &q_b);
+
+		if (ic < 5 && qc < 5)
+			break;
+	}
+	rtw8822c_dac_cal_step4(rtwdev, RF_PATH_B);
+
+	rtw_write32(rtwdev, 0x1b00, 0x00000008);
+	rtw_write32_mask(rtwdev, 0x4130, BIT(30), 0x1);
+	rtw_write8(rtwdev, 0x1bcc, 0x0);
+	rtw_write32(rtwdev, 0x1b00, 0x0000000a);
+	rtw_write8(rtwdev, 0x1bcc, 0x0);
+
+	rtw8822c_dac_restore_reg(rtwdev, backup, backup_rf);
+
+	rtw_dbg(rtwdev, "[DACK] path A: ic=0x%x, qc=0x%x\n", ic_a, qc_a);
+	rtw_dbg(rtwdev, "[DACK] path B: ic=0x%x, qc=0x%x\n", ic_b, qc_b);
+	rtw_dbg(rtwdev, "[DACK] path A: i=0x%x, q=0x%x\n", i_a, q_a);
+	rtw_dbg(rtwdev, "[DACK] path B: i=0x%x, q=0x%x\n", i_b, q_b);
+}
+
+static void rtw8822c_rf_x2_check(struct rtw_dev *rtwdev)
+{
+	u8 x2k_busy;
+
+	mdelay(1);
+	x2k_busy = rtw_read_rf(rtwdev, RF_PATH_A, 0xb8, BIT(15));
+	if (x2k_busy == 1) {
+		rtw_write_rf(rtwdev, RF_PATH_A, 0xb8, RFREG_MASK, 0xC4440);
+		rtw_write_rf(rtwdev, RF_PATH_A, 0xba, RFREG_MASK, 0x6840D);
+		rtw_write_rf(rtwdev, RF_PATH_A, 0xb8, RFREG_MASK, 0x80440);
+		mdelay(1);
+	}
+}
+
+static void rtw8822c_rf_init(struct rtw_dev *rtwdev)
+{
+	rtw8822c_rf_dac_cal(rtwdev);
+	rtw8822c_rf_x2_check(rtwdev);
+}
+
 static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 {
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
@@ -109,6 +708,7 @@ static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 	dm_info->cck_gi_u_bnd = ((cck_gi_u_bnd_msb << 4) | (cck_gi_u_bnd_lsb));
 	dm_info->cck_gi_l_bnd = ((cck_gi_l_bnd_msb << 4) | (cck_gi_l_bnd_lsb));
 
+	rtw8822c_rf_init(rtwdev);
 	/* wifi path controller */
 	rtw_write32_mask(rtwdev, 0x70, 0xff000000, 0x0e);
 	rtw_write32_mask(rtwdev, 0x1704, 0xffffffff, 0x7700);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index fa71104..6a64640 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -96,6 +96,11 @@ struct rtw8822c_efuse {
 	};
 };
 
+#define DACK_PATH_8822C		2
+#define DACK_REG_8822C		16
+#define DACK_RF_8822C		1
+#define DACK_SN_8822C		100
+
 /* phy status page0 */
 #define GET_PHY_STAT_P0_PWDB_A(phy_stat)                                       \
 	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
-- 
2.7.4

