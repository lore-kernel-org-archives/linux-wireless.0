Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58850 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaHDIWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:25 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 02/14] wil6210: fix race in reset
Date: Mon, 4 Aug 2014 11:20:42 +0300
Message-ID: <1407140454-31639-3-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102228_081996_5389D9C0)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

It is important to halt USER CPU first, then MAC CPU
Otherwise, race happens in the firmware

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 3704d2a..d734283 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -327,6 +327,8 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	/* register clear = read, AND with inverted, write */
 #define C(a, v) W(a, R(a) & ~v)
 
+	wmb(); /* If host reorder writes here -> race in NIC */
+	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
 	wil->hw_version = R(RGF_USER_FW_REV_ID);
 	rev_id = wil->hw_version & 0xff;
 
@@ -343,8 +345,9 @@ static void wil_target_reset(struct wil6210_priv *wil)
 		wmb(); /* order is important here */
 	}
 
-	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
 	W(RGF_USER_USER_CPU_0, BIT(1)); /* user_cpu_man_rst */
+	wmb(); /* If host reorder writes here -> race in NIC */
+	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
 	wmb(); /* order is important here */
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
-- 
1.8.5.2

