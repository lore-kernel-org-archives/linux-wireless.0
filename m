Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0G0R6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:58:16 -0400
Subject: [wt PATCH 7/16] libertas: convert LED_GPIO_CTRL to a direct command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:59:44 -0700
Message-ID: <1280260784.19686.21.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/host.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 680a5f5..7f512ed 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -879,6 +879,8 @@ struct cmd_ds_802_11_pa_cfg {
 
 
 struct cmd_ds_802_11_led_ctrl {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le16 numled;
 	u8 data[256];
@@ -969,9 +971,6 @@ struct cmd_ds_command {
 		struct cmd_ds_mac_reg_access macreg;
 		struct cmd_ds_bbp_reg_access bbpreg;
 		struct cmd_ds_rf_reg_access rfreg;
-
-		struct cmd_ds_802_11_led_ctrl ledgpio;
-
 		struct cmd_ds_bt_access bt;
 		struct cmd_ds_fwt_access fwt;
 	} params;
-- 
1.7.1.1


