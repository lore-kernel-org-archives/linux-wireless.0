Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6657 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaLANiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:38:55 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 8/9] wil6210: reset flow update
Date: Mon, 1 Dec 2014 15:36:31 +0200
Message-ID: <1417440991-27358-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143859_470762_837CEC95)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If card reset with firmware download executed, followed by reset
with use of firmware from build in flash, firmware download indication
remains in the hardware register.
When running firmware download flow,
the SW download indication is written by the driver to bit 0 in usage_6:
wil_fw_load(), "S(RGF_USER_USAGE_6, 1);"
This register, like all USER RGF, wasn't reset in SW reset flow.
Therefore the driver must clear it on SW reset flow.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8f257a4..8ff3fe3 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -493,6 +493,9 @@ static int wil_target_reset(struct wil6210_priv *wil)
 
 	wil_halt_cpu(wil);
 
+	/* Clear Fw Download notification */
+	C(RGF_USER_USAGE_6, BIT(0));
+
 	if (is_sparrow) {
 		S(RGF_CAF_OSC_CONTROL, BIT_CAF_OSC_XTAL_EN);
 		/* XTAL stabilization should take about 3ms */
-- 
2.1.0

