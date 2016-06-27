Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcF0QcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 09/12] rtl8xxxu: Enable aggregation for rtl8192cu/rtl8188cu/rtl8188ru
Date: Mon, 27 Jun 2016 12:32:07 -0400
Message-Id: <1467045130-18874-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_183223_941954_DC38BA7A)
In-Reply-To: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This enables aggregation on rtl8192cu and derivative parts. This uses
the same parameters as for rtl8723au.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
index eefb7ca..69d1a14 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -560,6 +560,7 @@ struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
 	.config_channel = rtl8xxxu_gen1_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
+	.init_aggregation = rtl8xxxu_gen1_init_aggregation,
 	.enable_rf = rtl8xxxu_gen1_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
@@ -567,6 +568,7 @@ struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.writeN_block_size = 128,
+	.rx_agg_buf_size = 16000,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
 	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
 	.adda_1t_init = 0x0b1b25a0,
-- 
2.7.4

