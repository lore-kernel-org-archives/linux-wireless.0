Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5536 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbaCQNfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:18 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 20/21] wil6210: add memory barriers for the reset flow
Date: Mon, 17 Mar 2014 15:34:24 +0200
Message-ID: <1395063265-6522-21-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143525_934486_0E5A82B8)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

make sure reset flow executed in order

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c782e25..0005d9b 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -289,19 +289,23 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(6));
 	/* car_perst_rst_src_n_mask */
 	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(7));
+	wmb(); /* order is important here */
 
 	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
 	W(RGF_USER_USER_CPU_0, BIT(1)); /* user_cpu_man_rst */
+	wmb(); /* order is important here */
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000170);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FC00);
+	wmb(); /* order is important here */
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+	wmb(); /* order is important here */
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
 	if (rev_id == 1) {
@@ -311,6 +315,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
 	}
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+	wmb(); /* order is important here */
 
 	/* wait until device ready */
 	do {
@@ -327,6 +332,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
 
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
+	wmb(); /* order is important here */
 
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay);
 
-- 
1.8.3.2

