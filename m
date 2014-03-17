Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46028 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbaCQNfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:01 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 11/21] wil6210: reset on power good
Date: Mon, 17 Mar 2014 15:34:15 +0200
Message-ID: <1395063265-6522-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143511_439065_F4BE1BE4)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure hardware to perform full reset on "power good". This mean,
reset HW on system boot. This improves card stability.
By default this is off.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 8 ++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index bd27bee..6847622 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -241,8 +241,9 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	/* register write */
 #define W(a, v) iowrite32(v, wil->csr + HOSTADDR(a))
 	/* register set = read, OR, write */
-#define S(a, v) iowrite32(ioread32(wil->csr + HOSTADDR(a)) | v, \
-		wil->csr + HOSTADDR(a))
+#define S(a, v) W(a, R(a) | v)
+	/* register clear = read, AND with inverted, write */
+#define C(a, v) W(a, R(a) & ~v)
 
 	wil->hw_version = R(RGF_USER_FW_REV_ID);
 	rev_id = wil->hw_version & 0xff;
@@ -286,11 +287,14 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	if (rev_id == 2)
 		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
 
+	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
+
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay);
 
 #undef R
 #undef W
 #undef S
+#undef C
 }
 
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b376399..f7d8f0e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -79,6 +79,8 @@ struct RGF_ICR {
 #define RGF_USER_MAC_CPU_0		(0x8801fc)
 #define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
 #define RGF_USER_FW_REV_ID		(0x880a8c) /* chip revision */
+#define RGF_USER_CLKS_CTL_0		(0x880abc)
+	#define BIT_USER_CLKS_RST_PWGD	BIT(11) /* reset on "power good" */
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_0	(0x880b04)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_1	(0x880b08)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_2	(0x880b0c)
-- 
1.8.3.2

