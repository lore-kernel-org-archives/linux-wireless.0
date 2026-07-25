Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC2532F757
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991905; cv=none; b=QFesIvrruNq9dyHytw9M8ndz5bTJmvTm/zrUaevZqV3VXNR9Gr7IyC0NljIwy6WFyVYloHm5vbALhhLnEuOLdm+AEkiekju0mwPhn9itDWxhg51eo6VI/kOQjtlGeqAnwIvSWQYASI8nMsv+nndZsWIT56krkQkfXlJuJTzRJLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991905; c=relaxed/simple;
	bh=C3TNYUaKBWvvYVbO+JdlXL47DQhuEnjNCIpZAzdbkNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8BpR15nTppD+VnyOnJAKys+7u9vyJsjzRfDGTQL+lNRa1goktB8w/Yjoz2PZZKMcj5YaDDF+flJ9K9tJ6/8PSUoJVY2ZQ8oGxf97Ay82GA9R4PYJJJW8YogedfYy5f2uefXBzdudFxtSbrUx2dvi3UVi/kZs1Nbuq3TeppaXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LEmnMRu3; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LEmnMRu3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cSIwu9AEUhQsDhogTlPu3xgVFIrhvB4GmSe7w5GX8Pg=;
	b=LEmnMRu3S8M005g1CHg2epqU8CrDg/YmBAFW//1/+kvxvmvLtCgjFNoq0OAVG4zewq5XdM
	kR2DizUJXQq1Orn/GI4NsfyciX4o83v+sA+dAPY0XpGnaqgVCJ9t8GDBcuTXpXD9l4+1uL
	wr49FCTobGj3dG3lP/NpTElDXxAFfaI=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 06/11] wifi: rtw88: coex: reassert the antenna path when associating
Date: Sat, 25 Jul 2026 17:04:22 +0200
Message-ID: <20260725150427.93887-7-luka.gejak@linux.dev>
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

The vendor ConnectNotify() returns early without sending H2C commands
when BT is disabled, because the scan path has already established the
antenna configuration, coexistence table and PS-TDMA. What it does keep
is a register level reassertion of the PTA antenna at associate start,
without which the antenna can be left pointing at BT across the
authentication exchange.

Add that reassertion, and the pre-authentication H2C sequence that the
join path added later needs.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 46 +++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/coex.h |  1 +
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index daba6082f850..314b2a368a8f 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -1541,6 +1541,23 @@ static void rtw_coex_8723bs_fw_gnt_bt_low(struct rtw_dev *rtwdev)
 	rtw_fw_set_gnt_bt(rtwdev, 0);
 }
 
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
 static void rtw_coex_8723bs_reassert_ant_buffer(struct rtw_dev *rtwdev)
 {
 	u8 sys_func_before;
@@ -1593,6 +1610,24 @@ void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev)
 	rtw_coex_8723bs_restore_pad_ctrl(rtwdev, true);
 }
 
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
 static const char *rtw_coex_get_algo_string(u8 algo)
 {
 	switch (algo) {
@@ -3115,6 +3150,17 @@ void rtw_coex_connect_notify(struct rtw_dev *rtwdev, u8 type)
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
index 72b1353c9313..c58ae0a50b30 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.h
+++ b/drivers/net/wireless/realtek/rtw88/coex.h
@@ -431,5 +431,6 @@ static inline void rtw_coex_active_query_bt_info(struct rtw_dev *rtwdev)
 }
 
 void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev);
+void rtw_coex_8723bs_pre_auth_h2c(struct rtw_dev *rtwdev);
 
 #endif
-- 
2.55.0

